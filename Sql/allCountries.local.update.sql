/*
::@(#)NAME
::@(-)  The name of the command or function, followed by a one-line description of what it does.
::@(#)  allCountries.local.update.sql -- Updating personalize Geonames data into SQLite database
::@(#) 
::@ (#) 
::@(#)DESCRIPTION
::@(-)  A textual description of the functioning of the command or function.
::@(#)  This script will:
::@(#)  - Delete localized data
::@(#)  - Import updated data
::@(#) 
::@(#)REQUIRES
::@(-)  Dependencies
::@(#)
::@(#)REFERENCE
::@(-)  References to inspiration, clips and other documentation
::@ (#)  Author:
::@ (#)  URL: http://forum.geonames.org/gforum/posts/list/732.page
::@(#)
::@(#)AUTHOR
::@(-)  Who did what
::@(#)  %$AUTHOR%
::*** HISTORY **********************************************************
::SET $VERSION=YYYY-MM-DD&SET $REVISION=hh:mm:ss&SET $COMMENT=Description/init
  SET $VERSION=2016-03-18&SET $REVISION=00:00:00&SET $COMMENT=Initial/ErikBachmann
::**********************************************************************
::@(#){COPY}%$VERSION:~0,4% %$Author%
::**********************************************************************
*/

.changes on
--.stats on
--.stats off
.timer on
.separator \t
delete from geoname where geonameid > "90000000";
.import "Data/allCountries.local.txt" geoname
select max(geonameid), *  from geoname;

/* *** End of File ************************************************* */