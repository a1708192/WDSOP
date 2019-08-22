# Optimization_WDSs_CMAES-GS
Covariance Matrix Adaptation Greedy Search Applied to Water Distribution System Optimization
The Matlab hybrid framework consists of three componenets including 

1. Covariance Matrix Adaptation Evolution Strategy (CMA-ES):  
Applied for minimizing the cost of the pipes.
The recommended version of CMA-ES : https://www.lri.fr/~hansen/cmaes.m

2. UpWard Greedy Search:
Applied for handling the violations of constraints

3. DownWard Greedy Search:
Applied for reducing the extra cost of pipes.
-----------------------------------------------------------------------

Please pay attention to some essential points :

a. main.m  is the main file for running this framework, 
but before running, please check the below code line in your Matlab prompt 


mex - setup


if the below error message is shown: please follow the recommended steps:

Error using mex
No supported compiler or SDK was found. You can install the freely available MinGW-w64 C/C++ compiler; 
see Install MinGW-w64 Compiler.
For more options, visit http://www.mathworks.com/support/compilers/R2017a/.

The links can be helpful for dealing with the error.

https://au.mathworks.com/help/matlab/matlab_external/changing-default-compiler.html

https://mingw-w64.org/doku.php/download
======================================================================
Functions :

set_Network_name      :     initializing the network name 
set_dim               :     initializing the diameters of the applied pipes
set_fitfun            :     setting the cost function name 
Def_Iter              :     used for an iterative network like DNYTP and 50NYTP
Def_Constraint        :     determining the Nodal pressure head constraints
set_Bestfmin          :     estimating of the near-optimum network cost design 
initialize_xstart     :     initializing the first population
Def_TolFun            :     defining the tolerance of the fitness function as a stopping criterian
set_Max_Eval          :     initializing the maximum evaluation number
cmaes                 :     CMAES function
Finding_best          :     recording the best continuous, discrete and possible pipe configurations     
Downward_Greedy_Search:     applying the strategy of downward greedy search 
Upward_Greedy_Search  :     applying the strategy of upward greedy search
rep                   :     counting the same pipe configurations
Dim_Correction        :     converting the continuous designs to the nearest possible ones
=======================================================================
The structure of recorded results:
Pipe:                The main structure
UGSflag:             a flag (0/1) shows the upward greedy search is run or not                  
DGSflag:             a flag (0/1) shows the downward greedy search is run or not
Continuous_Sols      a matrix of all continuous pipe designs (design number * network pipe number)
Continuous_Cost      an array of the continuous pipe costs 
Continuous_Violation an array of total violations of all continuous pipes
Rounded_Sols         a matrix of all possible pipe designs (design number * network pipe number)
Rounded_Cost         an array of the possible pipe costs 
Rounded_Violation    an array of total violations of all possible pipes
UGS_Sols             a matrix of all possible pipe designs after applying the upward greedy search (design number * network pipe number)
UGS_Cost             an array of the possible pipe costs after applying the upward greedy search
XminU                a variable shows the best pipe design of upward greedy search
FminU                a variable shows the best pipe cost of upward greedy search
XminC                a variable shows the best continuous pipe design 
FminC                a variable shows the best continuous pipe cost 
XminD                a variable shows the best discrete pipe design 
FminD                a variable shows the best discrete pipe cost
UGS_Sols             a matrix of all possible pipe designs after applying the downward greedy search (design number * network pipe number)
UGS_Cost             an array of the possible pipe costs after applying the downward greedy search             
