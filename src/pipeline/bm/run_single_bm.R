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
chemical <- "hist"
water.temp <- "all"
coloring.variable <- "diameter"

# check args
if(chemical == "all") {chemical <- ratio.data[, chem] |> unique()
} else if(!chemical %in% ratio.data[, chem] |> unique()) {
    stop(paste(chemical, "is not foudn in data", sep = ' '))
    }

if(water.temp == "all") {water.temp <- ratio.data[, water] |> unique()
} else if(!water.temp %in% ratio.data[, water] |> unique()) {
    stop(paste(water.temp, "is not foudn in data", sep = ' '))
    }

bm.data <- ratio.data[correction == c.value &
                          chem %in% chemical &
                          water %in% water.temp]

# point cloud
pc <- bm.data[, .(pct.zero.ca, pct.delta.prior)]

# coloring varialbe
c <- bm.data[, .(parse(text = coloring.variable) |> eval())]

# epsilon
e <- 0.06

single.bm <- single_ballmapper(pointcloud = pc, coloring = c,
                               epsilon = e, save_bm = 0)

