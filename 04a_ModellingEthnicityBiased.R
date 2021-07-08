### Modelling for ethnicity
library(tidymodels)

SMR1_SimulatedDataBiasEthnicity_PreModelling = SMR1_SimulatedDataBiasEthnicity.new2
#SMR1_SimulatedDataBiasEthnicity_Modelling = as.data.frame(SMR1_SimulatedDataBiasEthnicity_PreModelling)

### Transforming the variables into factors before testing any of the models
SMR1_SimulatedDataBiasEthnicity_Modelling_Biased = SMR1_SimulatedDataBiasEthnicity_PreModelling %>%
  mutate(ETHNIC_GROUP = as.factor(ETHNIC_GROUP)) %>%
  mutate(RECRUITMENT_neutral = as.factor(RECRUITMENT_ETHNICITYneutral)) %>%
  mutate(RECRUITMENT_Ethnicitybias = as.factor(RECRUITMENT_ETHNICITYbias)) %>%
  select(-AGE_IN_YEARS) 


### Creating the train and test data set to be used in the models
set.seed(12)
ethnicity_bias_split <- initial_split(SMR1_SimulatedDataBiasEthnicity_Modelling_Biased, 
                                 strata = RECRUITMENT_ETHNICITYbias)
ethnicity_bias_train <- training(ethnicity_bias_split)
ethnicity_bias_test <- testing(ethnicity_bias_split)

#subset(ethnicity_test, ETHNIC_GROUP == "07")

#which(ethnicity_train$ETHNIC_GROUP == "07")

### Ensuring that there is one 07 ethnicity in both test and train
### This is a HACK to make the code work
rbind(ethnicity_bias_test, ethnicity_bias_train[1900,])


#nrow(ethnicity_train)
#nrow(ethnicity_test)

# Developing the model based on train data
set.seed(12)
LG_Ethnicity_Biased <- logistic_reg() %>%
  
  # Set the engine
  set_engine("glm") %>%
  
  # Set the mode
  set_mode("classification") %>%
  
  # Fit the model
  fit(RECRUITMENT_Ethnicitybias~., data = ethnicity_bias_train)

tidy(LG_Ethnicity_Biased) 


# Testing the model: Class prediction-
pred_class_ethncitity_Biased <- predict(LG_Ethnicity_Biased,
                      new_data = ethnicity_bias_test,
                      type = "class")

# Testing the model: Prediction Probabilities
pred_probability_ethnicity_Biased <- predict(LG_Ethnicity_Biased,
                                      new_data = ethnicity_bias_test,
                                      type = "prob")

# Final data preperation for model evaluation
recruitment_ethnicity_Biased <- ethnicity_bias_test %>%
  select(RECRUITMENT_Ethnicitybias) %>%
  bind_cols(pred_class_ethncitity_Biased, pred_probability_ethnicity_Biased)

recruitment_ethnicity_Biased

#Model evaluation with the matrix
conf_mat(recruitment_ethnicity_Biased, truth = RECRUITMENT_Ethnicitybias,
         estimate = pred_class_ethncitity_Biased)

#Model evlauation with the accuracy
accuracy(recruitment_ethnicity_Biased, truth = RECRUITMENT_Ethnicitybias,
         estimate = pred_class_ethncitity_Biased)

#Model evaluation with sensitivity
sens(recruitment_ethnicity_Biased, truth = RECRUITMENT_Ethnicitybias,
     estimate = pred_class_ethncitity_Biased)

#Model evaluation with specifity 
spec(recruitment_ethnicity_Biased, truth = RECRUITMENT_Ethnicitybias,
     estimate = pred_class_ethncitity_Biased)

#Model evaluation with precision
precision(recruitment_ethnicity_Biased, truth = RECRUITMENT_Ethnicitybias,
          estimate = pred_class_ethncitity_Biased)

#Model evaluation metrics in one list
custom_metrics <- metric_set(accuracy, sens, spec, precision)
custom_metrics(recruitment_ethnicity_Biased,
               truth = RECRUITMENT_Ethnicitybias,
               estimate = pred_class_ethncitity_Biased)



