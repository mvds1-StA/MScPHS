### OPTION 1: NOT FINISHED YET, DOESN'T PRODUCE THE ESTIMATES WHEN PRINTING THE MODEL. MY 
### SUSPICION IS THAT THERE IS NO ACTUAL PREDICTION YET, ONLY THE MODEL IS CREATED. WILL 
### CONTINUE TO WORK ON THIS NEXT WEEK.
### REMARK: NO TEST DATA USED.
set.seed(12)
ethnicity_boot <- bootstraps(ethnicity_train)
ethnicity_boot

glm_spec <- logistic_reg() %>%
  set_engine("glm")

#glm_spec

ethnicity_wf <- workflow() %>%
  add_formula(RECRUITMENT_Ethnicitybias ~ .)

#ethnicity_wf

glm_rs <- ethnicity_wf %>%
  add_model(glm_spec) %>%
  fit_resamples(
    resamples = ethnicity_boot,
    control = control_resamples(save_pred = TRUE)
  )

glm_rs
summary(glm_rs)

### OPTION 2: NOT FINISHED YET, DOESN'T PRODUCE THE ESTIMATES WHEN PRINTING THE MODEL. MY 
### SUSPICION IS THAT THERE IS NO ACTUAL PREDICTION YET, ONLY THE MODEL IS CREATED. WILL 
### CONTINUE TO WORK ON THIS NEXT WEEK.
### REMARK: NO TEST DATA USED.
ethnicity_rec <- recipe(RECRUITMENT_Ethnicitybias ~ ., data = ethnicity_train) %>%
  step_corr(all_numeric()) %>%
  step_dummy(all_nominal(), -all_outcomes()) %>%
  step_zv(all_numeric()) %>%
  step_normalize(all_numeric())

ethnicity_prep <- ethnicity_rec %>%
  prep()
#ethnicity_prep

### Fitting the model for ethnicity
ethnicity_juiced <- juice(ethnicity_prep)

glm_spec <- logistic_reg() %>%
  set_engine("glm")

glm_fit <- glm_spec %>%
  fit(RECRUITMENT_Ethnicitybias ~ ., data = ethnicity_juiced)
#glm_fit

set.seed(123)
folds <- vfold_cv(ethnicity_train, strata = RECRUITMENT_Ethnicitybias)

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

