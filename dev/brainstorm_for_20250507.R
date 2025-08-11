x <- single.bm$landmarks
x_1 <- seq(1, length(x))
y <- points_covered_by_landmarks(single.bm, x[1])


bm.data[y] %>%
    count(water) %>%
    mutate(pct = n/sum(n),
           node = )

z <- lapply(seq_along(x_1),
       function(i) bm.data[points_covered_by_landmarks(single.bm, i)] %>%
           count(water) %>%
           mutate(pct = n/sum(n),
                  node = i
                  )
       )

z_1 <- lapply(seq_along(x_1),
       function(i) bm.data[points_covered_by_landmarks(single.bm, i)] %>%
           mutate(oxygen = case_when(water %like% "A" ~ "Anoxic",
                                     water %like% "N" ~ "Normoxic")) %>%
           count(oxygen) %>%
           mutate(pct = n/sum(n),
                  node = i
           )
)

ratio.data %>%
    select(water, chem, pct.zero.ca, pct.delta.prior) %>%
    ggplot() +
    geom_histogram(aes(x = pct.zero.ca), bins = 50) +
    facet_grid(chem ~ water)
