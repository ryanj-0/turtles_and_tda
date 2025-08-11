#list rds files
rds_data <- list.files(paste(getwd(), "data/processed/vessel", sep = '/'),
                       pattern = ".rds")[-5] # drop hist_base

#run clean_turtles
rds_data <- lapply(rds.data, extract_vesselData) |> invisible()

#combine, reorder, remove NAs
turtle.data.all <- do.call(rbind, rds.data)
turtle.names <- c('date', 'water', 'chem', 'measure',
                  'starting.notes.z1', 'z1',
                  'pct.zero.ca.z1', 'pct.delta.prior.z1', 'notes.z1',
                  'starting.notes.z2', 'z2',
                  'pct.zero.ca.z2', 'pct.delta.prior.z2', 'notes.z2',
                  'trial'
                  )
turtle.data.all <- as_tibble(turtle.data.all) %>%
    select(turtle.names) %>%
    mutate(pct.delta.prior.z1:=as.numeric(pct.delta.prior.z1),
           pct.delta.prior.z2:=as.numeric(pct.delta.prior.z2),
           across(c(z1, pct.zero.ca.z1, pct.delta.prior.z1,
                    z2, pct.zero.ca.z2,pct.delta.prior.z2),
                  ~replace_na(.x, 0))
           )

# Make Final data set; drop cols with "...notes"
turtle.data <- turtle.data.all %>%
    select(!contains("notes")) %>%
    mutate(flagM = grepl(".*M", measure))

# variable clean up
rm(turtle.names)