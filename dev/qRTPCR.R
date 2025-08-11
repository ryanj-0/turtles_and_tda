
qRTPCR_files <- list.files(paste(getwd(), "data/raw/qRTPCR", sep = "/"),
                           full.names = TRUE) %>% as_tibble()
bioRad_dirs <- list.files(paste(getwd(), "data/raw/qRTPCR/BioRad Files", sep = "/"),
                          full.names = TRUE)
bioRad_dirNames <- list.files(paste(getwd(), "data/raw/qRTPCR/BioRad Files",
                                 sep = "/")) %>%
    as_tibble() %>%
    rename(pcrRun = value)

fileVec <- c()

for(f in bioRad_dirs){

    nFiles <- list.files(f) %>% length()
    fileVec <- c(fileVec, nFiles)
}

bioRad_coverage <- cbind(bioRad_dirNames, fileVec)

ggplot(bioRad_coverage[1:55,], aes(x = pcrRun, y = fileVec)) +
    geom_col() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))

qRTPCR_data <- qRTPCR_files %>%
    filter(value %like% ".xlsx")

source(paste(getwd(), "dev/04_bioRad_data.R", sep = '/'))

### Extract 2022_0101_rtPCR_ALL.xlsx sheets
qRTPCR_channel_sheets <- qRTPCR_data[5, ] |>
    unlist() |>
    excel_sheets() %>%
    .[1:3]

qRTPCR_all <- lapply(qRTPCR_channel_sheets, extract_qrtpcr_channels)

for( t in qRTPCR_all){
    tmp <- full_join(t, test, relationship = "many-to-many") %>%
      select(Run_Started, Run_Ended, Fluor, Tissue, channel,
               Label, Gene, Plate, Position,
               CrossingPoint, Individual_Efficiency,
               Cq, End_Point_End_RFU,
               starts_with("Melt_Curve"),
               Ind_Extr, Ind_Exp, Replicate, qPCRreplicate,
               Sample_Vol, Lid_Temp, Set_Point,
               everything()) %>%
      mutate(channel = t$channel |> unique())

    gene_factor <- tmp$Gene %>% factor() |> as.numeric()
    exposure_factor <- tmp$Exposure %>% factor() |> as.numeric()

    tmp <-  tmp %>%
      mutate(gene_code = gene_factor, .before = Plate) %>%
      mutate(exposure_code = exposure_factor, .before = Included)

    assign(paste0("qRTPCR_", tmp$channel[1]), tmp)

}

ref_tbl <- qRTPCR_KV %>%
    filter(!is.na(Run_Started)) %>%
    drop_na(where(is.numeric))

test_pc <- ref_tbl %>%
    select(where(is.numeric)) %>%
    as.data.frame() %>%
    normalize_to_min_0_max_1()

test_coloring <- ref_tbl %>%
    select(exposure_code) %>%
    as.data.frame() %>%
    normalize_to_min_0_max_1()

test_e <- 0.7

test_bm <- BallMapper(test_pc, test_coloring, test_e)
ColorIgraphPlot(test_bm)
title(main =
          paste(
              paste("qRTPCR Data, Channel:", ref_tbl$channel |> unique()),
              paste("Coloring:", names(test_coloring)),
              sep = "\n"
              ),
      sub =
          paste(
              paste0("epsilon=", test_e),
              paste("n catagories: ", unique(test_coloring) |> nrow()),
              sep = "\t"
              )
)

test_pts <- points_covered_by_landmarks(test_bm, 3)
ref_tbl[test_pts, ] |> view()


# water states --------------------------------------------------------------------------------


code <- 4

test_pc <- ref_tbl %>%
  select(where(is.numeric)) %>%
  filter(exposure_code == code) %>%
  as.data.frame() %>%
  normalize_to_min_0_max_1()

test_coloring <- ref_tbl %>%
  select(gene_code) %>%
  as.data.frame() %>%
  normalize_to_min_0_max_1()

test_e <- 0.7

test_bm <- BallMapper(test_pc, test_coloring, test_e)
ColorIgraphPlot(test_bm)
title(main =
        paste(
          paste("qRTPCR Data, Channel:", ref_tbl$channel |> unique()),
          paste("Coloring:", names(test_coloring)),
          sep = "\n"
        ),
      sub =
        paste(
          paste("epsilon=", test_e),
          paste("n catagories:", unique(test_coloring) |> nrow()),
          paste("Exposure code:", code),
          sep = "\t"
        )
)
