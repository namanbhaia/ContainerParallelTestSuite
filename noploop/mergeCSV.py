import glob
import pandas as pd
import datetime
import os
import sys

def extractValues(x):
	vals = x.split(' ');
	vals = [i for i in vals if i];
	return vals

file = 'temp.csv'
df = pd.read_csv(file, sep=" ", header=None)
data = pd.DataFrame(columns=['TestNum', 'Real', 'User', 'Sys'])
for i in range(len(df)):
	val = df.iloc[i, 1]
	col = df.iloc[i, 0]
	data.loc[i//3, col] = val
	data.loc[i//3, 'TestNum'] = i//3 + 1

dateTime = datetime.datetime.now();
dateTimeStr = dateTime.strftime("%d-%m-%Y_%H-%M-%S")
filename = os.getcwd() + sys.argv[5] + "/NoploopRun_" + dateTimeStr + "_" + sys.argv[4] + "_" + sys.argv[1] + "_" + sys.argv[2] + "_" + sys.argv[3];
name = filename + ".csv";
counter = 1;
while os.path.isfile(name):
	name = filename + "(" + str(counter) + ").csv";
	counter = counter + 1;
data.to_csv(name, index=False)
#print("Concatenated file is stored at: ", name);
