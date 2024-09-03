#############################
# Run full ETL pipeline
############################
# set globals
etl.dir <- paste(src.dir, "pipeline", "etl", sep = "/")

# Load Needed Functions ---------------------------------------------------
source(paste(getwd(),"src", "functions","clean_turtles.R", sep = "/"))

# Extract -----------------------------------------------------------------
#source(paste(etl.dir, "data_grab.R", sep = "/")) # run as needed


# Load --------------------------------------------------------------------
source(paste(etl.dir, "02_data_import.R", sep = "/"))


# Transform ---------------------------------------------------------------
# create ratio metric data table
source(paste(etl.dir, "03_ratio_data.R", sep = "/"))
