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
          "igraph",
          "network",
          "patchwork",
          "pdftools",
          "readxl",
          "tidyverse")

pacman::p_load(pkgs, character.only = TRUE, dependencies = TRUE)


# User credentials ----
# For new users they will need to sign in on their machine.
googledrive::drive_auth()
googlesheets4::gs4_auth(token = drive_token())

# Hannah Lab Research Google Drive folder IDs
HLR_drive <- "Hannah Lab Research"
HLR_data <- "1z4QQ8xOGFVZibvKTadQE6mNfIcXlowS3"
