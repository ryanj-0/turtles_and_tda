#######################################
# Load in data from data directory
# ran 20231015 (universal date)
#######################################

# file dir
data.files <- list.files(data.dir)
turtle.path <- paste0(data.dir, data.files[data.files %like% '.xlsx'])
turtle.sheets <- readxl::excel_sheets(turtle.path)

# Check for files

# assign tables for each sheet
hist.base <- readxl::read_excel(turtle.path, sheet = 1)
hist.data <- readxl::read_excel(turtle.path, sheet = 2)
acetyl.data <- readxl::read_excel(turtle.path, sheet = 4)
glyb.data <- readxl::read_excel(turtle.path, sheet = 6)
fiveht.data <- readxl::read_excel(turtle.path, sheet = 8)
fourap.data <- readxl::read_excel(turtle.path, sheet = 10)

# replace spaces with NA
hist.base[hist.base == ""] <- NA
hist.data[hist.data == ""] <- NA
acetyl.data[acetyl.data == ""] <- NA
glyb.data[glyb.data == ""] <- NA
fiveht.data[fiveht.data == ""] <- NA
fourap.data[fourap.data == ""] <- NA

# set as data.table
hist.base <- hist.base %>% as.data.table()
hist.data <- hist.data %>% as.data.table()
acetyl.data <- acetyl.data %>% as.data.table()
glyb.data <- glyb.data %>% as.data.table()
fiveht.data <- fiveht.data %>% as.data.table()
fourap.data <- fourap.data %>% as.data.table()


# # save rds file
saveRDS(hist.base, paste0(data.dir, "hist_base.rds"))
saveRDS(hist.data, paste0(data.dir, "hist_data.rds"))
saveRDS(acetyl.data, paste0(data.dir, "acetyl_data.rds"))
saveRDS(glyb.data, paste0(data.dir, "glyb_data.rds"))
saveRDS(fiveht.data, paste0(data.dir, "fiveht_data.rds"))
saveRDS(fourap.data, paste0(data.dir, "fourap_data.rds"))
