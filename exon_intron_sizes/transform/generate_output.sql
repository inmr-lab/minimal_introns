SELECT A."Gene name",
      A."Chromosome/scaffold name",
      CASE WHEN A."Strand direction" = '+' THEN 'Fwd' ELSE 'Rev' END AS "Strand direction",
      A."Transcript",
      A."Intron/Exon",
      A."Intron/Exon number",
      A."Start (bp)",
      A."End (bp)",
      A."Length"
 FROM data_introns A
JOIN longest_transcript B
 ON A."Gene name" = B."Gene name"
 AND A."Chromosome/scaffold name" = B."Chromosome/scaffold name"
 AND A."Transcript" = B."Transcript"
 AND A."Dup counter" = B."Dup counter";

SELECT A."Gene name",
      A."Chromosome/scaffold name",
      CASE WHEN A."Strand direction" = '+' THEN 'Fwd' ELSE 'Rev' END AS "Strand direction",
      A."Transcript",
      A."Intron/Exon",
      A."Intron/Exon number",
      A."Start (bp)",
      A."End (bp)",
      A."Length"
 FROM data_exons A
JOIN longest_transcript B
 ON A."Gene name" = B."Gene name"
 AND A."Chromosome/scaffold name" = B."Chromosome/scaffold name"
 AND A."Transcript" = B."Transcript"
 AND A."Dup counter" = B."Dup counter";