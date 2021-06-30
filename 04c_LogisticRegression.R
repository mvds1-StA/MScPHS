glm_spec <- logistic_reg() %>%
  set_engine("glm")

glm_fit <- glm_spec %>%
  fit(ETHNIC_GROUP ~ ., data = SMR1_SimulatedDataBiasEthnicity.new2)

glm_fit

glm_fit %>%
  tidy() %>%
  arrange(-estimate)

glm_fit %>%
  predict(
    SMR1_SimulatedDataComplete = bake(ETHNIC_GROUP$SMR1_SimulatedDataBiasEthnicity.new2),
    type = "prob"
  ) %>%
  mutate(truth = ETHNIC_GROUP) %>%
  roc_auc(truth, .pred_high)

glm_fit %>%
  predict(
    new_data = bake(uni_prep, new_data = uni_test),
    type = "class"
  ) %>%
  mutate(truth = uni_test$diversity) %>%
  spec(truth, .pred_class)


skimr::skim(SMR1_SimulatedDataBiasEthnicity.new2)
