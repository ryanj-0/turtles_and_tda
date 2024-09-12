single_ballmapper <- function(pointcloud,
                              coloring,
                              epsilon) {
    # Error checking, TBD

    # BallMapper Function
    single.bm <- BallMapper(points = pointcloud,
                            values = coloring,
                            epsilon = epsilon)

    # Graphing
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

    return(single.bm)
}
