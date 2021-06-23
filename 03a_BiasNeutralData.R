
gender_bias <- sample(SMR1_SimulatedDataRecruited$SEX, size=number_patients,
                      rep=TRUE,prob=c(0.7, 0.3))


for i in SMR1_SimulatedDataRecruited
  if SMR1_SimulatedDataRecruited$SEX = 1 then:
      probability of recruitment is 0.7
  if SMR1_SimulatedDataRecruited$SEX = 2 then:
    probability of recruitment is 0.3


get_SIMD16_Quintile = function ( id ) {
    return( PATIENT.DATA %>% filter( id == id ) %>% pull(SIMD16_Quintile) )
}

SIMD16_Quintile_definition = defDataAdd( varname = "SIMD16_Quintile",
                                           dist    = "nonrandom",
                                           formula = "get_SIMD16_Quintile(idnum)" )

trial_data.synthetic = addColumns(SIMD16_Quintile_definition,trial_data.synthetic)