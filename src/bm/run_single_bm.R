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

# Function Load -----------------------------------------------------------
source(paste(getwd(), "src/helpers/normalize_cerebral_data.R", sep = '/'))
source(paste(getwd(), "src/functions/bm_to_igraph.R", sep = '/'))
source(paste(getwd(), "src/functions/bm_ggraph.R", sep = '/'))

# Single BallMapper -------------------------------------------------------
# parameters
coloring.variable <- "correction"

# 0 - include starting diamter and only measures of diff. concentrations
# 1 - first and second 60k flushes
# 2 - measure == 10K/Hist
# 3 - measure == Hist Post Wash
# 10 - pss.values

c.value = c(0)

# point cloud
pc <- cerebral_data |>
    filter(
        correction %in% c.value &
            chem %in% chemical &
            water %in% water.temp
    ) |>
    select(pct.zero.ca, pct.delta.prior) |>
    as.data.frame()

# coloring varialbe
c <- cerebral_data |>
    select(eval(coloring.variable)) |>
    as.data.frame()

# epsilon
e <- 0.025

bm <- BallMapper(points = pc, values = c, epsilon = e)
bm_ig <- bm_to_igraph(bm)

bm_ggraph(bm_ig, coloring = c, epsilon = e,
          legend_label = coloring.variable, layout = "stress")

ColorIgraphPlot(bm, seed_for_plotting = 27)




# Values for Separate Chems -----------------------------------------------


