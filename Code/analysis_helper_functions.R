# Get point estimate of ACE
get_point_ests <- function(dat_list, outcome_name, resample = FALSE){
  n_mun <- length(dat_list)
  outcome_under_exp <- rep(NA, n_mun)
  outcome_under_noexp <- rep(NA, n_mun)
  for (i in 1:n_mun){
    temp <- dat_list[[i]]
    if (resample){
      temp[, outcome_name] <- temp[sample(1:nrow(temp), replace = TRUE), outcome_name]
    }
    if (log_transform){
      fit <- lm(temp[, outcome_name] ~ temp$log_exposure)
      outcome_under_exp[i] <- round_to_within_range(sum(coef(fit) * c(1, -3.693)))
      outcome_under_noexp[i] <- round_to_within_range(sum(coef(fit) * c(1, -5.174)))
    } else {
      fit <- lm(temp[, outcome_name] ~ temp$exposure)
      outcome_under_exp[i] <- round_to_within_range(sum(coef(fit) * c(1, 0.0222)))
      outcome_under_noexp[i] <- round_to_within_range(sum(coef(fit) * c(1, 0.0035)))
    }
  }
  if (take_mean){
    ace <- mean(outcome_under_exp) - mean(outcome_under_noexp)
  } else {
    ace <- median(outcome_under_exp) - median(outcome_under_noexp)
  }
  return(list(ace = ace, 
              outcome_under_exp = outcome_under_exp, 
              outcome_under_noexp = outcome_under_noexp))
}

# Get point estimates of ACE under permuted data sets
get_perm_ests <- function(dat_list, outcome_name, n_permutations = 99){
  res <- foreach(i = 1:n_permutations) %dopar%{
    get_point_ests(dat_list = dat_list, outcome_name = outcome_name, resample = TRUE)$ace
  }
  return(unlist(res))
}

# Get two-sided p-value
get_pvalue <- function(test_stat, perm_stats, n_permutations){
  return(min(1, 2 * min((1 + sum(perm_stats <= test_stat)) / (1 + n_permutations), 
                        (1 + sum(perm_stats >= test_stat)) / (1 + n_permutations))))
}

round_to_within_range <- function(x){
  if (x > upper_limit){
    return(upper_limit)
  } else if (x < lower_limit){
    return(lower_limit)
  } else {
    return(x)
  }
}

get_est_and_pval <- function(dat_list, outcome_name, n_permutations){
  est <- get_point_ests(dat_list = dat_list, outcome_name = outcome_name)
  if (n_permutations > 0){
    perm_stats <- get_perm_ests(dat_list = dat_list, outcome_name = outcome_name, n_permutations = n_permutations)
    pval <- get_pvalue(test_stat = est$ace, perm_stats = perm_stats, n_permutations = n_permutations)
  } else {
    pval <- NULL
  }
  return(list(est = est$ace, pval = pval, outcome_under_exp = est$outcome_under_exp, 
              outcome_under_noexp = est$outcome_under_noexp, perm_stats = perm_stats))
}

get_delta_and_pvalue <- function(group1, group2){
  delta <- group2$est - group1$est
  n_permutations <- length(group2$perm_stats)
  delta_perm <- group2$perm_stats - group1$perm_stats
  pval <- get_pvalue(test_stat = delta, perm_stats = delta_perm, n_permutations = n_permutations)
  return(list(est = delta, pval = pval))
}

analyze_all_outcomes <- function(dat_list, n_permutations){
  res1 <- get_est_and_pval(dat_list = dat_list, outcome_name = 'NU_MEDIA_CN', n_permutations = n_permutations)
  res2 <- get_est_and_pval(dat_list = dat_list, outcome_name = 'NU_MEDIA_CH', n_permutations = n_permutations)
  res3 <- get_est_and_pval(dat_list = dat_list, outcome_name = 'NU_MEDIA_LP', n_permutations = n_permutations)
  res4 <- get_est_and_pval(dat_list = dat_list, outcome_name = 'NU_MEDIA_MT', n_permutations = n_permutations)
  res5 <- get_est_and_pval(dat_list = dat_list, outcome_name = 'NU_MEDIA_RED', n_permutations = n_permutations)
  return(list(res1 = res1, res2 = res2, res3 = res3, res4 = res4, res5 = res5))
}

get_all_deltas <- function(res_group1, res_group2){
  return(
    list(res1 = get_delta_and_pvalue(res_group1$res1, res_group2$res1), 
         res2 = get_delta_and_pvalue(res_group1$res2, res_group2$res2), 
         res3 = get_delta_and_pvalue(res_group1$res3, res_group2$res3), 
         res4 = get_delta_and_pvalue(res_group1$res4, res_group2$res4), 
         res5 = get_delta_and_pvalue(res_group1$res5, res_group2$res5))
  )
}

get_latex_row <- function(res){
  get_entry <- function(res){
    paste0(format(round(res$est, 2), nsmall = 2), 
           ' (', format(round(res$pval, 2), nsmall = 2), ')')
  }
  return(xtable(cbind(get_entry(res$res1), get_entry(res$res2), get_entry(res$res3), 
                      get_entry(res$res4), get_entry(res$res5)), digits = 2))
}