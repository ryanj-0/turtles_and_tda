####
# Run main analysis
####

# Clear environment and reset graphical devices ----
rm(list = ls())
try(dev.off(dev.list()["RStudioGD"]), silent=TRUE)

# load config ----
sapply(list.files(paste(getwd(), "src/config", sep = "/"),
                  full.names = TRUE),
                  source)

# Load functions ----
sapply(list.files(paste(getwd(), "src/functions", sep = "/"),
                  full.names = TRUE),
       source)


# ETL ----
## data extraction script, run as needed.
## source(paste(getwd(), "src/pipline/etl/01_data_grab.R", sep = "/"))

## import extracted data
source(paste(getwd(), "src/scripts/load_extracted.R", sep = "/"))

## Create ratio-metric data for vessel analysis
source(paste(getwd(), "src/create_ratioData.R", sep = "/"))

# EDA ----
final = 0
sapply(list.files(paste(getwd(), "src/plots", sep = "/"), full.names = TRUE),
       source)
