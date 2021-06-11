
trial_data.definition = 
  ### Defining the gender variable
  defData( varname = "gender",
           dist = "categorical",
           formula = genCatFormula(0.50,0.50),
           id = "idnum" ) %>% 
  ### Defining the car variable
  ### https://www.scotlandscensus.gov.uk/census-results/at-a-glance/ethnicity/
  ### https://www.scotlandscensus.gov.uk/webapi/jsf/tableView/tableView.xhtml
  defData( varname = "ethnicity",
           dist = "categorical",
           formula = genCatFormula(0.96, 0.042, 0.04) ) %>% 
  ### Defining the education variable
  ### https://www.scotlandscensus.gov.uk/webapi/jsf/tableView/tableView.xhtml
  defData( varname = "socioeconomic_education",
           dist = "categorical",
           formula = genCatFormula(0.2679, 0.2308, 0.1433, 0.0971, 0.2609) ) %>%  
  ### Defining the income variable
  ### https://www.gov.scot/publications/poverty-income-inequality-scotland-2016-19/pages/3/
  defData( varname = "socioeconomic_income",
           dist = "categorical",
           formula = genCatFormula(0.81,0.19) ) %>%  
  ### Defining the age variable
  defData( varname = "age",
         dist = "uniform",
         formula = "18;80") 


### Updating gender to Female/Male
trial_data.synthetic = trial_data.synthetic %>% 
  mutate( gender = recode( gender,
                           "1"="Female",
                           "2"="Male") )

### Updating ethnicity to ethnicity group
trial_data.synthetic = trial_data.synthetic %>% 
  mutate( ethnicity = recode( ethnicity,
                            "1"="White Scottish/White British",
                            "2"="Other white identities",
                            "3"="Asian ethnicities",
                            "4"="African, Caribbean or Black ethnicities",
                            "5"="Mixed or other ethnic groups") )

### Updating education to education group
trial_data.synthetic = trial_data.synthetic %>% 
  mutate( socioeconomic_education = recode( socioeconomic_education,
                              "1"="No qualifications",
                              "2"="Level 1: Standard grade",
                              "3"="Level 2: Higher grade",
                              "4"="Level 3: Other post-school, but pre-higher qualifications",
                              "5"="Level 4: Degree") )

### Updating income to income group
trial_data.synthetic = trial_data.synthetic %>% 
  mutate( socioeconomic_income = recode( socioeconomic_income,
                              "1"="Yes",
                              "2"="No") )

### Updating dob to age in years
date_range = seq( ymd("2018-01-01"),
                  ymd("2019-12-31"), by="day")
trial_data.synthetic = trial_data.synthetic %>% 
  mutate( DOR = sample(date_range,
                       size=number_patients,
                       replace=TRUE) )