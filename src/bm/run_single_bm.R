###############################
# Run full BallMapper pipeline
###############################
#globals
final <- 0 # place in results/final
c.value <- 0
chemical <- "all"
water.temp <- "all"

# check args
if(chemical == "all") {chemical <- ratio.data[, chem] |> unique()
} else if(!chemical %in% ratio.data[, chem] |> unique()) {
    stop(paste(chemical, "is not foudn in data", sep = ' '))
}

if(water.temp == "all") {water.temp <- ratio.data[, water] |> unique()
} else if(!water.temp %in% ratio.data[, water] |> unique()) {
    stop(paste(water.temp, "is not foudn in data", sep = ' '))
}

# create normalization values
chem_list <- ratio.data %>% pull(chem) %>% unique()
chem_norm <- function(x){
    ratio.data %>%
        mutate(unit_measure = str_extract(measure,".M"),
               .after = measure) %>%
        mutate(value_measure = str_extract(measure,"\\d*\\.*\\d") |> as.numeric(),
               .after = measure) %>%
        filter(chem == x & !is.na(unit_measure)) %>%
        select(chem, measure, value_measure, unit_measure) %>%
        mutate(unit_measure = factor(unit_measure, levels = c("nM", "uM", "mM"))) %>%
        unique() %>%
        arrange(unit_measure, value_measure) %>%
        mutate(norm_rank = seq(1, n()),
               norm_min_max = {norm_rank-min(norm_rank)}/{max(norm_rank)-min(norm_rank)})
}
norm_list <- lapply(chem_list, chem_norm) %>% reduce(., rbind)

# ballmapper reference data
bm.data <- ratio.data %>% as_tibble() %>%
    filter(correction == c.value & chem %in% chemical & water %in% water.temp) %>%
    mutate(anoxic = case_when(water %like% "A" ~ 1, .default = 0),
           .after = water) %>%
    left_join(select(norm_list, !ends_with("_measure")),
              by = c("chem", "measure")) %>%
    relocate(norm_rank, norm_min_max, .after = measure) %>%
    mutate(norm_rank = ifelse(is.na(norm_rank), 0, norm_rank),
           norm_min_max = ifelse(is.na(norm_min_max), -1, norm_min_max))

# Function Load -----------------------------------------------------------
source(paste(getwd(), "src/functions/single_ballmapper.R", sep = '/'))

# Single BallMapper -------------------------------------------------------
# parameters
coloring.variable <- "norm_rank"

# point cloud
pc <- bm.data %>%
    select(pct.zero.ca, pct.delta.prior, norm_min_max) |> as.data.frame()

# coloring varialbe
c <- bm.data %>%
    select(., eval(coloring.variable)) |> as.data.frame()

# epsilon
e <- 0.09

single.bm <- single_ballmapper(pointcloud = pc, coloring = c, epsilon = e, save_bm = 0)

