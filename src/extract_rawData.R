#######################################################
# Import Raw Data and Store in Process after Extracted
######################################################

dir.exists(c(paste(getwd(), "data/raw/cerebral", sep = "/"),
             paste(getwd(), "data/raw/qRTPCR", sep = "/")))


# Hannah Research Lab Paths -----------------------------------------------
HLR_rawData <- drive_ls(as_id(HLR_data))[1,2] |> unlist()
HLR_rawBioRad_id <- drive_ls(as_id(HLR_rawData))[1,2] |> unlist()
HLR_rawCerebral_id <- drive_ls(as_id(HLR_rawData))[2,2] |> unlist()

# Cerebral Vessel Data ----------------------------------------------------

# data sheet names
cerebral_sheets <- excel_sheets(
    paste(getwd(), "data/raw/cerebral/Cerebral_Blood_Vessel_Compounds.xlsx",
                   sep = "/"))

cerebral_sheets <- cerebral_sheets[!grepl("graphs", cerebral_sheets,
                                      ignore.case = TRUE)]

# save RDS of each chemical sheet
lapply(cerebral_sheets, extract_raw_cerebral_data)


# qRTPCR Data -------------------------------------------------------------

# BioRad Data ----
# Gene Expression, Quantificaiton Plate View/Summary,
# and Melt Curve Plate View/Summary are not necessary tables or are empty.
# We drop the aforementioned files marked NA. Group by file name and split.
bioRad_raw_groupList <- list.files(
    paste(getwd(), "data/raw/qRTPCR/BioRad Files", sep = "/"),
    recursive = TRUE,
    full.names = TRUE) |>
    as_tibble() |>
    rename(file_name = value) |>
    mutate(file_code = case_when(
        grepl("End Point Results", file_name) ~ 1,
        grepl("Melt Curve Amplification Results", file_name) ~ 2,
        grepl("Melt Curve Derivative Results", file_name) ~ 3,
        grepl("Melt Curve Peak Results", file_name) ~ 4,
        grepl("Quantification Amplification Results", file_name) ~ 5,
        grepl("Quantification Cq Results", file_name)  ~ 6,
        .default = NA)) |>
    filter(!is.na(file_code)) |>
    group_by(file_code) |>
    group_split()

bioRad_rawData <- lapply(bioRad_raw_groupList, extract_raw_bioRad_data)

bioRad_transformed_list <- lapply(bioRad_rawData, transform_raw_bioRad_data)



# Plate Data --------------------------------------------------------------

plateData_sheets <- excel_sheets(
    paste(getwd(),"data/raw/qRTPCR/2022_0101_rtPCR ALL.xlsx", sep = "/")) |>
    _[1:3]

plateData_raw <- lapply(plateData_sheets, extract_qrtpcr_channels)
