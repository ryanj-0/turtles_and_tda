chemical = "fourap"
correct <- 0
water.temp <- "all"
honing.e <- c()

if(chemical=="all" & water.temp=="all"){
   message("State 1 - running Chemical: all and water: all")
   pointcloud <- ratio.data[correction == correct,
                            .(pct.zero.ca, pct.delta.prior)]
   coloring.values <- ratio.data[correction == correct,
                                 water.cont] %>% as.data.frame()
}else if(chemical=="all" & water.temp!="all") {
   message(paste("State 2 - running chemical: all and water:"), water.temp)
   pointcloud <- ratio.data[correction == correct & water == water.temp,
                            .(pct.zero.ca, pct.delta.prior)]
   coloring.values <- ratio.data[correction == correct & water == water.temp,
                                 water.cont] %>% as.data.frame()
}else if(chemical!="all" & water.temp=="all") {
   message(paste("State 3 - running chemical:", chemical, "and water: all"))
   pointcloud <- ratio.data[correction == correct & chem == chemical,
                            .(pct.zero.ca, pct.delta.prior)]
   coloring.values <- ratio.data[correction == correct & chem == chemical,
                                 water.cont] %>% as.data.frame()
}else{
   message(paste("State 4 - running chemical:", chemical,
                 "and water:"), water.temp)
   pointcloud <- ratio.data[correction == correct &
                               chem == chemical& water == water.temp,
                            .(pct.zero.ca, pct.delta.prior)]
   coloring.values <- ratio.data[correction == correct &
                                    chem == chemical& water == water.temp,
                                 water.cont] %>% as.data.frame()
}



# find upper Bound
e = 0.1
while(TRUE){

   message("testing ", e)
   ratio.bm <- BallMapper::BallMapper(pointcloud, coloring.values, epsilon = e)

   # vertices
   bm.verts <- ratio.bm[['vertices']] %>% as.data.table()
   bm.verts[, 2] <- 20 * bm.verts[, 2]/max(bm.verts[, 2]) + 7
   # Edges
   bm.edges <- ratio.bm[['edges']] %>% as.data.table()


   g <- igraph::graph_from_data_frame(bm.edges,
                                      vertices = bm.verts,
                                      directed = FALSE)
   cmpts <- count_components(g)

   if(cmpts == 1) {
      print("found")
      message("cmpts: ", cmpts, " nrow: ", nrow(pointcloud))
      honing.e <- c(honing.e, e)
      gc()
      return(e)
   } else{

      message("cmpts: ", cmpts, " nrow: ", nrow(pointcloud))
      honing.e <- c(honing.e, e)
      e <- e*1.005
      message("next epsilon: ", e, "\n")
   }
}


# find lower Bound
e = 0.00000251
while(TRUE){

   message("testing ", e)
   ratio.bm <- BallMapper::BallMapper(pointcloud, coloring.values, epsilon = e)

   # vertices
   bm.verts <- ratio.bm[['vertices']] %>% as.data.table()
   bm.verts[, 2] <- 20 * bm.verts[, 2]/max(bm.verts[, 2]) + 7
   # Edges
   bm.edges <- ratio.bm[['edges']] %>% as.data.table()
   g <- igraph::graph_from_data_frame(bm.edges,
                                      vertices = bm.verts,
                                      directed = FALSE)
   cmpts <- count_components(g)

   if(cmpts == nrow(pointcloud)) {
      print("found")
      message("cmpts: ", cmpts, " nrow: ", nrow(pointcloud))
      honing.e <- c(honing.e, e)
      gc()
      return(e)
   } else{

      message("cmpts: ", cmpts, " nrow: ", nrow(pointcloud))
      honing.e <- c(honing.e, e)
      e <- e-(e*0.005)
      message("next epsilon: ", e, "\n")
   }
}

#test function
correct <- 0
steps = 10
test.function <- function(dt) {

   print(dt)
   # set epsilon range
   e.vec <- seq(bounds$e.min, bounds$e.max,length.out = steps)
   print(e.vec)

   if(chems == "all" & temps == "all"){
      message("State 1 - running Chemical: all and water: all")
      pointcloud <- ratio.data[correction == correct,
                               .(pct.zero.ca, pct.delta.prior)]
      coloring.values <- ratio.data[correction == correct,
                                    water.cont] %>% as.data.frame()
   }else if(chems == "all" & temps != "all") {
      message(paste("State 2 - running chemical: all and water: "), temps)
      pointcloud <- ratio.data[correction == correct & water == temps,
                               .(pct.zero.ca, pct.delta.prior)]
      coloring.values <- ratio.data[correction == correct & water == temps,
                                    water.cont] %>% as.data.frame()
   }else if(chems!="all" & temps == "all") {
      message(paste("State 3 - running chemical:", chems, "and water: all"))
      pointcloud <- ratio.data[correction == correct & chem == chems,
                               .(pct.zero.ca, pct.delta.prior)]
      coloring.values <- ratio.data[correction == correct & chem == chems,
                                    water.cont] %>% as.data.frame()
   }else{
      message(paste("State 4 - running chemical:", chems,
                    "and water: "), temps)
      pointcloud <- ratio.data[correction == correct &
                                  chem == chems& water == temps,
                               .(pct.zero.ca, pct.delta.prior)]
      coloring.values <- ratio.data[correction == correct &
                                       chem == chems& water == temps,
                                    water.cont] %>% as.data.frame()
   }
}








# BallMapper Metrics
count_components(g)
count_components(g)/ratio.bm[["landmarks"]] %>% length()
largest_component(g)
biconnected_components(g)
decompose(g)