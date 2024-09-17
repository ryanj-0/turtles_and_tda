###############################
# Run full BallMapper pipeline
###############################
#globals
final <- 0 # place in results/final

# Function Load -----------------------------------------------------------
source(paste(getwd(), "src/functions/single_ballmapper.R", sep = '/'))

# Single BallMapper -------------------------------------------------------
# parameters
c.value <- 0
chemical <- "glyb"
water.temp <- "all"
coloring.variable <- "water.cont"

# check args
if(chemical == "all") {chemical <- ratio.data[, chem] |> unique()
} else if(!chemical %in% ratio.data[, chem] |> unique()) {
    stop(paste(chemical, "is not foudn in data", sep = ' '))
    }

if(water.temp == "all") {water.temp <- ratio.data[, water] |> unique()
} else if(!water.temp %in% ratio.data[, water] |> unique()) {
    stop(paste(water.temp, "is not foudn in data", sep = ' '))
    }

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
e <- 0.6

single_ballmapper(pointcloud = pc, coloring = c,
                  epsilon = e, return_bm = 1) |> system.time()
