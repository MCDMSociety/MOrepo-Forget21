## Generate statistics for the lower bound sets 

library(fs)
library(here)
library(tidyverse)

getStat <- function(path) {
  dat <- read_csv(path, col_types = cols())
  return(dat)
}
getStat(path = here("results", "convert", "csv", "statFiles", "Depth", "Forget21-PPP_10_3_1-100_1-100_1-2500_1_50_random_10_10_LP_MOFV.txt"))

paths <- dir_ls(here("results/convert/csv/statFiles/Depth"), recurse = T, type = "file")
dat <- tibble(path = paths) %>%
  mutate(filename = path_file(path),
         instance_name = str_replace(filename, "^(.*)_.*?_.*?$", "\\1"),
         n = case_when(
           str_detect(instance_name, "Kirlik") ~ str_replace(instance_name, "^.*n-(.*?)_(.*)", "\\1"),
           TRUE ~ str_replace(instance_name, "^.*?-(.*?)_(.*?)_.*", "\\2")
         ),
         n = as.numeric(n),
         n = if_else(str_detect(instance_name, "UFLP"), n*(n+1), n),
         n = if_else(str_detect(instance_name, "PPP"), n*3, n),
         class = str_replace(instance_name, "^.*?-(.*?)_(.*)", "\\1"),
         configLB = str_replace(filename, "^(.*)_(.*?)_.*?$", "\\2"),
         configValSplit = str_replace(filename, "^(.*)_(.*?)_(.*?).txt$", "\\3"),
         p = as.numeric(str_replace(filename, "^.*?-(.*?)_(.*?)(_|-)(.)_.*$", "\\4")),
        ) 
dat <- dat %>% #slice_head(n=2) %>% 
  filter(configValSplit %in% c("MOFVREVISITED2", "MED2")) %>% 
  mutate(data = map(path, getStat)) %>% 
  unnest(data)
write_csv(dat, here("results/paper_tab_fig/lb_set.csv"))
message("Saved lb_set.csv")
