##############################################
# Fuction to extract Bio Rad raw data to combine with data
# that has the Genes coded by run
#####################################################

extract_raw_bioRad_data <- function(bioRad_raw_group){

    bioRad_raw_group <- bioRad_raw_group |>
        mutate(file_type = str_extract(bioRad_raw_group$file_name,
                                       "(?<=(.xlsx\\s-\\s)).*(?=.csv)"),
               run_num = str_extract(bioRad_raw_group$file_name,
                                     "(?<=(Files/)).*(?=/)"))

    # Extract BioRad Run Data
    bioRad_runData_files <- bioRad_raw_group |>
        filter(file_type != "Run Information")

    bioRad_runData <- lapply(bioRad_runData_files$file_name,
                                  extract_raw_bioRad_runData) |>
        list_rbind() |>
        full_join(bioRad_runData_files, by = "file_name") |>
        mutate(file_name = str_extract(file_name, "^.*(?=\\s-\\s.*.csv)")) |>
        select(-file_type)

    # Extract BioRad Run Information
    bioRad_runInfo_files <- bioRad_raw_group |>
        filter(file_type == "Run Information")

    bioRad_runInfo <- lapply(bioRad_runInfo_files$file_name,
                             extract_raw_bioRad_runInfo) |>
        list_rbind() |>
        full_join(bioRad_runInfo_files, by = "file_name") |>
        mutate(file_name = str_extract(file_name, "^.*(?=\\s-\\s.*.csv)")) |>
        select(-file_type)

    # Join extracted data
    return_bioRad_group <- full_join(bioRad_runData, bioRad_runInfo,
                                     by = join_by("file_name", "file_code",
                                                  "run_num")) |>
        select(-c(file_name)) |>
        mutate(file_cat = case_when(file_code == 1 ~ "End_Point",
                                    file_code == 2 ~ "MeltCurve_Amp",
                                    file_code == 3 ~ "MeltCurve_Deriv",
                                    file_code == 4 ~ "MeltCurve_Peak",
                                    file_code == 5 ~ "Quant_Amp",
                                    file_code == 6 ~ "Quant_Cq")) |>
        as_tibble()

    return(return_bioRad_group)

}