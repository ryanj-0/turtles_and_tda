#######################################################
# Import Raw Data and Store in Process after Extracted
######################################################

# Cerebral Vessel Data ----------------------------------------------------

# data sheet names
vessel_sheets <- excel_sheets(
    paste(getwd(), "data/raw/vessel/Cerebral_Blood_Vessel_Compounds.xlsx",
                   sep = "/"))

vessel_sheets <- vessel_sheets[!grepl("graphs", vessel_sheets,
                                      ignore.case = TRUE)]

# save RDS of each chemical sheet
lapply(vessel_sheets, extract_rawVesselData)
