###############################################
# clean, rearrage data, and add corrective cols
# to each trial in data
##############################################
clean_vesselData <- function(section) {

    section <- section %>%
        mutate(date = section[[3]][1] |> as.Date(origin = "1899-12-30"),
               water = section[[2]][1],
               trial = row_id,
               .before = chem) %>%
        slice(-1) %>%
        select(-c(rows, starts, ends, row_id))

    # split by zones
    zoneOne <- section %>%
        select(1:notes.z1) %>%
        rename(diameter = z1) %>%
        rename_with(.cols = 7:9, ~ gsub(".z1", "", .x)) %>%
        mutate(zone = 1, .after = diameter)

    zoneTwo <- section %>%
        select(1:measure, z2:notes.z2) %>%
        rename(diameter = z2) %>%
        rename_with(.cols = 7:9, ~ gsub(".z2", "", .x)) %>%
        mutate(zone = 2, .after = diameter)

    # bind split tables and add corrective codes
    section <- rbind(zoneOne, zoneTwo) %>%
        mutate(across(6:9, ~ as.numeric(.x))) %>%
        mutate(across(10, ~ as.character(.x))) %>%
        mutate(correction = case_when(measure == "first test of 60K" ~ 1,
                                      measure == "second test of 60K" ~ 1,
                                      measure  == "10K/Hist" ~ 2,
                                      measure == "Hist Post Wash" ~ 3,
                                      measure == "10K" & chem == "hist" ~ 4,
                                      measure == "PSS" ~ 10,
                                      .default = 0)) %>%
        mutate(water.code = case_when(water == "21CN" ~ 1,
                                      water == "21CA" ~ 2,
                                      water == "5CN" ~ 3,
                                      water == "5CA" ~ 5)) %>%
        mutate(chem.code = case_when(chem == "acetyl" ~ 1,
                                     chem == "fiveht" ~ 2,
                                     chem == "fourap" ~ 3,
                                     chem == "glyb" ~ 4,
                                     chem == "hist" ~ 5))

    return(section)
}