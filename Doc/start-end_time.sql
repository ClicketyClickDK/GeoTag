/*

Example of timer function to messure duration

2016-03-20T23:08:00/ErikBachmann@ClicketyClick.dk
*/
--timer
DROP TABLE IF EXISTS timer;
CREATE TEMP TABLE IF NOT EXISTS timer (
	key	primary key, 
	start	TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	end	TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Start value
INSERT OR REPLACE INTO timer(key, start, end) VALUES (1, '2016-03-20 00:00:30', NULL ); 
SELECT * FROM timer;

-- End value
UPDATE timer SET end = CURRENT_TIMESTAMP WHERE key LIKE '1';
SELECT * FROM timer;

-- Select diff in HH:MM:SS
SELECT  time( strftime('%s',t.end)-strftime('%s',t.start) , 'unixepoch') FROM timer AS t;
-- http://stackoverflow.com/questions/2685956/how-would-you-convert-secs-to-hhmmss-format-in-sqlite

--*** End of File ***