##################
# Extact BioRad run information for each path
#########################

extract_raw_bioRad_runInfo <- function(runInfo_path){

    runInfo <- fread(runInfo_path) |>
        pivot_wider(names_from = 1, values_from = 2) |>
        rename_with(~ gsub(" ", "_", .x)) |>
        mutate(file_name = runInfo_path)

    return(runInfo)

}