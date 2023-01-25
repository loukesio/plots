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

ggsave("plots/erasmus.png", width = 30, height = 25, units = "cm")

