-- file: kx_csv2foreign_tables.sql
-- Standard procedures to use CSV as a commom SQL table, to link or populate your database.
--   (this script is a cache, "kx_" prefixed file, generated by software from datapackage.json)
--
-- 1. cd /tmp
-- 2. git clone https://github.com/UnB-CIDACS/observatorio-jats.git
-- 3. PGPASSWORD=postgres psql -h localhost -U postgres obsjats < /tmp/observatorio-jats/src/csv2foreign_tables.sql
-- 4. ... populate your database using the tables tmpcsv_* defined below...
-- 5. (opcional) DROP SERVER csv_files CASCADE;
--

CREATE EXTENSION file_fdw;
CREATE SERVER csv_files FOREIGN DATA WRAPPER file_fdw;

--
-- Each standard CSV file and its fields definition
-- Check data model and migration scripts for more details about final use in the system.
--

/**
 * List of all articles (~4560000) in the PMC repo.
 *
 * cd /tmp; wget ftp://ftp.ncbi.nlm.nih.gov/pub/pmc/PMC-ids.csv.gz
 * gunzip PMC-ids.csv.gz
 */
CREATE FOREIGN TABLE tmpcsv_pmc_ids (
	Journal_Title text,
	ISSN text,
	eISSN text,
	Year int,
	Volume text,
	Issue text,
	Page text,
	DOI text,
	PMCID text,
	PMID bigint,
	Manuscript_Id text,
	Release_Date text
)   SERVER csv_files OPTIONS ( 
     filename '/tmp/PMC-ids.csv', 
       format 'csv', 
       header 'true'
);

CREATE VIEW tmpcsv_state_codes_current AS
  SELECT * 
  FROM tmpcsv_state_codes
  WHERE extinction IS NULL
  ORDER BY subdivision
;
