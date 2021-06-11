
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
#Generate some results at times 0, 9 and 10 from the start of the epidemic and
#store the results from 9 and 10
deaths <- simulate(model, t = c(0,9,10))$D[c(2,3)]
##Calculate the current state of the model
model <- calculateCurrentState(model, deaths)
#> Warning in .local(epiModel, ...): This currently assumes a constant rate of change for the
#>                     last time step so it will only be close to the true
#>                     result.
#print the current state
print(currentState(model))
#> $D
#> [1] 11.83369
#> 
#> $R
#> [1] 37.43873
#> 
#> $I
#> [1] 18.64987
#> 
#> $S
#> [1] 32.07772

##Limitations
#Currently S and I are estimated with an approximation to an ODE so do not equal
#what the model would generate exactly
print(simulate(model, t=c(0,10))$S[2])
#> [1] 32.19971
print(simulate(model, t=c(0,10))$I[2])
#> [1] 18.52787

#If there is no change in deaths (as might be seen when using real data) then
#I will be estimated to be 0
model <- calculateCurrentState(model, c(10,10))
#> Warning in .local(epiModel, ...): This currently assumes a constant rate of change for the
#>                     last time step so it will only be close to the true
#>                     result.
print(currentState(model))
#> $D
#> [1] 10
#> 
#> $R
#> [1] 31.63741
#> 
#> $I
#> [1] 0
#> 
#> $S
#> [1] 58.36259
```
