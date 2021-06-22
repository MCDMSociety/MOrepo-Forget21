This folder contains the raw output from the algorithm (subfolder csv), 
which is converted into json result files using an R script.

A csv file (resultsMain.csv) contains general results for each instances. Each row corresponds to one instance solved with one configuration. Columns in the csv file are: (all cpu times are expressed in seconds)

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
  - `cpuLbCopy`: cpu time spent in copying lower bound sets in children nodes
  
  Detailed results are given for each instance and configuration in the statFiles folder. First, in the Depth folder, statistics in function of the depth of the tree can be found. Each file name is in the [instance]_[configLB]_[configValSplit].txt format. Each row corresponds to a specific depth of the tree. The columns in each of these files are:
  
  - `depth`: depth of the tree studied. The root node is at depth 0.
  - `nbNodes`: number of nodes at the given depth.
  - `nbInfeas`: number of nodes fathomed by infeasibility at the given depth.
  - `avgFacet`: average number of facets in the linear relaxation.
  - `avgVertex`: average number of vertices in the linear relaxation. This includes extreme rays too.
  - `minFacet`: minimum number of facets in the linear relaxation. Infeasible nodes are not taken into account.
  - `minVertex`: minimum number of vertices in the linear relaxation. Infeasible nodes are not taken into account. This includes extreme rays too.
  - `maxFacet`: maximum number of facets in the linear relaxation. Infeasible nodes are not taken into account.
  - `maxVertex`: maximum number of vertices in the linear relaxation. Infeasible nodes are not taken into account. This includes extreme rays too.
  - `cpuUpdatePoly`: total cpu time spent in updating polyhedra at this depth. Expressed in seconds.
  - `cpuDepth`: total cpu time spent at the given depth. Expressed in seconds.
  - `avgFeasVtx`: (relevant for WLP only) average number of feasible vertices in the initial polyhedron extracted from the father node.
  - `avgNewFacets`: average number of facets generated when computing the linear relaxation at the given depth.
  - `avgVtxNoRay`: average number of vertices in the linear relaxation. This does not include extreme rays.
  
  Second, in the UB folder, the best upper bound set known is given for each instance and configuration. Each file name is in the [instance]_[configLB]_[configValSplit].txt format. Each row corresponds to a specific feasible point (it is non-dominated for the problem if the corresponding instance and configuration was solved to optimality, cf resultsMain.csv). The columns in each of these files are:
  
  - `obj`k: value of objective k. There is one column per objective, which results in p columns.
  - `cpu`: cpu time (in seconds) at which the point was found.