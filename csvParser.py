import csv
from __builtin__ import any as b_any
prev = ""
attributes = ""
f = open("util/blank", "w")
subjectTitle = {}
topics = []
with open("util/translate.csv") as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
                if len(row) == 1:
                        f.write('\n')
                        f.close()
                        f = open("relations/" + row[0] + ".csv", "w")
                        f.write("districtID,")
                        topics.append(row[0])
                elif len(row) > 1:
                        f.write(row[2]+",")
                        if row[0] not in subjectTitle:
                                subjectTitle[row[0]] = []
                        if row[1] not in subjectTitle[row[0]]:
                                subjectTitle[row[0]].append(row[1])
f.write("\n")                        
f.close()
f = open("states/states.txt", "r")
states = [state.strip() for state in f.readlines()]
print(states)
f = open("util/blank", "w")
districtId = 0
for state in states:
	with open("states/" + state) as csvfile:
		reader = csv.DictReader(csvfile)
                districts = []
                for row in reader:
                        for key in row:
                                if "Estimate" in key:
                                        districts.append(key)
                        break
                districts.sort()
                for i in range (len(districts)):
                        prevTopic = ''
                        print(state)
                        print(districts[i])
		        for row in reader:
                                if row['Topic'] not in topics:
                                        continue
                                if prevTopic != row["Topic"]:
                                        f.write('\n')
                                        f.close()
                                        f = open("relations/" + row["Topic"] + ".csv", "a")
                                        f.write(state.replace(".csv", "") + str(i+1)+",")
                                        prevTopic = row["Topic"]
                                if row["Subject"] in subjectTitle:
                                        if b_any(title in row["Title"] for title in subjectTitle[row["Subject"]]):
                                                f.write(row[districts[i]].strip()+",")
                        csvfile.seek(0)
