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

/*-------------------------------------------------------------------*/

--SELECT "-- Import data";
.separator \t
--.show

-- Escaped data from Geonames.org
.separator "\t" " "
SELECT "-- allCountries                        ";
.separator "\t" "\n"
.import data/allCountries.txt.esc geoname
SELECT COUNT(*) FROM geoname;

.separator "\t" " "
--                                             ";
SELECT "-- countryInfo-n                       ";
.separator "\t" "\n"
.import data/countryInfo-n.txt.esc countryinfo
SELECT COUNT(*) FROM countryinfo;

.separator "\t" " "
--                                             ";
SELECT "-- alternatenames                      ";
.separator "\t" "\n"
.import data/alternatenames.txt.esc alternatenames
SELECT COUNT(*) FROM alternatenames;

.separator "\t" " "
--                                             ";
SELECT "-- iso_languagecodes                   ";
.separator "\t" "\n"
.import data/iso-languagecodes.txt.esc iso_languagecodes 
SELECT COUNT(*) FROM iso_languagecodes;

.separator "\t" " "
--                                             ";
SELECT "-- admin1CodesAscii                    ";
.separator "\t" "\n"
.import data/admin1CodesAscii.txt.esc admin1CodesAscii 
SELECT COUNT(*) FROM admin1CodesAscii;

.separator "\t" " "
--                                             ";
SELECT "-- featureCodes                        ";
.separator "\t" "\n"
.import data/featureCodes_en.txt.esc featureCodes 
SELECT COUNT(*) FROM featureCodes;

.separator "\t" " "
--                                             ";
SELECT "-- timeZones                           ";
.separator "\t" "\n"
.import data/timeZones.txt.esc timeZones 
SELECT COUNT(*) FROM timeZones;

--.separator "\t" " "
--                                             ";
-- SELECT "-- continentCodes                     ";
--.separator "\t" "\n"
-- .import data/continentCodes.txt.esc continentCodes 
--SELECT COUNT(*) FROM continentCodes;

-- Your local data
.separator "\t" " "
--                                             ";
SELECT "-- allCountries.local                  ";
.separator "\t" "\n"
.import data/allCountries.local.txt.esc geoname
SELECT COUNT(*) FROM geoname;

/*-------------------------------------------------------------------*/

--SELECT "-- Clean up - Please be patient        ";
-- vacuum;

/*-------------------------------------------------------------------*/

SELECT "- Data load ended";
.quit

/* *** End of File ************************************************* */