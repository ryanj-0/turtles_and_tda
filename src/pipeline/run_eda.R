#############################
# Run full EDA pipeline
############################
# set globals
eda.dir <- paste(src.dir, "pipeline", "eda", sep = "/")
final <- 0

# Load Needed Functions ---------------------------------------------------

# Frequency plot by Measure -----------------------------------------------
source(paste(eda.dir, "01_freq_by_measure.R", sep = "/"))

# Observations by Water Temperature ---------------------------------------
source(paste(eda.dir, "02_observations_by_water_temp.R", sep = "/"))


# Plots -------------------------------------------------------------------

# by zones
g.plot <- ggplot(ratio.data, aes(x = pct.zero.ca)) +
    geom_histogram(color = "grey30", fill = "lightblue",
                   bins = 50) +
    geom_rug(alpha = 0.5) +
    facet_wrap(~zone, ncol = 1) +
    labs(title = "pct.zero.ca by zones",
         caption = "Source: ratio.data")
print(g.plot)

g.plot <- ggplot(ratio.data, aes(x = pct.delta.prior)) +
    geom_histogram(color = "grey30", fill = "lightblue",
                   bins = 50) +
    geom_rug(alpha = 0.5) +
    facet_wrap(~zone, ncol = 1) +
    labs(title = "pct.delta.prior by zones",
         caption = "Source: ratio.data")
print(g.plot)

g.plot <- ggplot(ratio.data, aes(x = diameter)) +
    geom_histogram(color = "grey30", fill = "lightblue",
                   bins = 50) +
    geom_rug(alpha = 0.5) +
    facet_wrap(~zone, ncol = 1) +
    labs(title = "diameter by zones",
         caption = "Source: ratio.data")
print(g.plot)

# over time
g.temp <- ggplot(ratio.data, aes(x = date)) +
    geom_bar(aes(fill = water)) +
    scale_x_date(date_labels = "%b %y",
                 date_breaks = "1 month") +
    labs(title = "by water temp")

g.chem <- ggplot(ratio.data, aes(x = date)) +
    geom_bar(aes(fill = chem)) +
    scale_x_date(date_labels = "%b %y",
                 date_breaks = "1 month") +
    labs(title = "by chemical")

final.plot <- g.temp/g.chem +
    plot_annotation(title = "data collection over time",
                    caption = "Source: ratio.data")
print(final.plot)
