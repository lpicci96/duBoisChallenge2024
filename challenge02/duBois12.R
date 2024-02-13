# DuBoisChallenge2024 Chart #12 "Slave and Free Negroes"

library(tidyverse)
library(ggplot2)
library(showtext)

# Du Bois font
showtext_auto()
font_add_google("Public Sans", "Public Sans")


# read in the data
data <- read.csv("data.csv")


# data formatting
data<- data %>% mutate(FreeValue = case_when(Free < 100 ~ Free, TRUE ~ 3),
                SlaveValue = 3 - FreeValue,
                FreeLabel = case_when((Year == 1790 | Year == 1870 ) 
                                      ~ paste0(Free, "%"), 
                                      TRUE ~ as.character(Free))
                ) %>% 
  bind_rows(tibble(Year=1863, FreeValue=3, SlaveValue=0))



# random numbers for axis break
set.seed(123)
years <- seq(1790, 1870, by = 0.25)
random <- data.frame(Year = years, 
                     RandNumber = runif(years, min = 2.92, max = 3))

# plot
plot <- ggplot(data)+
  
  #plot values
  geom_ribbon(aes(xmax=0, xmin=3, y=Year), fill="#111111")+
  geom_ribbon(aes(xmin=0, xmax=FreeValue, y=Year), fill="#c3213e", color="#e2d0be", linewidth=0.2)+
  
  # axis break
  geom_ribbon(data=random, aes(xmin=3, xmax=RandNumber, y=Year), fill="#e2d0be", color="#111111", linewidth=0.25)+
  geom_segment(aes(x=3, xend=3, y=1790, yend=1870), color="#e2d0be")+ # hide connecting line
  
  # grid lines
  geom_segment(data = data.frame(Year=seq(1790, 1870, by = 10)), 
               aes(x = 2.9, xend=0, y=Year, yend=Year), color="#e2d0be", size=0.2)+
  geom_segment(aes(y=1790, x=3, xend=0, yend=1790), color="#e2d0be")+
  geom_segment(aes(y=1870, x=3, xend=0, yend=1870), color="#e2d0be")+
  
  # axis customization
  scale_x_reverse(position="top", breaks=c(1,2,3), labels = function(x) paste0(x, "%"))+
  scale_y_reverse(breaks = seq(from = 1790, to = 1870, by = 10))+
  xlim(c(3, -0.6))+
  
  labs(title="SLAVES AND FREE NEGROES.")+
  theme(plot.background = element_rect(fill = "#e2d0be", color="#e2d0be"),
        panel.background = element_rect(fill = "#e2d0be", color="#e2d0be"),
        panel.grid = element_blank(),
        text = element_text(family="Public Sans", color="#413528"),
        plot.margin = margin(t = 20, r = 70, b = 5, l = 70, unit = "pt"),
        
        axis.title = element_blank(),
        axis.text.x = element_blank(), 
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_text(size=20, color="#958475"),
        
        plot.title = element_text(hjust=10, size=35, face="bold", margin=margin(b=0))
        )+
  
  annotate("text", label="3%", x=2.95, y=1789, vjust=0, size=5, fontface="plain", color="#958475", family="Public Sans")+
  annotate("text", label="2%", x=2, y=1789, vjust=0, size=5, fontface="plain", color="#958475", family="Public Sans")+
  annotate("text", label="1%", x=1, y=1789, vjust=0, size=5, fontface="plain", color="#958475", family="Public Sans")+
  
  annotate("segment", x=2.95, xend=2.95, y=1790, yend=1789.5, color="#a4917f", size=0.2)+
  annotate("segment", x=2, xend=2, y=1790, yend=1789.5, color="#a4917f", size=0.2)+
  annotate("segment", x=1, xend=1, y=1790, yend=1789.5, color="#a4917f", size=0.2)+
  
  annotate("text", x=-0.4, y=1786, label="PERCENT", size=4.5, vjust=0, color="#958475", family="Public Sans")+
  annotate("text", x=-0.4, y=1787.2, label="OF", size=4.5, vjust=0, color="#958475", family="Public Sans")+
  annotate("text", x=-0.4, y=1788.4, label="FREE NEGROES", size=4.5, vjust=0, color="#958475", family="Public Sans")+

  # data labels
  geom_text(aes(label=FreeLabel, x=-0.3, y=Year), hjust=0, color="#958475", size=7, family="Public Sans")+
  
  # footer
  annotate("text",label="#DuBoisChallenge2024", x=-0.6, hjust=1, y=1877, size=6, color = "#413528")+
  annotate("text",label="Chart by Luca Picci | @lpicci96", x=-0.6, hjust=1, y=1879, size=6, color = "#413528")


ggsave("plot.png", plot, width = 4.5, height = 6, dpi = 300)
  
  
  

