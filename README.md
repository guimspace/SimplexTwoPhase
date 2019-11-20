# Dantzig's Simplex Algorithm
[![License](https://img.shields.io/badge/license-MIT%20License-red.svg)](https://github.com/guimspace/SimplexTwoPhase/blob/master/LICENSE.md)

> A Dantzig's simplex algorithm to solve linear programming problems (LPP) with two-phase method to obtain an initial basic feasible solution.



## About

The code is written in MATLAB language and supports **minization LPP in standard form**:

    Minimize   cx
    subject to Ax = b
                x >= 0

where **c** is a _cost coefficients_ vector, **x** is a vector of _decision variables_, **b** is a (__RHS__) vector of minimal requirements to be satisfied (_demands_), and elements **a_ij** from **A** are _technological coefficients_.


### Example

    A = [
        1 2 1 0;
        -1 1 0 1
    ];
    b = [4; 1];
    c = [-3 1];
    [x z] = simplex_main(A, b, c, false)
    
**Result**

    x =
        4
        0
    
    z =
        -12


## Reference
Bazaraa, Mokhtar S., et al. _Linear Programming and Network Flows_, John Wiley & Sons, New Jersey, 2010.
