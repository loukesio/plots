#____________________________________________________________________________________________________________________________________
# 
# ██╗   ██╗ ██████╗ ██████╗  ██████╗ ███╗   ██╗ ██████╗ ██╗    ██████╗ ██╗ █████╗  ██████╗ ██████╗  █████╗ ███╗   ███╗███████╗
# ██║   ██║██╔═══██╗██╔══██╗██╔═══██╗████╗  ██║██╔═══██╗██║    ██╔══██╗██║██╔══██╗██╔════╝ ██╔══██╗██╔══██╗████╗ ████║██╔════╝
# ██║   ██║██║   ██║██████╔╝██║   ██║██╔██╗ ██║██║   ██║██║    ██║  ██║██║███████║██║  ███╗██████╔╝███████║██╔████╔██║███████╗
# ╚██╗ ██╔╝██║   ██║██╔══██╗██║   ██║██║╚██╗██║██║   ██║██║    ██║  ██║██║██╔══██║██║   ██║██╔══██╗██╔══██║██║╚██╔╝██║╚════██║
#  ╚████╔╝ ╚██████╔╝██║  ██║╚██████╔╝██║ ╚████║╚██████╔╝██║    ██████╔╝██║██║  ██║╚██████╔╝██║  ██║██║  ██║██║ ╚═╝ ██║███████║
#   ╚═══╝   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝    ╚═════╝ ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
#___________________________________________________________________________________________________________________________________

#___________________________________________________________________
# ┬  ┬┌─┐┬─┐┌─┐┌┐┌┌─┐┬╔╦╗┬─┐┌─┐┌─┐┌┬┐┌─┐┌─┐  ┌─┐┌─┐┌─┐┬┌─┌─┐┌─┐┌─┐
# └┐┌┘│ │├┬┘│ │││││ ││ ║ ├┬┘├┤ ├┤ │││├─┤├─┘  ├─┘├─┤│  ├┴┐├─┤│ ┬├┤ 
#  └┘ └─┘┴└─└─┘┘└┘└─┘┴ ╩ ┴└─└─┘└─┘┴ ┴┴ ┴┴    ┴  ┴ ┴└─┘┴ ┴┴ ┴└─┘└─┘
#___________________________________________________________________

#voronoi diagram from a two column data 
#Here is the documentation for the package https://github.com/uRosConf/voronoiTreemap

library(voronoiTreemap)      #load the voronoi Tree map data 

df <- data.frame(country = c("Ukraine", "Russia", "Argentina", "China", "Romania", "Other"),    #create a data.frame 
                 prod = c(11.0, 10.6, 3.1, 2.4, 2.1, 15.3))                                     #add the second column for produtivity 

vor <- data.frame(h1 = 'World',                                           #convert the data to the right format to create a voronoiTreemap
                  h2 = c('Europe', 'Europe', 'Americas', 'Asia',          #add a second column for continents 
                         'Europe', 'Other'),
                  h3 = df$country,                                        #add the country
                  color = hcl.colors(nrow(df), palette = 'TealRose'),     #add the colors of the country
                  weight = df$prod,                                       #add as weight the productivity
                  codes = df$country)                                     #country should be the code  

vor         #here is the prepared dataset

vt <- vt_input_from_df(vor)    #this creates a tree relationship for your data
vt

vt_d3(vt_export_json(vt), color_border = "#000000", width = 1000,height = 1000,
      size_border = "2px", legend = TRUE) #this function takes the tree and creates the graph

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
head(mtcars)

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

#_______________________________
# ┌─┐┌─┐┬  ┬┌─┐┬─┐┌─┐┌┐┌┌─┐┬
# │ ┬│ ┬└┐┌┘│ │├┬┘│ │││││ ││
# └─┘└─┘ └┘ └─┘┴└─└─┘┘└┘└─┘┴
#_______________________________

# look at this one 
#1. https://github.com/nrennie/30DayChartChallenge/blob/main/2022/scripts/04_flora.R
#2. https://github.com/nrennie/30DayChartChallenge/issues/1#issuecomment-1093369269

library(tidyverse)                                    #package for data wrangling

polygons <- read.csv("data/voronoi/voronoi.csv")      #read polygon data that ggvoronoi likes
polygons

text_df <- polygons %>%       #this is crazy and what it does is to find the summary of each dimension in the polygon data
  group_by(group) %>%
  summarise(x = mean(x),
            y = mean(y))

ggplot() +
  geom_polygon(data = polygons,   #create a geom polygon data
  aes(x = x,y = y, group = group,
      fill = group), colour = "white", size = 2) +
  geom_text(data = text_df,       #add the text in the polygons
  mapping = aes(x = x, y = y, label = group),
            colour = "#46607c",
            size = 5) +
  coord_fixed() +               #create a circular plot
  scale_fill_manual(values = 
                      c("Ukraine"="#98d9e4", "Russia"="#3ca8bc", "Argentina"="#4e9f50",
                      "China"="#87d180", "Romania"="#fcc66d", "Other"="#e7e5ef")) +
  labs(title = "Sunflower Seed Production",
       subtitle = "Sunflower seed production per country in millions of tonnes.") +
  theme_void() +
  scale_y_reverse() +
  theme(legend.position = "none",
        plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"),
        plot.title = element_text(colour = "#648ab2", size=17, face = "bold", hjust = 0, family="sans"),
        plot.subtitle = element_text(colour = "darkgrey", size=14, hjust = 0, family="sans",
                                     face = "italic"),
        plot.caption = element_text(colour = "black", size=8, hjust = 0, family="sans",
                                    face = "italic"))

#To go more crazy with the voronoi plots look in here 
#https://paezha.github.io/spatial-analysis-r/spatially-continuous-data-i.html