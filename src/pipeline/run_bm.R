###############################
# Run full BallMapper pipeline
###############################

# Single BallMapper -------------------------------------------------------
# Epsilon Search values
water.list <- c("all", "21CN", "21CA", "5CN", "5CA")
hist.list <- data.table(fixed = rep(0.068, 5),
                        high = c(0.068, 0.15, 0.20, 0.10, 0.15),
                        lower = c())

source(paste(getwd(), "src/pipeline/bm/run_single_bm.R"))


list.files(paste(getwd(), "results/test/bm/", sep = '/'))


# BM Graphs Loop ----------------------------------------------------------
source(paste(getwd(), "src/pipeline/bm/run_bm_loop.R"))