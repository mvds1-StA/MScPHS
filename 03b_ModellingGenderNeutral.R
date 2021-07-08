### Modelling for gender
library(tidymodels)

### Creating the train and test data set
set.seed(1234)
gender_split = initial_split(SMR1_SimulatedDataBiasGender_Modelling, 
                              strata = RECRUITMENT_SEXneutral)
gender_train = training(gender_split)
gender_test = testing(gender_split)

#nrow(gender_train)
#nrow(gender_test)

# Developing the model based on train data
set.seed(12)
LG_Gender_Neutral = logistic_reg() %>%
  
  # Set the engine
  set_engine("glm") %>%
  
  # Set the mode
  set_mode("classification") %>%
  
  # Fit the model
  fit(RECRUITMENT_SEXneutral~., data = gender_train)

tidy(LG_Gender_Neutral) 


# Testing the model: Class prediction-
pred_class_Gender_Neutral = predict(LG_Gender_Neutral,
                                    new_data = gender_test,
                                    type = "class")

# Testing the model: Prediction Probabilities
pred_probability_Gender_Neutral = predict(LG_Gender_Biased,
                                          new_data = gender_test,
                                          type = "prob")

# Final data preperation for model evaluation
recruitment_gender_Neutral = gender_test %>%
  select(RECRUITMENT_SEXneutral) %>%
  bind_cols(pred_class_Gender_Neutral, pred_probability_Gender_Neutral)

recruitment_gender_Neutral

#Model evaluation with the matrix
conf_mat(recruitment_gender_Neutral, truth = RECRUITMENT_SEXneutral,
         estimate = pred_class_Gender_Neutral)

#Model evlauation with the accuracy
accuracy(recruitment_gender_Neutral, truth = RECRUITMENT_SEXneutral,
         estimate = pred_class_Gender_Neutral)

#Model evaluation with sensitivity
sens(recruitment_gender_Neutral, truth = RECRUITMENT_SEXneutral,
     estimate = pred_class_Gender_Neutral)

#Model evaluation with specifity 
spec(recruitment_gender_Neutral, truth = RECRUITMENT_SEXneutral,
     estimate = pred_class_Gender_Neutral)

#Model evaluation with precision
precision(recruitment_gender_Neutral, truth = RECRUITMENT_SEXneutral,
          estimate = pred_class_Gender_Neutral)

#Model evaluation metrics in one list
custom_metrics <- metric_set(accuracy, sens, spec, precision)
custom_metrics(recruitment_gender_Neutral,
               truth = RECRUITMENT_SEXneutral,
               estimate = pred_class_Gender_Neutral)



