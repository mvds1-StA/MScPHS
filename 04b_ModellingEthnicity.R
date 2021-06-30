### Modelling for gender
library(tidymodels)

SMR1_SimulatedDataBiasEthnicity.new2 <- SMR1_SimulatedDataBiasEthnicity.new2 %>%
  mutate(ETHNIC_GROUP = factor(ETHNIC_GROUP)) %>%
  mutate(ETHNICITY_Bias = factor(ETHNICITY_Bias)) %>%
  mutate(RECRUITMENT_neutral = factor(RECRUITMEmNT_neutral)) %>%
  mutate(RECRUITMENT_Ethnicitybias = factor(RECRUITMENT_Ethnicitybias)) %>%
  mutate(SEX = factor(SEX)) 

set.seed(1234)
ethnicity_split <- initial_split(SMR1_SimulatedDataBiasEthnicity.new2, strata = RECRUITMENT_Ethnicitybias)
ethnicity_train <- training(ethnicity_split)
ethnicity_test <- testing(ethnicity_split)

ethnicity_rec <- recipe(RECRUITMENT_Ethnicitybias ~ ., data = ethnicity_train) %>%
  step_corr(all_numeric()) %>%
  step_dummy(all_nominal(), -all_outcomes()) %>%
  step_zv(all_numeric()) %>%
  step_normalize(all_numeric())

ethnicity_prep <- ethnicity_rec %>%
  prep()

ethnicity_prep


### Fitting the model for gender
ethnicity_juiced <- juice(ethnicity_prep)

glm_spec <- logistic_reg() %>%
  set_engine("glm")

glm_fit <- glm_spec %>%
  fit(RECRUITMENT_Ethnicitybias ~ ., data = ethnicity_juiced)

glm_fit


### Evaluating the model using resampling
set.seed(123)
folds <- vfold_cv(ethnicity_train, strata = RECRUITMENT_Ethnicitybias)

set.seed(234)
glm_rs <- glm_spec %>%
  fit_resamples(
    ethnicity_rec,
    folds,
    metrics = metric_set(roc_auc, sens, spec),
    control = control_resamples(save_pred = TRUE)
  )

glm_rs %>%
  collect_metrics()