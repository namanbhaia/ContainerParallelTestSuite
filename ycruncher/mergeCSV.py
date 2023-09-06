import glob
import pandas as pd
import datetime
import os
import sys

csvPath = r'results/*.txt'
# List to store files
csvFiles = glob.glob(csvPath)
print("The result files being merged are: \n", "\n".join(csvFiles))

results = []
testNum = 1;
data = pd.DataFrame(columns=['TestNum', 'ComputationTime', 'WallTime', 'CPUUtil', 'CPUUtilKOverhead', 'MultiCoreEff', 'MultiCoreEffKOverhead'])
string1 = "Total Computation Time:";
string2 = "Start-to-End Wall Time:";
string3 = "CPU Utilization:";
string4 = "Multi-core Efficiency:";
for file in csvFiles:
	with open(file, "r") as f:
		s = f.readlines();
		val1 = "";
		val2 = ""
		val3 = ""
		val4 = ""
		val5 = ""
		val6 = ""
		for x in s:
			if x.__contains__(string1):
				x = x.split();
				val1 = float(x[3]);
			if x.__contains__(string2):
				x = x.split();
				val2 = float(x[3]);
			if x.__contains__(string3):
				x = x.split();
				val3 = float(x[2]);
				val4 = float(x[5]);
			if x.__contains__(string4):
				x = x.split();
				val5 = float(x[2]);
				val6 = float(x[5]);
		f.close()
	data = pd.concat([pd.DataFrame([[testNum, val1, val2, val3, val4, val5, val6]], columns=data.columns), data], ignore_index=True)
	testNum += 1;	

aggRow = data.mean(numeric_only=True);
data.loc['Total'] = aggRow.transpose().round(3);
data.at['Total','TestNum'] = 0;

dateTime = datetime.datetime.now();
dateTimeStr = dateTime.strftime("%d-%m-%Y_%H-%M-%S")
filename = os.getcwd() + sys.argv[5] + "/YCruncherRun_" + dateTimeStr + "_" + sys.argv[4] + "_" + sys.argv[1] + "_" + sys.argv[2] + "_" + sys.argv[3];
name = filename + ".csv";
counter = 1;
while os.path.isfile(name):
	name = filename + "(" + str(counter) + ").csv";
	counter = counter + 1;
data.to_csv(name, index=False)
# print("Concatenated file is stored at: ", name);