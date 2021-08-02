### SECTION 03c_Ethnicity_ModellingBiased
### This section models for ethnicity in the biased dataset.
### This work is based on the work by Julia Silge
### https://juliasilge.com/blog/tuition-resampling/

### Transforming the variables into factors
SMR1_SimulatedDataBiasEthnicity_PreModelling_Biased <- SMR1_SimulatedDataBiasEthnicity.new2 %>%
  mutate(ETHNIC_GROUP = as.factor(ETHNIC_GROUP)) %>%
  mutate(RECRUITMENT_ETHNICITYneutral = as.factor(RECRUITMENT_ETHNICITYneutral)) %>%
  mutate(RECRUITMENT_ETHNICITYbias = as.factor(RECRUITMENT_ETHNICITYbias)) %>%
  select(-AGE_IN_YEARS) %>%
  select(-ETHNICITY_Bias )

### Creating the train and test data set
set.seed(12)
ethnicity_biased_split <- initial_split(SMR1_SimulatedDataBiasEthnicity_PreModelling_Biased, 
                                         strata = RECRUITMENT_ETHNICITYbias)
ethnicity_biased_train <- training(ethnicity_biased_split)
ethnicity_biased_test <- testing(ethnicity_biased_split)

### Developing the model based on train data
set.seed(12)
ethnicity_biased_logistic_model <- logistic_reg() %>%
  
  ### Set the engine
  set_engine("glm") %>%
  
  ### Set the mode
  set_mode("classification") %>%
  
  ### Fit the model
  fit(RECRUITMENT_ETHNICITYbias~., data = ethnicity_biased_train)

tidy(ethnicity_biased_logistic_model) 

### Calculating the Odds Ratio
tidy(ethnicity_biased_logistic_model, exponentiate = TRUE)

### Class prediction
pred_class <- predict(ethnicity_biased_logistic_model,
                      new_data = ethnicity_biased_test,
                      type = "class")

### Prediction Probabilities
pred_prob <- predict(ethnicity_biased_logistic_model,
                     new_data = ethnicity_biased_test,
                     type = "prob")

### Final data preperation for model evaluation
recruitment_ethnicity_biased <- ethnicity_biased_test %>%
  select(RECRUITMENT_ETHNICITYbias) %>%
  bind_cols(pred_class, pred_prob)

### Model evaluation with the matrix
conf_mat(recruitment_ethnicity_biased, truth = RECRUITMENT_ETHNICITYbias,
         estimate = .pred_class)

### Model evlauation with the accuracy
accuracy(recruitment_ethnicity_biased, truth = RECRUITMENT_ETHNICITYbias,
         estimate = .pred_class)

### Model evaluation with sensitivity
sens(recruitment_ethnicity_biased, truth = RECRUITMENT_ETHNICITYbias,
     estimate = .pred_class)

### Model evaluation with specifity 
spec(recruitment_ethnicity_biased, truth = RECRUITMENT_ETHNICITYbias,
     estimate = .pred_class)

### Model evaluation with precision
precision(recruitment_ethnicity_biased, truth = RECRUITMENT_ETHNICITYbias,
          estimate = .pred_class)

### Model evaluation metrics in one list
custom_metrics <- metric_set(accuracy, sens, spec, precision)
custom_metrics(recruitment_ethnicity_biased, 
               truth = RECRUITMENT_ETHNICITYbias,
               estimate = .pred_class)