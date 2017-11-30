rm(list = ls())

fly_introns <- read.csv(file = "results/fly_introns.tsv", sep = "\t", header = TRUE)
fly_introns['Species'] <- "Fly"

human_introns <- read.csv(file = "results/human_introns.tsv", sep = "\t", header = TRUE)
human_introns['Species'] <- "Human"

worm_introns <- read.csv(file = "results/worm_introns.tsv", sep = "\t", header = TRUE)
worm_introns['Species'] <- "Worm"

zebrafish_introns <- read.csv(file = "results/zebrafish_introns.tsv", sep = "\t", header = TRUE)
zebrafish_introns['Species'] <- "Zebrafish"

# Introns less than 37 bp length excluded
fly_introns <- fly_introns[fly_introns$Length>=20,]
worm_introns <- worm_introns[worm_introns$Length>=20,]
zebrafish_introns <- zebrafish_introns[zebrafish_introns$Length>=37,]
human_introns <- human_introns[human_introns$Length>=37,]

# 10th, 25th, 50th, 75th, 90th percentile

quantile_range <- c(0.01, 0.1, 0.25, 0.50, 0.75, 0.90, 0.95, 0.99)

quantile(fly_introns$Length, quantile_range)

quantile(worm_introns$Length, quantile_range)

quantile(zebrafish_introns$Length, quantile_range)

quantile(human_introns$Length, quantile_range)

# % of human introns with length < 70 nt

(nrow(human_introns[human_introns$Length<70,])/nrow(human_introns)) * 100
