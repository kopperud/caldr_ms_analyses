#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(caldr)

source("scripts/read_palms.R")

NUM_CLASSES <- as.numeric(args[1])

analysis <- hisse_mcmc(palms, fruit_size, sampling_fraction, burnin = 3000, n = 10000, thinning = 10, num_hidden_states = NUM_CLASSES, estimate_marginal_likelihood = TRUE)
fpath <- paste0("output/mcmc_hisse", NUM_CLASSES, ".rda")
#write.table(df_hisse, file = fpath, sep = ",", row.names = FALSE)
save(analysis, file = out_name)

