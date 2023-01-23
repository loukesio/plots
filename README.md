# PLOTS
This is a public repository which shows how to do fancy plots in R with simple data

### 1. Make a ternary plot with ggtern 

This is how the data looks like 

```
# > head(data)
# # A tibble: 6 × 4
#      x         y     z  time
#   <dbl>    <dbl> <dbl> <int>
# 1 0.893   0.268 0.672     1
# 2 0.141   0.448 0.863     2
# 3 0.00621 0.589 0.624     3
# 4 0.479   0.204 0.385     4
# 5 0.209   0.471 0.417     5
# 6 0.756   0.973 0.674     6

```

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

### 2. Make a voronoi diagram 
  
  Cluster cars based on the gear
  
  ```
  data(mtcars) 
  head(mtcars)
                     mpg cyl disp  hp drat    wt  qsec vs am gear carb           car_name
Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4         Mazda\nRX4
Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4    Mazda\nRX4\nWag
Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1        Datsun\n710
Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1   Hornet\n4\nDrive
Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2 Hornet\nSportabout
Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1            Valiant
  
  ```
  
  <details><summary> code </summary>

```
#___________________________________________________________________________
#
# ╦ ╦┌─┐┬┌─┐┬ ┬┌┬┐┌─┐┌┬┐╔╦╗┬─┐┌─┐┌─┐┌┬┐┌─┐┌─┐┌─┐  ┌─┐┌─┐┌─┐┬┌─┌─┐┌─┐┌─┐
# ║║║├┤ ││ ┬├─┤ │ ├┤  ││ ║ ├┬┘├┤ ├┤ │││├─┤├─┘└─┐  ├─┘├─┤│  ├┴┐├─┤│ ┬├┤ 
# ╚╩╝└─┘┴└─┘┴ ┴ ┴ └─┘─┴┘ ╩ ┴└─└─┘└─┘┴ ┴┴ ┴┴  └─┘  ┴  ┴ ┴└─┘┴ ┴┴ ┴└─┘└─┘
#____________________________________________________________________________

library(WeightedTreemaps) #use a weightedTreemap that contains a lots of shapes https://github.com/m-jahn/WeightedTreemaps
library(ltc)

data(mtcars)  #use the mtcars data 
mtcars$car_name = gsub(" ", "\n", row.names(mtcars)) #add a new rows with the car names

mtcars %>%                                #shows how many different gears exist
  distinct(gear)

tm <- voronoiTreemap(                     #use the voronoiTreemap function to 
  data = mtcars,                          #add the data
  levels = c("gear", "car_name"),         #it will split the area into the 3 gears (4,5,6) and in each of them will add the cars
  cell_size = "wt",
  shape = "rounded_rect",
  seed = 123
)

pal=ltc("dora",100,"continuous")         #add the color palette that you might need
palettes                                 #see all palettes from ltc and choose the one you like

drawTreemap(                             #the function draws the Treemap
  tm, 
  color_palette = pal,
  color_type = "cell_size",
  color_level = 2,
  #label_level = c(1,2),
  label_size = 3,                    
  #label_color = grey(0.5),            
  border_color = "black",                #add color for the borders
  #layout = c(1, 2),
  position = c(1, 1),                    #I am not sure what it does
  title = "Cars per gear"
)
```
 
</details>
    
<img src="https://github.com/loukesio/plots/blob/main/plots/weighted_voronoi.png" width="400" />
      
