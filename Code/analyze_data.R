## Loading data and code
load('../Results/cleaned_data.RData')
source('analysis_helper_functions.R')

## Loading packages
library('xtable')
library('doParallel')
library('foreach')

## Setting global variables
n_permutations <- 250
lower_limit <- 0
upper_limit <- 1000
take_mean <- TRUE
log_transform <- FALSE

RNGkind("L'Ecuyer-CMRG")
registerDoParallel(cores=20)

################################################################################
## Overall ACE estimates
################################################################################

set.seed(1)
res <- analyze_all_outcomes(dat_list = dat_red_list, n_permutations = n_permutations)
get_latex_row(res)

################################################################################
## Subgroup analysis by cutoff year
################################################################################

# 2010
set.seed(1)
res_before_2010 <- analyze_all_outcomes(dat_list = dat_red_list_before_2010, n_permutations = n_permutations)
res_after_2010 <- analyze_all_outcomes(dat_list = dat_red_list_after_2010, n_permutations = n_permutations)
dif_2010 <- get_all_deltas(res_before_2010, res_after_2010)

get_latex_row(res_before_2010)
get_latex_row(res_after_2010)
get_latex_row(dif_2010)

# 2011
set.seed(1)
res_before_2011 <- analyze_all_outcomes(dat_list = dat_red_list_before_2011, n_permutations = n_permutations)
res_after_2011 <- analyze_all_outcomes(dat_list = dat_red_list_after_2011, n_permutations = n_permutations)
dif_2011 <- get_all_deltas(res_before_2011, res_after_2011)

get_latex_row(res_before_2011)
get_latex_row(res_after_2011)
get_latex_row(dif_2011)

# 2012
set.seed(1)
res_before_2012 <- analyze_all_outcomes(dat_list = dat_red_list_before_2012, n_permutations = n_permutations)
res_after_2012 <- analyze_all_outcomes(dat_list = dat_red_list_after_2012, n_permutations = n_permutations)
dif_2012 <- get_all_deltas(res_before_2012, res_after_2012)

get_latex_row(res_before_2012)
get_latex_row(res_after_2012)
get_latex_row(dif_2012)

# 2013
set.seed(1)
res_before_2013 <- analyze_all_outcomes(dat_list = dat_red_list_before_2013, n_permutations = n_permutations)
res_after_2013 <- analyze_all_outcomes(dat_list = dat_red_list_after_2013, n_permutations = n_permutations)
dif_2013 <- get_all_deltas(res_before_2013, res_after_2013)

get_latex_row(res_before_2013)
get_latex_row(res_after_2013)
get_latex_row(dif_2013)


################################################################################
## Subgroup analysis by exposure
################################################################################

set.seed(1)
res_low_exposure <- analyze_all_outcomes(dat_list = dat_red_list_low_exposure, n_permutations = n_permutations)
res_high_exposure <- analyze_all_outcomes(dat_list = dat_red_list_high_exposure, n_permutations = n_permutations)
dif_exposure <- get_all_deltas(res_low_exposure, res_high_exposure)

get_latex_row(res_low_exposure)
get_latex_row(res_high_exposure)
get_latex_row(dif_exposure)

################################################################################
## Subgroup analysis by income
################################################################################

set.seed(1)
res_low_income <- analyze_all_outcomes(dat_list = dat_red_list_lincome, n_permutations = n_permutations)
res_high_income <- analyze_all_outcomes(dat_list = dat_red_list_hincome, n_permutations = n_permutations)
dif_income <- get_all_deltas(res_low_income, res_high_income)

get_latex_row(res_low_income)
get_latex_row(res_high_income)
get_latex_row(dif_income)

save.image(file = '../Results/results_primary.RData')
