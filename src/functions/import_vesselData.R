############################################
# Function to clean and combine raw data
# source: Cerebral Vessel Data
############################################
import_vesselData <- function(data_file) {

   # set file name
   chem_name <- str_extract(data_file, ".+(?=.rds)")
   message("Cleaning and Importing: ", chem_name)

   # Load in data file
   tmp_data <- readRDS(paste(getwd(), "data/processed/vessel", data_file,
                             sep = '/'))

   # get row numbers to find where data is divided
   data_dividers <- {rowSums(is.na(tmp_data)) == ncol(tmp_data)} |> which()

   #set column names
   tibble_names <- c("measure",
                     "z1", "pct.zero.ca.z1", "pct.delta.prior.z1", "notes.z1",
                     "z2", "pct.zero.ca.z2", "pct.delta.prior.z2", "notes.z2")

   # raw RDS data of select data
   tmp_data <- tmp_data %>%
      select(1:9) %>%
      set_names(tibble_names) %>%
      mutate(chem = chem_name, .before = measure)

   # table indicating start and ending rows raw RDS data
   sec_table <- tibble(starts = lag(data_dividers, 1) + 1,
                       ends = data_dividers -1) %>%
      mutate(starts = replace_na(starts, 1))%>%
      add_row(starts = last(data_dividers) + 1,
              ends = nrow(tmp_data)) %>%
      mutate(row_id = row_number())

   # create list tibbles of each trial run
   sec_list <- tmp_data %>%
      mutate(rows = row_number()) %>%
      inner_join(sec_table, join_by(between(rows, starts, ends))) %>%
      arrange(row_id, rows) %>%
      group_by(row_id) %>%
      group_split()

   return_data <- lapply(sec_list, clean_vesselData) %>%
      list_rbind()


   return(return_data)
}

