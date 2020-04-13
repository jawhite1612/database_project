CREATE TABLE if not exists Education (
districtID varchar(50),
lessThan9thGrade int,
9thTo12thGrade int,
highSchoolDiploma int,
someCollege int,
associatesDegree int,
bachelorsDegree int,
graduateOrProfessionalDegree int,
percentHighSchoolOrHigher float,
percentBachelorsOrHigher float
);

LOAD DATA LOCAL INFILE 'Education.csv' INTO TABLE Education FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
