############################################
# Function to clean and combine data #######
############################################
clean_turtles <- function(data.file) {

   # set file name
   file.name <- str_extract(data.file, ".+(?=.rds)")
   chem.name <- str_extract(data.file, ".+(?=_)")
   message("Working: ", file.name)

   # Load in data file and get data breaks
   tmp.data <- readRDS(paste(getwd(), "data/extracted", data.file, sep = '/'))
   data.dividers <- {rowSums(is.na(tmp.data)) >= ncol(tmp.data)} |>
       which()

   #column names and empty data.table
   dt.names <- c("measure",
                 "z1", "pct.zero.ca.z1", "pct.delta.prior.z1", "notes.z1",
                 "z2", "pct.zero.ca.z2", "pct.delta.prior.z2", "notes.z2")
   dt <- data.table()
   pss.dt <- data.table(name = c("one", "two", "three"))

   # data cleaning and processing
   tmp.data <- tmp.data[ , 1:9] |> as.data.table()
   setnames(tmp.data, dt.names)

   # add columns
   tmp.data[ , chem:=chem.name]

   # Loop to read through data
   for(d in 1:(length(data.dividers)+1)){

      # pseudo 0-index
      if(d == 1){
         section.tmp <- tmp.data[1:(data.dividers[d]-1)]
      }else if(d == length(data.dividers)+1){
         section.tmp <- tmp.data[(data.dividers[d-1]+1):nrow(tmp.data)]
      }else{
         section.tmp <- tmp.data[(data.dividers[d-1]+1):(data.dividers[d]-1)]
      }

      # add needed columns
      for (x in 1:nrow(section.tmp[measure %like% "PSS", 1])){
         section.tmp[measure %like% "PSS", 1][x] <- paste0("PSS.", pss.dt[x])
      }
      section.tmp[, date := as.numeric(section.tmp[1, 2]) %>%
                      as.Date(origin = "1899-12-30")]
      section.tmp[, water:= section.tmp[1,1]]
      section.tmp[, starting.notes.z1:= section.tmp[1,5]]
      section.tmp[, starting.notes.z2:= section.tmp[1,9]]
      section.tmp[, trial:= d]
      section.tmp <- section.tmp[-1]
      dt <- rbind(dt, section.tmp)
   }
   return(dt)
}


