library(caldr)

source("scripts/read_palms.R")

for (i in c(2,3,4)){
    df_hisse <- hisse_mcmc(palms, fruit_size, sampling_fraction, burnin = 3000, n = 10000, thinnin = 10, num_hidden_states = i)
    fpath <- paste0("output/mcmc_hisse", i, ".csv")
    write.table(df_hisse, file = fpath, sep = ",", row.names = FALSE)
}

