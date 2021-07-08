### Modelling for gender
### Modelling for ethnicity
library(tidymodels)

SMR1_SimulatedDataBiasGender_PreModelling = SMR1_SimulatedDataBiasGender.new2
#SMR1_SimulatedDataBiasEthnicity_Modelling = as.data.frame(SMR1_SimulatedDataBiasEthnicity_PreModelling)

### Transforming the variables into factors
SMR1_SimulatedDataBiasGender_Modelling = SMR1_SimulatedDataBiasGender_PreModelling %>%
  mutate(SEX = as.factor(SEX)) %>%
  mutate(RECRUITMENT_SEXneutral = as.factor(RECRUITMENT_SEXneutral)) %>%
  mutate(RECRUITMENT_SEXbias = as.factor(RECRUITMENT_SEXbias)) 

### Creating the train and test data set
set.seed(1234)
gender_bias_split <- initial_split(SMR1_SimulatedDataBiasGender_Modelling, 
                              strata = RECRUITMENT_SEXbias)
gender_bias_train <- training(gender_bias_split)
gender_bias_test <- testing(gender_bias_split)

#nrow(gender_train)
#nrow(gender_test)

# Developing the model based on train data
set.seed(12)
LG_Gender_Biased <- logistic_reg() %>%
  
  # Set the engine
  set_engine("glm") %>%
  
  # Set the mode
  set_mode("classification") %>%
  
  # Fit the model
  fit(RECRUITMENT_SEXbias~., data = gender_bias_train)

tidy(LG_Gender_Biased) 


# Testing the model: Class prediction-
pred_class_Gender_Biased <- predict(LG_Gender_Biased,
                                        new_data = gender_bias_test,
                                        type = "class")

# Testing the model: Prediction Probabilities
pred_probability_Gender_Biased <- predict(LG_Gender_Biased,
                                             new_data = gender_bias_test,
                                             type = "prob")

# Final data preperation for model evaluation
recruitment_gender_Biased <- gender_bias_test %>%
  select(RECRUITMENT_SEXbias) %>%
  bind_cols(pred_class_Gender_Biased, pred_probability_Gender_Biased)

recruitment_gender_Biased

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



