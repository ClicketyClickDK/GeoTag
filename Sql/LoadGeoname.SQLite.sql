/*
::@(#)NAME
::@(-)  The name of the command or function, followed by a one-line description of what it does.
::@(#)  BuildGeorname.SQLite,sql -- Importing Geonames data into SQLite database
::@(#) 
::@ (#) 
::@(#)DESCRIPTION
::@(-)  A textual description of the functioning of the command or function.
::@(#)  This script will:
::@(#)  - Load data from geonames.org
::@(#)  - Unescape quotes and apostrophs
::@(#)  and finally get a total count of entries
::@(#) 
::@(#)REQUIRES
::@(-)  Dependencies
::@(#)  BuildGeoname.SQLite.cmd
::@(#)
::@(#)REFERENCE
::@(-)  References to inspiration, clips and other documentation
::@(#)  Author:
::@(#)  URL: http://forum.geonames.org/gforum/posts/list/732.page
::@(#)
::@(#)AUTHOR
::@(-)  Who did what
::@(#)  %$AUTHOR%
::*** HISTORY **********************************************************
::SET $VERSION=YYYY-MM-DD&SET $REVISION=hh:mm:ss&SET $COMMENT=Description/init
::SET $VERSION=2016-02-19&SET $REVISION=00:00:00&SET $COMMENT=Initial/ErikBachmann
  SET $VERSION=2016-03-06&SET $REVISION=00:00:00&SET $COMMENT=Unescaping quotes and apostrophs/ErikBachmann
::**********************************************************************
::@(#){COPY}%$VERSION:~0,4% %$Author%
::**********************************************************************
*/

.system TITLE LoadGeoname.SQLlite.sql - 
--SELECT "-- Init";
--.echo on
.log LoadGeoname.SQLite.log
.trace LoadGeoname.SQLite.trc
--.changes on
--.scanstats on
--.timer on

-- Optimize load
PRAGMA cache_size = 400000; 
PRAGMA synchronous = OFF; 
PRAGMA journal_mode = OFF; 
PRAGMA locking_mode = EXCLUSIVE; 
PRAGMA count_changes = OFF; 
PRAGMA temp_store = MEMORY; 
PRAGMA auto_vacuum = NONE;
PRAGMA count_changes = OFF;
PRAGMA automatic_index = OFF;

/*-------------------------------------------------------------------*/

--SELECT "-- Import data";
.separator \t
--.show

-- Escaped data from Geonames.org
.separator "\t" " "
SELECT "-- allCountries                        ";
.separator "\t" "\n"

BEGIN TRANSACTION;
.import data/allCountries.txt.esc geoname
END TRANSACTION;
INSERT OR REPLACE INTO System (section, name, value, note) VALUES ('tables','geoname_Load', CURRENT_TIMESTAMP ,'Loading Geoname');
SELECT COUNT(*) FROM geoname;

.separator "\t" " "
--                                             ";
SELECT "-- countryInfo-n                       ";
.separator "\t" "\n"
BEGIN TRANSACTION;
.import data/countryInfo-n.txt.esc countryinfo
END TRANSACTION;
INSERT OR REPLACE INTO System (section, name, value, note) VALUES ('tables','CountryInfo_Load', CURRENT_TIMESTAMP ,'Loading CountryInfo');

SELECT COUNT(*) FROM countryinfo;

.separator "\t" " "
--                                             ";
SELECT "-- alternatenames                      ";
.separator "\t" "\n"
BEGIN TRANSACTION;
.import data/alternatenames.txt.esc alternatenames
END TRANSACTION;
INSERT OR REPLACE INTO System (section, name, value, note) VALUES ('tables','alternatenames_Load', CURRENT_TIMESTAMP ,'Loading alternatenames');

SELECT COUNT(*) FROM alternatenames;

.separator "\t" " "
--                                             ";
SELECT "-- iso_languagecodes                   ";
.separator "\t" "\n"
BEGIN TRANSACTION;
.import data/iso-languagecodes.txt.esc iso_languagecodes 
END TRANSACTION;
INSERT OR REPLACE INTO System (section, name, value, note) VALUES ('tables','iso-languagecodes_Load', CURRENT_TIMESTAMP ,'Loading iso-languagecodes');

SELECT COUNT(*) FROM iso_languagecodes;

.separator "\t" " "
--                                             ";
SELECT "-- admin1CodesAscii                    ";
.separator "\t" "\n"
BEGIN TRANSACTION;
.import data/admin1CodesAscii.txt.esc admin1CodesAscii 
END TRANSACTION;
INSERT OR REPLACE INTO System (section, name, value, note) VALUES ('tables','admin1CodesAscii_Load', CURRENT_TIMESTAMP ,'Loading admin1CodesAscii');

SELECT COUNT(*) FROM admin1CodesAscii;

.separator "\t" " "
--                                             ";
SELECT "-- featureCodes                        ";
.separator "\t" "\n"
BEGIN TRANSACTION;
.import data/featureCodes_en.txt.esc featureCodes 
END TRANSACTION;
INSERT OR REPLACE INTO System (section, name, value, note) VALUES ('tables','featureCodes_en_Load', CURRENT_TIMESTAMP ,'Loading featureCodes_en');

SELECT COUNT(*) FROM featureCodes;

.separator "\t" " "
--                                             ";
SELECT "-- timeZones                           ";
.separator "\t" "\n"
BEGIN TRANSACTION;
.import data/timeZones.txt.esc timeZones 
SELECT COUNT(*) FROM timeZones;
INSERT OR REPLACE INTO System (section, name, value, note) VALUES ('tables','timeZones_Load', CURRENT_TIMESTAMP ,'Loading timeZones');

--.separator "\t" " "
--                                             ";
-- SELECT "-- continentCodes                     ";
--.separator "\t" "\n"
--BEGIN TRANSACTION;
-- .import data/continentCodes.txt.esc continentCodes 
--END TRANSACTION;

--SELECT COUNT(*) FROM continentCodes;

-- Your local data
.separator "\t" " "
--                                             ";
SELECT "-- allCountries.local                  ";
.separator "\t" "\n"
BEGIN TRANSACTION;
.import data/allCountries.local.txt.esc geoname
END TRANSACTION;
INSERT OR REPLACE INTO System (section, name, value, note) VALUES ('tables','allCountries.local_Load', CURRENT_TIMESTAMP ,'Loading allCountries.local');

SELECT COUNT(*) FROM geoname;

/*-------------------------------------------------------------------*/

--SELECT "-- Clean up - Please be patient        ";
-- vacuum;

/*-------------------------------------------------------------------*/

SELECT "- Data load ended";
.quit

/* *** End of File ************************************************* */