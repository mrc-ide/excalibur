
<!-- README.md is generated from README.Rmd. Please edit that file -->

# excalibur

<!-- badges: start -->

[![R-CMD-check](https://github.com/mrc-ide/excalibur/actions/workflows/R-CMD-check.yaml/badge.svg?branch=main)](https://github.com/mrc-ide/excalibur/actions/workflows/R-CMD-check.yaml)
[![codecov.io](https://codecov.io/github/mrc-ide/excalibur/coverage.svg?branch=main)](https://codecov.io/github/mrc-ide/excalibur?branch=main)
<!-- badges: end -->

**Ex**pediating **Calib**rations in yo**ur** epidemic models

The goal of excalibur is to explore the necessity of calibrations on ODE
epidemic models that are intended to predict future epidemic
trajectories.

-   :warning: This package is work in progress

## Installation

You can install the released version of *excalibur* from [its Github
repository](https://github.com/mrc-ide/excalibur) with:

``` r
devtools::install_github("mrc-ide/excalibur")
```

This package requires *Odin*. *Deriv* and *stringr* need to be installed
if you wish to calculate your own derivatives if using the derivative
approximation method.

## SIRD Model

### Examples

Estimating the current state for a simple SIRD model:

``` r
library(excalibur)
##Simulate some deaths to demonstrate calculating the current state of the model
#Set up an SIRD model
model <- setSIRD(N = 100, Beta = 1, Gamma = 1/3, ProbOfDeath = 0.1, I0 = 1)
#Generate some results at time 10 from the start of the epidemic
time <- 10
deaths <- simulate(model, t = time)$D
##Calculate the current state of the model
model <- calculateCurrentState(model, time, deaths)
#print the current state
print(currentState(model))
#>    t        S        I        R        D
#> 1 10 32.19973 18.52785 37.43873 11.83369

##Limitations
#Currently I is calculated by subtracting from N, hence will not be exact due to
#rounding in storage etc.
print(simulate(model, t=time))
#>    t        S        I        R        D Beta
#> 2 10 32.19971 18.52787 37.43873 11.83369    1
```

Estimating the current state for a simple SIRD model, with time-varying
Beta:

``` r
library(excalibur)
#Set up an SIRD model, with constant values of Beta that change at the times given
model <- setSIRD(N = 100, Beta = c(5,0.1,2), Gamma = 1/3, ProbOfDeath = 0.1, 
                I0 = 1, changeTimes = c(4,6))
#Generate some results, since this is time-varying we need these at the end of
#each of the changeTimes as well as at the current time
time <- 10
deaths <- simulate(model, t = c(4,6,time))$D
##Calculate the current state of the model
model <- calculateCurrentState(model, time, deaths)
#print the current state
print(currentState(model))
#>    t          S        I        R        D
#> 1 10 0.01595129 1.977261 74.46863 23.53816
#for comparison
print(simulate(model, t=time))
#>    t          S        I        R        D Beta
#> 2 10 0.01594839 1.977264 74.46863 23.53816    2
```

### Method

Consider the SIRD model with a known number of deaths *D*(*t*) a
particular time *t*, where *β* is the transmission parameter, *γ* the
rate of recovery, and *α* the rate of death (calculated from the
probability of death). Then the number of people in the recovered
population at time *t* is,

*R*(*t*) = (*D*(*t*) − *D*(0)) × *γ*/*α* + *R*(0).

To simplify, let *D*(*i*) + *R*(*i*) = *DR*(*i*). Then by a similar
argument to that laid out in (Kröger and Schlickeiser 2020), for a
constant value of *β*,

*S*(*t*) = *S*(0) × exp ((*DR*(0) − *DR*(*t*)) × *β*/(*N* × (*α* + *γ*))).

Then expanded to the time-varying *β* scenario,

*S*(*t*) = *S*(0) × exp ((*s**u**m*<sub>*i* = 0</sub><sup>*n*</sup>(*DR*(*t*<sub>*c*, *i*</sub>) − *DR*(*t*<sub>*c*, *i* + 1</sub>)) × *β*<sub>*i*</sub>)/(*N* × (*α* + *γ*)))

where *t*<sub>*c*, *i*</sub> ≤ *t* &lt; *t*<sub>*c*, *i* + 1</sub> means
that *β*(*t*) = *β*<sub>*i*</sub> and *t*<sub>*c*, 0</sub> = 0.

## SEIRD Model

### Examples

Estimating the current state for a simple SEIRD model, with time-varying
Beta:

``` r
library(excalibur)
#Set up an SIRD model, with constant values of Beta that change at the times given
model <- setSEIRD(N = 100, Beta = c(5,0.1,2), Gamma = 1/3, Lambda = 1/2, ProbOfDeath = 0.1, 
                I0 = 1, changeTimes = c(4,6))
#Generate some results, since this is time-varying we need these at the end of
#each of the changeTimes as well as at the current time
time <- 10
deaths <- simulate(model, t = c(4,6,time))$D
##Calculate the current state of the model
model <- calculateCurrentState(model, time, deaths, nderiv = 7)
#print the current state
print(currentState(model))
#>    t        S        E        I        R     D
#> 1 10 4.568455 8.644442 15.67042 54.03668 17.08
#for comparison
print(simulate(model, t=time))
#>    t        S        E        I        R        D Beta
#> 2 10 4.568464 8.270472 16.04444 54.03664 17.07998    2

#if we want to check the optimization we can also plot the derivative
model <- calculateCurrentState(model, time, deaths, nderiv = 7, plotDeriv = TRUE)
```

<img src="man/figures/README-SEIRD_example-1.png" width="100%" />

### Method

This method assumes that the n-th derivative of D is 0 and solves the
resulting equation for I. n is determined by the argument nderiv and the
derivative has been calculated symbolically with the package *Deriv*.
The higher n is the closer this approximation gets to the real solution,
however for certain set of parameters, increase n also flattens the
derivative, making it harder to optimise for I.

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-analyiticalSIR" class="csl-entry">

Kröger, M, and R Schlickeiser. 2020. “Analytical Solution of the
SIR-Model for the Temporal Evolution of Epidemics. Part A
Time-Independent Reproduction Factor.” *Journal of Physics A
Mathematical and Theoretical* 53 (December).
<https://doi.org/10.1088/abc65d>.

</div>

</div>
