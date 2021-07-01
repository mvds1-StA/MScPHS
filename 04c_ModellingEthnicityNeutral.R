### Modelling for gender
library(tidymodels)

### Transforming the variables into factors
SMR1_SimulatedDataBiasEthnicity.new3 = SMR1_SimulatedDataBiasEthnicity.new2 %>%
  mutate(ETHNIC_GROUP = factor(ETHNIC_GROUP)) %>%
  mutate(ETHNICITY_Bias = factor(ETHNICITY_Bias)) %>%
  mutate(RECRUITMENT_neutral = factor(RECRUITMENT_neutral)) %>%
  mutate(RECRUITMENT_Ethnicitybias = factor(RECRUITMENT_Ethnicitybias)) %>%
  select(-AGE_IN_YEARS)


### Creating the train and test data set
set.seed(12)
ethnicity_split <- initial_split(SMR1_SimulatedDataBiasEthnicity.new3, strata = RECRUITMENT_Ethnicitybias)
ethnicity_train <- training(ethnicity_split)
ethnicity_test <- testing(ethnicity_split)

#nrow(ethnicity_train)
#nrow(ethnicity_test)

### OPTION 1
set.seed(12)
ethnicity_boot <- bootstraps(ethnicity_train)
ethnicity_boot

glm_spec <- logistic_reg() %>%
  set_engine("glm")

#glm_spec

ethnicity_wf <- workflow() %>%
  add_formula(RECRUITMENT_neutral ~ .)

#ethnicity_wf


glm_rs <- ethnicity_wf %>%
  add_model(glm_spec) %>%
  fit_resamples(
    resamples = ethnicity_boot,
    control = control_resamples(save_pred = TRUE)
  )

glm_rs

### OPTION 2
ethnicity_rec <- recipe(RECRUITMENT_neutral ~ ., data = ethnicity_train) %>%
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
  fit(RECRUITMENT_neutral ~ ., data = ethnicity_juiced)

glm_fit

set.seed(123)
folds <- vfold_cv(ethnicity_train, strata = RECRUITMENT_neutral)

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
  
  summary(glm_rs)


### OPTION 3
set.seed(12)
# Fit the model
model <- glm( RECRUITMENT_neutral ~., data = ethnicity_train, family = binomial)
# Summarize the model
summary(model)
# Make predictions
probabilities <- model %>% predict(ethnicity_test, type = "response")
predicted.classes <- ifelse(probabilities > 0.5, "Yes", "No")
# Model accuracy
mean(predicted.classes == ethnicity_test$RECRUITMENT_neutral)
summary(model)


### OPTION 4
set.seed(12)
fitted_logistic_model <- logistic_reg() %>%
  # Set the engine
  set_engine("glm") %>%
  # Set the mode
  set_mode("classification") %>%
  # Fit the model
  fit(RECRUITMENT_neutral~., data = ethnicity_train)

tidy(fitted_logistic_model) 

tidy(fitted_logistic_model, exponentiate = TRUE)

tidy(fitted_logistic_model, exponentiate = TRUE) %>%
  filter(p.value < 0.05)

# Class prediction
pred_class <- predict(fitted_logistic_model,
                      new_data = ethnicity_test,
                      type = "class")

pred_class[1:5,]

# Prediction Probabilities
pred_proba <- predict(fitted_logistic_model,
                      new_data = ethnicity_test,
                      type = "prob")

pred_proba[1:5,]

# Final data preperation for model evaluation
recruitment_results <- ethnicity_test %>%
  select(RECRUITMENT_neutral) %>%
  bind_cols(pred_class, pred_proba)

recruitment_results[1:5, ]

#Model evaluation with the matrix
conf_mat(recruitment_results, truth = RECRUITMENT_neutral,
         estimate = .pred_class)

#Model evlauation with the accuracy
accuracy(recruitment_results, truth = RECRUITMENT_neutral,
         estimate = .pred_class)

#Model evaluation with sensitivity
sens(recruitment_results, truth = RECRUITMENT_neutral,
     estimate = .pred_class)

#Model evaluation with specifity 
spec(recruitment_results, truth = RECRUITMENT_neutral,
     estimate = .pred_class)

#Model evaluation with precision
precision(recruitment_results, truth = RECRUITMENT_neutral,
          estimate = .pred_class)

#Model evaluation metrics in one list
custom_metrics <- metric_set(accuracy, sens, spec, precision)
custom_metrics(recruitment_results,
               truth = RECRUITMENT_neutral,
               estimate = .pred_class)