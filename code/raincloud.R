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
  filter(!is.na(bill_ratio)) %>%       # remove NA values
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

