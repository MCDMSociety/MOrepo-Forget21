# Main file for generating results for the paper

library(here)

#### Step 1: Generate instances.csv with statistics for all instances ####
source(here("results/paper_tab_fig/stat_instances.R"))

#### Step 2: Generate lb_set.csv with statistics about the lower bound sets ####
source(here("results/paper_tab_fig/stat_lb_set.R"))

#### Step 3: Find cpu of last ND point ####
source(here("results/paper_tab_fig/stat_last_nd_point.R"))

#### Step 4: Validate that ND sets the same for all runs ####
source(here("results/paper_tab_fig/validate_nd_sets.R"))

#### Step 5: Generate figures, tables and comments for the paper ####
## 1) Open the file results/paper_tab_fig/fig_tab.Rmd and change the path string variable 
##    pathOverLeaf (around line 56) 
## 2) Knit the document or run each chunk
## 3) If no Dropbox sync, copy the files in the folder to OverLeaf
##
## You may also run:
# rmarkdown::render(here("results/paper_tab_fig/fig_tab.Rmd"))
# # Clean
# try(dir_delete(here("results/paper_tab_fig/fig_tab_cache")), silent = T)
# try(dir_delete(here("results/paper_tab_fig/fig_tab_files")), silent = T)
