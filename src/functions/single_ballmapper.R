single_ballmapper <- function(pointcloud,
                              coloring,
                              epsilon,
                              save_bm = TRUE) {
    # Error checking, TBD

    # Set locals
    if(water.temp |> length() > 1) water.temp <- "all"

    # BallMapper Function
    single.bm <- BallMapper(points = pointcloud,
                            values = coloring,
                            epsilon = epsilon)

    # Graphing
    if(save_bm) {

        svg.name <- paste0(paste(chemical, water.temp, e, sep = '_'), ".svg")

        if(final == 1){
            svg.path <- paste(getwd(), "results/final/bm", svg.name, sep = '/')
            svg(svg.path)
        } else {
            svg.path <- paste(getwd(), "results/test/bm", svg.name, sep = '/')
            svg(svg.path)
        }
    }

    ColorIgraphPlot(outputFromBallMapper = single.bm,
                    seed_for_plotting = 27)
    title(
        main = paste("Chemical:", paste(chemical, collapse = ' | '),
                     "\nWater Temp:", paste(water.temp, collapse = ' | '),
                     "\nEpsilon:", epsilon,
                     sep = ' '),

        sub = paste("Pointcloud:", paste(names(pointcloud),
                                         collapse = ' | '),
                    "\nColoring:", coloring.variable,
                    "\nN:", pc[, .N],
                    sep = ' ')
    )

    if(save_bm) {

        message(paste("Created:", svg.path, sep = ' '))
        dev.off()
    }
}
