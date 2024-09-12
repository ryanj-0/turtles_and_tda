single_ballmapper <- function(pointcloud,
                              coloring,
                              epsilon) {
    # Error checking, TBD

    # BallMapper Function
    single.bm <- BallMapper(points = pointcloud,
                            values = coloring,
                            epsilon = epsilon)

    # Graphing
    single.bm.plot <- ColorIgraphPlot(outputFromBallMapper = single.bm,
                                      seed_for_plotting = 27)
    title(
        main = paste("Chemical:", chemical,
                     "\nEpsilon:", epsilon,
                     "\nColoring:", coloring.variable,
                     sep = ' '),

        sub = paste("Pointcloud:",
                    paste(names(pointcloud), collapse = ' | '),
                    sep = ' ')
        )

}
