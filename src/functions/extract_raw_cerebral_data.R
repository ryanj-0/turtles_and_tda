##############################################
# extract raw vessel data based on sheet name
##############################################

extract_raw_cerebral_data <- function(sheetName){

    raw_data <- read_excel(
        paste(
            getwd(), "data/raw/cerebral/Cerebral_Blood_Vessel_Compounds.xlsx",
            sep = "/"),
        sheet = sheetName)

    file_name <- paste0(getwd(), "/data/processed/cerebral/",
                        gsub(" ", "_", sheetName),".rds")
    saveRDS(raw_data,file_name)

    message("Processed: ", sheetName)
}