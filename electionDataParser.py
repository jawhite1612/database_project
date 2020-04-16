import csv
from __builtin__ import any as b_any

elections = []
electionID = 0
f = open("relations/Election.csv", "w")
g = open("relations/Candidate.csv", "w")
f.write("electionID,districtID,year,office\n")
g.write("electionID,name,party,numOfVotes,totalVotes,writeIn\n")


def readElectionsAndCandidates(file):
  prevDistrict = ""
  global electionID
  with open("elections/" + file) as csvfile:
  	reader = csv.DictReader(csvfile)
  	for row in reader:
          election = row["district"] + "," + row["year"] + "," + row["office"]
          if (row["district"] != "prevDistrict"):
            electionID+=1;
            g.write(str(electionID)+","+row["candidate"]+","+row["party"]+","+row["candidatevotes"]+","+row["totalvotes"]+","+row["writein"]+'\n')
          if election not in elections:
            elections.append(election)
          prevDistrict = row["district"]

files = ['house.csv','senate.csv','president.csv']

for file in files:
  readElectionsAndCandidates(file)

electionID = 0
for item in elections:
  f.write(str(electionID)+","+item + '\n')
  electionID+=1

f.close()
g.close()

