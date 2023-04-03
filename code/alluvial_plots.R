
library(tidyverse)        # a wide range of tools for data manipulation, visualization, and analysis.
library(palmerpenguins)   # which contains data about penguins, including their species, sex, and measurements of different body parts.
library(ggalluvial)       # functions for creating alluvial diagrams, which are a type of flow diagram that can be used to visualize the movement of entities across different stages or categories.
library(ggpubr)           # functions for creating alluvial diagrams, which are a type of flow diagram that can be used to visualize the movement of entities across different stages or categories.
library(magick)           # provides an easy-to-use and powerful image processing toolkit for R, based on the 'ImageMagick' library
library(patchwork)        # functions for combining multiple 'ggplot2' plots into one, allowing for the creation of complex and customized multi-panel figures.
library(munsell)          # functions for working with the Munsell color system, which is a color notation system that uses a three-dimensional color space to describe colors based on their hue, value, and chroma.
library(colorspace)       # functions for working with color spaces, including RGB, HCL, LAB, and LCH, among others
library(flair)            # which provides a set of functions for highlighting, annotating, and formatting R source code, making it easier to create clear, readable, and shareable code.


df <- penguins %>% 
  count(species, island, year, sex, name = "freq") %>%  # count the species, per island per year and sex and name the column freq
  rowid_to_column("alluvium") %>%                       # add an id for each case 
  mutate(year = factor(year)) %>% 
  pivot_longer(
    -c(alluvium, freq, species),
    names_to = "variable", values_to = "stratum"
  )

df # with an alluvial plot we are gonna show how island, year, sex 

ggplot(aes(x = variable, y = freq, stratum = stratum, alluvium = alluvium, label = stratum)) 

+
  geom_alluvium(
    aes(fill = species), 
    aes.bind = "alluvia", colour = "darkgray", reverse = FALSE
  ) +
  geom_stratum(aes(fill = stratum), reverse = FALSE) +
  geom_text(stat = "stratum", reverse = FALSE) +
  scale_x_discrete(expand = expansion(mult = .1)) +
  scale_fill_manual(
    values = c(
      Adelie = "darkorange", Chinstrap = "purple", Gentoo = "cyan4",
      `2007` = munsell::mnsl("5Y 9/2"), `2008` = munsell::mnsl("5Y 9/4"), `2009` = munsell::mnsl("5Y 9/6"),
      female = 'aliceblue', male = 'honeydew',
      Biscoe = '#FCDAE0', Dream = '#D4E8CE', Torgersen = '#D3E4F7' 
    ),
    guide = FALSE, 
    na.value = "red"
  ) +
  coord_flip() 

penguins_png <- image_read("penguins.png")
img <- ggplot() + background_image(penguins_png)

(alluvial_plot / img) + 
  plot_annotation(
    title = 'Palmer Penguins species by year, sex and island',
    caption = 'Artwork by @allison_horst | #TidyTuesday | @mstkolf',
    theme = theme(
      plot.title = element_text(face = "bold", size = 20, family = "serif"),
      plot.caption = element_text(size = 10)
    ) 
  )
