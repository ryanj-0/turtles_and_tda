###############################
# Run full BallMapper pipeline
###############################

# Function Load -----------------------------------------------------------
source(paste(getwd(), "src/functions/single_ballmapper.R"))

# Single BallMapper -------------------------------------------------------
# parameters
c.value <- 0
chemical <- "hist"
water.temp <- "21CN"
coloring.variable <- "water.cont"

# check for args not in table
if(chemical == "all") chemical <- ratio.data[, chem] |> unique()
if(water.temp == "all") water.temp <- ratio.data[, water] |> unique()

# point cloud
pc <- ratio.data[correction == c.value &
                     chem %in% chemical &
                     water %in% water.temp,
                 .(pct.zero.ca, pct.delta.prior)]

# coloring varialbe
c <- ratio.data[correction == c.value &
                    chem %in% chemical &
                    water %in% water.temp,
                .(parse(text = coloring.variable) |>
                      eval())]

# epsilon
e <- 0.1

single_ballmapper(pointcloud = pc, coloring = c, epsilon = e) |>
    system.time()


# BM Graphs Loop ----------------------------------------------------------
c.list <- ls()[ls() %like% "cc."]
source(paste0(fxn.dir, "/set_pointcloud_coloring.R"))
source(paste0(fxn.dir, "/loop_bm_graphs.R"))

foreach(i=c.list) %do% loop_bm_graphs(i)