### Modelling for gender
library(tidymodels)

SMR1_SimulatedDataBiasGender.new2 <- SMR1_SimulatedDataBiasGender.new2 %>%
  mutate(SEX = factor(SEX)) %>%
  mutate(SEX_Bias = factor(SEX_Bias)) %>%
  mutate(RECRUITMENT_neutral = factor(RECRUITMENT_neutral)) %>%
  mutate(RECRUITMENT_SEXbias = factor(RECRUITMENT_SEXbias)) %>%
  mutate(ETHNIC_GROUP = factor(ETHNIC_GROUP))

set.seed(1234)
gender_split <- initial_split(SMR1_SimulatedDataBiasGender.new2, strata = RECRUITMENT_SEXbias)
gender_train <- training(gender_split)
gender_test <- testing(gender_split)

gender_rec <- recipe(RECRUITMENT_SEXbias ~ ., data = gender_train) %>%
  step_corr(all_numeric()) %>%
  step_dummy(all_nominal(), -all_outcomes()) %>%
  step_zv(all_numeric()) %>%
  step_normalize(all_numeric())

gender_prep <- gender_rec %>%
  prep()

gender_prep


### Fitting the model for gender
gender_juiced <- juice(gender_prep)

glm_spec <- logistic_reg() %>%
  set_engine("glm")

glm_fit <- glm_spec %>%
  fit(RECRUITMENT_SEXbias ~ ., data = gender_juiced)

glm_fit


### Evaluating the model using resampling
set.seed(123)
folds <- vfold_cv(gender_train, strata = RECRUITMENT_SEXbias)

set.seed(234)
glm_rs <- glm_spec %>%
  fit_resamples(
    gender_rec,
    folds,
    metrics = metric_set(roc_auc, sens, spec),
    control = control_resamples(save_pred = TRUE)
  )

glm_rs$.notes

glm_rs %>%
  collect_metrics()