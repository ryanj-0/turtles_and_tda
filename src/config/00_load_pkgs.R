##### Loading Needed packages ####
# Require and install pacman for loading all needed packages
if (!require("pacman", character.only = TRUE)) {
   install.packages("pacman")
   library(pacman)
}

# List of packages to be loaded
pkgs <- c("BallMapper",
          "data.table",
          "gtExtras",
          "ggthemes",
          "googledrive",
          "googlesheets4",
          "gt",
          "igraph",
          "network",
          "patchwork",
          "pdftools",
          "readxl",
          "tidyverse")

pacman::p_load(pkgs, character.only = TRUE, dependencies = TRUE)