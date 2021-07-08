### Modelling for gender
### Modelling for ethnicity
library(tidymodels)

RandomData_Ethnicity_PreModelling = RandomData_Bias_Ethnicity.new2
#SMR1_SimulatedDataBiasEthnicity_Modelling = as.data.frame(SMR1_SimulatedDataBiasEthnicity_PreModelling)

### Transforming the variables into factors
RandomData_Ethnicity_Modelling = RandomData_Ethnicity_PreModelling %>%
  mutate(ethnicity = as.factor(ethnicity)) %>%
  mutate(RECRUITMENT_Random_ETHNICITYneutral = as.factor(RECRUITMENT_Random_ETHNICITYneutral)) %>%
  mutate(RECRUITMENT_Random_ETHNICITYbias = as.factor(RECRUITMENT_Random_ETHNICITYbias)) 


RandomData_Ethnicity_Modelling
### Creating the train and test data set
set.seed(1234)
ethnicity_random_bias_split <- initial_split(RandomData_Ethnicity_Modelling, 
                                   strata = RECRUITMENT_Random_ETHNICITYbias)
ethnicity_random_bias_train <- training(ethnicity_random_bias_split)
ethnicity_random_bias_test <- testing(ethnicity_random_bias_split)

#nrow(gender_train)
#nrow(gender_test)

# Developing the model based on train data
set.seed(12)
LG_ethnicity_random_Biased <- logistic_reg() %>%
  
  # Set the engine
  set_engine("glm") %>%
  
  # Set the mode
  set_mode("classification") %>%
  
  # Fit the model
  fit(RECRUITMENT_Random_ETHNICITYbias~., data = ethnicity_random_bias_train)

tidy(LG_ethnicity_random_Biased) 


# Testing the model: Class prediction-
pred_class_Random_ethnicity_Biased <- predict(LG_ethnicity_random_Biased,
                                    new_data = ethnicity_random_bias_test,
                                    type = "class")

# Testing the model: Prediction Probabilities
pred_probability_Random_ethnicity_Biased <- predict(LG_ethnicity_random_Biased,
                                          new_data = ethnicity_random_bias_test,
                                          type = "prob")

# Final data preperation for model evaluation
recruitment_random_ethnicity_Biased <- ethnicity_random_bias_test %>%
  select(RECRUITMENT_Random_ETHNICITYbias) %>%
  bind_cols(pred_class_Random_ethnicity_Biased, pred_probability_Random_ethnicity_Biased)

recruitment_random_ethnicity_Biased

#Model evaluation with the matrix
conf_mat(recruitment_gender_Biased, truth = RECRUITMENT_SEXbias,
         estimate = pred_class_Gender_Biased)

library(caret)
confusionMatrix(pred_class_Gender_Biased, recruitment_gender_Biased$RECRUITMENT_SEXbias)

#Model evlauation with the accuracy
accuracy(recruitment_gender_Biased, truth = RECRUITMENT_SEXbias,
         estimate = pred_class_Gender_Biased)

#Model evaluation with sensitivity
sens(recruitment_gender_Biased, truth = RECRUITMENT_SEXbias,
     estimate = pred_class_Gender_Biased)

#Model evaluation with specifity 
spec(recruitment_gender_Biased, truth = RECRUITMENT_SEXbias,
     estimate = pred_class_Gender_Biased)

#Model evaluation with precision
precision(recruitment_gender_Biased, truth = RECRUITMENT_SEXbias,
          estimate = pred_class_Gender_Biased)

#Model evaluation metrics in one list
custom_metrics <- metric_set(accuracy, sens, spec, precision)
custom_metrics(recruitment_gender_Biased,
               truth = RECRUITMENT_SEXbias,
               estimate = pred_class_Gender_Biased)



