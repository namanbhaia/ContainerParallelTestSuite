import glob
import pandas as pd
import datetime
import os
# import sys

csvPath = r'*.csv'
# List to store files
csvFiles = glob.glob(csvPath)
# print("The result files being merged are: \n", "\n".join(csvFiles))

results = []
testNum = 1;
for file in csvFiles:
	data = pd.read_csv(file)
	# data = data.drop(columns=["real", "user", "sys"])
	aggRow = data.mean(numeric_only=True);
	data.loc['Total'] = aggRow.transpose().round(3);
	data.at['Total','TestNum'] = 0;
	data = data.query("TestNum == 0")
	data = data.assign(TestNum=testNum)
	testNum += 1;
	results.append(data)

joinedCSV = pd.concat(results, ignore_index=True)
aggRow = joinedCSV.mean(numeric_only=True);
joinedCSV.loc['Total'] = aggRow.transpose().round(3);
joinedCSV.at['Total','TestNum'] = 0;
joinedCSV.rename( 
    columns={"TestNum": "ParallelNum"},
    inplace=True,
)

dateTime = datetime.datetime.now();
dateTimeStr = dateTime.strftime("%d-%m-%Y_%H-%M-%S")
filename = os.getcwd() + "/NoploopCombinedRun_" + dateTimeStr;# + "_" + sys.argv[4] + "_" + sys.argv[1] + "_" + sys.argv[2] + "_" + sys.argv[3];
name = filename + ".csv";
joinedCSV.to_csv(name, index=False)
# print("Concatenated file is stored at: ", name);