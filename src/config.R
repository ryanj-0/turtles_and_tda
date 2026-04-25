########################
# Summary: Load packages and configure Google Drive credentials
# Date: 2025_05_26
# Author: Ryan Johnson
########################

# Load packages ----
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pkgs <- c("BallMapper",
          "data.table",
          "ggthemes",
          "googledrive",
          "googlesheets4",
          "gt",
          "gtExtras",
          "ggraph",
          "igraph",
          "network",
          "patchwork",
          "pdftools",
          "readxl",
          "tidyverse")

pacman::p_load(pkgs, character.only = TRUE, dependencies = TRUE)


# User credentials ----
# Check for a cached Google account
existing_user <- tryCatch({
    googledrive::drive_auth(email = TRUE, cache = gargle::gargle_oauth_cache())
    googledrive::drive_user()$emailAddress
}, error = function(e) NULL)

if (!is.null(existing_user)) {
    message("Google account found: ", existing_user)
} else {
    message("No Google account found. Launching authorization...")
    googledrive::drive_auth()
}

googlesheets4::gs4_auth(token = googledrive::drive_token())

# Hannah Lab Research Google Drive folder IDs
HLR_drive <- "Hannah Lab Research"
HLR_data <- "1z4QQ8xOGFVZibvKTadQE6mNfIcXlowS3"
