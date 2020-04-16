DROP TABLE IF EXISTS Education_small;
DROP TABLE IF EXISTS Socioeconomic_small;
DROP TABLE IF EXISTS Housing_small;
DROP TABLE IF EXISTS Workers_small;
DROP TABLE IF EXISTS Population_small;
DROP TABLE IF EXISTS Candidate_small;
DROP TABLE IF EXISTS Election_small;
DROP TABLE IF EXISTS District_small;

CREATE TABLE IF NOT EXISTS District_small (
  districtID VARCHAR(50),
  state VARCHAR(50),
  congressionalDistrictNum INT,
  PRIMARY KEY (districtID)
);
LOAD DATA LOCAL INFILE 'relations-small/Districts-small.txt' INTO TABLE District_small FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Election_small (
  electionID INT,
  districtID VARCHAR(50),
  year INT,
  office VARCHAR(50),
  PRIMARY KEY(electionID),
  FOREIGN KEY (districtID) REFERENCES District_small(districtID)
);
LOAD DATA LOCAL INFILE 'relations-small/Election-small.txt' INTO TABLE Election_small FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Candidate_small (
  candidateID INT,
  electionID INT,
  name VARCHAR(100),
  party VARCHAR(50),
  numOfVotes INT,
  totalVotes INT,
  writeIn VARCHAR(10),
  PRIMARY KEY(candidateID),
  FOREIGN KEY (electionID) REFERENCES Election_small(electionID)
);
LOAD DATA LOCAL INFILE 'relations-small/Candidate-small.txt' INTO TABLE Candidate_small FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';


CREATE TABLE IF NOT EXISTS Population_small (
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
  FOREIGN KEY(districtID) REFERENCES District_small(districtID)
);
LOAD DATA LOCAL INFILE 'relations-small/People-small.txt' INTO TABLE Population_small FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Workers_small (
  districtID VARCHAR(50),
  laborForce INT,
  nonLaborForce INT,
  unemploymentRate FLOAT,
  meanCommute FLOAT,
  FOREIGN KEY(districtID) REFERENCES District_small(districtID)
);
LOAD DATA LOCAL INFILE 'relations-small/Workers-small.txt' INTO TABLE Workers_small FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Housing_small (
  districtID VARCHAR(50),
  ownedUnits INT,
  medianOwned INT,
  mortgagedUnits INT,
  nonmortgagedUnits INT,
  rentedUnits INT,
  medianRent INT,
  FOREIGN KEY(districtID) REFERENCES District_small(districtID)
);
LOAD DATA LOCAL INFILE 'relations-small/Housing-small.txt' INTO TABLE Housing_small FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Socioeconomic_small (
  districtID VARCHAR(50),
  medianIncome INT,
  meanIncome FLOAT,
  withHealthInsurance INT,
  withoutHealthInsurance INT,
  percentBelowPovertyLine FLOAT,
  FOREIGN KEY(districtID) REFERENCES District_small(districtID)
);
LOAD DATA LOCAL INFILE 'relations-small/Socioeconomic-small.txt' INTO TABLE Socioeconomic_small FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Education_small (
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
  FOREIGN KEY(districtID) REFERENCES District_small(districtID)
);
LOAD DATA LOCAL INFILE 'relations-small/Education-small.txt' INTO TABLE Education_small FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
