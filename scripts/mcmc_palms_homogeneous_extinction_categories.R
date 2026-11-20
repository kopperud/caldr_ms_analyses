#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(caldr)

source("scripts/read_palms.R")

NUM_CLASSES <- as.numeric(args[1])

set.seed(123)

## the priors
mu_small <- Uniform(0.0, 2.0)
mu_large <- Uniform(0.0, 2.0)
x1 <- Uniform(0.0, 2.0)
x2 <- Uniform(0.0, 2.0)

lambda_small <- x1 + mu_small
lambda_large <- x2 + mu_large

tau <- Uniform(0.0, 0.1)
alpha <- Uniform(0.0, 0.1)
beta <- Constant(0.0)
standard_deviation <- Constant(0.587)

moves <- list(
  Scale(mu_small),
  Scale(mu_large),
  Scale(x1),
  Scale(x2),
  Scale(tau),
  Scale(alpha)
)


tr <- CharacterAndLineageDivRates(c(lambda_large, lambda_small), c(mu_large, mu_small),
                                  tau, alpha, beta,
                                  standard_deviation, 1.0, fruit_size, palms,
                                  num_lambda_discretization = NUM_CLASSES,
                                  num_mu_discretization = 1)

model <- Model(
  mu_small,
  mu_large,
  x1,
  x2,
  lambda_small,
  lambda_large,
  tau,
  alpha,
  tr)

monitors <- list(
  StochasticMapMonitor(tr),
  BranchRateMonitor(tr)
  )

#log prob clamped was -5135 with mu > lambda parameters
df <- mcmc(model, moves, burnin = 3001, n_iter = 10000, thin = 10, monitors = monitors)

## add the deterministic parameters
df$lambda_small <- df$mu_small + df$x1
df$lambda_large <- df$mu_large + df$x2

out_name_table <- paste0("output/mcmc_palms_mu_1_lambda_", NUM_CLASSES, ".rda")
save(df, file = out_name_table)

mlp <- marginal_log_probability(model, moves, burnin = 1000, n_iter = 1000, thin = 10)

out_name <- paste0("output/mcmc_palms_mu_1_lambda_", NUM_CLASSES, "_marginal_log_prob.rda")
save(mlp, file = out_name)

#analysis <- caldr_mcmc(palms, fruit_size, sampling_fraction, burnin = 3000, n = 10000, thinning = 10, num_lambda_discretization = NUM_CLASSES, num_mu_discretization = 1, estimate_marginal_likelihood = TRUE)
#out_name <- paste0("output/mcmc_palms_mu_1_lambda_", NUM_CLASSES, ".rda")
#save(analysis, file = out_name)


