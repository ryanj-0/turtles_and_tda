single_ballmapper <- function(pointcloud,
                              coloring,
                              epsilon,
                              return_bm = TRUE) {
    # Error checking, TBD

    # Set locals
    if(water.temp |> length() > 1) water.temp <- "all"

    # BallMapper Function
    single.bm <- BallMapper(points = pointcloud,
                            values = coloring,
                            epsilon = epsilon)

    # Graphing
    if(return_bm) {

        pdf.name <- paste0(paste(chemical, water.temp, e, sep = '_'), ".pdf")

        if(final == 1){
            pdf.path <- paste(getwd(), "results/final/bm", pdf.name, sep = '/')
            pdf(pdf.path)
        } else {
            pdf.path <- paste(getwd(), "results/test/bm", pdf.name, sep = '/')
            pdf(pdf.path)
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

    if(return_bm) {

        message(paste("Created:", pdf.path, sep = ' '))
        dev.off()
    }
}
