
-- Initiate System table
-- http://stackoverflow.com/questions/14461851/how-to-have-an-automatic-timestamp-in-sqlite
CREATE TABLE System (
    --id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    section    VARCHAR(64) not null,
    name       VARCHAR(64) not null,
    value      text,
    note       text,
    modtime    TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    createtime TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (section, name)
);

INSERT INTO system(section, name, value, note) VALUES('system','name','GeoTag','Project name');
INSERT INTO system(section, name, value, note) VALUES('system','DateCreated',CURRENT_TIMESTAMP,'Date when this database was created');
INSERT INTO system(section, name, value, note) VALUES('system','DateLoaded',CURRENT_TIMESTAMP,'Date when this database was created');
INSERT INTO system(section, name, value, note) VALUES('system','DateUpdated',NULL,'Date when an update has been performed');
INSERT INTO system(section, name, value, note) VALUES('system','SoftwareVersion',CURRENT_TIMESTAMP,'Main version of scripting');

.mode line
SELECT * from SYSTEM;
-----------------------------------------------------------------------

