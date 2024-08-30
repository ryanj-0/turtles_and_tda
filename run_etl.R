#############################
# Run full ETL pipeline
############################

# Load Needed Functions ---------------------------------------------------
source(paste0(fxn.dir,"/clean_turtles.R"))

# Extract -----------------------------------------------------------------


# Load --------------------------------------------------------------------
source(paste0(dir, "/data_import.R"))


# Transform ---------------------------------------------------------------
# create ratio metric data table
source(paste0(dir, "/ratio_data.R"))