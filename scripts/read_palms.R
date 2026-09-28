library(ape)

read.extended.newick <- function(txt){
  con <- textConnection(txt)
  tr <- treeio::read.beast.newick(con)
  
  return(tr)
}

trees <- read.nexus("data/Phylogeny_Con_Checklist.nex")
palms <- trees[[5]]

palm_data <- read.table("data/PalmTraits_1.0.txt", header = TRUE, sep = "\t")

palm_data$FruitSizeCategorical[palm_data$FruitSizeCategorical == ""] <- "?"
fruit_size <- palm_data$FruitSizeCategorical
names(fruit_size) <- palm_data$SpecName
names(fruit_size) <- gsub(" ", "_", names(fruit_size))

## remove the extra data
extra_species <- names(fruit_size)[which(!names(fruit_size) %in% palms$tip.label)]
fruit_size <- fruit_size[!names(fruit_size) %in% extra_species]

## add missing data for the other species in the tree
missing_species <- palms$tip.label[which(!palms$tip.label %in% names(fruit_size))]

new_data <- sapply(seq_along(missing_species), function(x) "?")
names(new_data) <- missing_species

fruit_size <- c(fruit_size, new_data)

sampling_fraction <- length(palms$tip.label) / 2600
