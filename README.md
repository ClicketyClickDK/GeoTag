# GeoTag
An out-of-the-Box Reverse Geotagging for images containing GPS information in EXIF format.

## Reverse Geotagging v. 2016-03-18 r. 00:00:00

/ Erik Bachmann, ClicketyClick.dk [ErikBachmann@ClicketyClick.dk]

URL: https://github.com/ClicketyClickDK/GeoTag

>*** Please note: This is a Windows only setup ***

## WHAT IT DOES

### For short:
An out-of-the-Box Reverse Geotagging for images containing GPS information in EXIF format.

### In detail:
A simple menu based tool to update the location meta data in image files, based on the GPS data stored by you camera.

Once installed enables you to add location meta data to your images - even when you off-line

## HOW IT WORKS

For each picture GPS data like lattitude and logitude are extracted and compared to the Geoname database to find the nearest match.
This match is written as location back into the image files IPCT meta data structure.

This is done using:
- Windows batch scripts
- ExifTool
- SQLite database
- and some data from Geoname.org.

And it works off-line (once installed)
 
## REQUIREMENTS

This setup does NOT require any admin rights or installation of software, that is not Open Source.

It's based on Windows Batch commands and VB scripts that can be executed on any Windows based PC.
In addtion a few utilites are required:

Package | URL  | Description
--------|------|------------
SQLite | https://www.sqlite.org/ | A public domain database 
ExifTool | http://www.sno.phy.queensu.ca/~phil/exiftool | A free and open-source software program for reading, writing, and manipulating image, audio, and video metadata.
ImageMagick| http://www.imagemagick.org | A free and open-source software suite for displaying, converting, and editing raster or vector image files

and some free script libraries:


Package | URL  | Description
--------|------|------------
Underscore 	| https://github.com/ClicketyClickDK/Underscore | A collection of generic, ready-to-use batch scripts, that I've developed and refined over the years
Pics		| https://github.com/ClicketyClickDK/Pics | Handling pictures from camera, SD, mobile or other devices


## INSTALLING

Create a directory to place the package in - like: `C:\TMP\Geotag\`. 
Download the Geotag package to the directory and unzip.

This will create a structure like:

```
   C:\TMP\GEOTAGGING
   +---Bin          Scripts and utilities
   |   \---_        The UnderScore directory
   +---Doc          Documentation
   \---Sql          SQL scripts
```

### Update configuration

<fieldset>
<legend>NOTE</legend>
    Do check that the current versions of software are downloaded!
</fieldset>

Please check the section **Packages to install** in `Bin/Geotag.config.cmd` for the latest versions of the utilities:

- ImageMagick `ImageMagick-7.0.7-38-portable-Q16-x866.zip`
- ExifTool `exiftool-10.99.zip;` Check http://owl.phy.queensu.ca/~phil/exiftool/ver.txt for latest version
- SQLite  https://www.sqlite.org/**2018**/ `sqlite-tools-win32-x86-3230100.zip` See latest version of Windows Tools version at https://www.sqlite.org/download.html

Update the config file `Geotag.config.cmd` and save it to `Bin/`.

### Run installation

From the Geotag directory, open the main menu:
```
C:\TMP\Geotag\geotag.menu.cmd
```

Since this is a "bare" setup with no databases you will be directed to the pre-install menu with the options:
```
  R  Read ME
  I  *** Install *** - The full monty
  C  Edit config file

  q  Quit (Return to main)
```

>	PLEASE NOTE!
>	"Installing" means downloading and unpacking the utilities 
>	mentioned above (aprox. 140 MB)
>	AND download a relatively large set of data from Geonames.org
>	(aprox. 340 MB)
>
>	After downloading the Geonames data data is unzipped, converteted 
>	and loaded into the geonames database.
>	This operation requires 4-6 GB disk space and can take a couple of hours (sic!)

Hit the `[i]` for installing

The script will:

1. Checking paths for the structure (will create the remaining directories)
2. Download and install packages (SQLite, ExifTool, ImageMagick)
3. Download meta data from Geoname.org
4. Convert meta data
5. Build databases
6. Load meta data
7. Post process loaded meta data

You will end up with a file structure like:
```   
   C:\TMP\GEOTAGGING
   +---Bin              Scripts and utilities
   |   +---ExifTool     Metadata handling
   |   +---ImageMagick  Image converting
   |   +---Pics         Scripts handling pictures from camera, SD, mobile or other devices
   |   +---SQLite       SQLite software
   |   +---UnderScore
   |   \---_            The UnderScore directory
   +---Data             Data and databases
   +---Doc              Documentation
   +---Images           Source dir for image files
   +---Sql              SQL scripts
   \---Web              Output for web-ready images
```

And you will return to the full main menu with the options:

```
  R  Read ME
  M  iMport picture from SD card
  G  Reverse Geotag new images
  X  eXtended functions (Import, convert, Export)
  B  > Build index from images
  I  > Install
  D  > Database menu

  Q  Quit
```
   
Now you're ready to rock!


## GET IMAGES TO GEOTAG

### MANUALLY

You can manually copy image files to the directory "IMAGES\" or any subdirectory below.

### AUTOMATED

OR you can import files from SD card / camera by using the iMport option in the menu.
The import option requires a directory named "DCIM" in the root of a drive. 
All drives (E: - H:) will be scanned and first occurence will be used as source.

Images will be stored in directories named by files date and each file will get 
a prefix of data and time:
```
   +--- YYYY-MM-DD
        +--- YYYY-MM-DDThh-mm-ss_filename1
        +--- YYYY-MM-DDThh-mm-ss_filename2
   +--- YYYY-MM-DD
        +--- YYYY-MM-DDThh-mm-ss_filename3
        +--- YYYY-MM-DDThh-mm-ss_filename4
```

## REVERSE GEOTAGGING

Select the "G  Reverse Geotag new images" option from the main menu.
The script traverses the "IMAGES\" directories and:

1. Extracts GPS location from the EXIF section of the image files
2. Finds the nearest postion match in the Geonames database
3. Writes the location into the IPTC section of the image file


## ADDNING PERSONALIZED GEONAMES

Add your personalize data to the data file "Data\allCountries.local.txt"

The allCountries table has the following tab delimited fields :

Table            |Mandatory| Description
-----------------|-----|----------------------------------
geonameid        | Yes | integer id of record in geonames database
name             | Yes | name of geographical point (utf8) varchar(200)
asciiname        | Yes | name of geographical point in plain ascii characters, varchar(200)
alternatenames   | Yes | alternatenames, comma separated, ascii names automatically transliterated, convenience attribute from alternatename table, varchar(10000)
latitude         | Yes | latitude in decimal degrees (wgs84)
longitude        | Yes | longitude in decimal degrees (wgs84)
feature class    |     | see http://www.geonames.org/export/codes.html, char(1)
feature code     |     | see http://www.geonames.org/export/codes.html, varchar(10)
country code     | Yes | ISO-3166 2-letter country code, 2 characters
cc2              |     | alternate country codes, comma separated, ISO-3166 2-letter country code, 200 characters
admin1 code      |     | fipscode (subject to change to iso code), see exceptions below, see file admin1Codes.txt for display names of this code; varchar(20)
admin2 code      |     | code for the second administrative division, a county in the US, see file admin2Codes.txt; varchar(80) 
admin3 code      |     | code for third level administrative division, varchar(20)
admin4 code      |     | code for fourth level administrative division, varchar(20)
population       |     | bigint (8 byte int) 
elevation        |     | in meters, integer
dem              |     | digital elevation model, srtm3 or gtopo30, average elevation of 3''x3'' (ca 90mx90m) or 30''x30'' (ca 900mx900m) area in meters, integer. srtm processed by cgiar/ciat.
timezone         |     | the timezone id (see file timeZone.txt) varchar(40)
modification date | Yes | date of last modification in yyyy-MM-dd format

Enter appropriate data in the fields marked with *. The remaining can be ignored

Please refere to http://download.geonames.org/export/dump/readme.txt for a more detailed description of the syntax

Geonames uses serial numbers for id. Use a large value to start your own sequence to avoid conflicts with valid Geonameid's 
Currently the max value provied by Geonames.org is 11073441 (or 11,073,441)

My local entries starts at: 99000000 to void confusion (that is 99,000,000).

Example:
```
99000000	Roskilde Cathedral	Roskilde Domkirke		55.642649	12.080365			DK			265			0		40	Europe/Copenhagen	2016-03-18
```
Save the file `"Data\allCountries.local.txt"` and reload:

Main menu select:

```
   "D  > Database menu"
```

From the Database menu select:
```
   "S  SQLite prompt - Geoname"
```

Enter the commands:
`.read "sql/allCountries.local.update.sql"`
 
This will delete old local entries and import the latest version:

```
	Run Time: real 0.060 user 0.000000 sys 0.062400
	changes:   1   total_changes: 24
	99000000        99000000        Roskilde Cathedral      Roskilde Domkirke
		55.642649       12.080365                       DK
	265                     0               40      Europe/Copenhagen       2016-03-
	18
	Run Time: real 0.002 user 0.000000 sys 0.000000
	changes:   1   total_changes: 25
```

## IMPROVING USING YOUR EXISTING META DATA
(not implemented)
