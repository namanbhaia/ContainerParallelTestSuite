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
	data = data.query("TestNum == 0")
	data = data.assign(TestNum=testNum)
	testNum += 1;
	results.append(data)

joinedCSV = pd.concat(results, ignore_index=True)
aggRow = joinedCSV.mean();
joinedCSV.loc['Total'] = aggRow;
joinedCSV.at['Total','TestNum'] = 0;
joinedCSV.rename( 
    columns={"TestNum": "ParallelNum"},
    inplace=True,
)

dateTime = datetime.datetime.now();
dateTimeStr = dateTime.strftime("%d-%m-%Y_%H-%M-%S")
filename = os.getcwd() + "/StreamCombinedRun_" + dateTimeStr;# + "_" + sys.argv[4] + "_" + sys.argv[1] + "_" + sys.argv[2] + "_" + sys.argv[3];
name = filename + ".csv";
joinedCSV.to_csv(name, index=False)
# print("Concatenated file is stored at: ", name);