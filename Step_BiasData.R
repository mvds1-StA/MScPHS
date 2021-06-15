### Biasing gender
bias_gender <- trtAssign(trial_data.synthetic, n = 3, balanced = TRUE, strata = gender("Female"), 
                         grpName = "rx")
bias_gender


### Biasing ethnicity
bias_ethnicity <- trtAssign(trial_biased.synthetic, n = 3, balanced = TRUE, strata = c("ethnicity_biased"), 
                         grpName = "rx")
bias_ethnicity


### Biasing socioeconomic_education
bias_education <- trtAssign(trial_biased.synthetic, n = 3, balanced = TRUE, strata = c("socioeconomic_education_biased"), 
                            grpName = "rx")
bias_education


### Biasing socioeconomic_income
bias_income <- trtAssign(trial_biased.synthetic, n = 3, balanced = TRUE, strata = c("socioeconomic_income_biased"), 
                            grpName = "rx")
bias_income


### Saving new file
save (
  trial_data.synthetic,
  file=sprintf( "files_created/02a_BiasedSAMPLE.Rdat",
                number_patients )
)
