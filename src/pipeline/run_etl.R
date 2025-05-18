#############################
# Run full ETL pipeline
############################

# Load Needed Functions ---------------------------------------------------
source(paste(getwd(),"src/functions/clean_turtles.R", sep = "/"))

# Extract -----------------------------------------------------------------
#source(paste(getwd(), "src/pipline/etl/01_data_grab.R", sep = "/")) # run as needed


# Load --------------------------------------------------------------------
source(paste(getwd(), "src/pipeline/etl/02_data_import.R", sep = "/"))


# Transform ---------------------------------------------------------------
# create ratio metric data table
source(paste(getwd(), "src/pipeline/etl/03_ratio_data.R", sep = "/"))
