##########################################
## Run all scripts
#########################################
# Clear environment and reset graphical devices
rm(list = ls())
try(dev.off(dev.list()["RStudioGD"]), silent=TRUE)

# set global dir
dir <- getwd()

# Setup
source(paste0(dir, "/0.0_setup.R"))

# EDA
source(paste0(dir, "/1.0_eda.R"))
