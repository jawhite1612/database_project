import csv
from __builtin__ import any as b_any

elections = []

f = open("relations/Election.csv", "w")
g = open("relations/Candidate.csv", "w")
f.write("electionID,districtID,year,office\n")
g.write("electionID,name,party,numOfVotes,totalVotes,writeIn\n")

electionID = 0
candidateID = 1
def readElectionsAndCandidates(file):
  prevDistrict = ""
  global electionID
  global candidateID
  with open("elections/" + file) as csvfile:
  	reader = csv.DictReader(csvfile)
  	for row in reader:
          election = row["district"] + "," + row["year"] + "," + row["office"]
          if (row["district"] != prevDistrict):
            electionID+=1;
          g.write(str(candidateID) +"," + str(electionID)+","+row["candidate"]+","+row["party"]+","+row["candidatevotes"]+","+row["totalvotes"]+","+row["writein"]+'\n')
          if election not in elections:
            elections.append(election)
          prevDistrict = row["district"]
          candidateID += 1

files = ['house.csv','senate.csv','president.csv']

for file in files:
  readElectionsAndCandidates(file)

electionID = 1
for item in elections:
  f.write(str(electionID)+","+item + '\n')
  electionID+=1

f.close()
g.close()

