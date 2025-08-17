##############################################
# extract raw vessel data based on sheet name
##############################################

extract_rawVesselData <- function(sheet){

    raw_data <- read_excel(
        paste(getwd(), "data/raw/vessel/Cerebral_Blood_Vessel_Compounds.xlsx",
              sep = "/"),
        sheet = sheet)

    file_name <- paste0(getwd(), "/data/processed/vessel/",
                        gsub(" ", "_", sheet),".rds")
    saveRDS(raw_data,file_name)

    message("Processed: ", sheet)
}