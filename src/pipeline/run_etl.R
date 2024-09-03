#############################
# Run full ETL pipeline
############################

# Load Needed Functions ---------------------------------------------------
source(paste(getwd(),"src", "functions","clean_turtles.R",
             sep = "/"))

# Extract -----------------------------------------------------------------
source(paste0)

# Load --------------------------------------------------------------------
source(paste0(dir, "/data_import.R"))


# Transform ---------------------------------------------------------------
# create ratio metric data table
source(paste0(dir, "/ratio_data.R"))