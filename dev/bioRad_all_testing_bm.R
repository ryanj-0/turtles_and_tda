
genesOfInterest <- c("ACTIN-B", "PPIA", "ABCC8", "GADPH", "KCNJ8", "KCNJ11",
                     "KCNJ2", "KCNJ12", "KCNA2", "KCNB1", "KCNB2", "KCNF1",
                     "KCNS3", "ADRB2", "MW2060", "ABCC9")

bioRad_withChannels <-
    bioRad_withChannels |>
    mutate(geneInterest = if_else(Gene %in% genesOfInterest,
                                  true = 1, false = 0),
           geneCode = case_when(Gene == "KCNJ8" ~ 01,
                                Gene == "KCNJ2" ~ 02,
                                Gene == "KCNA2"  ~ 03,
                                Gene == "ACTIN-B" ~ 04,
                                Gene == "PPIA" ~ 05,
                                Gene == "ABCC8" ~ 06,
                                Gene == "GADPH" ~ 07,
                                Gene == "KCNJ8" ~ 08,
                                Gene == "KCNJ11"  ~ 09,
                                Gene == "KCNJ12" ~ 10,
                                Gene == "KCNB1"  ~ 11,
                                Gene == "KCNB2" ~ 12,
                                Gene == "KCNF1"  ~ 13,
                                Gene == "KCNS3"  ~ 14,
                                Gene == "ADRB2" ~ 15,
                                Gene == "MW2060" ~ 16,
                                Gene == "ABCC9"  ~ 17,
                                .default = 0),
           channelCode = case_when(channel == "KV" ~ 1,
                                   channel == "KIR" ~ 2,
                                   channel == "KATP" ~ 3)
           )


# TEsting -----------------------------------------------------------------

sampleObs <- sample(100:5000, 20, replace = FALSE) |> sort()

timeTest <-
  lapply(sampleObs,
         function(sampleSize){
           bioRad_full <-
             bioRad_withChannels |>
             filter(if_all(everything(), ~ !is.na(.)))

           pointcloud_sample <-
             bioRad_full |>
             slice_sample(n = sampleSize)


           pointcloud <-
             pointcloud_sample |>
             select(Cq, Cq_Mean, Peak_Height, MeltCurve_Amp,
                    Quant_Amp, End_RFU, Melt_Temperature,
                    CrossingPoint, geneCode, channelCode) |>
             as.data.frame() |>
             normalize_to_min_0_max_1()

           coloring <-
             pointcloud_sample |>
             pull(geneCode) |>
             as.data.frame()

           e <- 0.8

           time_result <- system.time({
             bmData <- BallMapper(pointcloud, coloring, epsilon = e)
             gc()
           })

           ColorIgraphPlot(bmData)
           title(main =
                   paste0("Point Cloud: ", pointcloud |> nrow(), " obs \n",
                          paste(names(pointcloud), collapse = ", ")),
                 sub =
                   paste0("epsilon= ", e, " | time: ",
                          time_result["elapsed"]))

           return(time_result)
         })


timeTest |>
  bind_rows() |>
  cbind(sampleObs) |>
  ggplot(aes(y = elapsed, x = sampleObs)) + geom_line()



