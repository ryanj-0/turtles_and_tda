# Function to extract 2022_0101_rtPCR_ALL.xlsx sheets

extract_qrtpcr_channels <- function(channel) {

    qRTPCR_channel <- read_excel(
        paste(getwd(),"data/raw/qRTPCR/2022_0101_rtPCR ALL.xlsx", sep = "/"),
        sheet = channel,
        range = cell_cols("B:V")) |>
        mutate(Position = ifelse(nchar(Position) < 3,
                                 gsub("(^.{1})(.*)$","\\10\\2", Position),
                                 Position)) |>
        mutate(channel = channel, .after = Researcher) |>
        rename(Individual_Efficiency = 'Individual\nEfficiency') |>
        arrange(Plate, Position) |>
        rename(water_temp = Temperature)

    # Save RDS Copy
    saveChannel = qRTPCR_channel |> pull(channel) |> unique()
    file_name <- paste0(getwd(), "/data/processed/qRTPCR/channel_",
                        saveChannel, ".rds")
    saveRDS(qRTPCR_channel, file_name)

    return(qRTPCR_channel)

}