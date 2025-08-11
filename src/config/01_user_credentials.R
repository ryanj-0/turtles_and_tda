########################
# Summary: configure user credentials, set Hannah Lab Research Google Drive
# Date: 2025_05_26
# Author: Ryan Johnson
########################

# User Credentials
googledrive::drive_auth()
googlesheets4::gs4_auth(token = drive_token())


# Hannah Lab Credentials
HLR_drive <- "Hannah Lab Research"
HLR_data <- "1z4QQ8xOGFVZibvKTadQE6mNfIcXlowS3"

