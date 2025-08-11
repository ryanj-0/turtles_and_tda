
d <- bioRad_dirs[1] #for testing
bioRad_extractedFolder <- paste(getwd(), "data/extracted/bioRad/", sep = "/")

for (d in bioRad_dirs) {
    message(paste("Running:", d))
    if(list.files(d) |> length() > 1){ #check if only .pcrb
        if(file_test("-d", d)){ #directory check
            dirNum <- sub(".*BioRad Files/", "", d)
            bioRad_files <- list.files(d, pattern = ".csv", full.names = TRUE)

            for(i in seq(1, length(bioRad_files), 2)) {

                bioRad_one <- fread(bioRad_files[i], header = TRUE)
                bioRad_one_name <- str_extract(bioRad_files[i], "(?<= - ).*(?=.csv)")
                bioRad_two <- fread(bioRad_files[i+1], header = TRUE)
                bioRad_two_name <- str_extract(bioRad_files[i+1], "(?<= - ).*(?=.csv)")

                if(dim(bioRad_one)[1] == 12 && dim(bioRad_one)[2] == 2) { #check for info dataframe
                    bioRad_info <-  bioRad_one %>%
                        pivot_wider(names_from = 1, values_from = 2) %>%
                        rename_with(~ gsub(" ", "_", .x))
                    assign("bioRad_data", bioRad_two)
                    bioRad_data <- bioRad_data %>%
                        rename_with(~ gsub(" ", "_", .x)) %>%
                        select_if(~ !(all(is.na(.))))
                } else {
                    bioRad_info <-  bioRad_two %>%
                        pivot_wider(names_from = 1, values_from = 2) %>%
                        rename_with(~ gsub(" ", "_", .x))
                    assign("bioRad_data", bioRad_one)
                    bioRad_data <- bioRad_data %>%
                        rename_with(~ gsub(" ", "_", .x)) %>%
                        select_if(~ !(all(is.na(.))))
                }

                bioRad_fileCatagory <- str_extract(bioRad_two_name, ".+(?=.xlsx)") |>
                    str_replace_all(" ", "_")
                bioRad_rdsData <- bioRad_fileCatagory %>% str_c(dirNum, "_", .) # to-be RDS file name
                bioRad_rdsPath <- paste0(bioRad_extractedFolder, bioRad_rdsData, ".RDS")
                bioRad_data <- cross_join(bioRad_data, bioRad_info, copy = TRUE) %>%
                    mutate(Plate = dirNum, .before = 1) %>%
                    mutate(File_Catagory = bioRad_fileCatagory, .before = 2) %>%
                    mutate(Source = bioRad_rdsPath |> basename())
                assign(bioRad_rdsData, bioRad_data)

                if(bioRad_rdsPath |> file.exists()){
                    if(all.equal(bioRad_rdsPath |> read_rds(), bioRad_rdsData |> get())) {
                        message(paste("NO CHANGE:", bioRad_rdsPath))
                    } else {
                        saveRDS(bioRad_rdsData |> get(), bioRad_rdsPath)
                        message(paste("UPDATED:", bioRad_rdsData))
                    }
                } else {
                    saveRDS(bioRad_rdsData |> get(), bioRad_rdsPath)
                    message(paste("CREATED:", bioRad_rdsPath |> basename()))
                }
            }
        }
    }else message(paste("ONE FILE:", d)); next
} #end
