### Modelling for gender
library(tidymodels)

### Transforming the variables into factors
SMR1_SimulatedDataBiasEthnicity_PreModelling_Neutral = SMR1_SimulatedDataBiasEthnicity.new2 %>%
  mutate(ETHNIC_GROUP = as.factor(ETHNIC_GROUP)) %>%
  mutate(RECRUITMENT_neutral = as.factor(RECRUITMENT_ETHNICITYneutral)) %>%
  mutate(RECRUITMENT_Ethnicitybias = as.factor(RECRUITMENT_ETHNICITYbias)) %>%
  select(-AGE_IN_YEARS)


### Creating the train and test data set
set.seed(12)
ethnicity_neutral_split <- initial_split(SMR1_SimulatedDataBiasEthnicity_PreModelling_Neutral, 
                                         strata = RECRUITMENT_ETHNICITYneutral)
ethnicity_neutral_train <- training(ethnicity_neutral_split)
ethnicity_neutral_test <- testing(ethnicity_neutral_split)

#nrow(ethnicity_train)
#nrow(ethnicity_test)

set.seed(12)
ethnicity_neutral_logistic_model <- logistic_reg() %>%
  # Set the engine
  set_engine("glm") %>%
  # Set the mode
  set_mode("classification") %>%
  # Fit the model
  fit(RECRUITMENT_ETHNICITYneutral~., data = ethnicity_neutral_train)

tidy(ethnicity_neutral_logistic_model) 

tidy(fitted_logistic_model, exponentiate = TRUE)

tidy(fitted_logistic_model, exponentiate = TRUE) %>%
  filter(p.value < 0.05)

# Class prediction
pred_class <- predict(ethnicity_neutral_logistic_model,
                      new_data = ethnicity_test,
                      type = "class")

# Prediction Probabilities
pred_probability_ethnicity_Neutral <- predict(ethnicity_neutral_logistic_model,
                                     new_data = ethnicity_test,
                                     type = "prob")

# Final data preperation for model evaluation
recruitment_results <- ethnicity_test %>%
  select(RECRUITMENT_neutral) %>%
  bind_cols(pred_class, pred_proba)

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