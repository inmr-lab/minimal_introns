  SELECT
    A."Chromosome/scaffold name",
    A."Start (bp)" - 6, /* for bed subtract 1 and then subtract 5 for flanking region */
    A."End (bp)" + 5, /* flanking towards the end */
    A."Transcript" || ',' || A."Gene name" || ',' || A."Intron/Exon number" || ',' || A."Length",
    '0',
    A."Strand direction"
  FROM data_introns A
  JOIN longest_transcript B
    ON A."Gene name" = B."Gene name"
       AND A."Chromosome/scaffold name" = B."Chromosome/scaffold name"
       AND A."Transcript" = B."Transcript"
       AND A."Dup counter" = B."Dup counter"
