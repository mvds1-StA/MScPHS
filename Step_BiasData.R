### Define trial_data
trial_biased.definition = 
  
  ### Defining the gender variable
  ### SOURCE
  defData( varname = "gender_biased",
           dist = "categorical",
           formula = genCatFormula(0.99,0.01),
           id = "idnum" )  %>%

  ### Defining the ethnicity variable
  ### SOURCE
  defData( varname = "ethnicity_biased",
           dist = "categorical",
           formula = genCatFormula(0.62, 0.34, 0.04) ) %>%
  
  ### Defining the education variable
  ### SOURCE
  defData( varname = "socioeconomic_education_biased",
           dist = "categorical",
           formula = genCatFormula(0.11, 0.34, 0.22, 0.11, 0.22) ) %>%  
  
  ### Defining the income variable
  ### SOURCE
  defData( varname = "socioeconomic_income_biased",
           dist = "categorical",
           formula = genCatFormula(0.41,0.59) ) %>%  
  
  ### Defining the age variable
  defData( varname = "age",
           dist = "uniform",
           formula = "18;80") 
  
#Generating the biased data
trial_biased.synthetic = genData( number_patients,
                                  trial_biased.definition )
  
### Updating gender to Female/Male
trial_biased.synthetic = trial_biased.synthetic %>% 
    mutate( gender_biased = recode( gender_biased,
                             "1"="Female",
                             "2"="Male") )

### Updating ethnicity to ethnicity group
trial_biased.synthetic = trial_biased.synthetic %>% 
  mutate( ethnicity_biased = recode( ethnicity_biased,
                              "1"="White Scottish/White British",
                              "2"="Other white identities",
                              "3"="Asian ethnicities",
                              "4"="African, Caribbean or Black ethnicities",
                              "5"="Mixed or other ethnic groups") )

### Updating education to education group
trial_biased.synthetic = trial_biased.synthetic %>% 
  mutate( socioeconomic_education_biased = recode( socioeconomic_education_biased,
                                            "1"="No qualifications",
                                            "2"="Level 1: Standard grade",
                                            "3"="Level 2: Higher grade",
                                            "4"="Level 3: Other post-school, but pre-higher qualifications",
                                            "5"="Level 4: Degree") )

### Updating income to income group
trial_biased.synthetic = trial_biased.synthetic %>% 
  mutate( socioeconomic_income_biased = recode( socioeconomic_income_biased,
                                         "1"="Not living in poverty",
                                         "2"="Living in poverty after housingcosts ") )

### Updating dob to age in years
date_range = seq( ymd("2018-01-01"),
                  ymd("2019-12-31"), by="day")

trial_biased.synthetic = trial_biased.synthetic %>% 
  mutate( DOR = sample(date_range,
                       size=number_patients,
                       replace=TRUE) )



### Biasing gender
bias_gender <- trtAssign(trial_biased.synthetic, n = 3, balanced = TRUE, strata = c("gender_biased"), 
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
