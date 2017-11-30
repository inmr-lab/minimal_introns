library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

rm(list = ls())

fly_exons <- read.csv(file = "/Users/himanshujoshi/Documents/Westmead/exon_intron_sizes/results/fly_exons.tsv", sep = "\t", header = TRUE)
fly_exons['Species'] <- "Fly"

human_exons <- read.csv(file = "/Users/himanshujoshi/Documents/Westmead/exon_intron_sizes/results/human_exons.tsv", sep = "\t", header = TRUE)
human_exons['Species'] <- "Human"

worm_exons <- read.csv(file = "/Users/himanshujoshi/Documents/Westmead/exon_intron_sizes/results/worm_exons.tsv", sep = "\t", header = TRUE)
worm_exons['Species'] <- "Worm"

zebrafish_exons <- read.csv(file = "/Users/himanshujoshi/Documents/Westmead/exon_intron_sizes/results/zebrafish_exons.tsv", sep = "\t", header = TRUE)
zebrafish_exons['Species'] <- "Zebrafish"

exons = rbind(fly_exons, worm_exons, human_exons, zebrafish_exons)

fly_exons_freq <- count(fly_exons, Length)
names(fly_exons_freq)[2] <- "Freq"
fly_exons_freq['Species'] <- "Fly"
fly_exons_freq['Freq %'] <- fly_exons_freq$Freq / sum(fly_exons_freq$Freq)

human_exons_freq <- count(human_exons, Length)
names(human_exons_freq)[2] <- "Freq"
human_exons_freq['Species'] <- "Human"
human_exons_freq['Freq %'] <- human_exons_freq$Freq / sum(human_exons_freq$Freq)

worm_exons_freq <- count(worm_exons, Length)
names(worm_exons_freq)[2] <- "Freq"
worm_exons_freq['Species'] <- "Worm"
worm_exons_freq['Freq %'] <- worm_exons_freq$Freq / sum(worm_exons_freq$Freq)

zebrafish_exons_freq <- count(zebrafish_exons, Length)
names(zebrafish_exons_freq)[2] <- "Freq"
zebrafish_exons_freq['Species'] <- "Zebrafish"
zebrafish_exons_freq['Freq %'] <- zebrafish_exons_freq$Freq / sum(zebrafish_exons_freq$Freq)

exons_freq = rbind(fly_exons_freq, worm_exons_freq, human_exons_freq, zebrafish_exons_freq)

# Frequency plot (base 10)
freqplot_log10 <- ggplot(data = exons_freq) +
  geom_line(aes(x = log(Length,10), y = `Freq %`, colour = Species), size = 1) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(breaks = seq(0,6,1), 
                     labels = sprintf("%s", formatC(10^seq(0,6,1), format = "d", big.mark = ","))) +
  labs(x = expression("Exon length (bp)"~log[10]), y = "Percentage of exons") +
  theme(legend.position = "bottom") +
  annotation_logticks(base = 10, sides = "b", scaled = TRUE, linetype = 1)

#freqplot_log10

ggsave(filename = "/Users/himanshujoshi/Dropbox/Westmead/Papers/Minimal introns/Images/Percentage of exons across species (base 10).png", 
       width = 7,
       height = 6,
       dpi = 100,
       plot = freqplot_log10,
       device = "png")

# Violin plot
exons_violin_plot <- ggplot(exons, aes(Species, log(Length, 10))) +
  geom_violin(aes(colour = Species, fill = Species)) +
  scale_x_discrete(limits = c("Worm","Fly","Zebrafish","Human")) +
  scale_y_continuous(breaks = seq(0,6,1), 
                     labels = sprintf("%s", formatC(10^seq(0,6,1), format = "d", big.mark = ","))) +
  labs(y = expression("Exon length (bp)"~log[10])) +
  theme(legend.position="none") +
  annotation_logticks(base = 10, sides = "l", scaled = TRUE, linetype = 1)

ggsave(filename = "/Users/himanshujoshi/Dropbox/Westmead/Papers/Minimal introns/Images/Violin plot exons length across species (base 10).png", 
       width = 7,
       height = 6,
       dpi = 100,
       plot = exons_violin_plot,
       device = "png")
