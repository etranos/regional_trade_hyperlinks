library(tidyverse)

setwd("C:/Users/nw19521/OneDrive - University of Bristol/projects/regional_trade_hyperlinks/scripts")


all <- read_csv("rmse_all.csv") %>% 
  rename(rmse.all = value,
         year = variable)
nohl <- read_csv("rmse_nohl.csv") %>% 
  rename(rmse.nohl = value) %>% 
  dplyr::select(rmse.nohl)
nodist <- read_csv("rmse_nodist.csv") %>% 
  rename(rmse.nodist = value) %>% 
  dplyr::select(rmse.nodist)


df <- cbind(all, nohl) %>% 
  cbind(nodist) %>%  
  mutate(dif.all_nodl = rmse.all - rmse.nohl,             #100 - 80
         diff.nodist_nohl = rmse.nodist - rmse.nohl) %>%  #100 - 80
  glimpse()

# negative meean hl deceases the rmse.