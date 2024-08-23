set_pointcloud_coloring <- function(c, w){

   # set global pointclouad and coloring values
   pointcloud <- ratio.data[correction == correct]
   coloring.values <- ratio.data[correction == correct, .(water.cont)]

   # set pointcloud and coloring values for BallMapper
   if(c == "all" & w == "all"){
      message("State 1 - Chemical: all and water: all")
      pointcloud <- ratio.data[ , .(pct.zero.ca, pct.delta.prior)]
   }else if(c == "all") {
      message(paste("State 2 - chemical: all and water: "), w)
      pointcloud <- ratio.data[water == w,
                               .(pct.zero.ca, pct.delta.prior)]
      coloring.values <- ratio.data[water == w, .(water.cont)]
   }else if(w == "all") {
      message(paste("State 3 - chemical:", c, "and water: all"))
      pointcloud <- ratio.data[chem == c,
                               .(pct.zero.ca, pct.delta.prior)]
      coloring.values <- ratio.data[chem == c, .(water.cont)]
   }else{
      message(paste("State 4 - chemical:", c, "and water: "), w)
      pointcloud <- ratio.data[chem == c & water == w,
                               .(pct.zero.ca, pct.delta.prior)]
      coloring.values <- ratio.data[chem == c & water == w,
                                    .(water.cont)]
   }

   bm.data <- list(pointclound = pointcloud,
                   coloring.values = coloring.values)
   return(bm.data)
}
