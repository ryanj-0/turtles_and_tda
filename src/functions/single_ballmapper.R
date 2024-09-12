single_ballmapper <- function(pointcloud,
                              coloring,
                              epsilon) {
    # Error checking, TBD

    # Set locals
    if(water.temp |> length() > 1) water.temp <- "all"

    # BallMapper Function
    single.bm <- BallMapper(points = pointcloud,
                            values = coloring,
                            epsilon = epsilon)

    # Graphing
    if(final == 1){
        pdf(paste(getwd(), "results/final/bm",
                  paste(chemical, water.temp, ".pdf", sep = '_'),
                  sep = '/'))
    } else {
        pdf(paste(getwd(), "results/test/bm",
                  paste(chemical, water.temp, ".pdf", sep = '_'),
                  sep = '/'))
        }

    bm.plot <- ColorIgraphPlot(outputFromBallMapper = single.bm,
                               seed_for_plotting = 27)
    title(
        main = paste("Chemical:", paste(chemical, collapse = ' | '),
                     "\nWater Temp:", paste(water.temp, collapse = ' | '),
                     "\nEpsilon:", epsilon,
                     sep = ' '),

        sub = paste("Pointcloud:", paste(names(pointcloud), collapse = ' | '),
                    "\nColoring:", coloring.variable,
                    "\nN:", pc[, .N],
                    sep = ' ')
        )

    dev.off()
}
