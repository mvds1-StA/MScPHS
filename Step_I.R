#Obtain sample every time
set.seed(1)

#Set sample size
number_patients = 20

#Define the dataset and create appropriate lists
list_of_patients = tibble(
  date_of_birth = xx$DoB,
  HB = xx$HB,
  ethnicity = xx$ethnicity,
  SIMD = xx$SIMD
)

#