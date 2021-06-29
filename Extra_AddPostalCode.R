### Add Postcode to every patient
POSTALCODE = postcode_holder 
SMR1_SimulatedDataPostal <- cbind(SMR1_SimulatedDataComplete, postcode_holder[-1,])
SMR1_SimulatedDataPostal

save( SMR1_SimulatedDataPostal,
      number_patients,
      file=sprintf( "files_created/01d_SMR1wPostal.Rdat",
                    number_patients ) )
