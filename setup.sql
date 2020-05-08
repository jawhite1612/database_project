DROP TABLE IF EXISTS Education;
DROP TABLE IF EXISTS Socioeconomic;
DROP TABLE IF EXISTS Housing;
DROP TABLE IF EXISTS Workers;
DROP TABLE IF EXISTS Population;
DROP TABLE IF EXISTS Candidate;
DROP TABLE IF EXISTS Election;
DROP TABLE IF EXISTS District;

CREATE TABLE IF NOT EXISTS District (
  districtID VARCHAR(50),
  state VARCHAR(50),
  congressionalDistrictNum INT,
  PRIMARY KEY (districtID)
);
LOAD DATA LOCAL INFILE 'relations/Districts.txt' INTO TABLE District FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Election (
  electionID INT,
  districtID VARCHAR(50),
  year INT,
  office VARCHAR(50),
  PRIMARY KEY(electionID),
  FOREIGN KEY (districtID) REFERENCES District(districtID)
);
LOAD DATA LOCAL INFILE 'relations/Election.txt' INTO TABLE Election FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Candidate (
  candidateID INT,
  electionID INT,
  name VARCHAR(100),
  party VARCHAR(50),
  numOfVotes INT,
  totalVotes INT,
  writeIn VARCHAR(10),
  PRIMARY KEY(candidateID),
  FOREIGN KEY (electionID) REFERENCES Election(electionID)
);
LOAD DATA LOCAL INFILE 'relations/Candidate.txt' INTO TABLE Candidate FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';


CREATE TABLE IF NOT EXISTS Population (
  districtID VARCHAR(50),
  totalPop INT,
  male INT,
  female INT,
  medianAge FLOAT,
  18andOver INT,
  65andOver INT,
  singleRace INT,
  multiRace INT,
  white INT,
  black INT,
  nativeAmericanAlaskan INT,
  asian INT,
  pacificIslander INT,
  otherRace INT,
  hispanic INT,
  nativeBorn INT,
  foreignBorn INT,
  FOREIGN KEY(districtID) REFERENCES District(districtID)
);
LOAD DATA LOCAL INFILE 'relations/People.txt' INTO TABLE Population FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Workers (
  districtID VARCHAR(50),
  laborForce INT,
  nonLaborForce INT,
  unemploymentRate FLOAT,
  meanCommute FLOAT,
  FOREIGN KEY(districtID) REFERENCES District(districtID)
);
LOAD DATA LOCAL INFILE 'relations/Workers.txt' INTO TABLE Workers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Housing (
  districtID VARCHAR(50),
  ownedUnits INT,
  medianOwned INT,
  mortgagedUnits INT,
  nonmortgagedUnits INT,
  rentedUnits INT,
  medianRent INT,
  FOREIGN KEY(districtID) REFERENCES District(districtID)
);
LOAD DATA LOCAL INFILE 'relations/Housing.txt' INTO TABLE Housing FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Socioeconomic (
  districtID VARCHAR(50),
  medianIncome INT,
  meanIncome FLOAT,
  withHealthInsurance INT,
  withoutHealthInsurance INT,
  percentBelowPovertyLine FLOAT,
  FOREIGN KEY(districtID) REFERENCES District(districtID)
);
LOAD DATA LOCAL INFILE 'relations/Socioeconomic.txt' INTO TABLE Socioeconomic FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Education (
  districtID VARCHAR(50),
  lessThan9thGrade INT,
  9thTo12thGrade INT,
  highSchoolDiploma INT,
  someCollege INT,
  associatesDegree INT,
  bachelorsDegree INT,
  graduateOrProfessionalDegree INT,
  percentHighSchoolOrHigher FLOAT,
  percentBachelorsOrHigher FLOAT,
  FOREIGN KEY(districtID) REFERENCES District(districtID)
);
LOAD DATA LOCAL INFILE 'relations/Education.txt' INTO TABLE Education FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

delimiter //
DROP PROCEDURE IF EXISTS GetStateIncome //
CREATE PROCEDURE GetStateIncome(IN s VARCHAR(40))
BEGIN
  SELECT districtId, medianIncome, sum(case when `party` = 'democrat' then 1 else 0 end)/count(*) as ratio from (SELECT state, District.districtId, medianIncome, name, party, votes
    FROM Socioeconomic, District, Election, Candidate inner join (select max(numOfVotes)as votes, electionID from Candidate group by electionID) as A
    ON A.votes = Candidate.numOfVotes and A.electionID = Candidate.electionID
    WHERE Socioeconomic.districtID = District.districtID
    AND District.districtID = Election.districtID
    AND Candidate.electionId = Election.electionID
    AND District.districtID LIKE s) as B
  GROUP BY districtId;
END;
//
delimiter ;

delimiter //
DROP PROCEDURE IF EXISTS GetStatePovertyRate //
CREATE PROCEDURE GetStatePovertyRate(IN s VARCHAR(40))
BEGIN
  SELECT districtId, percentBelowPovertyLine, sum(case when `party` = 'democrat' then 1 else 0 end)/count(*) as ratio from (SELECT state, District.districtId, percentBelowPovertyLine, name, party, votes
    FROM Socioeconomic, District, Election, Candidate inner join (select max(numOfVotes)as votes, electionID from Candidate group by electionID) as A
    ON A.votes = Candidate.numOfVotes and A.electionID = Candidate.electionID
    WHERE Socioeconomic.districtID = District.districtID
    AND District.districtID = Election.districtID
    AND Candidate.electionId = Election.electionID
    AND District.districtID LIKE s) as B
  GROUP BY districtId;
END;
//
delimiter ;

delimiter //
DROP PROCEDURE IF EXISTS GetStateUnemploymentRate //
CREATE PROCEDURE GetStateUnemploymentRate(IN s VARCHAR(40))
BEGIN
  SELECT districtId, unemploymentRate, sum(case when `party` = 'democrat' then 1 else 0 end)/count(*) as ratio from (SELECT state, District.districtId, unemploymentRate, name, party, votes
    FROM Workers, District, Election, Candidate inner join (select max(numOfVotes)as votes, electionID from Candidate group by electionID) as A
    ON A.votes = Candidate.numOfVotes and A.electionID = Candidate.electionID
    WHERE Workers.districtID = District.districtID
    AND District.districtID = Election.districtID
    AND Candidate.electionId = Election.electionID
    AND District.districtID LIKE s) as B
  GROUP BY districtId;
END;
//
delimiter ;

delimiter //
DROP PROCEDURE IF EXISTS GetPercentHighSchoolOrHigher //
CREATE PROCEDURE GetPercentHighSchoolOrHigher(IN s VARCHAR(40))
BEGIN
  SELECT districtId, percentHighSchoolOrHigher, sum(case when `party` = 'democrat' then 1 else 0 end)/count(*) as ratio from (SELECT state, District.districtId, percentHighSchoolOrHigher, name, party, votes
    FROM Education, District, Election, Candidate inner join (select max(numOfVotes)as votes, electionID from Candidate group by electionID) as A
    ON A.votes = Candidate.numOfVotes and A.electionID = Candidate.electionID
    WHERE Education.districtID = District.districtID
    AND District.districtID = Election.districtID
    AND Candidate.electionId = Election.electionID
    AND District.districtID LIKE s) as B
  GROUP BY districtId;
END;
//
delimiter ;

delimiter //
DROP PROCEDURE IF EXISTS GetPercentBachelorsOrHigher //
CREATE PROCEDURE GetPercentBachelorsOrHigher(IN s VARCHAR(40))
BEGIN
  SELECT districtId, percentBachelorsOrHigher, sum(case when `party` = 'democrat' then 1 else 0 end)/count(*) as ratio from (SELECT state, District.districtId, percentBachelorsOrHigher, name, party, votes
    FROM Education, District, Election, Candidate inner join (select max(numOfVotes)as votes, electionID from Candidate group by electionID) as A
    ON A.votes = Candidate.numOfVotes and A.electionID = Candidate.electionID
    WHERE Education.districtID = District.districtID
    AND District.districtID = Election.districtID
    AND Candidate.electionId = Election.electionID
    AND District.districtID LIKE s) as B
  GROUP BY districtId;
END;
//
delimiter ;
