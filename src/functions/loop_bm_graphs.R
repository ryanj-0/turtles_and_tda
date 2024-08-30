loop_bm_graphs <- function(c.table){

   pdf(
      paste0(plots.dir,
          "/cc_graphs",
          "/bmplot_", stringr::str_replace_all(c.table, "[.]", "_"), ".pdf")
   )

   df <- get(c.table)
   chemical <- stringr::str_split(c.table, "\\.")[[1]][3]
   water.temp <- stringr::str_split(c.table, "\\.")[[1]][2]


   bm.data <- set_pointcloud_coloring(c = chemical, w = water.temp)
   pointcloud <- bm.data[[1]]
   coloring.values <- bm.data[[2]]

   for(i in 1:nrow(df)){

      bm <- BallMapper(pointcloud, coloring.values, df[i, epsilons])
      ColorIgraphPlot(bm, seed_for_plotting = 27)
      title(main = paste0("Point Cloud: Z1&Z2 ratio metric",
                          "\n Chemical:", chemical,
                          "\n Coloring:", water.temp),
            sub = paste0("Change: ", df[i, change],
                         "\n epsilon=", df[i, epsilons]))

   }

   dev.off()

}