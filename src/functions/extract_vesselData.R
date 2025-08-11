############################################
# Function to clean and combine raw data
############################################
extract_vesselData <- function(data_file) {

   # set file name
   file_name <- str_extract(data_file, ".+(?=.rds)")
   chem_name <- str_extract(data_file, ".+(?=_)")
   message("Working: ", file_name)

   # Load in data file
   tmp_data <- readRDS(paste(getwd(), "data/processed/vessel", data_file,
                             sep = '/'))

   # get row numbers to find where data is divided
   data_dividers <- {rowSums(is.na(tmp_data)) == ncol(tmp_data)} |> which()

   #column names and empty data.table
   tibble_names <- c("measure",
                     "z1", "pct.zero.ca.z1", "pct.delta.prior.z1", "notes.z1",
                     "z2", "pct.zero.ca.z2", "pct.delta.prior.z2", "notes.z2")
   pss.dt <- data.table(name = c("one", "two", "three"))

   # subset, clean, and add data
   tmp_data <- tmp_data %>%
      select(1:9) %>%
      set_names(tibble_names) %>%
      mutate(chem = chem_name)

   # Read through table and transfrom to cleaner format
   return_tibble <- list[]

   for(i in seq_along(data_dividers)){

      if(i == 1){
         sec_start <- {data_dividers[i]}-{data_dividers[i]-1}
         sec_end <- data_dividers[i]-1
         sec_tmp <- tmp_data[sec_start:sec_end, ]
         print(sec_tmp)
      } else{
         sec_start <- data_dividers[i-1]+1
         sec_end <- data_dividers[i]-1
         print(sec_start:sec_end)
      }



   }
    return(dt)
}


# add needed columns
for (x in 1:nrow(section.tmp[measure %like% "PSS", 1])){
   section.tmp[measure %like% "PSS", 1][x] <- paste0("PSS.", pss.dt[x])
}
section.tmp[, date := as.numeric(section.tmp[1, 2]) %>% as.Date(origin = "1899-12-30")]
section.tmp[, water:= section.tmp[1,1]]
section.tmp[, starting.notes.z1:= section.tmp[1,5]]
section.tmp[, starting.notes.z2:= section.tmp[1,9]]
section.tmp[, trial:= d]
section.tmp <- section.tmp[-1]
dt <- rbind(dt, section.tmp)