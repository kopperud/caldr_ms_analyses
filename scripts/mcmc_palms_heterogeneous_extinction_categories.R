#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(caldr)

source("scripts/read_palms.R")

NUM_CLASSES <- as.numeric(args[1])

analysis <- caldr_mcmc(palms, fruit_size, sampling_fraction, burnin = 3000, n = 10000, thinning = 10, num_lambda_discretization = NUM_CLASSES, num_mu_discretization = NUM_CLASSES)
out_name <- paste0("output/mcmc_palms_mu_", NUM_CLASSES, "_lambda_", NUM_CLASSES, ".rda")
#write.table(df_caldr, file = out_name, sep = ",")
save(analysis, file = out_name)


