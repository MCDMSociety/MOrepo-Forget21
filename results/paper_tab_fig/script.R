## Script for generating tables and figures for the paper

library(tidyverse)
#library(knitr)

# read from csv file
datMain <- read.csv("results/convert/csv/resultsMain.csv")

# add a column for problem class
datMain <- datMain %>%
  group_by(instance, configLB, configNodeSel, configOB, configValSplit) %>%
  mutate(pb = strsplit( strsplit(instance, "_")[[1]][1] , "-" )[[1]][2])

# a version where max cpu is truncated, to have nice performance profiles
datMainT <- datMain %>%
  group_by(instance, configLB, configNodeSel, configOB, configValSplit) %>%
  mutate(cpuTotal = min(cpuTotal,3600))

# performance profile
datMainT %>%
  group_by(pb, p, configLB) %>%
  arrange(cpuTotal) %>%
  mutate(count = row_number()) %>% 
  ggplot() +
  geom_step( aes(x = cpuTotal, y = count,color = configValSplit, linetype = configLB) ) +
  facet_wrap(vars(pb, p), scales = "free") +
  xlab("CPU time (in seconds)") + ylab("number of instances solved")

# tables variable selection LP and WLP
datMainT %>% # LP
  filter(pb != "UFLP", configLB == "LP") %>%
  select(instance, configValSplit, solved, cpuTotal, pb, p) %>%
  group_by(instance) %>%
  pivot_wider(names_from = configValSplit, values_from = c(solved, cpuTotal)) %>%
  ungroup() %>%
  filter(solved_med == 1, solved_mofv == 1) %>%
  group_by(pb, p) %>%
  summarise(avgSpeedup = mean(cpuTotal_med) / mean(cpuTotal_mofv)) %>%
  ungroup() %>%
  pivot_wider(names_from = p, values_from = avgSpeedup)

datMainT %>% # WLP
  ungroup() %>%
  filter(pb != "UFLP", configLB == "WLP") %>%
  select(instance, configValSplit, solved, cpuTotal, pb, p) %>%
  group_by(instance) %>%
  pivot_wider(names_from = configValSplit, values_from = c(solved, cpuTotal)) %>%
  ungroup() %>%
  filter(solved_med == 1, solved_mofv == 1) %>%
  group_by(pb, p) %>%
  summarise(avgSpeedup = mean(cpuTotal_med) / mean(cpuTotal_mofv)) %>%
  ungroup() %>%
  pivot_wider(names_from = p, values_from = avgSpeedup)

# tables for LP vs WLP
tb1 <- datMainT %>% # used as a basis for the next three tables
  ungroup() %>%
  filter(pb == "UFLP" | configValSplit == "med") %>%
  select(instance, configLB, solved, cpuTotal, nbLpSolved, nbNodes, pb, p) %>%
  group_by(instance) %>%
  pivot_wider(names_from = configLB, values_from = c(solved, cpuTotal, nbLpSolved, nbNodes))

tb1 %>% # avg speed-up
  ungroup() %>%
  filter(solved_LP == 1, solved_WLP == 1) %>%
  group_by(pb, p) %>%
  summarise(avgSpeedup = mean(cpuTotal_LP) / mean(cpuTotal_WLP)) %>%
  ungroup() %>%
  pivot_wider(names_from = p, values_from = avgSpeedup)

tb1 %>% # calls single-objective LP solver
  ungroup() %>%
  filter(solved_LP == 1, solved_WLP == 1) %>%
  group_by(pb, p) %>%
  summarise(avgSpeedup = mean(nbLpSolved_LP) / mean(nbLpSolved_WLP)) %>%
  ungroup() %>%
  pivot_wider(names_from = p, values_from = avgSpeedup)

tb1 %>% # number of nodes explored
  ungroup() %>%
  filter(solved_LP == 0, solved_WLP == 0) %>%
  group_by(pb, p) %>%
  summarise(avgTreeSize = mean(nbNodes_WLP) / mean(nbNodes_LP)) %>%
  ungroup() %>%
  pivot_wider(names_from = p, values_from = avgTreeSize)

# cpu time spent in B&B
datMain %>% 
  filter(configValSplit == "med" || pb == "UFLP") %>%
  mutate(pctLB = 100 * cpuLbComputation / cpuTotal , pctUB = 100 * cpuUbUpdate / cpuTotal , pctDomiTest = 100 * cpuDominanceTest / cpuTotal , pctNodeSel = 100 * cpuNodeSel / cpuTotal , pctVarSel = 100 * cpuVarSel / cpuTotal , pctOther = 100 - pctLB - pctUB - pctDomiTest - pctNodeSel - pctVarSel) %>%
  group_by(p, configLB, pb) %>% 
  summarise(CPU_LB = mean(pctLB) , CPU_UB = mean(pctUB) , CPU_Dominance_Test = mean(pctDomiTest) , CPU_Other = mean(pctOther) + mean(pctNodeSel) + mean(pctVarSel)) %>%
  pivot_longer(!c(pb,p,configLB) , names_to = "part" , values_to = "pctCpu" ) %>%
  ggplot(aes(x = factor(configLB), y = pctCpu, fill = part)) +
  geom_col(color = "black") +
  geom_text(aes(label = round(pctCpu, 2)), colour="white", size=2.5,
            position = position_stack(vjust = .5)) +
  facet_grid( rows = vars(pb) , cols = vars(p), margins = F, scales = "free") +
  ylab("% of total cpu time") + xlab("configLB")

# cpu time spent in LB computations
datMain %>% 
  filter(configValSplit == "med" || pb == "UFLP") %>%
  mutate(pctCplex = 100 * cpuCplex / cpuLbComputation , pctUpdatePolyhedron = 100 * cpuUpdatePolyhedron / cpuLbComputation , pctInitialization = 100 * cpuInitialization / cpuLbComputation, pctOther = 100 - pctCplex - pctUpdatePolyhedron - pctInitialization) %>%
  group_by(p, pb, configLB) %>% 
  summarise(CPU_Cplex = mean(pctCplex) , CPU_Update_Polyhedron = mean(pctUpdatePolyhedron) , CPU_Initialization = mean(pctInitialization) , CPU_Other = mean(pctOther)) %>%
  pivot_longer(!c(p,pb,configLB) , names_to = "part" , values_to = "pctCpu" ) %>%
  ggplot(aes(x = factor(configLB), y = pctCpu, fill = part)) +
  geom_col(color = "black") +
  geom_text(aes(label = round(pctCpu, 2)), colour="white", size=2.5,
            position = position_stack(vjust = .5)) +
  facet_grid( rows = vars(pb) , cols = vars(p), margins = F, scales = "free") +
  ylab("% of total LB computation time") + xlab("configLB")
