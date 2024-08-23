############################################
# Function to clean and combine data #######
############################################
clean.turtles <- function(data.file) {

   # set file name
   file.name <- tools::file_path_sans_ext(data.file)
   chem.name <- stringr::str_extract(file.name, "[^_]+")
   message("Working ", file.name)

   # Load in data file and get data breaks
   temp.data <- readRDS(paste0(data.dir, "/", data.file))
   data.dividers <- is.na(temp.data[ , 1]) %>% which()

   #column names and empty data.table
   dt.names <- c("measure",
                 "z1", "pct.zero.ca.z1", "pct.delta.prior.z1", "notes.z1",
                 "z2", "pct.zero.ca.z2", "pct.delta.prior.z2", "notes.z2")
   dt <- data.table()
   pss.dt <- data.table(name = c("one", "two", "three"))

   # data cleaning and processing
   temp.data <- temp.data[ , 1:9]
   setnames(temp.data, dt.names)

   # add columns
   temp.data[ , chem:=chem.name]

   # Loop to read through data
   for(d in 1:(length(data.dividers)+1)){

      # pseudo 0-index
      if(d == 1){
         section.temp <- temp.data[1:(data.dividers[d]-1)]
      }else if(d == length(data.dividers)+1){
         section.temp <- temp.data[(data.dividers[d-1]+1):nrow(temp.data)]
      }else{
         section.temp <- temp.data[(data.dividers[d-1]+1):(data.dividers[d]-1)]
      }

      # add needed columns
      for (x in 1:nrow(section.temp[measure %like% "PSS", 1])){
         section.temp[measure %like% "PSS", 1][x] <- paste0("PSS.", pss.dt[x])
      }
      section.temp[, date := as.numeric(section.temp[1, 2]) %>%
                      as.Date(origin = "1899-12-30")]
      section.temp[, water:= section.temp[1,1]]
      section.temp[, starting.notes.z1:= section.temp[1,5]]
      section.temp[, starting.notes.z2:= section.temp[1,9]]
      section.temp[, trial:= d]
      section.temp <- section.temp[-1]
      dt <- rbind(dt, section.temp)
   }
   return(dt)
}


