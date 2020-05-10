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
  white INT,
  black INT,
  nativeAmericanAlaskan INT,
  asian INT,
  pacificIslander INT,
  otherRace INT,
  multiRace INT,
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
DROP PROCEDURE IF EXISTS GetStateMedianIncome //
CREATE PROCEDURE GetStateMedianIncome(IN s VARCHAR(40))
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
DROP PROCEDURE IF EXISTS GetStateAverageCommute //
CREATE PROCEDURE GetStateAverageCommute(IN s VARCHAR(40))
BEGIN
  SELECT districtId, meanCommute, sum(case when `party` = 'democrat' then 1 else 0 end)/count(*) as ratio from (SELECT state, District.districtId, meanCommute, name, party, votes
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
DROP PROCEDURE IF EXISTS GetStatePercentHighSchoolOrHigher //
CREATE PROCEDURE GetStatePercentHighSchoolOrHigher(IN s VARCHAR(40))
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
DROP PROCEDURE IF EXISTS GetStatePercentBachelorsOrHigher //
CREATE PROCEDURE GetStatePercentBachelorsOrHigher(IN s VARCHAR(40))
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

delimiter //
DROP PROCEDURE IF EXISTS GetStateMedianRent //
CREATE PROCEDURE GetStateMedianRent(IN s VARCHAR(40))
BEGIN
  SELECT districtId, medianRent, sum(case when `party` = 'democrat' then 1 else 0 end)/count(*) as ratio from (SELECT state, District.districtId, medianRent, name, party, votes
    FROM Housing, District, Election, Candidate inner join (select max(numOfVotes)as votes, electionID from Candidate group by electionID) as A
    ON A.votes = Candidate.numOfVotes and A.electionID = Candidate.electionID
    WHERE Housing.districtID = District.districtID
    AND District.districtID = Election.districtID
    AND Candidate.electionId = Election.electionID
    AND District.districtID LIKE s) as B
  GROUP BY districtId;
END;
//
delimiter ;

delimiter //
DROP PROCEDURE IF EXISTS GetStateMedianAge //
CREATE PROCEDURE GetStateMedianAge(IN s VARCHAR(40))
BEGIN
  SELECT districtId, medianAge, sum(case when `party` = 'democrat' then 1 else 0 end)/count(*) as ratio from (SELECT state, District.districtId, medianAge, name, party, votes
    FROM Population, District, Election, Candidate inner join (select max(numOfVotes)as votes, electionID from Candidate group by electionID) as A
    ON A.votes = Candidate.numOfVotes and A.electionID = Candidate.electionID
    WHERE Population.districtID = District.districtID
    AND District.districtID = Election.districtID
    AND Candidate.electionId = Election.electionID
    AND District.districtID LIKE s) as B
  GROUP BY districtId;
END;
//
delimiter ;

delimiter //
DROP PROCEDURE IF EXISTS GetStateMedianHomeValue //
CREATE PROCEDURE GetStateMedianHomeValue(IN s VARCHAR(40))
BEGIN
  SELECT districtId, medianOwned, sum(case when `party` = 'democrat' then 1 else 0 end)/count(*) as ratio from (SELECT state, District.districtId, medianOwned, name, party, votes
    FROM Housing, District, Election, Candidate inner join (select max(numOfVotes)as votes, electionID from Candidate group by electionID) as A
    ON A.votes = Candidate.numOfVotes and A.electionID = Candidate.electionID
    WHERE Housing.districtID = District.districtID
    AND District.districtID = Election.districtID
    AND Candidate.electionId = Election.electionID
    AND District.districtID LIKE s) as B
  GROUP BY districtId;
END;
//
delimiter ;

delimiter //
DROP PROCEDURE IF EXISTS GetStatePercentForeignBorn //
CREATE PROCEDURE GetStatePercentForeignBorn(IN s VARCHAR(40))
BEGIN
  SELECT districtId, ROUND((foreignBorn*100.0)/(foreignBorn+nativeBorn),2) as percent, sum(case when `party` = 'democrat' then 1 else 0 end)/count(*) as ratio from (SELECT state, District.districtId, foreignBorn, nativeBorn, name, party, votes
    FROM Population, District, Election, Candidate inner join (select max(numOfVotes)as votes, electionID from Candidate group by electionID) as A
    ON A.votes = Candidate.numOfVotes and A.electionID = Candidate.electionID
    WHERE Population.districtID = District.districtID
    AND District.districtID = Election.districtID
    AND Candidate.electionId = Election.electionID
    AND District.districtID LIKE s) as B
  GROUP BY districtId;
END;
//
delimiter ;

delimiter //
DROP PROCEDURE IF EXISTS GetStatePercentMortgagedUnits //
CREATE PROCEDURE GetStatePercentMortgagedUnits(IN s VARCHAR(40))
BEGIN
  SELECT districtId, ROUND((mortgagedUnits*100.0)/(mortgagedUnits+nonmortgagedUnits),2) as percent, sum(case when `party` = 'democrat' then 1 else 0 end)/count(*) as ratio from (SELECT state, District.districtId, mortgagedUnits, nonmortgagedUnits, name, party, votes
    FROM Housing, District, Election, Candidate inner join (select max(numOfVotes)as votes, electionID from Candidate group by electionID) as A
    ON A.votes = Candidate.numOfVotes and A.electionID = Candidate.electionID
    WHERE Housing.districtID = District.districtID
    AND District.districtID = Election.districtID
    AND Candidate.electionId = Election.electionID
    AND District.districtID LIKE s) as B
  GROUP BY districtId;
END;
//
delimiter ;

delimiter //
DROP PROCEDURE IF EXISTS GetStatePercentMinority //
CREATE PROCEDURE GetStatePercentMinority(IN s VARCHAR(40))
BEGIN
  SELECT districtId, ROUND((black+nativeAmericanAlaskan+asian+pacificIslander+otherRace)*100.0/(totalPop),2) as percent, sum(case when `party` = 'democrat' then 1 else 0 end)/count(*) as ratio from (SELECT state, District.districtId, black, nativeAmericanAlaskan, asian, pacificIslander, otherRace, totalPop, name, party, votes
    FROM Population, District, Election, Candidate inner join (select max(numOfVotes)as votes, electionID from Candidate group by electionID) as A
    ON A.votes = Candidate.numOfVotes and A.electionID = Candidate.electionID
    WHERE Population.districtID = District.districtID
    AND District.districtID = Election.districtID
    AND Candidate.electionId = Election.electionID
    AND District.districtID LIKE s) as B
  GROUP BY districtId;
END;
//
delimiter ;

delimiter //
DROP PROCEDURE IF EXISTS GetStatePercentWithoutHealthInsurance //
CREATE PROCEDURE GetStatePercentWithoutHealthInsurance(IN s VARCHAR(40))
BEGIN
  SELECT districtId, ROUND((withoutHealthInsurance*100.0)/(withHealthInsurance+withoutHealthInsurance),2) as percent, sum(case when `party` = 'democrat' then 1 else 0 end)/count(*) as ratio from (SELECT state, District.districtId, withHealthInsurance, withoutHealthInsurance, name, party, votes
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
DROP PROCEDURE IF EXISTS GetStateEducationLevels //
CREATE PROCEDURE GetStateEducationLevels(IN s VARCHAR(40))
BEGIN
  SELECT districtId, lessThan9thGrade, 9thTo12thGrade, highSchoolDiploma, someCollege, associatesDegree, bachelorsDegree, graduateOrProfessionalDegree, sum(case when `party` = 'democrat' then 1 else 0 end)/count(*) as ratio from (SELECT state, District.districtId, lessThan9thGrade, 9thTo12thGrade, highSchoolDiploma, someCollege, associatesDegree, bachelorsDegree, graduateOrProfessionalDegree, name, party, votes
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
