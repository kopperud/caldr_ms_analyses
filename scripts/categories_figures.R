library(phytools)
library(ggtree)
library(ggplot2)
library(coda)
library(ape)
library(vroom)
library(dplyr)
library(legendry)

setwd("~/projects/caldr_ms_analyses")

df_hisse <- read.csv("output/mcmc_hisse2.csv")

#fpaths <- Sys.glob("output/*.csv")
fpaths <- c(
  "output/mcmc_hisse2.csv",
  "output/mcmc_hisse3.csv",
  "output/mcmc_hisse4.csv",
  #"output/mcmc_palms_mu_6_lambda_6.csv"
)
for (i in seq_along(fpaths)){
  print(i)
  df <- read.csv(fpaths[i])
  write.table(df, file = fpaths[i], row.names = FALSE, sep = ",")
}

dfs_hisse <- list()
for (i in 2:4){
  fpath <- paste0("output/mcmc_hisse",i,".csv")
  this_df <- vroom(fpath, delim = ",", col_select = starts_with("log_likelihood")) |>
    mutate("categories" = i,
           "group" = "hisse") 
  dfs_hisse[[i-1]] <- this_df
}
df_hisse <- bind_rows(dfs_hisse)


dfs_extinction_simple <- list()
for (i in 2:8){
  fpath <- paste0("output/mcmc_palms_mu_1_lambda_",i,".csv")
  df <- vroom(fpath, col_select = starts_with("log")) |>
    mutate("categories" = i,
           "group" = "caldr simple")
  dfs_extinction_simple[[i-1]] <- df
}
df_extinction_simple <- bind_rows(dfs_extinction_simple)

dfs_caldr <- list()
for (i in 2:7){
  fpath <- paste0("output/mcmc_palms_mu_", i, "_lambda_",i,".csv")
  df <- vroom(fpath, col_select = starts_with("log")) |>
    mutate("categories" = i,
           "group" = "caldr varying mu")
  dfs_caldr[[i-1]] <- df
}
df_caldr <- bind_rows(dfs_caldr)

plot_df <- bind_rows(df_hisse, df_extinction_simple, df_caldr)

plot_df$group_category <- paste0(plot_df$group, "_", plot_df$categories)
plot_df$delta_log_likelihood <- plot_df$log_likelihood - max(plot_df$log_likelihood)
plot_df$delta_log_posterior <- plot_df$log_posterior - max(plot_df$log_posterior)


range_key <- key_range_manual(
  start = c(1,8,14), end = c(7,13,16),
name = c(
  "caldr (6 parameters)",
  "caldr (7 pars.)",
  "hisse (10-14 p.)")
  #"hisse (10 p.)")
)

p_cats <- ggplot(plot_df, aes(x = group_category, y = delta_log_likelihood, fill = group)) +
    geom_violin() +
    #stat_summary(fun = "mean",  geom = "crossbar", width = 0.6, colour = "gray") +
    theme_classic() +
    labs(x = "number of rate categories", y = "delta log P(tree,X|parameters)") +
    guides(
      x = compose_stack(
        "axis_base",
        primitive_bracket(range_key, "curvy")
        )
    ) +
    scale_x_discrete(labels = c(2*(2:8), 2*(2:7)^2, 4,6,8))
p_cats
#ggsave("figures/caldr_vs_hisse234.png", units = "mm", height = 70, width = 150)
#ggsave("figures/caldr_vs_hisse2.pdf", units = "mm", height = 70, width = 150)


14*2 - 2*max(dfs_hisse[[3]]$log_likelihood)
12*2 - 2*max(dfs_hisse[[2]]$log_likelihood)
10*2 - 2*max(dfs_hisse[[1]]$log_likelihood)

7*2 - 2*max(dfs_caldr[[6]]$log_likelihood)

plot_df |>
  group_by(categories, group)
