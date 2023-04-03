# load required packages
library(tidyverse)         # for data wrangling and visualization
library(palmerpenguins)    # for the penguins dataset

head(penguins)

reprex::reprex()


# remove rows with missing values
penguins %>%
  drop_na() %>%
  ggplot(aes(species, bill_length_mm, group = sex)) + # create a scatter plot of species vs. bill length, with sex grouping
  geom_jitter(aes(color = sex),                       # add jittered points with colors based on sex  
              size = 3,
              alpha = 0.8,
              position = position_jitterdodge()         # this is the key for creating a grouped dotted plot
  ) +
  stat_summary(                                         # add summary statistics (mean and standard deviation) with error bars
    fun.data = "mean_sdl",                              # function to calculate mean and standard deviation
    fun.args = list(mult = 1),                          # usually it gives a bar with 2x standard deviation, with mult=1, you make sure that you use 1 sd
    position = position_dodge(width = .75)              # position the summary statistics to look like the grouped dots
  ) +
  scale_color_manual(values = c("darkorange", "purple")) +   # set manual color scale for the points based on sex
theme_bw()


ggsave("plots/plotA_GroupedDots.png", width = 30, height = 25, units = "cm")



#### PLOT B - The trick in here that you create a faceted plot with facet wrap and then you break the distance between them

penguins %>%
  drop_na() %>%                                            # remove rows with missing values
  ggplot(aes(sex, bill_length_mm, group = sex)) +          # create a ggplot object with x-axis as sex and y-axis as bill_length_mm
  geom_jitter(aes(color = sex),                            # add a jittered scatterplot with points colored by sex
              size = 3,
              alpha = 0.8
  ) +
  stat_summary(
    fun.data = "mean_sdl", fun.args = list(mult = 1)        # add a summary statistic of the mean and standard deviation, with mean multiplied by 1
  ) +
  scale_color_manual(values = c("darkorange", "purple")) +  # manually set the colors for each sex
  facet_wrap(~species, strip.position = "bottom") +         # add facets to the plot based on species
  theme(
    panel.spacing.x = unit(0, "pt"),                         # set the horizontal spacing between panels to 0 points
    strip.placement = "outside",                             # place facet labels outside of the plot area
    strip.background.x = element_blank()                     # remove the background color of facet labels in the x-direction
  ) +
guides(color = "none")                                       # remove the color legend from the plot
  

ggsave("plots/plotB_GroupedDots.png", width = 30, height = 25, units = "cm")
