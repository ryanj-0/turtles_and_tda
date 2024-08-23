# Clear environment and reset graphical devices
rm(list = ls())

# set directories
dir <- getwd()
data.dir <- paste0(dir, "/data")
fxn.dir <- paste0(dir, "/functions")
plots.dir <- paste0(dir, "/plots")

# Set Globals
my.colors <- c("#0072B2","#E69F00", "#71CCFF", "#F0E442", "#CC79A7")

#source needed fxns and files
source(paste0(dir,"/load_pkgs.R"))
source(paste0(dir,"/personals.R"))

source(paste0(fxn.dir,"/clean_turtles.R"))

#list rds files
rds.data <- list.files(data.dir, pattern = ".rds") |>
   _[-5] # drop hist_base

#run clean_turtles
rds.data <- lapply(rds.data, clean.turtles) |>
   invisible()

#combine and reorder
turtle.data.all <- do.call(rbind, rds.data)
turtle.names <- c('date', 'water', 'chem', 'measure',
                  'starting.notes.z1', 'z1',
                  'pct.zero.ca.z1', 'pct.delta.prior.z1', 'notes.z1',
                  'starting.notes.z2',
                  'z2', 'pct.zero.ca.z2', 'pct.delta.prior.z2', 'notes.z2')
setcolorder(turtle.data.all, turtle.names)

turtle.data.all[, pct.delta.prior.z1:=as.numeric(pct.delta.prior.z1)] |>
   _[, pct.delta.prior.z2:=as.numeric(pct.delta.prior.z2)]

# NAs to 0
turtle.data.all[is.na(z1), z1:= 0] |>
   _[is.na(z2), z2:= 0] |>
   _[is.na(pct.zero.ca.z1), pct.zero.ca.z1:= 0] |>
   _[is.na(pct.zero.ca.z2), pct.zero.ca.z2:= 0] |>
   _[is.na(pct.delta.prior.z1), pct.delta.prior.z1:= 0] |>
   _[is.na(pct.delta.prior.z2), pct.delta.prior.z2:= 0]

# Make Final data set; drop cols with "...notes"
turtle.data <- turtle.data.all[, .(date, water, chem, measure,
                                     z1, pct.zero.ca.z1, pct.delta.prior.z1,
                                     z2, pct.zero.ca.z2, pct.delta.prior.z2,
                                     trial)]

# fix one-offs
turtle.data[measure %like% "accidental", 4:= "33.3 uM*"]

# Check NAs in data
if(turtle.data |> is.na() |> rowSums() |> sum()){
   which(turtle.data.nas > 0)
   turtle.data.nas <- which(turtle.data.nas > 0)
   message("Rows which contain NA: ")
   print(turtle.data.nas)
}

# Graphs ------------------------------------------------------------------
# Frequency plot by Measure
source(paste0(plots.dir, "/freq_by_measure.R"))

# Observations by Water Temperature
source(paste0(plots.dir, "/observations_by_water_temp.R"))

# Ratio Metric Data
source(paste0(dir, "/ratio_data.R"))


# CC Loop -----------------------------------------------------------------
# epsilon bound table
temps <- c("all", "21CN", "21CA", "5CA", "5CN") |> rep(2)
chems <- c(rep("hist", 5), rep("fourap", 5))
hist.bounds <-
   data.table(
      e.min = c(0.000005, 0.0001678, 0.0002758, 0.0000399, 0.000203),
      e.max = c(0.062108, 0.0762, 0.1682, 0.13612, 0.09642)
      )
fourap.bounds <-
   data.table(
      e.min = c(0.000002436, 0.000042597, 0.000020011, 0.0000312, 0.0000914),
      e.max = c(0.088172, 0.198331, 0.120192, 0.191617, 0.141783)
      )

bounds <- cbind(temps,
                chems,
                rbind(hist.bounds, fourap.bounds))


# User Parameters
steps = 50
correct = 0
#source(paste0(dir, "/run_bm_loop.R")) # last ran 2024/06/11


# BM Graphs Loop ----------------------------------------------------------
c.list <- ls()[ls() %like% "cc."]
source(paste0(fxn.dir, "/set_pointcloud_coloring.R"))
source(paste0(fxn.dir, "/loop_bm_graphs.R"))

foreach(i=c.list) %do% loop_bm_graphs(i)

