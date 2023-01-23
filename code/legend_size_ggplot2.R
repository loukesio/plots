library(tidyverse)
library(palmerpenguins)
theme_set(theme_bw(16))

penguins %>%
  drop_na() %>%
  unite(species_sex, c(species, sex)) %>% 
  ggplot(aes(flipper_length_mm, body_mass_g, color=island))+
  geom_point(size=4, alpha=0.7) +
  scale_color_manual(values=c("#732B38","#D6AD2F","#3B78B7")) +
  guides(colour = guide_legend(override.aes = list(size=6))) #simply change the size of the legend with one command

# Reference 
#1 . https://datavizpyr.com/increase-legend-key-size-in-ggplot2/