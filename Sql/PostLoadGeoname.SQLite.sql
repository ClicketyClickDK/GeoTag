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

--SELECT "- Init";
--.echo on
.log postLoadGeoname.SQLite.log
.trace postLoadGeoname.SQLite.trc
--.changes on
--.scanstats on
--.timer on

/*-------------------------------------------------------------------*/

SELECT "- Unescape quotes and apostrophs";

-- Wrap lines
.separator "\t" ""

SELECT char(10)||printf("-- %-42.42s", "geoname.name");
UPDATE geoname SET name = replace( replace( name, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

SELECT char(10)||printf("-- %-42.42s", "geoname.asciiname");
UPDATE geoname SET asciiname = replace( replace( asciiname, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

SELECT char(10)||printf("-- %-42.42s", "geoname.alternatenames");
UPDATE geoname SET alternatenames = replace( replace( alternatenames, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

SELECT char(10)||printf("-- %-42.42s", "geoname.admin2");
UPDATE geoname SET admin2 = replace( replace( admin2, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

SELECT char(10)||printf("-- %-42.42s", "alternatename.alternateName");
UPDATE alternatenames SET alternateName = replace( replace( alternateName, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

SELECT char(10)||printf("-- %-42.42s", "iso_languagecodes.iso_639_2");
UPDATE iso_languagecodes SET iso_639_2 = replace( replace( iso_639_2, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

SELECT char(10)||printf("-- %-42.42s", "iso_languagecodes.iso_639_1");
UPDATE iso_languagecodes SET iso_639_1 = replace( replace( iso_639_1, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

SELECT char(10)||printf("-- %-42.42s", "iso_languagecodes.language_name");
UPDATE iso_languagecodes SET language_name = replace( replace( language_name, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

SELECT char(10)||printf("-- %-42.42s", "admin1Codes.name");
UPDATE admin1Codes SET name = replace( replace( name, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

SELECT char(10)||printf("-- %-42.42s", "admin1CodesAscii.name");
UPDATE admin1CodesAscii SET name = replace( replace( name, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

SELECT char(10)||printf("-- %-42.42s", "admin1CodesAscii.nameAscii");
UPDATE admin1CodesAscii SET nameAscii = replace( replace( nameAscii, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

SELECT char(10)||printf("-- %-42.42s", "featureCodes.name");
UPDATE featureCodes SET name = replace( replace( name, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

SELECT char(10)||printf("-- %-42.42s", "featureCodes.description");
UPDATE featureCodes SET description = replace( replace( description, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

SELECT char(10)||printf("-- %-42.42s", "timeZones.timeZoneId");
UPDATE timeZones SET timeZoneId = replace( replace( timeZoneId, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

SELECT char(10)||printf("-- %-42.42s", "continentCodes.name");
UPDATE continentCodes SET name = replace( replace( name, '{x27}', ''''), '{x22}', '"');
SELECT printf("[%-30.30s]", "Done");

        
-- Clean out dublets
--:: http://stackoverflow.com/questions/8190541/deleting-duplicate-rows-from-sqlite-database
/*
DELETE FROM image_%~2
WHERE  rowid NOT IN (
   SELECT      max(rowid) 
   FROM        image_%~2
   GROUP BY    %~2
);

*/

/*-------------------------------------------------------------------*/

--SELECT char(10)||"- Clean up - Please be patient";
SELECT char(10)||printf("- %-42.42s", "Vacuuming");
SELECT printf("[%-30.30s]", "Please be patient...");
vacuum;
--SELECT char(13)||"- Clean up - Done";
SELECT char(10)||printf("- %-42.42s", "Vacuuming");
SELECT printf("[%-30.30s]", "Done");

-- Normalize separator
.separator "\t" "\n"

/*-------------------------------------------------------------------*/
/*
SELECT char(10)||printf("-- %-42.42s", "Count entries";
SELECT COUNT(*) FROM geoname;
SELECT COUNT(*) FROM countryinfo;
*/
/*-------------------------------------------------------------------*/

--SELECT "- Quitting";
.quit

/* *** End of File ************************************************* */