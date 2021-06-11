#Calculating age based on the date of birth (DOB)
#DOB = date of birth
#enddate = defaults to current date
#units = in this case years
#precise = whether or not to calculate with leap year 
data_normal %>%
  age_calc(dob, enddate = Sys.Date(), units = "months", precise = TRUE) %>%
  select(-dob)

save(file=sprintf("dat/01b_TRUESAMPLE.Rdat"))



