# Observations by Water Temperature

# some data work
water.groups <- turtle.data %>%
   group_by(water, chem) %>%
   count()
water.tots <- water.groups %>%
   group_by(water) %>%
   summarise(temp_totals = sum(n))

water.groups <- inner_join(water.groups, water.tots, by = "water") %>%
    mutate(pct = round(n/temp_totals*100, 1)) %>%
    ungroup()


# plot
g.plot <- water.groups |>
    ggplot(aes(x = water, y = n, fill = chem)) +
    geom_col() +
    geom_text(aes(label = paste0(pct, "%")),
             position = position_stack(0.5)) +
    labs(
        title = "Observations by Water Temperature",
        caption = paste("N =", nrow(turtle.data)),
        x = "Water Temperature", y = "Count",
        fill = "Chemical") +
    scale_fill_manual(values = my.colors) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.05)))

# preview
print(g.plot)

# save and clean up
if(final == 1){
    ggsave("observations_by_water_temp.pdf",
           plot = g.plot,
           path = paste(getwd(), "results/final/eda", sep = '/'),
           width = 14, height = 6.32, units = "in")
} else {
    ggsave("observations_by_water_temp.pdf",
           plot = g.plot,
           path = paste(getwd(), "results/test/eda", sep = '/'),
           width = 14, height = 6.32, units = "in")
}

rm(water.tots,
   water.groups,
   g.plot)