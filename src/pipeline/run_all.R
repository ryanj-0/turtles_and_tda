##########################################
## Run all scripts
#########################################
# Clear environment and reset graphical devices
rm(list = ls())
try(dev.off(dev.list()["RStudioGD"]), silent=TRUE)

# load config
config.files <- list.files(paste(getwd(), "config", sep = "/"))

for (f in config.files) {
    source(paste(getwd(), "config", f, sep = "/"))
    message(f)
}
rm(config.files)

# ETL
source(paste(src.dir, "pipeline", "run_etl.R", sep = "/"))

# EDA
source(paste(src.dir, "pipeline", "run_eda.R", sep = "/"))