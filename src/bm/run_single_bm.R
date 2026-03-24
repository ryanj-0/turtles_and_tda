###############################
# Run full BallMapper pipeline
###############################
#globals
chemical <- "all"
water.temp <- "all"

# check args
if(chemical == "all") {
    chemical <- cerebral_data |>
        pull(chem) |>
        unique()
}

if(water.temp == "all") {
    water.temp <- cerebral_data |>
        pull(water) |>
        unique()
}

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

# add anoxic/normoxic col
cerebral_data <- cerebral_data |>
    mutate(anoxic = case_when(water %like% "A" ~ 1, .default = 0),
           .after = water)

# add normilization rank data
cerebral_data <- cerebral_data |>
    left_join(select(norm_list, !ends_with("_measure")),
              by = c("chem", "measure")) |>
    relocate(norm_rank, norm_min_max, .after = measure) |>
    mutate(norm_rank = ifelse(is.na(norm_rank), 0, norm_rank),
           norm_min_max = ifelse(is.na(norm_min_max), -1, norm_min_max))

# Function Load -----------------------------------------------------------
source(paste(getwd(), "src/functions/bm_to_igraph.R", sep = '/'))
source(paste(getwd(), "src/functions/bm_ggraph.R", sep = '/'))

# Single BallMapper -------------------------------------------------------
# parameters
coloring.variable <- "norm_rank"
c.value = 0

# point cloud
pc <- cerebral_data |>
    filter(
        correction == c.value &
            chem %in% chemical &
            water %in% water.temp
    ) |>
    select(pct.zero.ca, pct.delta.prior, norm_min_max) |>
    as.data.frame()

# coloring varialbe
c <- cerebral_data |>
    select(eval(coloring.variable)) |>
    as.data.frame()

# epsilon
e <- 0.2

bm <- BallMapper(points = pc, values = c, epsilon = e)
bm_ig <- bm_to_igraph(bm)
bm_ggraph(bm_ig, coloring = c, epsilon = e, legend_label = coloring.variable)

