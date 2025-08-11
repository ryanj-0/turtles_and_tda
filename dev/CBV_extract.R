#######################################
# Load Cerebral Data
# File Name: Cerebral_Blood_Vessel_Compounds
#######################################

# file dir
CBV_file <- list.files("~/R/turtles_and_tda/data/raw", full.names = TRUE)[1]
CBV_sheets <- excel_sheets(CBV_file)[c(2,4,6,8,10)]




# assign tables for each sheet
hist.base <- read_excel(turtle.path, sheet = 1)
hist.data <- read_excel(turtle.path, sheet = 2)
acetyl.data <- read_excel(turtle.path, sheet = 4)
glyb.data <- read_excel(turtle.path, sheet = 6)
fiveht.data <- read_excel(turtle.path, sheet = 8)
fourap.data <- read_excel(turtle.path, sheet = 10)

# # save rds file
saveRDS(hist.base, paste(data.dir, "extracted/hist_base.rds", sep = '/'))
saveRDS(hist.data, paste(data.dir, "extracted/hist_data.rds", sep = '/'))
saveRDS(acetyl.data, paste(data.dir, "extracted/acetyl_data.rds", sep = '/'))
saveRDS(glyb.data, paste(data.dir, "extracted/glyb_data.rds", sep = '/'))
saveRDS(fiveht.data, paste(data.dir, "extracted/fiveht_data.rds", sep = '/'))
saveRDS(fourap.data, paste(data.dir, "extracted/fourap_data.rds", sep = '/'))
