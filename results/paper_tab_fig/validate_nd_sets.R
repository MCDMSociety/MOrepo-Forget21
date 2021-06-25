## Validate if ND sets the same for all solved instances

library(fs)
library(here)
library(tidyverse)

getNDSet <- function(path) {
  dat <- read_csv(path, col_types = cols())
  return(dat)
}

dat <- read_csv(here("results", "convert", "csv", "resultsMain.csv")) %>% 
  mutate(instance_name = str_remove(instance, "....$"),
         instance = instance_name,
         class = str_replace(instance_name, "^.*?-(.*?)_(.*)", "\\1"),
         alg_config = str_c("\\", configLB, "-\\", toupper(configValSplit))) %>% 
  filter(solved == 1) %>% #filter(instance_name == "Forget21-PPP_10_3_1-100_1-100_1-2500_1_50_random_10_10") %>% 
  group_by(instance_name) %>% 
  filter(n() > 1) %>% 
  nest() %>%
  ungroup() %>% 
  # slice_head(n=2) %>% 
  mutate(validated = map_lgl(data,  function(df) {
    for (i in 1:nrow(df)) {
      tmp <- getNDSet(here("results/convert/csv/statFiles/UB", str_c(df$instance[i], "_", df$configLB[i], "_", df$configValSplit[i], ".txt")))
      if (i == 1) {
        nDSet = tmp
        next
      }
      if (!setequal(nDSet[,1:(ncol(nDSet)-1)], tmp[,1:(ncol(tmp)-1)])) {
        warning("Different nondominated sets for instance ", df$instance[i])
        return(FALSE)
      }
    }
    return(TRUE)
  }))
which(!dat$validated)
warnings()
