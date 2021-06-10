#Define hospital postcode
hospital_postcode = "EH105HF"
hospital_postcod_info = postcode_lookup(hospital_postcode)

#Ask Lisa what this list means and what it refers too
list_of_outcodes = c( sprintf( "PA%d", c( 1:19 ) ),
                      sprintf( "G%d" , c( 41:46,
                                          51:53,
                                          60,
                                          73:78,
                                          81, 82, 84) )
)


#Set the list 
list_of_postcodes = tibble(
  outocde = hospital_postcod_info$outcode,
  postcode = hospital_postcod_info$postcode,
  longitude = hospital_postcod_info$longitude,
  latitude = hospital_postcod_info$latitude,
  zone_intermediate = hospital_postcod_info$msoa,
  zone_lower = hospital_postcod_info$lsoa,
  admin_authority = hospital_postcod_info$admin_district
)

#Iterate through the participants 
for (i in 1:number_patients) {
  
  this.outcode = sample(list_of_outcodes, 1)
  
  this.postcode_information = random_postcode(this.outcode)
  
  if (i %% 25 == 0) {
    cat( sprintf("%04d Random postcodes generated\n",
                  i) )
  }
  
  postcode_holder = postcode_holder %>% 
    add_row( idnum = i,
             outcode  = this.outcode,
             postcode = this.postcode_information$postcode,
             longitude = this.postcode_information$longitude,
             latitude  = this.postcode_information$latitude,
             zone_intermediate = this.postcode_information$msoa,
             zone_lower        = this.postcode_information$lsoa,
             admin_authority   = this.postcode_information$admin_district )
  
  
}

postcode_holder = postcode_holder %>%
  arrange(idnum) %>% 
  mutate(group = ifelse( is.na(idnum),
                          "Hospital",
                          "Participant") )

save( postcode_holder,
      list_of_outcodes,
      hospital_postcode,
      hospital_postcode_information,
      number_of_participants,
      file=sprintf( "dat/01a_POSTCODES.Rdat",
                    number_of_participants ) )