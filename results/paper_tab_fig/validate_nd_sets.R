## Validate if ND sets the same for all solved instances

library(fs)
library(here)
library(tidyverse)

getNDSet <- function(path, dropLast = T) {
  dat <- read_csv(path, col_types = cols())
  if (dropLast) return(dat[,1:(ncol(dat)-1)]) else return(dat)
}

dat <- bind_rows(
  read_csv(here("results", "convert", "csv", "resultsMain.csv")) %>% 
    mutate(instance_name = str_remove(instance, "....$"),
           instance = instance_name,
           class = str_replace(instance_name, "^.*?-(.*?)_(.*)", "\\1"),
           alg_config = str_c("\\", configLB, "-\\", toupper(configValSplit))),
  read_csv(here("results/convert/csv/resultsOSS.csv"))  %>% 
    mutate(instance_name = str_remove(instance, "...$"),
           instance = instance_name,
           class = str_replace(instance_name, "^.*?-(.*?)_(.*)", "\\1"),
           alg_config = "\\OSS")
)

#dat <- read_csv(here("results", "convert", "csv", "resultsMain.csv")) %>% 
#    mutate(instance_name = str_remove(instance, "....$"),
#           instance = instance_name,
#           class = str_replace(instance_name, "^.*?-(.*?)_(.*)", "\\1"),
#           alg_config = str_c("\\", configLB, "-\\", toupper(configValSplit)))

dat <- dat %>% 
  filter(solved == 1) %>% #filter(instance_name == "Forget21-PPP_11_4_1-100_1-100_1-2500_1_50_random_10_10") %>% 
  select(instance_name, instance, configLB, configValSplit, alg_config) %>% 
  group_by(instance_name) %>% 
  filter(n() > 1) %>% 
  nest() %>%
  ungroup() %>% 
  # slice_head(n=2) %>% 
  mutate(validated = map_lgl(data,  function(df) {
    # print(df)
    for (i in 1:nrow(df)) {
      if (df$alg_config[i] == "\\OSS") {
        fn <- here("results/convert/csv/statFiles/UB", str_c(df$instance[i], "_OSS.txt"))
        tmp <- getNDSet(fn, dropLast = F)
      } else {
        fn <- here("results/convert/csv/statFiles/UB", str_c(df$instance[i], "_", df$configLB[i], "_", df$configValSplit[i], ".txt"))
        tmp <- getNDSet(fn)
      }
      # print(tmp)
      if (i == 1) {
        nDSet = tmp
        next
      }
      if (!setequal(nDSet, tmp)) {
        warning("Different nondominated sets for instance ", df$instance[i])
        return(FALSE)
      }
    }
    return(TRUE)
  }))
which(!dat$validated)
warnings()
message("Validation of ND sets finished")