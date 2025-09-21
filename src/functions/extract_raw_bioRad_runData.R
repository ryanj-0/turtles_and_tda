#########################
# Extact BioRad Run Data for each path in group
#########################

extract_raw_bioRad_runData <- function(runData_path){

    runData <- fread(runData_path)

    if(lapply(names(runData),
              str_detect, pattern = "V[[:alnum:]]") |> unlist() |> all()){

        names(runData) <- runData[1, ] |> unlist()
        runData <- runData |>
            mutate(across(7:10,as.numeric)) |>
            slice(-1)
    }

    runData <- runData |>
        rename_with(~ gsub(" ", "_", .x)) |>
        select(-1) |>
        mutate(file_name = runData_path)

    return(runData)

}