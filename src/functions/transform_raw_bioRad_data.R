###############################
# Transform BioRad Data to a uniform format using "file_code" column
#################################

transform_raw_bioRad_data <- function(bioRad_extracted_group){

    transform_selector <- bioRad_extracted_group$file_code |> unique()
    valueName <- bioRad_extracted_group$file_cat |> unique()

    if(transform_selector %in% c(2,3,5)){

        # Following tables have same structure
        #   Melt_Curve_Amplification_Results
        #   Melt_Curve_Derivative_Results
        #   Quant_Amplification_Results
        return_transformed <- bioRad_extracted_group |>
            pivot_longer(2:97, names_to = "Well",
                         values_to = "Value") |>
            mutate(Well = if_else(nchar(Well) == 2,
                                  gsub("^([A-Z]{1})([0-9])+$", "\\10\\2", Well),
                                  Well)) |>
            rename_with(~valueName, Value)

    } else if(transform_selector %in% c(1,4,6)){

        # Following tables have same structure
        #   End Point Results
        #   Melt_Curve_Peak_Results
        #   Quant_Cq_Results
        return_transformed <- bioRad_extracted_group

    } else{
        stop("Outside of expected input, see code to fix.")
    }

    # Global transformations
    dateFormat <- "%m/%d/%Y %I:%M:%S %p UTC -08:00"
    setNumeric <- c("Sample_Vol", "Lid_Temp", "End_RFU", "Temperature",
                    "Melt_Curve_Amp", "Melt_Temperature", "Peak_Height",
                    "Beginning_Temperature", "End_Temperature", "Melt_Temp",
                    "Cq", "Cq_Mean", "Cq_Std._Dev", "SQ_Mean", "SQ_Std._Dev",
                    "Set_Point")

    return_transformed <- return_transformed |>
        mutate(across(contains(setNumeric), as.numeric)) |>
        mutate(across(c("Run_Started","Run_Ended"),
                      ~ as.Date(.x, format = dateFormat)))

    # Save RDS Copy
    saveCat = return_transformed |> pull(file_cat) |> unique()
    file_name <- paste0(getwd(), "/data/processed/qRTPCR/",saveCat,".rds")
    saveRDS(return_transformed, file_name)

    return(return_transformed)
}