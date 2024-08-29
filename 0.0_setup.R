# set directories
if(dir != getwd()){
    dir <- getwd()
}

data.dir <- paste0(dir, "/data")
fxn.dir <- paste0(dir, "/functions")
plots.dir <- paste0(dir, "/plots")
scripts.dir <- paste0(dir, "/rx")

# Set Globals
my.colors <- c("#0072B2","#E69F00", "#71CCFF", "#F0E442", "#CC79A7")

#source needed fxns, files, and pkgs
source(paste0(scripts.dir,"/load_pkgs.R"))
source(paste0(scripts.dir,"/personals.R"))
source(paste0(fxn.dir,"/clean_turtles.R"))

# import data
source(paste0(dir, "/0.1_data_import.R"))

# create ratio metric data table ------------------------------------------
source(paste0(dir, "/0.2_ratio_data.R"))

