load("files_created/01d_SMR1wPostal.Rdat")

### SMR1_SimulatedDataPostal


### NOTE THAT YOU HAVE SOME SEX VARIABLES BEING SOMETHING
### OTHER THAN 1/2. Can you amend so that where SEX<1, it should
### be changed to 1 and where SEX>2, it should be changed to 2,
### as below.

SMR1_SimulatedDataPostal = SMR1_SimulatedDataPostal %>% 
  mutate( SEX_corrected = case_when( SEX < 1 ~ 1,
                                     SEX > 2 ~ 2,
                                     TRUE ~ SEX ) )

SMR1_SimulatedDataPostal.tmp = SMR1_SimulatedDataPostal %>% 
  mutate( SEX_intermediate = case_when( as.numeric(SEX_corrected) == 1 ~ 0.7,
                                        as.numeric(SEX_corrected) == 2 ~ 0.3,
                                        TRUE ~ NA_real_ ) )

recruitment_definition.neutral = defDataAdd( varname = "RECRUITMENT_neutral",
                                             dist    = "binary",
                                             formula = 0.5 )
recruitment_definition.biased = defDataAdd( varname = "RECRUITMENT_SEXbias",
                                             dist    = "binary",
                                             formula = "SEX_intermediate",
                                            link = "identity")

SMR1_SimulatedDataPostal.new1 = addColumns(recruitment_definition.neutral,
                                            as.data.table( SMR1_SimulatedDataPostal.tmp) )

SMR1_SimulatedDataPostal.new2 = addColumns(recruitment_definition.biased,
                                            as.data.table( SMR1_SimulatedDataPostal.new1) )

recruitment_summary = SMR1_SimulatedDataPostal.new2 %>% 
  pivot_longer( cols = starts_with( "RECRUITMENT_" ),
                names_to = "recruitment_model",
                values_to = "recruitment_q") %>% 
  group_by( SEX_corrected, recruitment_model, recruitment_q ) %>% 
  dplyr::summarise( n=n() ) %>% 
  pivot_wider( names_from = recruitment_q,
               values_from = n ) %>% 
  arrange( recruitment_model ) %>% 
  dplyr::rename( YES = `1`,
                 NO = `0` ) %>% 
  ungroup() %>% 
  mutate( SEX = recode( SEX_corrected,
                        "1" = "Female",
                        "2" = "Male" )) %>% 
  select( recruitment_model, SEX, YES, NO ) 

recruitment_summary %>%
  filter( recruitment_model == "RECRUITMENT_neutral" ) %>% 
  janitor::adorn_totals( where = "col" ) %>% 
  mutate( RATIO = YES/(YES+NO) ) 

recruitment_summary %>% filter( recruitment_model == "RECRUITMENT_SEXbias" ) %>% 
  janitor::adorn_totals( where = "col" ) %>% 
  mutate( RATIO = YES/(YES+NO) ) 
