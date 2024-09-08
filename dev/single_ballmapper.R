single_ballmapper <- function(pointcloud,
                              coloring,
                              epsilon,
                              return_bm = TRUE,
                              return_plot = TRUE) {
    # Error checking, TBD

    # BallMapper Function
    single.bm <- BallMapper::BallMapper(
        points = pointcloud,
        values = coloring,
        epsilon = epsilon)

    if(return_bm) assign("single.bm", value = single.bm, envir = .GlobalEnv)

    # Graphing
    single.bm.plot <- BallMapper::ColorIgraphPlot(
        outputFromBallMapper = single.bm,
        seed_for_plotting = 27)
    title(main = paste("Pointcloud:",
                       paste(names(pointcloud), collapse = ' | '),
                       sep = ' '),
          sub = paste("Epsilon:", epsilon, sep = ' '))
    if(return_plot) print(single.bm.plot)
}
