##### Loading Needed packages ####
# Require and install pacman for loading all needed packages
if (!require("pacman", character.only = TRUE)) {
   install.packages("pacman")
   library(pacman)
}

# List of packages to be loaded
pkgs <- c("aws.s3",
          "BallMapper",
          "colorBlindness",
          "colorspace",
          "cowplot",
          "data.table",
          "foreach",
          "furrr",
          "future",
          "future.apply",
          "GGally",
          "ggrepel",
          "ggthemes",
          "googledrive",
          "googlesheets4",
          "httr",
          "igraph",
          "network",
          "patchwork",
          "plotly",
          "readxl",
          "rvest",
          "tidyverse",
          "tidymodels",
          "wesanderson")

pacman::p_load(pkgs, character.only = TRUE, dependencies = TRUE)
message("System Initialized, packages loaded:")
print(pacman::p_loaded() %>% sort())