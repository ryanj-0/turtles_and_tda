# Function Parameters
source(paste0(fxn.dir, "/run_bm.R"))

# Loop for water temp -----------------------------------------------------
pdf(paste(plots.dir, "/connected_components.pdf", sep = ""),
    width = 14, height = 6.32)
for (r in 1:nrow(bounds)) {

   water.temp <- bounds[r,1]
   chemical <- bounds[r,2]
   lower.e <- bounds[r,3]
   upper.e <- bounds[r,4]
   message(paste0("Run: ", r, "/", nrow(bounds)))
   message(paste("--- Parameters ---",
                 "\n Water Temp.:", water.temp,
                 "\n Chemical:", chemical,
                 "\n Lower Epsilon:", lower.e,
                 "\n Upper Epsilon:", upper.e,
                 "\n Steps:", steps))

   # set epsilon range
   e.vec <- seq(lower.e |> unlist(),
                upper.e |> unlist(),
                length.out = steps)

   # set global pointclouad and coloring values
   pointcloud <- ratio.data[correction == correct]
   coloring.values <- ratio.data[correction == correct, .(water.cont)]

   # set pointcloud and coloring values for BallMapper
   if(chemical == "all" & water.temp == "all"){
      message("State 1 - Chemical: all and water: all")
      pointcloud <- ratio.data[ , .(pct.zero.ca, pct.delta.prior)]
   }else if(chemical == "all") {
      message(paste("State 2 - chemical: all and water: "), water.temp)
      pointcloud <- ratio.data[water == water.temp,
                               .(pct.zero.ca, pct.delta.prior)]
      coloring.values <- ratio.data[water == water.temp, .(water.cont)]
   }else if(water.temp == "all") {
      message(paste("State 3 - chemical:", chemical, "and water: all"))
      pointcloud <- ratio.data[chem == chemical,
                               .(pct.zero.ca, pct.delta.prior)]
      coloring.values <- ratio.data[chem == chemical, .(water.cont)]
   }else{
      message(paste("State 4 - chemical:", chemical, "and water: "), water.temp)
      pointcloud <- ratio.data[chem == chemical & water == water.temp,
                               .(pct.zero.ca, pct.delta.prior)]
      coloring.values <- ratio.data[chem == chemical & water == water.temp,
                                    .(water.cont)]
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
   assign(paste0("cc.", water.temp, ".", chemical),
          connected.componets)

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
      xlab("Epsilon") +
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
      xlab("Epsilon") +
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
   message(paste("Plot done for Chemical:", chemical,
                 "and water: ", water.temp, "\n"))

   } # end
dev.off()


