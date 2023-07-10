# Multi-objective combinatorial optimization problems

Instances and results for the paper N. Forget, S. L. Gadegaard, and L. R. Nielsen, "Linear relaxation based branch-and-bound for multi-objective integer programming with warm-starting", [Optimization Online](http://www.optimization-online.org/DB_HTML/2021/08/8531.html), 2021. The working paper was published as N. Forget, S. L. Gadegaard, and L. R. Nielsen, "Warm-starting lower bound set computations for branch-and-bound algorithms for multi objective integer linear programs", European Journal of Operational Research, vol. 302, no. 3, pp. 909–924, 2022, doi: [10.1016/j.ejor.2022.01.047](https://doi.org/10.1016/j.ejor.2022.01.047). 

The paper consider instances for tri-objective combinatorial (binary) optimization problems. New instances are generated in problem classes considered are PPP (Production Planning) and Uncapacitated Facility Location (UFLP). 

These instances are also used in paper N. Forget, S. L. Gadegaard, K. Klamroth, L. R. Nielsen, and A. Przybylski, "Branch-and-bound and objective branching with three or more objectives", Computers and Operations Research, vol. 148, p. 106012, 2022, doi: [10.1016/j.cor.2022.106012](https://doi.org/10.1016/j.cor.2022.106012).

## Test instances

Instances are named `Forget21_[problemClass]_[n]_[p]_[rangeOfCosts]_[costGenerationMethod]_[constaintId]_[id].fgt` where 

   - `problemClass` is either PPP (Production Planning Problem), or UFLP (Uncapacitated Facility
      Location Problem).
   - `n` is the size of the problem. 
   - `p` is the number of objectives.
   - `rangeOfCosts`: Objective coefficient range e.g. 1-1000.
   - `costGenerationMethod`: Either random or spheredown. For further details see 
      the documentation function `genSample` in the R package 
      [gMOIP](https://CRAN.R-project.org/package=gMOIP).
   - `constaintId`: Same id if constraints are the same.
   - `id`: Instance id running within the constraint id.

### Fgt format description 

All instance files are given in raw format (a text file). An example for a Production Planning Problem is:

```
15 10 5

minsum minsum minsum minsum minsum

53 67 4 55 100 6 13 86 6 65 1352 1723 318 1236 2166
87 36 3 51 70 69 13 87 90 52 1325 1689 1984 422 2024
98 75 75 68 87 64 94 86 96 42 332 723 565 891 88
76 85 76 45 45 2 34 98 13 18 1831 777 1873 868 221
95 33 39 31 65 23 91 19 48 47 939 1189 2083 2255 1015

1 0 0 0 0 -1 0 0 0 0 0 0 0 0 0
0 1 0 0 0 1 -1 0 0 0 0 0 0 0 0
0 0 1 0 0 0 1 -1 0 0 0 0 0 0 0
0 0 0 1 0 0 0 1 -1 0 0 0 0 0 0
0 0 0 0 1 0 0 0 1 -1 0 0 0 0 0
1 0 0 0 0 0 0 0 0 0 -141 0 0 0 0
0 1 0 0 0 0 0 0 0 0 0 -141 0 0 0
0 0 1 0 0 0 0 0 0 0 0 0 -141 0 0
0 0 0 1 0 0 0 0 0 0 0 0 0 -141 0
0 0 0 0 1 0 0 0 0 0 0 0 0 0 -141

2 50
2 24
2 5
2 48
2 14
1 0
1 0
1 0
1 0
1 0

0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
141 141 141 141 141 141 141 141 141 141 1 1 1 1 1

```

The general format is defined as: 

```
n m p

objectiveTypes

objectiveCoefficientMatrix

constraintMatrix

rHSMatrix

lbVector
ubVector
```

where:

   - `n` is the number of variables.
   - `m` is the number of constrains.
   - `p` is the number of objectives.
   - `objectiveTypes` is the nature of the objectives to be optimized. An identifier should be 
   added for each objective, and it should be done in the same order as in the objective matrix. 
   Four types are supported:
      	* maxsum: maximise a sum objective function
      	* minsum: minimise a sum objective function
   - `objectiveCoefficientMatrix` is a p x n matrix defining the coefficients of the objective functions
   - `constraintMatrix` is a m x n matrix defining the coefficients of the constraints
   - `rHSMatrix` is a m x 2 matrix defining the right-hand side of the constraints. 
   For each constraint, two numbers are required:
      * The second number is the actual value of the right-hand side of the constraint
      * The first number is an identifier that is used to define the sign of the constraint. 
      Three identifiers can be used: 0 for >= constraints, 1 for <= constraints and 2 for = constraints.
   - `lbVector` is a vector of size n containing the lower bound of each variable.
   - `ubVector` is a vector of size n containing the upper bound of each variable.

## Results

Restults are given in the `results` folder using the [json
format](https://github.com/MCDMSociety/MOrepo/blob/master/contribute.md) (see Step 3). 




