##################################
# Chemical normalization for
# cerebral vessel data
##################################

# create normalization values
chem_list <- cerebral_data |>
    pull(chem) |>
    unique()

chem_norm <- function(x){
    cerebral_data |>
        mutate(unit_measure = str_extract(measure,".M"),
               .after = measure) |>
        mutate(value_measure =
                   str_extract(measure,"\\d*\\.*\\d") |>
                   as.numeric(),
               .after = measure) |>
        filter(chem == x & !is.na(unit_measure)) |>
        select(chem, measure, value_measure, unit_measure) |>
        mutate(unit_measure =
                   factor(unit_measure, levels = c("nM", "uM", "mM"))) |>
        unique() |>
        arrange(unit_measure, value_measure) |>
        mutate(norm_rank = seq(1, n()),
               norm_min_max = {
                   norm_rank-min(norm_rank)}/{max(norm_rank)-min(norm_rank)}
               )
}
norm_list <- lapply(chem_list, chem_norm) |> reduce(rbind)

# add normilization rank data
cerebral_data <- cerebral_data |>
    left_join(select(norm_list, !ends_with("_measure")),
              by = c("chem", "measure")) |>
    relocate(norm_rank, norm_min_max, .after = measure) |>
    mutate(norm_rank = ifelse(is.na(norm_rank), 0, norm_rank),
           norm_min_max = ifelse(is.na(norm_min_max), -1, norm_min_max))
