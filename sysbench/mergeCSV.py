import glob
import pandas as pd
import datetime
import os
import sys

csvPath = r'results/*.prof'
# List to store files
csvFiles = glob.glob(csvPath)
# print("The result files being merged are: \n", "\n".join(csvFiles))

results = []
testNum = 1;
data = pd.DataFrame(columns=['TestNum', 'TotalTime(s)', 'NumEvents', 'EventsPerSec', 'MinRespTime(ms)', 'MaxRespTime(ms)', 'AvgRespTime(ms)', '95RespTime(ms)', 'ThreadFairEvt', 'ThreadFairStddev', 'EvtExecAvg', 'EvtExecStddev'])
string1 = "total time:";
string2 = "total number of events:";
string3 = "events per second:";
string4 = "min:";
string5 = "avg:";
string6 = "max:";
string7 = "95th percentile:";
string8 = "events (avg/stddev):";
string9 = "execution time (avg/stddev):";
for file in csvFiles:
	with open(file, "r") as f:
		s = f.readlines();
		val1 = "";
		val2 = ""
		val3 = ""
		val4 = ""
		val5 = ""
		val6 = ""
		val7 = ""
		val8 = ""
		val9 = ""
		val10 = ""
		val11 = ""
		for x in s:
			if x.__contains__(string1):
				x = x.split();
				val1 = float(x[2][:-1]);
			if x.__contains__(string2):
				x = x.split();
				val2 = float(x[4]);
			if x.__contains__(string3):
				x = x.split();
				val3 = float(x[3]);
			if x.__contains__(string4):
				x = x.split();
				val4 = float(x[1][:-2])
			if x.__contains__(string5):
				x = x.split();
				val5 = float(x[1][:-2]);
			if x.__contains__(string6):
				x = x.split();
				val6 = float(x[1][:-2]);
			if x.__contains__(string7):
				x = x.split();
				val7 = float(x[2]);
			if x.__contains__(string8):
				x = x.split();
				x = x[2];
				x = x.split('/');
				val8 = float(x[0]);
				val9 = float(x[1]);
			if x.__contains__(string9):
				x = x.split();
				x = x[3];
				x = x.split('/');
				val10 = float(x[0]);
				val11 = float(x[1]);
		f.close()
	data = pd.concat([pd.DataFrame([[testNum, val1, val2, val3, val4, val5, val6, val7, val8, val9, val10, val11]], columns=data.columns), data], ignore_index=True)
	testNum += 1;	

aggRow = data.mean(numeric_only=True);
data.loc['Total'] = aggRow.transpose().round(3);
data.at['Total','TestNum'] = 0;

dateTime = datetime.datetime.now();
dateTimeStr = dateTime.strftime("%d-%m-%Y_%H-%M-%S")
filename = os.getcwd() + sys.argv[5] + "/SysbenchRun_" + dateTimeStr + "_" + sys.argv[4] + "_" + sys.argv[1] + "_" + sys.argv[2] + "_" + sys.argv[3];
name = filename + ".csv";
counter = 1;
while os.path.isfile(name):
	name = filename + "(" + str(counter) + ").csv";
	counter = counter + 1;
data.to_csv(name, index=False)
# print("Concatenated file is stored at: ", name);