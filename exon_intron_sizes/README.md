# Exon Intron sizes
Scripts to nicely summarise exon and intron sizes for Human, Fly, Zebrafish &amp; Worm (based on UCSC data)

## Source
https://www.genome.ucsc.edu/cgi-bin/hgTables
* Mammal - Human - Feb. 2009 (GRCh37/hg19)
* Fly - D. melanogaster - Aug. 2014 (BDGP Release 6 + ISO MT/dm6)
* Worm - C. elegans - Feb 2013 (WBCel235/ce11)
* Zembrafish - Sep. 2014 (GRCz10/danRer10)


## Steps
1. Load data from /ucsc_genes folder into Postgresql (recommended loading into separate schemas)
   1. Load the ***\<organism>_genes_transcripts***. Name the table *data_genes_transcripts* table
   2. Load the ***\<organism>_introns*** into *data_introns table*
   3. Load the ***\<organism>_exons*** into *data_exons table*
2. For each schema, run scripts in the /transform folder
   1. ***import.sql*** - Transforms the data so that you have human friendly column names, 1 based positioning (instead of BED's 0 based), Assign exon/intron numbers, handle "duplicate" scenarios and lastly identify the longest transcript for each gene
   2. ***generate_output.sql*** - Script used to extract list of Exons/Introns (The output of this script has been stored in /results folder
3. Load exon_intron_sizes.Rproj. This provides the means to generate required visuals
   1. ***visuals_exons.R*** - Generates violin plots contrasting exon sizes distribution between the 4 organisms of interest
   2. ***visuals_introns.R*** - Generates violin plots contrasting intron sizes distribution between the 4 organisms of interest
   3. ***intron_quantiles.R*** - Calculate intron size quantiles for the 4 organisms of interest
