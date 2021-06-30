### Modelling for gender
library(tidymodels)

### Transforming the variables into factors
SMR1_SimulatedDataBiasEthnicity.new2 <- SMR1_SimulatedDataBiasEthnicity.new2 %>%
  mutate(ETHNIC_GROUP = factor(ETHNIC_GROUP)) %>%
  mutate(ETHNICITY_Bias = factor(ETHNICITY_Bias)) %>%
  mutate(RECRUITMENT_neutral = factor(RECRUITMENT_neutral)) %>%
  mutate(RECRUITMENT_Ethnicitybias = factor(RECRUITMENT_Ethnicitybias)) %>%
  mutate(SEX = factor(SEX))  %>%
  mutate(AGE_IN_YEARS = fatcor(AGE_IN_YEARS))

### Creating the train and test data set
set.seed(1234)
ethnicity_split <- initial_split(SMR1_SimulatedDataBiasEthnicity.new2, strata = RECRUITMENT_Ethnicitybias)
ethnicity_train <- training(ethnicity_split)
ethnicity_test <- testing(ethnicity_split)

### OPTION 1
set.seed(123)
ethnicity_boot <- bootstraps(ethnicity_train)
ethnicity_boot

glm_spec <- logistic_reg() %>%
  set_engine("glm")

glm_spec

ethnicity_wf <- workflow() %>%
  add_formula(RECRUITMENT_Ethnicitybias ~ .)

ethnicity_wf


glm_rs <- ethnicity_wf %>%
  add_model(glm_spec) %>%
  fit_resamples(
    resamples = ethnicity_boot,
    control = control_resamples(save_pred = TRUE)
  )

glm_rs

### OPTION 2
ethnicity_rec <- recipe(RECRUITMENT_Ethnicitybias ~ ., data = ethnicity_train) %>%
  step_corr(all_numeric()) %>%
  step_dummy(all_nominal(), -all_outcomes()) %>%
  step_zv(all_numeric()) %>%
  step_normalize(all_numeric())

ethnicity_prep <- ethnicity_rec %>%
  prep()

ethnicity_prep


### Fitting the model for ethnicity
ethnicity_juiced <- juice(ethnicity_prep)

glm_spec <- logistic_reg() %>%
  set_engine("glm")

glm_fit <- glm_spec %>%
  fit(RECRUITMENT_Ethnicitybias ~ ., data = ethnicity_juiced)

glm_fit

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
  collect_metrics() %>%
  summary()


### OPTION 3
# Fit the model
model <- glm( RECRUITMENT_Ethnicitybias ~., data = ethnicity_train, family = binomial)
# Summarize the model
summary(model)
# Make predictions
probabilities <- model %>% predict(ethnicity_test, type = "response")
predicted.classes <- ifelse(probabilities > 0.5, "Yes", "No")
# Model accuracy
mean(predicted.classes == ethnicity_test$RECRUITMENT_Ethnicitybias)
