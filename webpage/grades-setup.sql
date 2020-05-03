-- grades-setup.sql

-- To execute this file named grades-setup.sql as a script on dbase from ugrad:
-- 
-- Option A: Execute it from ugrad. Save this file on ugrad in your current folder, then type:
--      mysql -h dbase.cs.jhu.edu -u YourUsername -D YourDatabaseName -p < grades-setup.sql
-- where you've replaced YourUsername and YourDatabaseName accordingly.
--
-- Option B: Execute it from your own laptop using DbVisualizer.
-- Connect to dbase via DbVisualizer specifying an appropriate database name, in the
-- connection setup, then paste this into an SQL Commander window, and execute it. In DbVisualizer, 
-- you may find that you frequently need to click the "reload current view" to see table updates.


DROP TABLE IF EXISTS Rawscores;
CREATE TABLE Rawscores(
    SSN	VARCHAR(4) PRIMARY KEY,
    LName   VARCHAR(11),
    FName   VARCHAR(11),
    Section VARCHAR(3),
    HW1     DECIMAL(5,2),
    HW2a    DECIMAL(5,2),
    HW2b    DECIMAL(5,2),
    Midterm DECIMAL(5,2),
    HW3	    DECIMAL(5,2),
    FExam   DECIMAL(5,2)
);

INSERT INTO Rawscores VALUES ('9176', 'Epp', 'Eric', '415', 99, 79, 31, 99, 119, 199);
INSERT INTO Rawscores VALUES ('5992', 'Lin', 'Linda', '415', 98, 71, 29, 83, 105, 171);
INSERT INTO Rawscores VALUES ('3774', 'Adams', 'Abigail', '315', 85, 63, 27, 88, 112, 180);
INSERT INTO Rawscores VALUES ('1212', 'Osborne', 'Danny', '315', 29, 31, 12, 66, 61, 106);
INSERT INTO Rawscores VALUES ('4198', 'Wilson', 'Amanda', '315', 84, 73, 27, 87, 115, 172);
INSERT INTO Rawscores VALUES ('1006', 'Nielsen', 'Bridget', '415', 93, 76, 28, 95, 111, 184);
INSERT INTO Rawscores VALUES ('8211', 'Clinton', 'Chelsea', '415', 100, 80, 32, 100, 120, 200);
INSERT INTO Rawscores VALUES ('1180', 'Quayle', 'Jonathan', '315', 50, 40, 16, 55, 68, 181);



-- Create a stored procedure named ShowRawScores which will return the row for a single student
-- whose SSN value is specified
delimiter //
DROP PROCEDURE IF EXISTS ShowRawScores //
CREATE PROCEDURE ShowRawScores(IN ss VARCHAR(4))
BEGIN
IF EXISTS(SELECT SSN FROM Rawscores WHERE SSN=ss) THEN
    SELECT *
    FROM Rawscores
    WHERE SSN = ss;
ELSE
    SELECT 'ERROR: ', 'Incorrect SSN' as 'Result';
END IF;
END;
//
delimiter ;

