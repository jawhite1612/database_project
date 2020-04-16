To run the state data parser to create the state data relations, type:

python stateDataParser.py

Dir description:

    relations --> the output of relations when running the parser
    states --> the raw data from states (removed occupation for now)
    elections --> the raw data from elections (only includes )
    util --> blank (required for io)
    	     translate.txt
		To add an attribute to a specific relation:
		1. Find the relation that you want to write to
		2. Under that relation name, type:
		   	 Subject,Title,sql_attribute
		   Where Subject and Title are defined in the states data
		   And sql_attribute is the alias in the csv to be used in the database