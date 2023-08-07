import glob
import pandas as pd
import datetime
import os
import sys

## Identify all CSV files to merge
# Folder path with result CSVs
csvPath = r'byte-unixbench/UnixBench/results/*.csv'
# List to store files
csvFiles = glob.glob(csvPath)
# print("The result files being merged are: \n", "\n".join(csvFiles))

## Append all found CSV files
l = [];
for file in csvFiles:
	l.append(pd.read_csv(file))

joinedCSV = pd.concat(l, ignore_index=True)

dateTime = datetime.datetime.now();
dateTimeStr = dateTime.strftime("%d-%m-%Y_%H-%M-%S")
filename = os.getcwd() + "finalResults/UnixBenchRun_" + dateTimeStr + "_" + sys.argv[4] + "_" + sys.argv[1] + "_" + sys.argv[2] + "_" + sys.argv[3];
name = filename + ".csv";
while os.path.isfile(name):
	filename = filename + str(1);
	name = filename + ".csv";
joinedCSV.to_csv(name, index=False)
# print("Concatenated file is stored at: ", name);
