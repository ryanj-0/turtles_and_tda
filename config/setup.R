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

