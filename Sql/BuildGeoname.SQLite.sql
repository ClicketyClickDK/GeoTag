/*
::@(#)NAME
::@(-)  The name of the command or function, followed by a one-line description of what it does.
::@(#)  BuildGeorname.SQLite,sql -- Importing Geonames data into SQLite database
::@(#) 
::@ (#) 
::@(#)DESCRIPTION
::@(-)  A textual description of the functioning of the command or function.
::@(#)  This script will:
::@(#)  - Create the database if not existing
::@(#)  - Drop existing tables
::@(#)  - Recreate tables
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

SELECT "-- Init";
--.echo on
.log BuildGeoname.SQLite.log
.trace BuildGeoname.SQLite.trc
--.changes on
--.scanstats on
--.timer on

/*-------------------------------------------------------------------*/


SELECT "-- Create tables";
DROP TABLE IF EXISTS geoname;
CREATE TABLE IF NOT EXISTS geoname (
	geonameid int PRIMARY KEY,
	name varchar(200),
	asciiname varchar(200),
	alternatenames varchar(4000),
	--latitude decimal(10,7),
	--longitude decimal(10,7),
	latitude decimal(15,10),
	longitude decimal(15,10),
	fclass char(1),
	fcode varchar(10),
	country varchar(2),
	cc2 varchar(60),
	admin1 varchar(20),
	admin2 varchar(80),
	admin3 varchar(20),
	admin4 varchar(20),
	population int,
	elevation int,
	gtopo30 int,
	timezone varchar(40),
	moddate date
);

DROP TABLE IF EXISTS countryinfo;
CREATE TABLE IF NOT EXISTS countryinfo (
	iso_alpha2 	char(2),
	iso_alpha3 	char(3),
	iso_numeric 	integer,
	fips_code 	character varying(3),
	name 		character varying(200),
	capital 	character varying(200),
	areainsqkm 	double precision,
	population 	integer,
	continent 	char(2),
	tld 		char(3),
	currency 	char(3),
	currencyName 	char(20),
	Phone 		char(10),
	postalCodeFormat char(20),
	postalCodeRegex char(20),
	geonameId 	int,
	languages 	character varying(200),
	neighbours 	char(20),
	equivalentFipsCode char(10)
);

DROP TABLE IF EXISTS alternatenames;
CREATE TABLE IF NOT EXISTS alternatenames ( 
	alternatenameId	int PRIMARY KEY, 
	geonameid	int,
	isoLanguage	varchar(7),
	alternateName	varchar(200),
	isPreferredName	boolean,
	isShortName	boolean,
	isColloquial	boolean,
	isHistoric	boolean
);

CREATE TABLE IF NOT EXISTS iso_languagecodes( 
	iso_639_3	CHAR(4),
	iso_639_2	VARCHAR(50),
	iso_639_1	VARCHAR(50),
	language_name	VARCHAR(200)
);

DROP TABLE IF EXISTS admin1Codes;
CREATE TABLE IF NOT EXISTS admin1Codes ( 
	code		CHAR(6),
	name		TEXT
); 


DROP TABLE IF EXISTS admin1CodesAscii;
CREATE TABLE IF NOT EXISTS admin1CodesAscii ( 
	code		CHAR(6),
	name		TEXT,
	nameAscii	TEXT,
	geonameid	int
); 


DROP TABLE IF EXISTS featureCodes;
CREATE TABLE IF NOT EXISTS featureCodes ( 
	code		CHAR(7),
	name		VARCHAR(200),
	description	TEXT
);

-- CountryCode	TimeZoneId	GMT offset 1. Jan 2016	DST offset 1. Jul 2016	rawOffset (independant of DST)

DROP TABLE IF EXISTS timeZones;
CREATE TABLE IF NOT EXISTS timeZones ( 
	iso_alpha2		CHAR(2),
	timeZoneId		VARCHAR(200),
	GMT_offset		DECIMAL(3,1),
	GMT_offset_summer	DECIMAL(3,1),
	DST_offset		DECIMAL(3,1)
); 

DROP TABLE IF EXISTS continentCodes;
CREATE TABLE IF NOT EXISTS continentCodes ( 
	code			CHAR(2),
	name			VARCHAR(20),
	geonameid		INT
); 

/*-------------------------------------------------------------------*/

SELECT "-- Create indexes";
CREATE INDEX IF NOT EXISTS latitude ON geoname(latitude);
CREATE INDEX IF NOT EXISTS longitude ON geoname(longitude);
CREATE INDEX IF NOT EXISTS country ON geoname(country);

CREATE INDEX IF NOT EXISTS iso_alpha2 ON countryinfo(iso_alpha2);
CREATE INDEX IF NOT EXISTS iso_alpha3 ON countryinfo(iso_alpha3);

/*-------------------------------------------------------------------*/

SELECT "-- Clean up - Please be patient";
vacuum;

/*-------------------------------------------------------------------*/

.databases
.tables

SELECT "-- Quitting";
.quit

/* *** End of File ************************************************* */