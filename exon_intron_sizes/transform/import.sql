-- DROP TABLE data_genes_transcripts;
-- DROP TABLE data_introns;
-- DROP TABLE data_exons;

/************************************************************************************************
 TRANSCRIPTS
 ************************************************************************************************/

ALTER TABLE data_genes_transcripts RENAME COLUMN "#name" TO "Transcript";
ALTER TABLE data_genes_transcripts RENAME COLUMN chrom TO "Chromosome/scaffold name";
ALTER TABLE data_genes_transcripts RENAME COLUMN txstart TO "Start (bp)";
ALTER TABLE data_genes_transcripts RENAME COLUMN txend TO "End (bp)";
ALTER TABLE data_genes_transcripts RENAME COLUMN name2 TO "Gene name";

ALTER TABLE data_genes_transcripts ADD "Length" INT NULL;
ALTER TABLE data_genes_transcripts ADD "Dup counter" INT NULL;

/* Update starting position to base 1 */
UPDATE data_genes_transcripts SET "Start (bp)" = "Start (bp)" + 1;

WITH INFO AS
(
  SELECT "Chromosome/scaffold name",
         "Transcript",
         ROW_NUMBER() OVER (PARTITION BY "Chromosome/scaffold name", "Transcript" ORDER BY "Start (bp)") AS counter
     FROM data_genes_transcripts
)
UPDATE data_genes_transcripts
   SET "Dup counter" = INFO.counter
  FROM INFO
 WHERE data_genes_transcripts."Chromosome/scaffold name" = INFO."Chromosome/scaffold name"
   AND data_genes_transcripts."Transcript" = INFO."Transcript";

UPDATE data_genes_transcripts
   SET "Length" = ("End (bp)" - "Start (bp)") + 1;

CREATE INDEX data_genes_transcripts_idx_1 ON data_genes_transcripts ("Chromosome/scaffold name");
CREATE INDEX data_genes_transcripts_idx_2 ON data_genes_transcripts ("Start (bp)");
CREATE INDEX data_genes_transcripts_idx_3 ON data_genes_transcripts ("End (bp)");
CREATE INDEX data_genes_transcripts_idx_4 ON data_genes_transcripts ("Transcript");

/************************************************************************************************
 INTRONS DATA
 ************************************************************************************************/

ALTER TABLE data_introns RENAME COLUMN c1 TO "Chromosome/scaffold name";
ALTER TABLE data_introns RENAME COLUMN c2 TO "Start (bp)";
ALTER TABLE data_introns RENAME COLUMN c3 TO "End (bp)";
ALTER TABLE data_introns RENAME COLUMN c4 TO "Annotation";
ALTER TABLE data_introns RENAME COLUMN c5 TO "Ignore";
ALTER TABLE data_introns RENAME COLUMN c6 TO "Strand direction";

ALTER TABLE data_introns ADD "Transcript" TEXT NULL;
ALTER TABLE data_introns ADD "Intron/Exon" TEXT NULL;
ALTER TABLE data_introns ADD "Intron/Exon number temp" INT NULL;
ALTER TABLE data_introns ADD "Intron/Exon number" INT NULL;
ALTER TABLE data_introns ADD "Gene name" TEXT NULL;
ALTER TABLE data_introns ADD "Length" INT NULL;
ALTER TABLE data_introns ADD "Dup counter" INT NULL;

/* Update starting position to base 1 */
UPDATE data_introns SET "Start (bp)" = "Start (bp)" + 1;

UPDATE data_introns SET "Length" = ("End (bp)" - "Start (bp)") + 1;

UPDATE data_introns
   SET "Transcript" = (regexp_split_to_array("Annotation", E'_'))[1] || '_' || (regexp_split_to_array("Annotation", E'_'))[2],
       "Intron/Exon" = 'Intron',
       "Intron/Exon number temp" = CAST((regexp_split_to_array("Annotation", E'_'))[4] AS INTEGER);

-- Add indexes
CREATE INDEX data_introns_idx_1 ON data_introns ("Chromosome/scaffold name");
CREATE INDEX data_introns_idx_2 ON data_introns ("Start (bp)");
CREATE INDEX data_introns_idx_3 ON data_introns ("End (bp)");
CREATE INDEX data_introns_idx_4 ON data_introns ("Transcript");

UPDATE data_introns
   SET "Gene name" = A."Gene name",
       "Dup counter" = A."Dup counter"
  FROM data_genes_transcripts A
 WHERE data_introns."Chromosome/scaffold name" = A."Chromosome/scaffold name"
   AND data_introns."Start (bp)" >= A."Start (bp)"
   AND data_introns."End (bp)" <= A."End (bp)"
   AND data_introns."Transcript" = A."Transcript";

UPDATE data_introns
   SET "Intron/Exon number" = "Intron/Exon number temp" + 1
 WHERE "Strand direction" = '+';

WITH intron_numbering AS
(
    SELECT
      "Chromosome/scaffold name",
      "Gene name",
      "Transcript",
      "Dup counter",
      "Intron/Exon number temp",
      ROW_NUMBER()
      OVER (
        PARTITION BY "Chromosome/scaffold name", "Gene name", "Transcript", "Dup counter"
        ORDER BY "Intron/Exon number temp" DESC ) AS new
    FROM data_introns
)
UPDATE data_introns
   SET "Intron/Exon number" = A.new
  FROM intron_numbering A
 WHERE data_introns."Gene name" = A."Gene name"
   AND data_introns."Chromosome/scaffold name" = A."Chromosome/scaffold name"
   AND data_introns."Transcript" = A."Transcript"
   AND data_introns."Dup counter" = A."Dup counter"
   AND data_introns."Intron/Exon number temp" = A."Intron/Exon number temp"
   AND data_introns."Strand direction" = '-';

/************************************************************************************************
 EXONS DATA
 ************************************************************************************************/

ALTER TABLE data_exons RENAME COLUMN c1 TO "Chromosome/scaffold name";
ALTER TABLE data_exons RENAME COLUMN c2 TO "Start (bp)";
ALTER TABLE data_exons RENAME COLUMN c3 TO "End (bp)";
ALTER TABLE data_exons RENAME COLUMN c4 TO "Annotation";
ALTER TABLE data_exons RENAME COLUMN c5 TO "Ignore";
ALTER TABLE data_exons RENAME COLUMN c6 TO "Strand direction";

ALTER TABLE data_exons ADD "Transcript" TEXT NULL;
ALTER TABLE data_exons ADD "Intron/Exon" TEXT NULL;
ALTER TABLE data_exons ADD "Intron/Exon number" INT NULL;
ALTER TABLE data_exons ADD "Intron/Exon number temp" INT NULL;
ALTER TABLE data_exons ADD "Gene name" TEXT NULL;
ALTER TABLE data_exons ADD "Length" INT NULL;
ALTER TABLE data_exons ADD "Dup counter" INT NULL;

/* Update starting position to base 1 */
UPDATE data_exons SET "Start (bp)" = "Start (bp)" + 1;

UPDATE data_exons SET "Length" = ("End (bp)" - "Start (bp)") + 1;

UPDATE data_exons
   SET "Transcript" = (regexp_split_to_array("Annotation", E'_'))[1] || '_' || (regexp_split_to_array("Annotation", E'_'))[2],
       "Intron/Exon" = 'Exon',
       "Intron/Exon number temp" = CAST((regexp_split_to_array("Annotation", E'_'))[4] AS INTEGER);

-- Add indexes
CREATE INDEX data_exons_idx_1 ON data_exons ("Chromosome/scaffold name");
CREATE INDEX data_exons_idx_2 ON data_exons ("Start (bp)");
CREATE INDEX data_exons_idx_3 ON data_exons ("End (bp)");
CREATE INDEX data_exons_idx_4 ON data_genes_transcripts ("Transcript");

UPDATE data_exons
   SET "Gene name" = A."Gene name",
       "Dup counter" = A."Dup counter"
  FROM data_genes_transcripts A
 WHERE data_exons."Chromosome/scaffold name" = A."Chromosome/scaffold name"
   AND data_exons."Start (bp)" >= A."Start (bp)"
   AND data_exons."End (bp)" <= A."End (bp)"
   AND data_exons."Transcript" = A."Transcript";

UPDATE data_exons
   SET "Intron/Exon number" = "Intron/Exon number temp" + 1
 WHERE "Strand direction" = '+';

WITH exon_numbering AS
(
    SELECT
      "Chromosome/scaffold name",
      "Gene name",
      "Transcript",
      "Dup counter",
      "Intron/Exon number temp",
      ROW_NUMBER()
      OVER (
        PARTITION BY "Chromosome/scaffold name", "Gene name", "Transcript", "Dup counter"
        ORDER BY "Intron/Exon number temp" DESC ) AS new
    FROM data_exons
)
UPDATE data_exons
   SET "Intron/Exon number" = A.new
  FROM exon_numbering A
 WHERE data_exons."Gene name" = A."Gene name"
   AND data_exons."Chromosome/scaffold name" = A."Chromosome/scaffold name"
   AND data_exons."Transcript" = A."Transcript"
   AND data_exons."Dup counter" = A."Dup counter"
   AND data_exons."Intron/Exon number temp" = A."Intron/Exon number temp"
   AND data_exons."Strand direction" = '-';

/************************************************************************************************
 TRANSCRIPTS - Add Exons information
 ************************************************************************************************/

ALTER TABLE data_genes_transcripts ADD "Exon count" INT NULL;

WITH INFO AS
(
    SELECT
      "Chromosome/scaffold name",
      "Gene name",
      "Transcript",
      "Dup counter",
      COUNT(*) AS exon_count
    FROM data_exons
    GROUP BY 1, 2, 3, 4
)
UPDATE data_genes_transcripts
   SET "Exon count" = INFO.exon_count
  FROM INFO
 WHERE data_genes_transcripts."Chromosome/scaffold name" = INFO."Chromosome/scaffold name"
   AND data_genes_transcripts."Gene name" = INFO."Gene name"
   AND data_genes_transcripts."Transcript" = INFO."Transcript"
   AND data_genes_transcripts."Dup counter" = INFO."Dup counter";

/************************************************************************************************
 Longest transcript per gene
 ************************************************************************************************/

CREATE TABLE longest_transcript AS
  (
    SELECT
      "Chromosome/scaffold name",
      "Gene name",
      "Transcript",
      "Dup counter",
      "Length",
      "Exon count",
      row_number()
      OVER (
        PARTITION BY "Chromosome/scaffold name", "Gene name"
        ORDER BY "Length" DESC, "Exon count" DESC ) AS rank
    FROM data_genes_transcripts
    WHERE "Transcript" NOT LIKE 'NR%'
  );

DELETE FROM longest_transcript WHERE rank > 1;