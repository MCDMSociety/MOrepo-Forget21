## Store cpu for finding the last ND points

library(fs)
library(here)
library(tidyverse)

getLastCpu <- function(path) {
  dat <- read_csv(path, col_types = cols())
  return(dat %>% slice_tail(n = 1) %>% pull(cpu))
}
# getLastCpu(path = here("results/convert/csv/statFiles/UB/Forget21-PPP_10_3_1-100_1-100_1-2500_1_50_random_10_10_LP_MOFVREVISITED2.txt"))

dat <- read_csv(here("results", "convert", "csv", "resultsMain.csv")) %>% 
    mutate(instance_name = str_remove(instance, "....$"),
           instance = instance_name,
           class = str_replace(instance_name, "^.*?-(.*?)_(.*)", "\\1"),
           alg_config = str_c("\\", configLB, "-\\", toupper(configValSplit))) %>% 
  select(instance_name, configLB, configValSplit) %>% 
  mutate(
    path = here("results/convert/csv/statFiles/UB", str_c(instance_name, "_", configLB, "_", configValSplit, ".txt")),
    lastNDCpu = map_dbl(path, getLastCpu)) %>% 
  select(-path)
write_csv(dat, here("results/paper_tab_fig/stat_last_nd.csv"))
message("Saved stat_last_nd.csv")
