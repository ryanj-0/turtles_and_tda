###############################
# Run full BallMapper pipeline
###############################

# Single BallMapper -------------------------------------------------------
source(paste(getwd(), "src/pipeline/bm/run_single_bm.R"))


# BM Graphs Loop ----------------------------------------------------------
source(paste(getwd(), "src/pipeline/bm/run_bm_loop.R"))