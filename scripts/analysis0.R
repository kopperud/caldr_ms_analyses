library(ape)
library(caldr)
library(phytools)

read.extended.newick <- function(txt){
  con <- textConnection(txt)
  tr <- treeio::read.beast.newick(con)
  
  return(tr)
}

trees <- read.nexus("data/Phylogeny_Con_Checklist.nex")
tree <- trees[[5]]

palm_data <- read.table("data/PalmTraits_1.0.txt", header = TRUE, sep = "\t")

palm_data$FruitSizeCategorical[palm_data$FruitSizeCategorical == ""] <- "?"
fruit_size <- palm_data$FruitSizeCategorical
names(fruit_size) <- palm_data$SpecName
names(fruit_size) <- gsub(" ", "_", names(fruit_size))

## remove the extra data
extra_species <- names(fruit_size)[which(!names(fruit_size) %in% tree$tip.label)]
fruit_size <- fruit_size[!names(fruit_size) %in% extra_species]

## add missing data for the other species in the tree
missing_species <- tree$tip.label[which(!tree$tip.label %in% names(fruit_size))]

new_data <- sapply(seq_along(missing_species), function(x) "?")
names(new_data) <- missing_species

fruit_size <- c(fruit_size, new_data)

sampling_fraction <- length(tree$tip.label) / 2600

df_caldr <- caldr_mcmc(tree, fruit_size, sampling_fraction, burnin = 4000, n = 15000, thinning = 10, num_lambda_discretization = 6, num_mu_discretization = 1)

write.table(df_caldr, file = "output/mcmc_palms_num_mu_1.csv", sep = ",")

