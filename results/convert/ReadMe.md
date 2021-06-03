This folder contains the raw output from the algorithm (subfolder csv), 
which is converted into json result files using an R script.

Columns in the csv file are: (all cpu times are expressed in seconds)

  - `instance`: name of the file containing the instance solved.
  - `p`: number of objectives.
  - `n`: number of variables.
  - `configLB`: lower bound set computation algorithm used. There are two configurations:
        * `LP`: linear relaxation computed from scratch at each node.
        * `WLP`: linear relaxation warm-started using the linear relaxation from the father node.
  - `configNodeSel`: node selection strategy. There are two configurations:
        * `breadth`: breadth first strategy.
        * `depth`: depth first strategy.
  - `configOB`: objective branching strategy. There are three configurations:
        * `noOB`: no objective branching.
        * `coneOB`: cone objective branching.
        * `fullOB`: full objective branching.
  - `configValSplit`: strategy for computing bounds on variables when branching. There are two configurations:
        * `med`: the median value of the variable among the vertices of the lower bound set is used.
        * `mofv`: the most often fractional value among the vertices of the lower bound set is chosen.
  - `solved`: 1 is the instance is solved within the time limit, 0 otherwise.
  - `YN`: number of non-dominated points.
  - `cpuTotal`: total cpu time.
  - `nbLpSolved`: total number of single-objective linear programs solved.
  - `cpuInitialization`: cpu time spent in initializing lower bound sets.
  - `cpuCplex`: cpu time spent in solving linear programs using CPLEX.
  - `cpuUpdatePolyhedron`: cpu time spent in updating polyhedra
  - `nbNodes`: total number of nodes explored.
  - `minDepth`: minimal depth of a leaf node.
  - `maxDepth`: maximal depth of a leaf node.
  - `avgDepth`: average depth of a leaf node.
  - `nbFathomedInfeas`: number of nodes fathomed by infeasibility.
  - `nbFathomedOptimality`: number of nodes fathomed by optimality.
  - `nbFathomedDominance`: number of nodes fathomed by dominance.
  - `cpuDominanceTest`: cpu time spent in performing dominance tests with the lower bound set
  - `cpuUbUpdate`: cpu time spent in updating the upper bound set and the set of local upper bounds.
  - `cpuLbComputation`: cpu time spent in computing lower bound sets.
  - `cpuComputeOb`: cpu time spent in computing objective branching.
  - `cpuVarSel`: cpu time spent in selecting the variables and the bounds to branch on.
  - `cpuNodeSel`: cpu time spent in chosing the next node to explore.