# Dantzig's Simplex Algorithm
[![License](https://img.shields.io/badge/license-MIT%20License-red.svg)](https://github.com/g117126unicamp/SimplexTwoPhase/blob/master/LICENSE.md)

> A Dantzig's simplex algorithm to solve linear programming problems (LPP) with two-phase method to obtain an initial basic feasible solution.



## About

The code is written in MATLAB language and supports **minization LPP in standard form**:

    Minimize   cx
    subject to Ax = b
                x >= 0

where **c** is a _cost coefficients_ vector, **x** is a vector of _decision variables_, **b** is a (__RHS__) vector of minimal requirements to be satisfied (_demands_), and elements **a_ij** from **A** are _technological coefficients_.



## Reference
Bazaraa, Mokhtar S., et al. _Linear Programming and Network Flows_, John Wiley & Sons, New Jersey, 2010.
