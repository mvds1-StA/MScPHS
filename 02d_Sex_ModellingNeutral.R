### SECTION 02d_Sex_ModellingNeutral
### This section models for gender in the neutral dataset.

### Creating the train and test data set
set.seed(1234)
gender_neutral_split = initial_split(SMR1_SimulatedDataBiasGender_Modelling, 
                              strata = RECRUITMENT_SEXneutral)
gender_neutral_train = training(gender_neutral_split)
gender_neutral_test = testing(gender_neutral_split)


### Developing the model based on train data
set.seed(12)
LG_Gender_Neutral = logistic_reg() %>%
  
  ### Set the engine
  set_engine("glm") %>%
  
  ### Set the mode
  set_mode("classification") %>%
  
  ### Fit the model
  fit(RECRUITMENT_SEXneutral~., data = gender_neutral_train)

tidy(LG_Gender_Neutral) 


### Testing the model: Class prediction-
pred_class = predict(LG_Gender_Neutral,
                                    new_data = gender_neutral_test,
                                    type = "class")

### Testing the model: Prediction Probabilities
pred_prob = predict(LG_Gender_Biased,
                                          new_data = gender_neutral_test,
                                          type = "prob")

### Final data preperation for model evaluation
recruitment_gender_Neutral = gender_neutral_test %>%
  select(RECRUITMENT_SEXneutral) %>%
  bind_cols(pred_class, pred_prob)

recruitment_gender_Neutral

### Model evaluation with the matrix
conf_mat(recruitment_gender_Neutral, truth = RECRUITMENT_SEXneutral,
         estimate = .pred_class)

### Model evlauation with the accuracy
accuracy(recruitment_gender_Neutral, truth = RECRUITMENT_SEXneutral,
         estimate = .pred_class)

### Model evaluation with sensitivity
sens(recruitment_gender_Neutral, truth = RECRUITMENT_SEXneutral,
     estimate = .pred_class)

### Model evaluation with specifity 
spec(recruitment_gender_Neutral, truth = RECRUITMENT_SEXneutral,
     estimate = .pred_class)

### Model evaluation with precision
precision(recruitment_gender_Neutral, truth = RECRUITMENT_SEXneutral,
          estimate = .pred_class)

### Model evaluation metrics in one list
custom_metrics <- metric_set(accuracy, sens, spec, precision)
custom_metrics(recruitment_gender_Neutral,
               truth = RECRUITMENT_SEXneutral,
               estimate = .pred_class)



