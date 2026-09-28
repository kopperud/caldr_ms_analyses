library(caldr)

source("scripts/read_palms.R")

MAX_NUM_CLASSES = 8

for (i in 2:MAX_NUM_CLASSES){
    df_caldr <- caldr_mcmc(palms, fruit_size, sampling_fraction, burnin = 3000, n = 10000, thinning = 10, num_lambda_discretization = i, num_mu_discretization = 1)
    out_name <- paste0("output/mcmc_palms_mu_1_lambda_", i, ".csv")
    write.table(df_caldr, file = out_name, sep = ",")
}


