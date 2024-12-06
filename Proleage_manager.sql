
CREATE TABLE Purple_Cap (
Record_ID INT AUTO_INCREMENT PRIMARY KEY,
Player_ID INT,
Player_Name VARCHAR(100), Team_ID INT,
Wickets_Taken INT, Matches_Played INT
);
CREATE TABLE Orange_Cap (
Record_ID INT AUTO_INCREMENT PRIMARY KEY,
Player_ID INT,
Player_Name VARCHAR(100), Team_ID INT,
Runs_Scored INT, Matches_Played INT
);
 
DELIMITER $$
CREATE TRIGGER after_player_insert_purple_cap AFTER INSERT ON Players
FOR EACH ROW BEGIN
DECLARE existing_wickets INT;

SELECT Wickets_Taken INTO existing_wickets FROM Purple_Cap
WHERE Player_Name = NEW.name;
IF existing_wickets IS NOT NULL THEN UPDATE Purple_Cap
SET Wickets_Taken = existing_wickets + NEW.wickets,
Matches_Played = Matches_Played + 1 WHERE Player_Name = NEW.name;
ELSE
-- If the player does not exist, insert a new record INSERT INTO Purple_Cap (Record_ID, Player_ID,
Player_Name, Team_ID, Wickets_Taken, Matches_Played)
VALUES (NULL, NEW.id, NEW.name, NEW.team_id, NEW.wickets, 1);
END IF;
END $$ DELIMITER ;
 
DELIMITER $$

CREATE TRIGGER after_player_insert AFTER INSERT ON Players
FOR EACH ROW BEGIN
DECLARE existing_runs INT;
SELECT Runs_Scored INTO existing_runs FROM Orange_Cap
WHERE Player_Name = NEW.name;

IF existing_runs IS NOT NULL THEN UPDATE Orange_Cap
SET Runs_Scored = existing_runs + NEW.runs, Matches_Played = Matches_Played + 1
WHERE Player_Name = NEW.name order by Runs_Scored desc;
ELSE
-- If the player does not exist, insert a new record INSERT INTO Orange_Cap (Record_ID, Player_ID,
Player_Name, Team_ID, Runs_Scored, Matches_Played)
VALUES (NULL, NEW.id, NEW.name, NEW.team_id, NEW.runs, 1);
END IF;
END $$
 
DELIMITER ;

ALTER TABLE Players
ADD Wickets_Taken INT DEFAULT 0, ADD Runs INT DEFAULT 0;


INSERT INTO Players (Player_ID, Team_ID, Name, Role, Batting_Style, Bowling_Style, Wickets_Taken, Runs,Date)
VALUES (4, 2, 'Dube', 'Batsman', 'Left-hand bat', 'Left- arm medium', 2, 66,'2024-04-24');

INSERT INTO Orange_Cap (Player_ID, Player_Name, Team_ID, Runs_Scored, Matches_Played)
VALUES (1, 'Virat Kohli', 1, 500, 14);
