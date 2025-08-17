#####################################################
# import/load our extracted data into a usable format
######################################################

# Cerebral Vessel Data ----------------------------------------------------

#list rds files
rds_data <- list.files(paste(getwd(), "data/processed/vessel", sep = '/'),
                       pattern = ".rds")[-5] # drop hist_base

# combine all chemicals for vessel data
vesselData <- lapply(rds_data, import_vesselData) %>%
    list_rbind() %>%
    mutate(across(where(is.numeric), ~ replace_na(.x, 0))) %>%
    mutate(flagM = grepl(".*M", measure))


# qRTPCR Data -------------------------------------------------------------


