##################
#
#################

bioRad_rdsList <- list.files(paste(getwd(), "data/extracted/bioRad", sep = "/"), full.names = TRUE)

bioRad_catagories <- c("End_Point_Results", "Melt_Curve_Amplification_Results",
                       "Melt_Curve_Derivative_Results", "Melt_Curve_Peak_Results",
                       "Quantification_Amplification_Results", "Quantification_Cq_Results")

for(i in bioRad_catagories){
    tmpData <- bioRad_rdsList[bioRad_rdsList %like% i] %>%
        lapply(., readRDS) %>%
        lapply(., mutate_all, as.character) %>%
        lapply(., mutate, Plate = as.numeric(Plate)) %>%
        list_rbind() %>%
        as_tibble()
    assign(i, tmpData)
}

bioRad_allData <- lapply(bioRad_catagories, get)
tblNames <- lapply(bioRad_allData, names)

# list to cross reference for numeric type
numericList <- c("Sample_Vol", "Lid_Temp", "End_RFU", "Temperature", "Result",
                 "Melt_Temperature", "Peak_Height", "Beginning_Temperature", "End_Temperature",
                 "Melt_Temp", "Cq", "Cq_Mean", "Cq_Std._Dev", "SQ_Mean", "SQ_Std._Dev", "Set_Point")
dateFormat <- "%m/%d/%Y %I:%M:%S %p UTC -08:00"
dropCols <- c("File_Catagory", "Created_By_User", "Notes", "ID", "Protocol_File_Name",
              "Plate_Setup_File_Name", "Base_Serial_Number", "Optical_Head_Serial_Number",
              "CFX_Manager_Version", "Source", "Content", "Sample_Type", "CallType", "Is_Control")

# End Point Results
End_Point_Results <- End_Point_Results %>%
    mutate(across(contains(numericList), as.numeric)) %>%
    mutate(across(c("Run_Started","Run_Ended"), ~ as.Date(.x, format = dateFormat))) %>%
    rename(End_Point_End_RFU = End_RFU,
           Position = Well) %>%
    select(-any_of(dropCols))

# Melt_Curve_Amplification_Results
Melt_Curve_Amplification_Results <- Melt_Curve_Amplification_Results %>%
    pivot_longer(4:99, names_to = "Well", values_to = "Result") %>%
    relocate(Well, Result, .after = Temperature) %>%
    mutate(Well = if_else(nchar(Well) == 2,
                          gsub("^([A-Z]{1})([0-9])+$", "\\10\\2", Well),
                          Well)) %>%
    mutate(across(contains(numericList), as.numeric)) %>%
    mutate(across(c("Run_Started","Run_Ended"), ~ as.Date(.x, format = dateFormat))) %>%
    rename(Melt_Curve_Amp = Result,
           Position = Well) %>%
    select(-any_of(dropCols))

# Melt_Curve_Derivative_Results
Melt_Curve_Derivative_Results <- Melt_Curve_Derivative_Results %>%
    pivot_longer(4:99, names_to = "Well", values_to = "Result") %>%
    relocate(Well, Result, .after = Temperature) %>%
    mutate(Well = if_else(nchar(Well) == 2,
                          gsub("^([A-Z]{1})([0-9])+$", "\\10\\2", Well),
                          Well)) %>%
    mutate(across(contains(numericList), as.numeric)) %>%
    mutate(across(c("Run_Started","Run_Ended"), ~ as.Date(.x, format = dateFormat)))%>%
    rename(Melt_Curve_Deriv = Result,
           Position = Well) %>%
    select(-any_of(dropCols))

# Melt_Curve_Peak_Results
Melt_Curve_Peak_Results <- Melt_Curve_Peak_Results %>%
    mutate(across(contains(numericList), as.numeric)) %>%
    mutate(across(c("Run_Started","Run_Ended"), ~ as.Date(.x, format = dateFormat))) %>%
    rename(Melt_Curve_Peak_Melt_Temp = Melt_Temperature,
           Melt_Curve_Peak_Begin_Temp = Begin_Temperature,
           Melt_Curve_Peak_End_Temp = End_Temperature,
           Melt_Curve_Peak_Height = Peak_Height,
           Position = Well) %>%
    select(-any_of(dropCols))

# Quantification_Amplification_Results
Quantification_Amplification_Results <- Quantification_Amplification_Results |> as_tibble() %>%
    pivot_longer(4:99, names_to = "Well", values_to = "Result") %>%
    relocate(Well, Result, .after = Cycle) %>%
    mutate(Well = if_else(nchar(Well) == 2,
                          gsub("^([A-Z]{1})([0-9])+$", "\\10\\2", Well),
                          Well)) %>%
    mutate(across(contains(numericList), as.numeric)) %>%
    mutate(across(c("Run_Started","Run_Ended"), ~ as.Date(.x, format = dateFormat))) %>%
    rename(Quant_Amp = Result,
           Position = Well) %>%
    select(-any_of(dropCols))

# Quantification_Cq_Results
Quantification_Cq_Results <- Quantification_Cq_Results |> as_tibble() %>%
    mutate(across(contains(numericList), as.numeric)) %>%
    mutate(across(c("Run_Started","Run_Ended"), ~ as.Date(.x, format = dateFormat))) %>%
    rename(Position = Well) %>%
    select(-c(any_of(dropCols),
              starts_with("SQ"),
              Cq_Mean, Cq_Std._Dev))


test <- reduce(list(End_Point_Results,
                    Melt_Curve_Peak_Results,
                    Quantification_Cq_Results),
               full_join) %>%
    relocate(c(Run_Started, Run_Ended), .before = Plate) %>%
    relocate(c(Fluor), .after = Set_Point)
