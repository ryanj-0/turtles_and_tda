#list rds files
rds.data <- list.files(data.dir, pattern = ".rds") |>
    _[-5] # drop hist_base

#run clean_turtles
rds.data <- lapply(rds.data, clean.turtles) |>
    invisible()

#combine and reorder
turtle.data.all <- do.call(rbind, rds.data)
turtle.names <- c('date', 'water', 'chem', 'measure',
                  'starting.notes.z1', 'z1',
                  'pct.zero.ca.z1', 'pct.delta.prior.z1', 'notes.z1',
                  'starting.notes.z2', 'z2',
                  'pct.zero.ca.z2', 'pct.delta.prior.z2', 'notes.z2')
setcolorder(turtle.data.all, turtle.names)

turtle.data.all[, pct.delta.prior.z1:=as.numeric(pct.delta.prior.z1)] |>
    _[, pct.delta.prior.z2:=as.numeric(pct.delta.prior.z2)]

# NAs to 0
turtle.data.all[is.na(z1), z1:= 0] |>
    _[is.na(z2), z2:= 0] |>
    _[is.na(pct.zero.ca.z1), pct.zero.ca.z1:= 0] |>
    _[is.na(pct.zero.ca.z2), pct.zero.ca.z2:= 0] |>
    _[is.na(pct.delta.prior.z1), pct.delta.prior.z1:= 0] |>
    _[is.na(pct.delta.prior.z2), pct.delta.prior.z2:= 0]

# Make Final data set; drop cols with "...notes"
turtle.data <- turtle.data.all[, .(date, water, chem, measure,
                                   z1, pct.zero.ca.z1, pct.delta.prior.z1,
                                   z2, pct.zero.ca.z2, pct.delta.prior.z2,
                                   trial)]

# fix one-offs
turtle.data[measure %like% "accidental", 4:= "33.3 uM*"]

# Check NAs in data
if(turtle.data |> is.na() |> rowSums() |> sum()){
    which(turtle.data.nas > 0)
    turtle.data.nas <- which(turtle.data.nas > 0)
    message("Rows which contain NA: ")
    print(turtle.data.nas)
}

# variable clean up
rm(turtle.names)