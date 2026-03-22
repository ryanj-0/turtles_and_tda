###########################
# Function to print various epsilon for chemical comparison
############################
chemcompare_pdf <- function(e){

   # fourap
   fourap.points <- fourap[, .(z1, pct.zero.ca.z1, pct.delta.prior.z1,
                               z2, pct.zero.ca.z2, pct.delta.prior.z2)]
   fourap.values <- fourap[, water.cont] %>% as.data.frame()
   fourap.bm <- BallMapper(fourap.points, fourap.values, epsilon = e)
   BallMapper::ColorIgraphPlot(fourap.bm, seed_for_plotting = 27)
   title(main = "4AP colored by Water Temp",
         sub = paste("21CN=1-2",
                     "21CA=2-3",
                     "5CN=3-4",
                     "5CA=4-5",
                     "\nepsilon=", e,
                     sep = ' ')
         )

   # hist
   hist.points <- hist[, .(z1, pct.zero.ca.z1, pct.delta.prior.z1,
                           z2, pct.zero.ca.z2, pct.delta.prior.z2)]
   hist.values <- hist[, water.cont] %>% as.data.frame()
   hist.bm <- BallMapper(hist.points, hist.values, epsilon = e)
   BallMapper::ColorIgraphPlot(hist.bm, seed_for_plotting = 27)
   title(main = "Histamine colored by Water Temp",
         sub = paste("21CN=1-2",
                     "21CA=2-3",
                     "5CN=3-4",
                     "5CA=4-5",
                     "\nepsilon=", e,
                     sep = ' ')
         )

   # both
   both.points <- compare[, .(z1, pct.zero.ca.z1, pct.delta.prior.z1,
                              z2, pct.zero.ca.z2, pct.delta.prior.z2)]
   both.values <- compare[, water.cont] %>% as.data.frame()
   both.bm <- BallMapper(both.points, both.values, epsilon = e)
   BallMapper::ColorIgraphPlot(both.bm, seed_for_plotting = 27)
   title(main = "4AP & Histamine\n colored by Water Temp",
         sub = paste("21CN=1-2",
                     "21CA=2-3",
                     "5CN=3-4",
                     "5CA=4-5",
                     "\nepsilon=", e,
                     sep = ' ')
         )

   # random
   plot(rnorm(100), y = rnorm(100))

}