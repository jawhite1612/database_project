import csv
from __builtin__ import any as b_any

elections = set()
f = open("relations/Election.csv", "w")
f.write("districtID,year,office\n")
with open("elections/house.csv") as csvfile:
	reader = csv.DictReader(csvfile)
	for row in reader:
               election = row["district"]+","+row["year"]+","+row["office"] 
               elections.add(election)
with open("elections/president.csv") as csvfile:
	reader = csv.DictReader(csvfile)
	for row in reader:
               election = row["district"]+","+row["year"]+","+row["office"] 
               elections.add(election)
with open("elections/senate.csv") as csvfile:
	reader = csv.DictReader(csvfile)
	for row in reader:
               election = row["district"]+","+row["year"]+","+row["office"] 
               elections.add(election)
for item in elections:
        f.write(item + '\n')
f.close()

