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

The data shows body characteristics of penguings in different islands
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

<img src="https://github.com/loukesio/plots/blob/main/plots/rainclound.png" width="600" />


### 4. Chord Diagram


```
# A tibble: 147 × 3
# Groups:   from [13]
   from           to      value
   <chr>          <chr>   <dbl>
 1 Germany        France    306
 2 Italy          France    268
 3 Germany        Belgium   235
 4 Belgium        France    200
 5 France         Belgium   190
 6 Italy          Spain     170
 7 Spain          France    152
 8 United Kingdom France    131
 9 Poland         France    125
10 Spain          Italy     123
# … with 137 more rows
```

<details><summary> code </summary>

```
#__________________________________________________________________________________________________________________
# 
#  ██████╗██╗  ██╗ ██████╗ ██████╗ ██████╗     ██████╗ ██╗ █████╗  ██████╗ ██████╗  █████╗ ███╗   ███╗███████╗
# ██╔════╝██║  ██║██╔═══██╗██╔══██╗██╔══██╗    ██╔══██╗██║██╔══██╗██╔════╝ ██╔══██╗██╔══██╗████╗ ████║██╔════╝
# ██║     ███████║██║   ██║██████╔╝██║  ██║    ██║  ██║██║███████║██║  ███╗██████╔╝███████║██╔████╔██║███████╗
# ██║     ██╔══██║██║   ██║██╔══██╗██║  ██║    ██║  ██║██║██╔══██║██║   ██║██╔══██╗██╔══██║██║╚██╔╝██║╚════██║
# ╚██████╗██║  ██║╚██████╔╝██║  ██║██████╔╝    ██████╔╝██║██║  ██║╚██████╔╝██║  ██║██║  ██║██║ ╚═╝ ██║███████║
#  ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝     ╚═════╝ ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
#_________________________________________________________________________________________________________________

library(countrycode)  # pacakge for converting country names, ISO codes, and other country-related information
library(tidyverse)    # data manipulation, visualization, and analysis
library(circlize)     # package for creating circular plots, heatmaps, and chord diagrams
library(cowplot)      # functions for creating and arranging complex plots, including multi-panel figures.
library(grid)         # its a graphics engine for packages like ggplot2
library(ggplotify)    # a package for converting complex plots into 'ggplot2' objects, making it easier to customize and modify the appearance of the plots.

#import data from tidytuesday github
df <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-03-08/erasmus.csv')

#which countries sends the most students abroad?
top_sending<-df%>%
  filter(sending_country_code!=receiving_country_code)%>%
  group_by(sending_country_code)%>%
  summarise(students=sum(participants))%>%
  arrange(-students)%>%
  head(10)

top_sending

#which countries receive the most students?
top_receiving<-df%>%
  filter(sending_country_code!=receiving_country_code)%>%
  group_by(receiving_country_code)%>%
  summarise(students=sum(participants))%>%
  arrange(-students)%>%
  head(10)

top_receiving

#create a list of countries that are either in the top 10 sending or top 10 receiving
#convret list of country codes to country names. manually plug in "UK", not part of iso code list
top_country_codes<-unique(c(top_sending$sending_country_code, top_receiving$receiving_country_code))
top_countries<-countrycode(top_country_codes , origin="iso2c", destination="iso.name.en")
top_countries[5]<-"United Kingdom"

data<-df%>%
  #use the countrycode function to convert codes to country names for both receiving and sending countries
  mutate(
    to= countrycode(receiving_country_code, origin="iso2c", destination="iso.name.en"),
    from= countrycode(sending_country_code , origin="iso2c", destination="iso.name.en"),
  )%>%
  #United Kingdom and Greece not translated with ISO country codes, override with dplyr "replace"
  mutate(
    to = replace(to, receiving_country_code=="UK","United Kingdom"),
    from = replace(from, sending_country_code=="UK","United Kingdom"), 
    to = replace(to, receiving_country_code=="EL","Greece"),
    from = replace(from, sending_country_code=="EL","Greece")
  )%>%
  #summarise number of participants by sending and receiving country code
  group_by(from, to)%>%
  summarise(value=sum(participants))%>%
  arrange(-value)

#subset data to simplify chord diagram
#filter out records where country "from" is the same as country "to". select countries part of top countries list
chord_data<-data%>%
  filter(from!=to)%>%
  filter(from %in% top_countries & to %in% top_countries)%>%
  arrange(-value)

#replace Netherlands (the) with Netherlands for all occurences (from and to)
chord_data[chord_data=="Netherlands (the)"]<-"Netherlands"

#create custom color palette, sites like https://coolors.co/ make it easy
pal<-c("#002765","#0061fd","#1cc6ff","#00b661","#5bf34d","#ffdd00","#ff7d00","#da2818","#ff006d","#8f00ff","#453435","black","grey80")
pal2=c("#f94144", "#f3722c","#f8961e","#f9844a","#f9c74f","#90be6d","#43aa8b","#4d908e","#577590", "#277da1","#453435","black","grey80")

#based on tutorial from https://jokergoo.github.io/circlize_book/book/the-chorddiagram-function.html
chordDiagram(chord_data, grid.col = pal2)

#convert chordDiagram (base plot) to grid plot to combine with ggplot annotations and theme details
p<-recordPlot()  # records the previous chord diagram and saves it as `p`. This is useful for creating complex plots that involve multiple layers, or for creating a base plot that can be modified later.

as.ggplot(ggdraw(p))+   # you can convert now  chord diagram `p` to a ggplot object
  labs(title="ERASMUS STUDENT MOBILITY",
       subtitle="Graphic depicts movement of participants between top participating countries from 2014 to 2020",
       caption="Data from Data.Europa")+
  theme(text=element_text(family="Arial"),
        plot.title=element_text(hjust=0.5, face="bold", size=18),                
        plot.subtitle=element_text(hjust=0.5, size=12, margin=margin(t=10)), # horizontal justification = 0.5, top margin to 10 units
        plot.caption=element_text(size=10, hjust=0.95, margin=margin(b=12)), # sets the bottom maring to 12 units
        plot.margin=margin(t=20)). # sets the top margin to 20 units

ggsave("erasmus.jpeg", height=9, width=9)

```

</details>

<img src="https://github.com/loukesio/plots/blob/main/plots/erasmus.png" width="600" />
  
### 5. Grouped dot plot
  
 
  ``` r
# load required packages
library(tidyverse)         # for data wrangling and visualization
library(palmerpenguins)    # for the penguins dataset

head(penguins)
#> # A tibble: 6 × 8
#>   species island    bill_length_mm bill_depth_mm flipper_l…¹ body_…² sex    year
#>   <fct>   <fct>              <dbl>         <dbl>       <int>   <int> <fct> <int>
#> 1 Adelie  Torgersen           39.1          18.7         181    3750 male   2007
#> 2 Adelie  Torgersen           39.5          17.4         186    3800 fema…  2007
#> 3 Adelie  Torgersen           40.3          18           195    3250 fema…  2007
#> 4 Adelie  Torgersen           NA            NA            NA      NA <NA>   2007
#> 5 Adelie  Torgersen           36.7          19.3         193    3450 fema…  2007
#> 6 Adelie  Torgersen           39.3          20.6         190    3650 male   2007
#> # … with abbreviated variable names ¹​flipper_length_mm, ²​body_mass_g
```

<sup>Created on 2023-04-03 with [reprex v2.0.2](https://reprex.tidyverse.org)</sup>
  
**Plot A**
  
  <img src="https://github.com/loukesio/plots/blob/main/plots/plotA_GroupedDots.png" width="600" />

  
<details><summary> code </summary>

  penguins %>%
  drop_na() %>%                                       # remove rows with missing values
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

 </details>

**Plot B**

    <img src="https://github.com/loukesio/plots/blob/main/plots/plotB_GroupedDots.png" width="600" />

  
 <details><summary> code </summary>
   
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
guides(color = "none")        
   
    </details>


