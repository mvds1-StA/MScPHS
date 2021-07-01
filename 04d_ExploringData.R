age_test <- SMR1_SimulatedDataBiasEthnicity.new3

age_test$AGE_IN_YEARS <- cut(age_test$AGE_IN_YEARS, 
    breaks = seq(25,85,by=10), right = TRUE)

age_test %>% 
    group_by(AGE_IN_YEARS) %>%
    tally(HD == "present")

ggplot(SMR1_SimulatedDataBiasEthnicity.new3,
       aes(x=ETHNIC_GROUP,
           y=,
           group=SEX)) +
  geom_point() +
  geom_smooth(method=lm, se=FALSE)+
  scale_color_viridis_d(option="plasma", end=0.7)


###

