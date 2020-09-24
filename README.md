# GEGravity
## GEGravity implementation in R

## Purpose:
The purpose of this package is to replicate the functionality of the ge_gravity Stata package for streamlined use within the R ecosystem. For a more in-depth discussion of the purpose, please consider checking out the documentation file and vignettes.

Overall, ge_gravity solves for general equilibrium effects of changes in trade policies using a one sector Armington-CES trade model. It uses a simple fixed point algorithm that allows for fast computation. This approach, together with the implementation in Stata, makes this program ideal for bootstrapping confidence intervals for general equilibrium simulations based on prior gravity estimates of FTAs or other similar variables. Examples of references that conduct general equilibrium analysis based on FTA estimates in this way include Egger, Larch, Staub, & Winkelmann (2011), Anderson & Yotov (2016), and Baier, Yotov, & Zylkin (2019). Yotov, Piermartini, Monteiro, & Larch (2016) provide a detailed survey and introduction to the topic.

## Dependencies
Required:
  R (>= 2.10)
Suggested:
  alpaca (>= 0.3.1)    (to compute fixed effect GLM)
  rmarkdown (>= 2.1)   (to view the vignettes)
  boot (>= 1.3)        (to facilitate bootstrapping)
  knitr                (to knit the vignettes)

## How To Use
We are currently in the process of submitting the package to CRAN. In the meantime, one can use the package in a streamlined manner as follows:
 - Download the `GEGravity/` folder or clone the repository and navigate to it.
 - Open `GEGravity.Rprog` in RStudio.
 - To see example of execution, theory, etc, run browseVignettes("GEGravity")
 - To load in package data, run data(...), i.e. data(TradeData0014)

## Stata Package:
https://kbroman.org/pkg_primer/pages/build.html
