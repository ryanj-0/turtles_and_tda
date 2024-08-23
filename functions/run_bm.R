# run ball mappter for parallel processing

run_bm <- function(i){
   bm <- BallMapper(pointcloud,
                    coloring.values,
                    epsilon = i)
   # connected components
   bm.verts <- bm[['vertices']] %>% as.data.table()
   bm.edges <- bm[['edges']] %>% as.data.table()
   bm.verts[, 2] <- 20 * bm.verts[, 2]/max(bm.verts[, 2]) + 7
   g <- graph_from_data_frame(d=bm.edges,
                              vertices=bm.verts,
                              directed=FALSE)
   cmpts <- count_components(g)
   verts <- V(g) %>% length()
   edgs <- E(g) %>% length()

   bm.info <- c(i, cmpts, verts, edgs)
   return(bm.info)
}