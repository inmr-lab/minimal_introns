library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

rm(list = ls())

fly_introns <- read.csv(file = "/Users/himanshujoshi/Documents/Westmead/exon_intron_sizes/results/fly_introns.tsv", sep = "\t", header = TRUE)
fly_introns['Species'] <- "Fly"

human_introns <- read.csv(file = "/Users/himanshujoshi/Documents/Westmead/exon_intron_sizes/results/human_introns.tsv", sep = "\t", header = TRUE)
human_introns['Species'] <- "Human"

worm_introns <- read.csv(file = "/Users/himanshujoshi/Documents/Westmead/exon_intron_sizes/results/worm_introns.tsv", sep = "\t", header = TRUE)
worm_introns['Species'] <- "Worm"

zebrafish_introns <- read.csv(file = "/Users/himanshujoshi/Documents/Westmead/exon_intron_sizes/results/zebrafish_introns.tsv", sep = "\t", header = TRUE)
zebrafish_introns['Species'] <- "Zebrafish"


# Introns less than 37 bp length excluded
fly_introns <- fly_introns[fly_introns$Length>=20,]
worm_introns <- worm_introns[worm_introns$Length>=20,]
zebrafish_introns <- zebrafish_introns[zebrafish_introns$Length>=37,]
human_introns <- human_introns[human_introns$Length>=37,]

introns = rbind(fly_introns, worm_introns, human_introns, zebrafish_introns)

fly_introns_freq <- count(fly_introns, Length)
names(fly_introns_freq)[2] <- "Freq"
fly_introns_freq['Species'] <- "Fly"
fly_introns_freq['Freq %'] <- fly_introns_freq$Freq / sum(fly_introns_freq$Freq)

human_introns_freq <- count(human_introns, Length)
names(human_introns_freq)[2] <- "Freq"
human_introns_freq['Species'] <- "Human"
human_introns_freq['Freq %'] <- human_introns_freq$Freq / sum(human_introns_freq$Freq)

worm_introns_freq <- count(worm_introns, Length)
names(worm_introns_freq)[2] <- "Freq"
worm_introns_freq['Species'] <- "Worm"
worm_introns_freq['Freq %'] <- worm_introns_freq$Freq / sum(worm_introns_freq$Freq)

zebrafish_introns_freq <- count(zebrafish_introns, Length)
names(zebrafish_introns_freq)[2] <- "Freq"
zebrafish_introns_freq['Species'] <- "Zebrafish"
zebrafish_introns_freq['Freq %'] <- zebrafish_introns_freq$Freq / sum(zebrafish_introns_freq$Freq)

introns_freq = rbind(fly_introns_freq, worm_introns_freq, human_introns_freq, zebrafish_introns_freq)

# Frequency plot (base 10)
freqplot_log10 <- ggplot(data = introns_freq) +
  geom_line(aes(x = log(Length,10), y = `Freq %`, colour = Species), size = 1) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(breaks = seq(0,6,1), 
                     labels = sprintf("%s", formatC(10^seq(0,6,1), format = "d", big.mark = ","))) +
  labs(x = expression("Intron length (bp)"~log[10]), y = "Percentage of introns") +
  theme(legend.position = "bottom") +
  annotation_logticks(base = 10, sides = "b", scaled = TRUE, linetype = 1)

ggsave(filename = "/Users/himanshujoshi/Dropbox/Westmead/Papers/Minimal introns/Images/Percentage of introns across species (base 10).png", 
       width = 7,
       height = 6,
       dpi = 100,
       plot = freqplot_log10,
       device = "png")

freqplot_log10_zoomed_in <- ggplot(data = introns_freq) +
  geom_line(aes(x = log(Length,10), y = `Freq %`, colour = Species), size = 1) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(breaks = seq(0,6,1), 
                     labels = sprintf("%s", formatC(10^seq(0,6,1), format = "d", big.mark = ",")),
                     limits = c(log(40,10),log(130,10))) +
  labs(x = expression("Intron length (bp)"~log[10]), y = "Percentage of introns") +
  theme(legend.position = "bottom") +
  annotation_logticks(base = 10, sides = "b", scaled = TRUE, linetype = 1)

ggsave(filename = "/Users/himanshujoshi/Dropbox/Westmead/Papers/Minimal introns/Images/Percentage of introns across species (base 10) 40 to 130 bp.png", 
       width = 7,
       height = 6,
       dpi = 100,
       plot = freqplot_log10_zoomed_in,
       device = "png")

# Violin plot
introns_violin_plot <- ggplot(introns, aes(Species, log(Length, 10))) +
  geom_violin(aes(colour = Species, fill = Species)) +
  scale_x_discrete(limits = c("Worm","Fly","Zebrafish","Human")) +
  scale_y_continuous(breaks = seq(0,6,1), 
                     labels = sprintf("%s", formatC(10^seq(0,6,1), format = "d", big.mark = ","))) +
  labs(y = expression("Intron length (bp)"~log[10])) +
  theme(legend.position="none") +
  annotation_logticks(base = 10, sides = "l", scaled = TRUE, linetype = 1)

ggsave(filename = "/Users/himanshujoshi/Dropbox/Westmead/Papers/Minimal introns/Images/Violin plot introns length across species (base 10).png", 
       width = 7,
       height = 6,
       dpi = 100,
       plot = introns_violin_plot,
       device = "png")
