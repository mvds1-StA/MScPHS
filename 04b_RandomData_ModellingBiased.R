### SECTION 04b_RandomData_ModellingBiased
### This section models for ethnicity in the biased dataset.
### This work is based on the work by Julia Silge
### https://juliasilge.com/blog/tuition-resampling/

### Loading the data
RandomData_Ethnicity_PreModelling = RandomData_Bias_Ethnicity.new2

### Transforming the variables into factors
RandomData_Ethnicity_Modelling <- RandomData_Ethnicity_PreModelling %>%
  mutate(ethnicity = as.factor(ethnicity)) %>%
  mutate(RECRUITMENT_Random_ETHNICITYneutral = as.factor(RECRUITMENT_Random_ETHNICITYneutral)) %>%
  mutate(RECRUITMENT_Random_ETHNICITYbias = as.factor(RECRUITMENT_Random_ETHNICITYbias))  %>%
  select(-age) %>%
  select(-DOR)  %>%
  select(-ETHNICITY_Bias_RandomData)

### Creating the train and test data set
set.seed(1234)
ethnicity_random_biased_split <- initial_split(RandomData_Ethnicity_Modelling, 
                                                strata = RECRUITMENT_Random_ETHNICITYbias)
ethnicity_random_biased_train <- training(ethnicity_random_biased_split)
ethnicity_random_biased_test <- testing(ethnicity_random_biased_split)

### Developing the model based on train data
set.seed(12)
LG_ethnicity_random_Biased <- logistic_reg() %>%
  
  ### Set the engine
  set_engine("glm") %>%
  
  ### Set the mode
  set_mode("classification") %>%
  
  ### Fit the model
  fit(RECRUITMENT_Random_ETHNICITYbias~., data = ethnicity_random_biased_train)

tidy(LG_ethnicity_random_Biased) 

### Calculating the Odds Ratio
tidy(LG_ethnicity_random_Biased, exponentiate = TRUE)

### Testing the model: Class prediction-
pred_class <- predict(LG_ethnicity_random_Biased,
                      new_data = ethnicity_random_biased_test,
                      type = "class")

### Testing the model: Prediction Probabilities
pred_prob <- predict(LG_ethnicity_random_Biased,
                     new_data = ethnicity_random_biased_test,
                     type = "prob")

### Final data preperation for model evaluation
recruitment_random_ethnicity_Biased <- ethnicity_random_biased_test %>%
  select(RECRUITMENT_Random_ETHNICITYbias) %>%
  bind_cols(pred_class, pred_prob)

### Model evaluation with the matrix
conf_mat(recruitment_random_ethnicity_Biased, 
         truth = RECRUITMENT_Random_ETHNICITYbias,
         estimate = .pred_class)

### Model evlauation with the accuracy
accuracy(recruitment_random_ethnicity_Biased, 
         truth = RECRUITMENT_Random_ETHNICITYbias,
         estimate = .pred_class)

### Model evaluation with sensitivity
sens(recruitment_random_ethnicity_Biased, 
     truth = RECRUITMENT_Random_ETHNICITYbias,
     estimate = .pred_class)

### Model evaluation with specifity 
spec(recruitment_random_ethnicity_Biased, 
     truth = RECRUITMENT_Random_ETHNICITYbias,
     estimate = .pred_class)

### Model evaluation with precision
precision(recruitment_random_ethnicity_Biased, 
          truth = RECRUITMENT_Random_ETHNICITYbias,
          estimate = .pred_class)

### Model evaluation metrics in one list
custom_metrics <- metric_set(accuracy, sens, spec, precision)
custom_metrics(recruitment_random_ethnicity_Biased, 
               truth = RECRUITMENT_Random_ETHNICITYbias,
               estimate = .pred_class)



