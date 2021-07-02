# Main file for generating results for the paper

library(here)

#### Generate instances.csv with statistics for all instances ####
# source(here("results/paper_tab_fig/stat_instances.R"))

#### Generate lb_set.csv with statistics about the lower bound sets ####
source(here("results/paper_tab_fig/stat_lb_set.R"))

#### Validate that ND sets the same for all runs ####
source(here("results/paper_tab_fig/validate_nd_sets.R"))

#### Generate figures, tables and comments for the paper (transferred to Overleaf via DB) ####
# rmarkdown::render(here("results/paper_tab_fig/fig_tab.Rmd"))
# # Clean
# try(dir_delete(here("results/paper_tab_fig/fig_tab_cache")), silent = T)
# try(dir_delete(here("results/paper_tab_fig/fig_tab_files")), silent = T)
