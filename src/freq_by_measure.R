# Frequency plot by Measure
g.plot <- cerebral_data |>
    ggplot(aes(x = measure |> fct_infreq())) +
    geom_bar(aes(fill = chem), position = position_stack(reverse = TRUE)) +
    scale_fill_manual(values = c("#0072B2", "#66C2A5", "#AA3377", "#F0E442", "#FF9F1C")) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
    geom_text(aes(label = after_stat(count), hjust = -0.3),
              stat = 'count') +
    labs(
        title = "Frequency plot by Measure",
        subtitle = "Total Counts",
        caption = paste("N =", nrow(cerebral_data)),
        x = "Counts", y = "Type of Measure",
        fill = "Chemical:") +
    theme(legend.position = "bottom") +
    coord_flip()


# preview
print(g.plot)

# save and clean up
if(final == 1){
    ggsave("freq_by_measure.pdf",
           plot = g.plot,
           path = paste(getwd(), "results/final/eda", sep = '/'),
           width = 14, height = 6.32, units = "in")
} else {
    ggsave("freq_by_measure.pdf",
           plot = g.plot,
           path = file.path(getwd(), "plots"),
           width = 14, height = 6.32, units = "in")
}
rm(g.plot)

