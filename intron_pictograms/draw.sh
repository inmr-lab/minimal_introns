#!/bin/sh

rm svg/*.svg

for FASTA_FILE_PATH in `ls fasta/*.fasta`
do
    FASTA_FILE=`basename $FASTA_FILE_PATH`
    echo Generating SVG for $FASTA_FILE
    perl draw.pl $FASTA_FILE_PATH > svg/$FASTA_FILE.svg
    svg2png svg/$FASTA_FILE.svg svg/$FASTA_FILE.png
done

echo Finished
