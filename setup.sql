DROP TABLE IF EXISTS Education;
DROP TABLE IF EXISTS Socioeconomic;
DROP TABLE IF EXISTS Housing;
DROP TABLE IF EXISTS Workers;
DROP TABLE IF EXISTS Population;
DROP TABLE IF EXISTS District;

CREATE TABLE IF NOT EXISTS District (
  districtID VARCHAR(50),
  state VARCHAR(50),
  congressionalDistrictNum INT,
  PRIMARY KEY (districtID)
);
LOAD DATA LOCAL INFILE 'relations/Districts.csv' INTO TABLE District FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

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
LOAD DATA LOCAL INFILE 'relations/People.csv' INTO TABLE Population FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Workers (
  districtID VARCHAR(50),
  laborForce INT,
  nonLaborForce INT,
  unemploymentRate FLOAT,
  meanCommute FLOAT,
  FOREIGN KEY(districtID) REFERENCES District(districtID)
);
LOAD DATA LOCAL INFILE 'relations/Workers.csv' INTO TABLE Workers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

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
LOAD DATA LOCAL INFILE 'relations/Housing.csv' INTO TABLE Housing FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Socioeconomic (
  districtID VARCHAR(50),
  medianIncome INT
  meanIncome FLOAT
  withHealthInsurance INT
  withoutHealthInsurance INT
  percentBelowPovertyLine FLOAT
  FOREIGN KEY(districtID) REFERENCES District(districtID)
);
LOAD DATA LOCAL INFILE 'relations/Socioeconomic.csv' INTO TABLE Socioeconomic FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

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
LOAD DATA LOCAL INFILE 'relations/Education.csv' INTO TABLE Education FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
