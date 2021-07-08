### SECTION 01a_SimulateRandomData
### This setcion focuses on generating a random data set. The data generated will primarily be used
### to determine which dataset (simulated SMR1 or this one) represents the original SMR1 data most 
### appropriately. 

### Define trial_data
random_data.definition = 
  
  ### Defining the gender variable
  defData( varname = "gender",
           dist = "categorical",
           formula = genCatFormula(0.50,0.50),
           id = "idnum" ) %>% 
  
  ### Defining the ethnicity variable
  ### https://www.scotlandscensus.gov.uk/census-results/at-a-glance/ethnicity/
  ### https://www.scotlandscensus.gov.uk/webapi/jsf/tableView/tableView.xhtml
  defData( varname = "ethnicity",
           dist = "categorical",
           formula = genCatFormula(0.40, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10) ) %>%
  
  ### Defining the education variable
  ### https://www.scotlandscensus.gov.uk/webapi/jsf/tableView/tableView.xhtml
  #defData( varname = "socioeconomic_education",
           #dist = "categorical",
           #formula = genCatFormula(0.2679, 0.2308, 0.1433, 0.0971, 0.2609) ) %>%  
  
  ### Defining the income variable
  ### https://www.gov.scot/publications/poverty-income-inequality-scotland-2016-19/pages/3/
  #defData( varname = "socioeconomic_income",
           #dist = "categorical",
           #formula = genCatFormula(0.81,0.19) ) %>%  
  
  ### Defining the age variable
  defData( varname = "age",
         dist = "uniform",
         formula = "18;80")   

#Generating the data
random_data.synthetic = genData( number_patients,
                                 random_data.definition )

### Updating gender to Female/Male
random_data.synthetic = random_data.synthetic %>% 
  mutate( gender = recode( gender,
                           "1"="Female",
                           "2"="Male") )

### Updating ethnicity to ethnicity group
random_data.synthetic = random_data.synthetic %>% 
  mutate( ethnicity = recode( ethnicity,
                            "1"="White",
                            "2"="Black",
                            "3"="Indian",
                            "4"="Pakistani",
                            "5"="Chinese",
                            "6"="Other",
                            "7"="Unknown") )

### Updating education to education group
#random_data.synthetic = random_data.synthetic %>% 
  #mutate( socioeconomic_education = recode( socioeconomic_education,
                              #"1"="No qualifications",
                              #"2"="Level 1: Standard grade",
                              #"3"="Level 2: Higher grade",
                              #"4"="Level 3: Other post-school, but pre-higher qualifications",
                              #"5"="Level 4: Degree") )

### Updating income to income group
#random_data.synthetic = random_data.synthetic %>% 
  #mutate( socioeconomic_income = recode( socioeconomic_income,
                              #"1"="Not living in poverty",
                              #"2"="Living in poverty after housingcosts ") )

### Updating dob to age in years
date_range = seq( ymd("2018-01-01"),
                  ymd("2019-12-31"), by="day")
random_data.synthetic = random_data.synthetic %>% 
  mutate( DOR = sample(date_range,
                       size=number_patients,
                       replace=TRUE) )

random_data.synthetic

## Checking the divsion across gender and ethnic groups
table(random_data.synthetic[c("gender")])
table(random_data.synthetic[c("ethnicity")])

save (
  number_patients,
  random_data.synthetic,
  file=sprintf( "files_created/01a_RandomData.Rdat",
                number_patients )
)

