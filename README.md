# plots
This is a public repository which shows how to do fancy plots in R with simple data

### 1. Make a ternary plot with ggtern 

<details><summary> code </summary>

``` r
#______________________________________________________________________________________________________
# ████████╗███████╗██████╗ ███╗   ██╗ █████╗ ██████╗ ██╗   ██╗    ██████╗ ██╗      ██████╗ ████████╗
# ╚══██╔══╝██╔════╝██╔══██╗████╗  ██║██╔══██╗██╔══██╗╚██╗ ██╔╝    ██╔══██╗██║     ██╔═══██╗╚══██╔══╝
#    ██║   █████╗  ██████╔╝██╔██╗ ██║███████║██████╔╝ ╚████╔╝     ██████╔╝██║     ██║   ██║   ██║    
#    ██║   ██╔══╝  ██╔══██╗██║╚██╗██║██╔══██║██╔══██╗  ╚██╔╝      ██╔═══╝ ██║     ██║   ██║   ██║   
#    ██║   ███████╗██║  ██║██║ ╚████║██║  ██║██║  ██║   ██║       ██║     ███████╗╚██████╔╝   ██║   
#    ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝       ╚═╝     ╚══════╝ ╚═════╝    ╚═╝   
#______________________________________________________________________________________________________

#_________________________
# ┬  ┬┌┐ ┬─┐┌─┐┬─┐┬┌─┐┌─┐
# │  │├┴┐├┬┘├─┤├┬┘│├┤ └─┐
# ┴─┘┴└─┘┴└─┴ ┴┴└─┴└─┘└─┘
#_________________________

suppressPackageStartupMessages(library(ggtern)) # library for loading the ggtern pacakge
library(tidyverse)                              # library for loading the tidyverse package for data analysis
library(here)                                   # define the directory you want to go 

#________________
# ┌┬┐┌─┐┌┬┐┌─┐
#  ││├─┤ │ ├─┤
# ─┴┘┴ ┴ ┴ ┴ ┴
#________________

data=tibble(x=runif(200),  y = runif(200),  z = runif(200), time=rep(seq(1:10),20))

#______________
# ┌─┐┬  ┌─┐┌┬┐
# ├─┘│  │ │ │ 
# ┴  ┴─┘└─┘ ┴ 
#______________

ggtern(data, aes(x,y,z)) +                   # This line creates a ternary plot using the ggtern package. The data is mapped to the x, y, and z aesthetics.
  geom_point() +                             # This line adds points to the ternary plot
  theme_rgbw() +                             # This line applies the theme_rgbw() theme to the plot
  stat_density_tern(geom = 'polygon',        # This line adds a density polygon to the plot, with the fill and alpha aesthetics mapped to the density level        
                    aes(fill  = after_stat(level),
                        alpha = after_stat(level)), bdl=0.001) +
  scale_fill_gradient(low = "blue",high = "red")  +       # This line scales the fill color of the density polygon from blue to red
  guides(color = "none", fill = "none", alpha = "none")   # This line removes the color, fill, and alpha guides from the plot

#___________________________
# ┌─┐┌┐┌┬┌┬┐┌─┐┌┬┐┬┌─┐┌┐┌
# ├─┤│││││││├─┤ │ ││ ││││
# ┴ ┴┘└┘┴┴ ┴┴ ┴ ┴ ┴└─┘┘└┘
#___________________________

library(gganimate)       # this line loads the gganimate library, which allows animation to be added to ggplots
library(magick)          # this line loads the magick library, which provides functionality to handle image files
 
# This loop iterates 20 times
for(i in 1:20) {
  # This line creates a ternary plot with data filtered by the current iteration value, and applies the same aesthetics and formatting as the previous plot
  p <- ggtern(data[data$time == i, ], aes(x, y, z)) +
    geom_point() +
    theme_rgbw() +
    stat_density_tern(geom = 'polygon',
                      aes(fill = ..level.., alpha = ..level..), bdl = 0.001) +
    scale_fill_gradient(low = "blue",high = "red")  +
    guides(color = "none", fill = "none", alpha = "none") 
  
  ggsave(paste0('ggtern', i, '.png'), p)                         # This line saves the current plot as a PNG file with a file name that includes the iteration number
}

list.files(pattern = 'ggtern\\d+\\.png', full.names = TRUE) %>%  # This line uses the magick library to read the PNG files that were created in the loop
  image_read() %>% 
  image_join() %>%                                               # This line joins the images together to form an animation
  image_animate(fps=4) %>%                                       # This line sets the animation speed to 4 frames per second
  image_write("plots/ggtern.gif")       
```
  
</details>
<img src="https://github.com/loukesio/plots/blob/main/plots/ggtern.gif" width="400" />

