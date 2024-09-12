# Frequency plot by Measure
g.plot <- turtle.data |>
    ggplot(aes(y = measure %>% fct_infreq())) +
    geom_bar(aes(fill = chem)) +
    geom_text(aes(label = after_stat(count), hjust = -0.3),
              stat = 'count') +
    labs(
        title = "Frequency plot by Measure",
        subtitle = "Total Counts",
        caption = paste("N =", nrow(turtle.data)),
        x = "Counts", y = "Type of Measure",
        fill = "Chemical:") +
    scale_fill_manual(values = my.colors,
                     breaks = turtle.data$chem %>% unique()) +
    scale_x_continuous(expand = expansion(mult = c(0, 0.05))) +
    theme(legend.position = "bottom")

# preview
print(g.plot)

# save and clean up
if(final == 1){
    ggsave("freq_by_measure.pdf",
           plot = g.plot,
           path = paste(getwd(), "results/final", sep = '/'),
           width = 14, height = 6.32, units = "in")
} else {
    ggsave("freq_by_measure.pdf",
           plot = g.plot,
           path = paste(getwd(), "results/test", sep = '/'),
           width = 14, height = 6.32, units = "in")
}
rm(g.plot)
