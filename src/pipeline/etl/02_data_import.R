#list rds files
rds.data <- list.files(paste(getwd(), "data/extracted", sep = '/'), pattern = ".rds") %>%
    .[-5] # drop hist_base

#run clean_turtles
rds.data <- lapply(rds.data, clean_turtles) |> invisible()

#combine and reorder
turtle.data.all <- do.call(rbind, rds.data)
turtle.names <- c('date', 'water', 'chem', 'measure',
                  'starting.notes.z1', 'z1', 'pct.zero.ca.z1', 'pct.delta.prior.z1', 'notes.z1',
                  'starting.notes.z2', 'z2', 'pct.zero.ca.z2', 'pct.delta.prior.z2', 'notes.z2'
                  )
setcolorder(turtle.data.all, turtle.names)

turtle.data.all[, pct.delta.prior.z1:=as.numeric(pct.delta.prior.z1)] %>%
    .[, pct.delta.prior.z2:=as.numeric(pct.delta.prior.z2)]

# NAs to 0
turtle.data.all[is.na(z1), z1:= 0] %>%
    .[is.na(z2), z2:= 0] %>%
    .[is.na(pct.zero.ca.z1), pct.zero.ca.z1:= 0] %>%
    .[is.na(pct.zero.ca.z2), pct.zero.ca.z2:= 0] %>%
    .[is.na(pct.delta.prior.z1), pct.delta.prior.z1:= 0] %>%
    .[is.na(pct.delta.prior.z2), pct.delta.prior.z2:= 0]

# Make Final data set; drop cols with "...notes"
turtle.data <- turtle.data.all[, .(date, water, chem, measure,
                                   z1, pct.zero.ca.z1, pct.delta.prior.z1,
                                   z2, pct.zero.ca.z2, pct.delta.prior.z2,
                                   trial)]

molarMeasures <- turtle.data[grepl(".*M", measure), measure] |> unique() |> sort()
turtle.data[measure %in% molarMeasures, flagM:=TRUE][measure %notin% molarMeasures, flagM:=FALSE]


# aceytl

# fiveht
# fourap
# glyb
# hist



# fix one-offs
turtle.data[measure %like% "accidental", 4:= "33.3 uM*"]

# variable clean up
rm(turtle.names)
