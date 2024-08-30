# Base Case Test ----------------------------------------------------------
# Global Parameters
e = 0.04
chemical = "hist"
correct <- 0

# set global pointblouad and coloring values
pointcloud <- ratio.data[chem == chemical] |>
   _[, .(pct.zero.ca, pct.delta.prior)]
coloring.values <- ratio.data[chem == chemical, .(trial)]

# bm
ratio.bm <- BallMapper::BallMapper(pointcloud, coloring.values, epsilon = e)
BallMapper::ColorIgraphPlot(ratio.bm, seed_for_plotting = 27)
title(main = paste0("Point Cloud: Z1&Z2 ratio metric",
                    "\n Chemical:", chemical,
                    "\t Coloring:", names(coloring.values)),
      sub = paste0("epsilon=", e))


# BallMapper Metrics
# vertices
bm.verts <- ratio.bm[['vertices']] %>% as.data.table()
# Edges
bm.edges <- ratio.bm[['edges']] %>% as.data.table()

# Graph Object
bm.verts[, 2] <- 20 * bm.verts[, 2]/max(bm.verts[, 2]) + 7
g <- igraph::graph_from_data_frame(bm.edges,
                                   vertices = bm.verts,
                                   directed = FALSE)
count_components(g)
count_components(g)/ratio.bm[["landmarks"]] %>% length()
largest_component(g)
biconnected_components(g)
decompose(g)


# testing parallel --------------------------------------------------------
# User Parameters
e.bound <- c(0.000005, 0.06211)
correct <- 0
chemical <- "hist"
water.temp <- "all"
steps <- 10

# Functional Parameters
source(paste0(fxn.dir, "/run_bm.R"))
ncores <- availableCores()-1
e.vec <- seq(e.bound[1], e.bound[2], length.out = steps)

# set state
if(chemical == "all" & water.temp == "all"){
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

# run parallel BallMapper
message("Running bm process")
plan(multisession, workers = availableCores())
all.f <- future_lapply(e.vec, run_bm)
plan(sequential)

# plots
message("Plotting...")
connected.componets <- do.call(rbind, all.f) |> as.data.table() |>
   setnames(c("epsilons", "cmpts", "vertices", "edges"))
connected.componets[, change:= c(NA,diff(cmpts))]
connected.componets[, cmpt.ratio:= cmpts/vertices]

# cols
cols.plot <- ggplot(connected.componets, aes(x = epsilons, y = cmpts)) +
   geom_col(aes(fill = row_number(epsilons) %% 2 == 0),
            show.legend = FALSE) +
   geom_text(aes(label = cmpts),
             data = . %>% filter(row_number() %% 3 == 0),
             vjust = -0.5) +
   scale_y_continuous(name = "# of Conn. Cmpnts.",
                      n.breaks = 10,
                      expand = expansion(mult = c(0.05,0.1))) +
   scale_fill_manual(values = c("lightblue3", "lightblue4")) +
   xlab("Epsilons") +
   theme_minimal()

# pops
pops.plot <- ggplot(connected.componets, aes(x = epsilons, y = change)) +
   geom_line(color = "grey80") +
   geom_hline(aes(yintercept = 0), color = "grey50", linetype = "dashed") +
   geom_point(aes(size = -change),
              data = . %>% filter(change != 0),
              shape = 21,
              fill = "grey",
              show.legend = FALSE) +
   geom_point(data = . %>% filter(change == 0),
              shape = 19,
              size = 2,
              color = "red",
              show.legend = FALSE) +
   geom_point(data = . %>% filter(change > 0),
              shape = 19,
              size = 2,
              color = "blue",
              show.legend = FALSE) +
   geom_text_repel(aes(label = change),
                   data = . %>% filter(row_number() %% 7 == 0),
                   vjust = 2) +
   scale_y_continuous(name = paste("Delta Conn. Cmpnts."),
                      expand = expansion(mult = c(0.1, 0.05))) +
   xlab("Epsilons") +
   theme_minimal()

# final plot
final.plot <- cols.plot/pops.plot +
   plot_annotation(title = "Connected Components & Epsilons",
                   subtitle = paste("Chemical:", chemical,
                                    ", Water Temp:", water.temp),
                   caption = paste("N:", pointcloud |> nrow(),
                                   "; Steps:", steps)) +
   plot_layout(guides = "collect", axis_titles = "collect",
               heights = c(2,1))


print(final.plot)


# Plot analysis -----------------------------------------------------------
test.loop <- function(ep) {

   test.bm <- BallMapper(pointcloud, coloring.values, ep)
   ColorIgraphPlot(test.bm, seed_for_plotting = 27)
   title(main = paste0("Point Cloud: Z1&Z2 ratio metric,",
         "\n Chemical:", chemical,
         "\n Coloring:", water.temp),
         sub = paste0("21CN=1-2, 21CA=2-3, 5CN=3-4, 5CA=4-5",
                      "\nepsilon=", ep))
}

pdf(paste0(dir, "/test.pdf"))
par(mfrow = c(2, 2))
for(e in e.vec) { test.loop(e) }
dev.off()
par(mfrow = c(1, 1))


