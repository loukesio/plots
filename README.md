# plots
This is a public repository which shows how to do fancy plots in R with simple data

### 1. Make a ternary plot with ggtern 

<details><summary> code </summary>

``` r
suppressPackageStartupMessages(library(ggtern)) # library for loading the ggtern pacakge
library(tidyverse)                              # library for loading the tidyverse package for data analysis

data=tibble(x=runif(200),  y = runif(200),  z = runif(200), time=rep(seq(1:10),20))


ggtern(data, aes(x,y,z)) +                 # This line creates a ternary plot using the ggtern package. The data is mapped to the x, y, and z aesthetics.
  geom_point() +                             # This line adds points to the ternary plot
  theme_rgbw() +                             # This line applies the theme_rgbw() theme to the plot
  stat_density_tern(geom = 'polygon',        # This line adds a density polygon to the plot, with the fill and alpha aesthetics mapped to the density level        
                    aes(fill  = after_stat(level),
                        alpha = after_stat(level)), bdl=0.001) +
  scale_fill_gradient(low = "blue",high = "red")  +       # This line scales the fill color of the density polygon from blue to red
  guides(color = "none", fill = "none", alpha = "none")   # This line removes the color, fill, and alpha guides from the plot
#> Warning: Removed 1 rows containing non-finite values (`StatDensityTern()`).
```

![](https://i.imgur.com/dKAw1Bq.png)<!-- -->

<sup>Created on 2023-01-19 with [reprex v2.0.2](https://reprex.tidyverse.org)</sup>
  
</details>
