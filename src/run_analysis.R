############################
# Run full analysis pipeline
###########################

# Clear environment, reset graphical devices, set file structure ----
rm(list = ls())
try(dev.off(dev.list()["RStudioGD"]), silent=TRUE)

# load config files ----
sapply(list.files(paste(getwd(), "src/config", sep = "/"),
                  full.names = TRUE), source)

# Load functions ----
sapply(list.files(paste(getwd(), "src/functions", sep = "/"),
                  full.names = TRUE), source)


# Etraxt, Transform, and Load ----
# check for data directory for new users
if(!dir.exists(paste(getwd(), "data", sep = "/"))){
    message("created 'Data' directory, please see the tree structure
    below to reduce errors.")
    dir.create(paste(getwd(), "data", sep = "/"))
    fs:::dir_tree(paste(getwd(), "data", sep = "/"), recurse = FALSE)
} else{
    message("'Raw' data directory exists.")
    import_new <- readline("Import new raw data? (Y/N)?: ") |> str_to_title()
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
