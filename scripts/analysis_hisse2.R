library(caldr)

source("scripts/read_palms.R")

df_hisse <- hisse_mcmc(palms, fruit_size, sampling_fraction, burnin = 3000, n = 10000, thinnin = 10)

write.table(df_hisse, file = "output/mcmc_hisse2.csv", sep = ",")
