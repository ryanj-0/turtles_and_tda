# Function to extract 2022_0101_rtPCR_ALL.xlsx sheets

extract_qrtpcr_channels <- function(channel) {

    qRTPCR_channel <- read_excel(qRTPCR_data[5, ] |> unlist(),
                                sheet = channel,
                                range = cell_cols("B:V")) %>%
        mutate(Position = ifelse(nchar(Position)<3,
                                 gsub("(^.{1})(.*)$","\\10\\2", Position),
                                 Position)) %>%
        mutate(channel = channel, .after = Researcher) %>%
        rename(Individual_Efficiency = 'Individual\nEfficiency') %>%
        arrange(Plate, Position) %>%
        rename(water_temp = Temperature)

}