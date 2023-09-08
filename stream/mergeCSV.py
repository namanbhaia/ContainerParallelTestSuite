import glob
import pandas as pd
import datetime
import os
import sys

csvPath = r'result/*.csv'
# List to store files
csvFiles = glob.glob(csvPath)
# print("The result files being merged are: \n", "\n".join(csvFiles))

testNum = 1;
columnNames = ['TestNum', 'Copy Rate (MB\s)', 'Scale Rate (MB\s)', 'Add Rate (MB\s)', 'Triad Rate (MB\s)'];
df = pd.DataFrame(columns=columnNames)
for file in csvFiles:
	data = pd.read_csv(file, skiprows = range(22))
	data.drop(data.index[4:7], inplace=True);
	for i in range(len(data)):
		l = data.iloc[i, 0]
		vals = l.split();
		df.loc[testNum-1, columnNames[i+1]] = float(vals[1]);
	df.loc[testNum-1, 'TestNum'] = testNum;
	testNum += 1;

aggRow = df.mean();
df.loc['Total'] = aggRow;
df.at['Total','TestNum'] = 0;
 
dateTime = datetime.datetime.now();
dateTimeStr = dateTime.strftime("%d-%m-%Y_%H-%M-%S")
filename = os.getcwd() + sys.argv[5] + "/StreamRun_" + dateTimeStr + "_" + sys.argv[4] + "_" + sys.argv[1] + "_" + sys.argv[2] + "_" + sys.argv[3];
name = filename + ".csv";
counter = 1;
while os.path.isfile(name):
	name = filename + "(" + str(counter) + ").csv";
	counter = counter + 1;
df.to_csv(name, index=False)
# print("Concatenated file is stored at: ", name);