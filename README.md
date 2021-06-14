
<!-- README.md is generated from README.Rmd. Please edit that file -->

# excalibur

<!-- badges: start -->

[![R-CMD-check](https://github.com/mrc-ide/excalibur/actions/workflows/R-CMD-check.yaml/badge.svg?branch=main)](https://github.com/mrc-ide/excalibur/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/mrc-ide/excalibur/actions/workflows/test-coverage.yaml/badge.svg?branch=main)](https://github.com/mrc-ide/excalibur/actions/workflows/test-coverage.yaml)
<!-- badges: end -->

**Ex**pediating **Calib**rations in yo**ur** epidemic models

The goal of excalibur is to explore the necessity of calibrations on ODE
epidemic models that are intended to predict future epidemic
trajectories.

-   :warning: This package is work in progress

## Installation

You can install the released version of excalibur from [its Github
repository](https://github.com/mrc-ide/excalibur) with:

``` r
devtools::install_github("mrc-ide/excalibur")
```

## Example

-   :warning: This package is WIP so this will change

This is a basic example which shows you how to solve a common problem:

``` r
library(excalibur)
##Simulate some deaths to demonstrate calculating the current state of the model
#Set up an SIR model
model <- setSIR(N = 100, Beta = 1, Gamma = 1/3, ProbOfDeath = 0.1, I0 = 1)
#Generate some results at time 10 from the start of the epidemic
deaths <- simulate(model, t = 10)$D
##Calculate the current state of the model
model <- calculateCurrentState(model, deaths)
#> Warning in .local(epiModel, ...): Functionality for time-varying Beta is WIP.
#print the current state
print(currentState(model))
#> $D
#> [1] 11.83369
#> 
#> $R
#> [1] 37.43873
#> 
#> $I
#> [1] 18.52785
#> 
#> $S
#> [1] 32.19973

##Limitations
#Currently I is calculated by subtracting from N, hence will not be exact due to
#rounding in storage etc.
print(simulate(model, t=10))
#>    t        S        I        R        D beta
#> 2 10 32.19971 18.52787 37.43873 11.83369    1
```
