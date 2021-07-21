### SECTION 01a_SimulateRandomData
### This setcion focuses on generating a random data set. The data generated will primarily be used
### to determine which dataset (simulated SMR1 or this one) represents the original SMR1 data most 
### appropriately. 

### Define trial_data
random_data.definition = 
  
  ### Defining the gender variable
  defData( varname = "gender",
           dist = "categorical",
           formula = genCatFormula(0.51,0.49),
           id = "idnum" ) %>% 
  
  ### Defining the ethnicity variable
  ### https://www.scotlandscensus.gov.uk/census-results/at-a-glance/ethnicity/
  ### https://www.scotlandscensus.gov.uk/webapi/jsf/tableView/tableView.xhtml
  defData( varname = "ethnicity",
           dist = "categorical",
           formula = genCatFormula(0.40, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10) ) %>%
  
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

### Updating dob to age in years
date_range = seq( ymd("2018-01-01"),
                  ymd("2019-12-31"), by="day")
random_data.synthetic = random_data.synthetic %>% 
  mutate( DOR = sample(date_range,
                       size=number_patients,
                       replace=TRUE) )

save (
  number_patients,
  random_data.synthetic,
  file=sprintf( "files_created/01a_RandomData.Rdat",
                number_patients )
)

