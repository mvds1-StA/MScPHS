### SECTION 01d_DataZone
### This section focuses on extracting the DATAZONE_2011 from the SMR1 dataset
### and appropriately transform this to SIMD data.

#not able to download devtools (see notes) 
devtools::install_github("TheDataLabScotland/simdr")

#used to download devtools, but ligbit not available to 3.6.1. 
#install.packages("libgit2", dependencies=TRUE)
usethis_source_url <- "https://cran.r-project.org/src/contrib/Archive/usethis/usethis_1.6.3.tar.gz" 
install.packages(usethis_source_url,repos = NULL,type="source") 
install.packages("devtools")
install.packages("gert")

install.packages("remotes")
remotes::install_github("TheDataLabScotland/simdr", force=TRUE)
library(simdr)
test <- simdr::simd16_domains(completeSMR1TestIII, DATAZONE_2011)

#simdr package is not found when used


