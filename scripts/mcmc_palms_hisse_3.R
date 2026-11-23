#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(caldr)

source("scripts/read_palms.R")

NUM_HIDDEN_STATES <- 3

## the priors
mu_small_0 <- Uniform(0.0, 2.0)
mu_small_1 <- Uniform(0.0, 2.0)
mu_small_2 <- Uniform(0.0, 2.0)

netdiv_small_0 <- Uniform(0.0, 2.0)
netdiv_small_1 <- Uniform(0.0, 2.0)
netdiv_small_2 <- Uniform(0.0, 2.0)

lambda_small_0 <- mu_small_0 + netdiv_small_0
lambda_small_1 <- mu_small_1 + netdiv_small_1 + netdiv_small_0
lambda_small_2 <- mu_small_2 + netdiv_small_2 + netdiv_small_0 + netdiv_small_1

mu_large_0 <- Uniform(0.0, 2.0)
mu_large_1 <- Uniform(0.0, 2.0)
mu_large_2 <- Uniform(0.0, 2.0)

netdiv_large_0 <- Uniform(0.0, 2.0)
netdiv_large_1 <- Uniform(0.0, 2.0)
netdiv_large_2 <- Uniform(0.0, 2.0)

lambda_large_0 <- mu_large_0 + netdiv_large_0
lambda_large_1 <- mu_large_1 + netdiv_large_1
lambda_large_2 <- mu_large_2 + netdiv_large_2

tau <- Uniform(0.0, 0.1)
alpha <- Uniform(0.0, 0.1)

# the moves
moves <- list(
  Scale(mu_small_0),
  Scale(mu_small_1),
  Scale(mu_small_2),
  Scale(netdiv_small_0),
  Scale(netdiv_small_1),
  Scale(netdiv_small_2),
  Scale(mu_large_0),
  Scale(mu_large_1),
  Scale(mu_large_2),
  Scale(netdiv_large_0),
  Scale(netdiv_large_1),
  Scale(netdiv_large_2),
  Scale(tau),
  Scale(alpha)
)

# the "observed" random variable
tr <- HiddenStateBirthDeath(c(lambda_large_0, lambda_large_1, lambda_large_2, lambda_small_0, lambda_small_1, lambda_small_2),
                            c(mu_large_0, mu_large_1, mu_large_2, mu_small_0, mu_small_1, mu_small_2),
                            tau,
                            alpha,
                            sampling_fraction,
                            fruit_size,
                            palms,
                            num_hidden_states = NUM_HIDDEN_STATES,
                            num_trait_states = 2)

model <- Model(
  netdiv_large_0, netdiv_large_1, netdiv_large_2, netdiv_small_0, netdiv_small_1, netdiv_small_2,
  mu_large_0, mu_large_1, mu_large_2, mu_small_0, mu_small_1, mu_small_2,
  tau,
  alpha, 
  tr)

#monitors <- list(
  #StochasticMapMonitor(tr),
  #BranchRateMonitor(tr)
  #)

# run the mcmc
df <- caldr::mcmc(model, moves, burnin = 3000, n_iter = 10000, thin = 10)

df$lambda_small_2 <- df$mu_small_2 + df$netdiv_small_2 + df$netdiv_small_1 + netdiv_small_0
df$lambda_small_1 <- df$mu_small_1 + df$netdiv_small_1 + df$netdiv_small_0 
df$lambda_small_0 <- df$mu_small_0 + df$netdiv_small_0 

out_name_table <- paste0("output/mcmc_palms_hisse_", NUM_HIDDEN_STATES, ".rda")
save(df, file = out_name_table)

# calculate marginal log probability
mlp <- marginal_log_probability(model, moves, burnin = 1000, n_iter = 1000, thin = 10, tuning_interval = 100)

out_name <- paste0("output/mcmc_palms_hisse_", NUM_HIDDEN_STATES, "_marginal_log_prob.rda")
save(mlp, file = out_name)
