# graphs looking at connected components over time ----------------
# epsilon bound table
temps <- c("all", "21CN", "21CA", "5CA", "5CN") |> rep(2)
chems <- c(rep("hist", 5), rep("fourap", 5))
hist.bounds <-
    data.table(
        e.min = c(0.000005, 0.0001678, 0.0002758, 0.0000399, 0.000203),
        e.max = c(0.062108, 0.0762, 0.1682, 0.13612, 0.09642)
    )
fourap.bounds <-
    data.table(
        e.min = c(0.000002436, 0.000042597, 0.000020011, 0.0000312, 0.0000914),
        e.max = c(0.088172, 0.198331, 0.120192, 0.191617, 0.141783)
    )

bounds <- cbind(temps,
                chems,
                rbind(hist.bounds, fourap.bounds))
# User Parameters
steps = 50
correct = 0
run.loop = 0
if(run.loop == 1) {
    source(paste0(dir, "/cc_loop.R")) # last ran 2024/06/11
}


# BM Graphs Loop ----------------------------------------------------------
c.list <- ls()[ls() %like% "cc."]
source(paste0(fxn.dir, "/set_pointcloud_coloring.R"))
source(paste0(fxn.dir, "/loop_bm_graphs.R"))

foreach(i=c.list) %do% loop_bm_graphs(i)