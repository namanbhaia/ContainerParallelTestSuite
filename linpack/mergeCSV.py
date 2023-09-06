import glob
import pandas as pd
import datetime
import os
import sys

def extractValues(x, convertVal):
	vals = x.split(' ');
	if convertVal:
		vals = [eval(i.replace("%","")) for i in vals if i];
	else:
		vals = [i for i in vals if i];
	return vals

csvPath = r'results/*.csv'
# List to store files
csvFiles = glob.glob(csvPath)
# print("The result files being merged are: \n", "\n".join(csvFiles))

results = []
testNum = 1;
for file in csvFiles:
	data = pd.read_csv(file, skiprows = range(8))
	data = data.drop(0)
	headers = list(data.columns.values.tolist());
	headers = extractValues(headers[0], False);
	df = pd.DataFrame(columns=headers)
	for i in range(len(data)):
		l = data.iloc[i, 0]
		l = extractValues(l, True)
		df.loc[len(df)] = l
	df.insert(0, 'TestNum', testNum)
	testNum += 1;
	results.append(df)

joinedCSV = pd.concat(results, ignore_index=True)
aggRow = joinedCSV.mean(numeric_only=True);
joinedCSV.loc['Total'] = aggRow.transpose().round(3);
joinedCSV.at['Total','TestNum'] = 0;
joinedCSV.rename( 
    columns={"DGEFA": "DGEFA%", "DGESL": "DGESL%", "OVERHEAD": "OVERHEAD%"},
    inplace=True,
)

dateTime = datetime.datetime.now();
dateTimeStr = dateTime.strftime("%d-%m-%Y_%H-%M-%S")
filename = os.getcwd() + sys.argv[5] + "/LinpackRun_" + dateTimeStr + "_" + sys.argv[4] + "_" + sys.argv[1] + "_" + sys.argv[2] + "_" + sys.argv[3];
name = filename + ".csv";
counter = 1;
while os.path.isfile(name):
	name = filename + "(" + str(counter) + ").csv";
	counter = counter + 1;
joinedCSV.to_csv(name, index=False)
# print("Concatenated file is stored at: ", name);