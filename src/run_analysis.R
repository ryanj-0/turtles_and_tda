############################
# Run full data pipeline
###########################

# Clear environment, reset graphical devices, set file structure ----
rm(list = ls())
try(dev.off(dev.list()["RStudioGD"]), silent=TRUE)

# load config files ----
source(paste(getwd(), "src/config.R", sep = "/"))

# Load functions ----
sapply(list.files(paste(getwd(), "src/functions", sep = "/"),
                  full.names = TRUE), source)


# Extract, Transform, and Load ----
# check for data directory for new users, if not create new dir
if(!dir.exists(paste(getwd(), "data", sep = "/"))){
    message("created 'Data' directory, please see the tree structure
    below to reduce errors.")
    dir.create(paste(getwd(), "data", sep = "/"))
    fs:::dir_tree(paste(getwd(), "data", sep = "/"), recurse = FALSE)
} else{
    message("'Raw' data directory exists. Select 'N' if no new data.")
    import_new <- readline("Import new raw data? (Y/N): ") |> str_to_title()
    if(import_new %in% c("Y", "Yes")){
        source(paste(getwd(), "src/scripts/extract_rawData.R", sep = "/"))
    }
}

## import extracted data
source(paste(getwd(), "src/scripts/import_processedData.R", sep = "/"))


# EDA ----
final = 0
sapply(list.files(paste(getwd(), "src/plots", sep = "/"), full.names = TRUE),
       source)
