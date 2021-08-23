# GEGravity

GEGravity is an R packge that replicates the functionality of the ge_gravity Stata package for streamlined use within the R ecosystem. In summary, ge_gravity solves for general equilibrium effects of changes in trade policies using a one sector Armington-CES trade model. It uses a simple fixed point algorithm that allows for fast computation. This approach, together with the implementations in R and Stata, makes it ideal for bootstrapping confidence intervals for general equilibrium simulations based on prior gravity estimates of FTAs or other similar variables. Examples of references that conduct general equilibrium analysis based on FTA estimates in this way include Egger, Larch, Staub, & Winkelmann (2011), Anderson & Yotov (2016), and Baier, Yotov, & Zylkin (2019). Yotov, Piermartini, Monteiro, & Larch (2016) provide a detailed survey and introduction to the topic.

For more details on the options and functionalities included with this command, a more in-depth discussion can be found in the R documentation file and vignettes found in this repository. For Stata users, the `Stata` folder contains an example .do file and help file along with the current version of the Stata package. 

# GEGravity implementation in R

## Dependencies

Required:  
- R (>= 2.10)  

Suggested:  
- alpaca (>= 0.3.1)   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (to compute fixed effect GLM)  
- rmarkdown (>= 2.1)  &nbsp; (to view the vignettes)  
- data.table (>= 1.14)       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (to facilitate bootstrapping)  
- devtools (>=1.13.6)  &nbsp;&nbsp;&nbsp;(to install from github)  
- knitr                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(to knit the vignettes)  

## How To Use
We are currently in the process of submitting the package to CRAN. In the meantime, one can use the package in a streamlined manner by installing from github. Use `devtools::install_github("VKudlay/GEGravity")`.

Alternatively, either download the `GEGravity/` folder or clone the repository and navigate to it, then open `GEGravity.Rprog` in RStudio.

To see example of execution, theory, etc, open the .Rmd files in the `Vignettes/` subfolder from within RStudio. To load in package data, run `data(...)`, i.e. `data(TradeData0014)`. The .Rmd files can either be run interactively from within R or they can be knit into easily readable html files using the knitr package.

## Funding
Funding for this R package was provided by the Department for Digital, Culture, Media and Sport, United Kingdom.

# Original Stata Package
The `Stata/` folder contains the current version of the ge_gravity Stata package along with a help file and worked examples.

To install from within in Stata, enter `ssc install ge_gravity, replace`.

# Suggested citation

If you are using either of these packages in your research, please cite

- Baier, Scott L., Yoto V. Yotov, and Thomas Zylkin. "On the widely
differing effects of free trade agreements: Lessons from twenty years
of trade integration". Journal of International Economics
116 (2019): 206-226.

The algorithm used in these packages was specifically written for the
exercises performed in this paper. Section 6 of the paper provides
a more detailed description of the underlying model and its connection
to the literature.


# References
Anderson, J. E. & Yotov, Y. V. (2016), “Terms of trade and global efficiency effects of free trade agreements, 1990–2002”, Journal of International Economics 99, 279–298.

Baier, S. L., Yotov, Y. V., & Zylkin, T. (2019), “On the widely differing effects of free trade agreements: Lessons from twenty years of trade integration”, Journal of International Economics 116, 206–226.

Egger, P., Larch, M., Staub, K. E., & Winkelmann, R. (2011), “The Trade Effects of Endogenous Preferential Trade Agreements”, American Economic Journal: Economic Policy 3(3), 113–143.

Yotov, Y. V., Piermartini, R., Monteiro, J.-A., & Larch, M. (2016), An Advanced Guide to Trade Policy Analysis:  The Structural Gravity Model, World Trade Organization, Geneva.
