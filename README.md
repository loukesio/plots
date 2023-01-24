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
      

### 3. Raincloud plot 

data
```
# A tibble: 342 × 9
# Groups:   species [3]
   species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex     year bill_ratio
   <fct>   <fct>              <dbl>         <dbl>             <int>       <int> <fct>  <int>      <dbl>
 1 Adelie  Torgersen           39.1          18.7               181        3750 male    2007       2.09
 2 Adelie  Torgersen           39.5          17.4               186        3800 female  2007       2.27
 3 Adelie  Torgersen           40.3          18                 195        3250 female  2007       2.24
 4 Adelie  Torgersen           36.7          19.3               193        3450 female  2007       1.90
 5 Adelie  Torgersen           39.3          20.6               190        3650 male    2007       1.91
 6 Adelie  Torgersen           38.9          17.8               181        3625 female  2007       2.19
 7 Adelie  Torgersen           39.2          19.6               195        4675 male    2007       2   
 8 Adelie  Torgersen           34.1          18.1               193        3475 NA      2007       1.88
 9 Adelie  Torgersen           42            20.2               190        4250 NA      2007       2.08
10 Adelie  Torgersen           37.8          17.1               186        3300 NA      2007       2.21
```


<details><summary> code </summary>

```
#_____________________________________________________________________________________________________________________
# 
# ██████╗  █████╗ ██╗███╗   ██╗ ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ██████╗ ██╗      ██████╗ ████████╗
# ██╔══██╗██╔══██╗██║████╗  ██║██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ██╔══██╗██║     ██╔═══██╗╚══██╔══╝
# ██████╔╝███████║██║██╔██╗ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║    ██████╔╝██║     ██║   ██║   ██║   
# ██╔══██╗██╔══██║██║██║╚██╗██║██║     ██║     ██║   ██║██║   ██║██║  ██║    ██╔═══╝ ██║     ██║   ██║   ██║   
# ██║  ██║██║  ██║██║██║ ╚████║╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝    ██║     ███████╗╚██████╔╝   ██║   
# ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝     ╚═╝     ╚══════╝ ╚═════╝    ╚═╝   
#_____________________________________________________________________________________________________________________

library(palmerpenguins)  # Importing the palmerpenguins library
library(ggtext)          # Importing the ggtext library
library(colorspace)      # Importing the colorspace library
library(ragg)            # Importing the ragg library
library(showtext)        # Importing the showtext library

font_add_google("Roboto Mono", "Roboto Mono") # Adding the Roboto Mono font
font_add_google("Zilla Slab", "Zilla Slab") # Adding the Zilla Slab font

showtext_auto() # with this command you register the font  

#___________________________________
# ┬─┐┌─┐┌─┐┌┬┐┌─┐┬─┐  ┬┌┬┐┌─┐┌─┐┌─┐
# ├┬┘├─┤└─┐ │ ├┤ ├┬┘  ││││├─┤│ ┬├┤ 
# ┴└─┴ ┴└─┘ ┴ └─┘┴└─  ┴┴ ┴┴ ┴└─┘└─┘
#___________________________________

# Defining the url of the image to be plotted
url <- "https://education.rstudio.com/blog/2020/07/palmerpenguins-cran/gorman-penguins.jpg"
# Reading the image
img <- magick::image_read((url))
# Creating a rasterGrob object of the image
pic <- grid::rasterGrob(img, interpolate = TRUE)

# Displaying the image
img

# Defining a color palette
pal <- c("#FF8C00", "#A034F0", "#159090")
pal2 <- c("#DC4434","#F7AA00","#00A9A6")

# Defining a function to add sample size to the plot
# the function is called add_sample and
add_sample <- function(x){       # it takes the argument x, which a column of numbers it creates two columns, aka two variables, 
  return(c(y = max(x) + .025,    # the first column finds the max of the x and adds 0.25
           label = length(x)))   # the second column the label, finds the length of x and adds it, it tells you actually the sample size
}


# Grouping the data by species, creating a new variable 'bill_ratio', filtering missing values, and plotting the data
penguins %>% 
  group_by(species) %>%                # group data by species
  mutate(bill_ratio =                  # add the bill ratio column 
  bill_length_mm / bill_depth_mm) %>%  
  filter(!is.na(bill_ratio))       # remove NA values
  
  ggplot(aes(x = fct_rev(species), y = bill_ratio)) +  # plot species over bill ratio. fct_rev(), is reversing the order of the species variable so that it is displayed in descending order on the x-axis of the plot
# ggdist 
   ggdist::stat_halfeye(                # Adding the stat_halfeye layer
    aes(color = species,              
        fill = after_scale(lighten(color, .5))), # increases the lightness of the fill color by 0.5
    adjust = .5,          # function that controls the position of the median line in relation to the box.
    width = .75,          # the width of the dist schematic. A value of 0.75 will make the box wider.
    .width = 0,           # adds a line. controls the width of the line separating the top and bottom of the box. A value of 0 will make this line disappear.
    justification = -.3,  # justification is a parameter of the stat_halfeye() function that controls the position of the box relative to the x-axis. A negative value of -0.4 will shift the box to the left.
    point_color = NA) +   # it shows the point where the median is 
    geom_boxplot(  
    aes(color = species,
      color = after_scale(darken(color, .1, space = "HLS")),  # you can use after_scale to modify the the scale of the color after you apply it. Here you darken it by 0.1 and HLS means Hue Lightness Saturation
      fill = after_scale(desaturate(lighten(color, .8), .4))),
      width = .42, 
      outlier.shape = NA) +
# geom_point
  geom_point(
  aes(color = species,
      color = after_scale(darken(color, .1, space = "HLS"))),
  fill = "white",
  shape = 21,
  stroke = .4,
  size = 2,
  position = position_jitter(seed = 1, width = .12)
) +
  stat_summary(                                                   # This function is used to add summary statistics to a plot
    geom = "text",        
    fun = "median",                                             # This function calculates the median of the variable y
    aes(label = round(..y.., 2),                                # This function rounds the median value of the variable y to 2 decimal places and labels it 
        color = species,
        color = after_scale(darken(color, .1, space = "HLS"))), # This function darkens the color of the median text by .1 in the HLS color space 
    family = "Roboto Mono",                                    # This function sets the font family to Roboto Mono
    fontface = "bold",                                          # This function sets the fontface of the median text to bold
    size = 4.5,                                                 # This function sets the size of the median text to 4.5
    vjust = -3.5                                                # This function sets the vertical justification of the median text to -3.5
  ) +
stat_summary(                                           
  geom = "text",                                                # this function uses a stat_summary and gives a geom_text
  fun.data = add_sample,                                        # the function that uses is calles add_sample
  aes(label = paste("n =", ..label..),                          # the function pastes the label together with the letter n=
      color = species,
      color = after_scale(darken(color, .1, space = "HLS"))),   # after you set the color you make a bit darker 
  #family = "Roboto Mono",
  size = 4,                                                     # add the size
  hjust = 0                                                     # adjust horizontically the text
  ) +
  coord_flip(xlim = c(1.2, NA), clip = "off") +                               # here flips the plot, sets the axis limits, and turns off clipping 
  annotation_custom(pic, ymin = 2.9, ymax = 3.85, xmin = 2.7, xmax = 4.7) +   # here adds the images in the graph
  scale_y_continuous(
    limits = c(1.57, 3.8),
    breaks = seq(1.6, 3.8, by = .2),
    expand = c(.001, .001)                       # sets a small expansion of the scales to ensure that the data points do not touch the edge of the plot.
  ) +
  scale_color_manual(values = pal2, guide = "none") +
  scale_fill_manual(values = pal2, guide = "none") + 
  theme_minimal(base_family = "Zilla Slab", base_size = 15) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    axis.ticks = element_blank(),
    axis.text.y = element_text(color = rev(darken(pal2, .1, space = "HLS")), size = 18),  # you can even dark the color from the element text
    axis.title.x = element_text(margin = margin(t = 10), size = 16),
    plot.title = element_markdown(face = "bold", size = 21),
    plot.subtitle = element_text(color = "grey40", hjust = 0, margin = margin(0, 0, 20, 0)),
    plot.title.position = "plot",
    plot.caption = element_markdown(color = "grey40", lineheight = 1.2, margin = margin(20, 0, 0, 0)),
    plot.margin = margin(15, 15, 10, 15)
  ) +
  labs(
    x = NULL,
    y = "Bill ratio",
    title = "Bill Ratios of Brush–Tailed Penguins (*Pygoscelis* spec.)",
    subtitle = "Distribution of bill ratios, estimated as bill length divided by bill depth."
  )

ggsave("plots/rainclound.png", width = 30, height = 25, units = "cm")



```


</details>

<img src="https://github.com/loukesio/plots/blob/main/plots/rainclound.png" width="400" />

