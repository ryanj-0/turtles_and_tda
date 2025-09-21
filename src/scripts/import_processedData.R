#####################################################
# import/load our extracted data into a usable format
######################################################

# Cerebral Vessel Data ----------------------------------------------------

#list rds files
processed_cerebral <-
    list.files(paste(getwd(), "data/processed/cerebral", sep = '/'),
               pattern = ".rds")
processed_cerebral <- processed_cerebral[!processed_cerebral %like%
                                             "Hist_Base_Data"]

# combine all chemicals for vessel data
cerebral_data <-
    lapply(processed_cerebral, import_cerebral_data) %>%
    list_rbind() %>%
    mutate(across(where(is.numeric), ~ replace_na(.x, 0))) %>%
    mutate(flagM = grepl(".*M", measure))


# qRTPCR Data -------------------------------------------------------------
processed_meltCurve <-
    list.files(paste(getwd(), "data/processed/qRTPCR/",sep = '/'),
               full.names = TRUE, pattern = "Curve") %>%
    lapply(readRDS)

processed_quant <-
    list.files(paste(getwd(), "data/processed/qRTPCR/",sep = '/'),
               full.names = TRUE, pattern = "Quant")

