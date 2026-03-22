###########################
# Function to print various epsilon for water temp comparison
############################
watercompare_pdf <- function(e){

   # 21CN
   twentyone.cn.points <- twentyone.cn[, .(z1, pct.zero.ca.z1, pct.delta.prior.z1,
                                           z2, pct.zero.ca.z2, pct.delta.prior.z2)]
   twentyone.cn.values <- twentyone.cn[, chem.cont] %>% as.data.frame()
   twentyone.cn.bm <- BallMapper(twentyone.cn.points, twentyone.cn.values, epsilon = e)
   ColorIgraphPlot(twentyone.cn.bm, seed_for_plotting = 27)
   title(main = "21CN colored by Chemical",
         sub = paste("4AP=3-4, Hist=5-6 | epsilon=", e,
                     sep = ''))

   # 21CA
   twentyone.ca.points <- twentyone.ca[, .(z1, pct.zero.ca.z1, pct.delta.prior.z1,
                                           z2, pct.zero.ca.z2, pct.delta.prior.z2)]
   twentyone.ca.values <- twentyone.ca[, chem.cont] %>% as.data.frame()
   twentyone.ca.bm <- BallMapper(twentyone.ca.points, twentyone.ca.values, epsilon = e)
   ColorIgraphPlot(twentyone.ca.bm, seed_for_plotting = 27)
   title(main = "21CA colored by Chemical",
         sub = paste("4AP=3-4, Hist=5-6 | epsilon=", e,
                     sep = ''))

   # 5CN
   five.cn.points <- five.cn[, .(z1, pct.zero.ca.z1, pct.delta.prior.z1,
                                 z2, pct.zero.ca.z2, pct.delta.prior.z2)]
   five.cn.values <- five.cn[, chem.cont] %>% as.data.frame()
   five.cn.bm <- BallMapper(five.cn.points, five.cn.values, epsilon = e)
   ColorIgraphPlot(five.cn.bm, seed_for_plotting = 27)
   title(main = "5CN colored by Chemical",
         sub = paste("4AP=3-4, Hist=5-6 | epsilon=", e,
                     sep = ''))

   # 5CA
   five.ca.points <- five.ca[, .(z1, pct.zero.ca.z1, pct.delta.prior.z1,
                                 z2, pct.zero.ca.z2, pct.delta.prior.z2)]
   five.ca.values <- five.ca[, chem.cont] %>% as.data.frame()
   five.ca.bm <- BallMapper(five.ca.points, five.ca.values, epsilon = e)
   ColorIgraphPlot(five.ca.bm, seed_for_plotting = 27)
   title(main = "5CA colored by Chemical",
         sub = paste("4AP=3-4, Hist=5-6 | epsilon=", e,
                     sep = ''))

}