### SECTION 01c_SimulatedSMR1
### This section simulates the data extracted in 01b_SMR1Data and saves it
### accordingly to funfctions and files.

### Using Synthpop to simulate the data just gathered
set.seed(123)
SMR1_dataSimulate <- syn(SMR1_data, m = 1, method = "parametric", visit.sequence = c(2,1,3), k=number_patients, seed = 125)

SMR1_SimulatedDataComplete <- SMR1_dataSimulate$syn

### Saving the file of data and values
save (
  SMR1_SimulatedDataComplete,
  file=sprintf( "files_created/01c_SimulatedSMR1.Rdat",
                number_patients )
)


