### 02c_Sex_ModellingBiased
### This section models for gender in the biased dataset.
### This work is based on the work by Julia Silge
### https://juliasilge.com/blog/tuition-resampling/

### Loading the data
SMR1_SimulatedDataBiasGender_PreModelling = SMR1_SimulatedDataBiasGender.new2

### Transforming the variables into factors
SMR1_SimulatedDataBiasGender_Modelling <- SMR1_SimulatedDataBiasGender_PreModelling %>%
  mutate(SEX = as.factor(SEX)) %>%
  mutate(RECRUITMENT_SEXneutral = as.factor(RECRUITMENT_SEXneutral)) %>%
  mutate(RECRUITMENT_SEXbias = as.factor(RECRUITMENT_SEXbias)) %>%
  select(-AGE_IN_YEARS) %>%
  select(-SEX_Bias )

### Creating the train and test data set
set.seed(1234)
gender_bias_split <- initial_split(SMR1_SimulatedDataBiasGender_Modelling, 
                              strata = RECRUITMENT_SEXbias)
gender_bias_train <- training(gender_bias_split)
gender_bias_test <- testing(gender_bias_split)

### Developing the model based on train data
set.seed(12)
LG_Gender_Biased <- logistic_reg() %>%
  
  ### Set the engine
  set_engine("glm") %>%
  
  ### Set the mode
  set_mode("classification") %>%
  
  ### Fit the model
  fit(RECRUITMENT_SEXbias~., data = gender_bias_train)

tidy(LG_Gender_Biased) 

### Calculating the Odds Ratio
tidy(LG_Gender_Biased, exponentiate = TRUE)

### Testing the model: Class prediction
### First gave different names to each of the classes such that the code was more 
### neet and also reusable. However, this meant that the .pred_class no longer worked
### and did not produce the numbers required. 
### Consequently, all files use .pred_class to ensure a working code.
pred_class <- predict(LG_Gender_Biased,
                      new_data = gender_bias_test,
                      type = "class")

### Testing the model: Prediction Probabilities
pred_prob <- predict(LG_Gender_Biased,
                     new_data = gender_bias_test,
                     type = "prob")

### Final data preperation for model evaluation
recruitment_gender_Biased <- gender_bias_test %>%
  select(RECRUITMENT_SEXbias) %>%
  bind_cols(pred_class, pred_prob)

recruitment_gender_Biased

### Model evaluation with the matrix
conf_mat(recruitment_gender_Biased, truth = RECRUITMENT_SEXbias,
         estimate = .pred_class)

### Model evlauation with the accuracy
accuracy(recruitment_gender_Biased, truth = RECRUITMENT_SEXbias,
         estimate = .pred_class)

### Model evaluation with sensitivity
sens(recruitment_gender_Biased, truth = RECRUITMENT_SEXbias,
     estimate = .pred_class)

### Model evaluation with specifity 
spec(recruitment_gender_Biased, truth = RECRUITMENT_SEXbias,
     estimate = .pred_class)

### Model evaluation with precision
precision(recruitment_gender_Biased, truth = RECRUITMENT_SEXbias,
          estimate = .pred_class)

### Model evaluation metrics in one list
custom_metrics <- metric_set(accuracy, sens, spec, precision)
custom_metrics(recruitment_gender_Biased,
               truth = RECRUITMENT_SEXbias,
               estimate = .pred_class)



