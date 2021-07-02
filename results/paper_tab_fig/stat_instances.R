## Generate input statistics 
# remotes::install_github("relund/gMOIP")
library(fs)
library(tidyverse)
library(gMOIP)
# set  wdir is the project dir
try(setwd(rstudioapi::getActiveProject()))

# Statistics for a single instance
getStat <- function(path) {
  print(path)
  v <- read_file(path) %>% str_split("\\n\\n") 
  v <- v[[1]]
  v[4] <- str_c(v[4], "\n")
  coeff <- t(read_delim(v[3], " ", col_names = F)) %>% as_tibble(.name_repair = "unique")
  ranges <- t(read_delim(v[6], " ", col_names = F)) %>% as_tibble(.name_repair = "unique") %>% filter(...2 > 1)
  set <- addNDSet(coeff)
  dat <- tibble(read_delim(str_c(v[1], "\n"), delim = " ", col_names = c("n", "m", "p"))) %>% 
    mutate(coef_nd_pct = nrow(set)/n, const_mat_non_zeros = length(which(read_delim(v[4], " ", col_names = F)>0))/(n*m),
           range_coeff_min = min(coeff), range_coeff_max = max(coeff), 
           n_binary = n-nrow(ranges), n_integer = nrow(ranges), 
           range_int_min = min(ranges$...1), range_int_max = max(ranges$...2))
  return(dat)
}
getStat(path = "../MOrepo-Kirlik14/instances/fgt/KP/3obj/Kirlik14-KP_p-3_n-100_ins-1.fgt")
getStat(path = "instances/raw/PPP/3obj/Forget21-PPP_10_3_1-100_1-100_1-2500_1_50_random_1_1.raw")

paths <- c(dir_ls("instances/fgt", recurse = T, type = "file"), 
           dir_ls("../MOrepo-Kirlik14/instances/fgt", recurse = T, type = "file"))
dat <- tibble(path = paths) %>%
  mutate(filename = path_file(path), 
         instance_name = str_remove(str_remove(filename, ".raw"), ".fgt"), 
         class = str_replace(instance_name, "^.*?-(.*?)_(.*)", "\\1")) 
dat <- dat %>% #head(dat) %>% 
  mutate(map_dfr(path, getStat)) 
# View(dat)
dat <- dat %>% mutate(range_int_max = if_else(range_int_min == Inf, NA_real_, range_int_max),
                      range_int_min = if_else(range_int_min == Inf, NA_real_, range_int_min))
write_csv(dat, "results/paper_tab_fig/instances.csv")
