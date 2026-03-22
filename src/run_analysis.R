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
data_dir <- file.path(getwd(), "data")
if (!dir.exists(data_dir)) {
    message("created 'data' directory, please see the tree structure
    below to reduce errors.")
    dir.create(data_dir)
    fs::dir_tree(data_dir, recurse = FALSE)
} else {
    message("'data' directory exists. Select 'N' if no new data.")
    import_new <- readline("Import new raw data? (Y/N): ") |> tolower()
    if (import_new %in% c("y", "yes")) {
        source(file.path(getwd(), "src/extract_rawData.R"))
    }
}

## import extracted data
source(paste(getwd(), "src/import_processedData.R", sep = "/"))


# EDA ----
final = 0
sapply(list.files(paste(getwd(), "plots", sep = "/"), full.names = TRUE),
       source)
