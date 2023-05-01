# Wildfire exposure and academic performance in Brazil

## Summary

This repository contains the code used in the statistical analyses in "Wildfire exposure and academic performance in Brazil: a causal inference approach for spatiotemporal data". The corresponding data are available upon request.

File descriptions:
* `analyze_data.R`: Code used to run the statistical analyses
* `analysis_helper_functions.R`: Code for various helper functions to compute the average causal effect estimates

## How to run the primary analyses and sensitivity analyses
The primary analyses can be performed by running the file `analyze_data.R`. The sensitivity analyses can be performed by running `analyze_data.R` and modifying the following global variables:
* `lower_limit`: Lower bound of the modelled mean SAP values in the municipality-specific regression models
* `upper_limit`: Upper bound of the modelled mean SAP values in the municipality-specific regression models
* `log_transform`: Indicator of whether to perform a log transformation of the wildfire density in the municipality-specific regression models
* `take_mean`: Indicator whether to estimate the average causal effect by taking the sample mean of the municipality-specific estimates. If set to `FALSE`, the sample median is used.

## Additional details

The analyses were run on R version 4.1.0 along with packages `xtable` (1.8-4), `doParallel` (1.0.16), `iterators` (1.0.13) and `foreach` (1.5.1). The analyses took approximately 10 minutes to run when parallelized across 20 CPU cores.

The code in `analyze_data.R` is based on the output of an R script that reads the data and suitably subsets the data. Consequently, it assumes the availability of the object `dat_red_list`, which is a list of data frames containing to the exposure and outcome data in each of the municipalities. Analogously, the following objects correspond to the subgroup analyses:
* `dat_red_list_before_2010` and `dat_red_list_after_2010` correspond to the subgroup analyses based on data prior to 2010 and after 2010, respectively (and similarly for cutoff years 2011, 2012, 2013). 
* `dat_red_list_low_exposure` and `dat_red_list_high_exposure` correspond to the subgroup analyses based on the municipalities' exposure level
* `dat_red_list_lincome` and `dat_red_list_hincome` correspond to the subgroup analyses based on the municipalities' income level
