import pandas as pd
import numpy as np
import csv 

pid="Cli"
vid="14f"
gen="evosuite"
seed="1"

merged_kmap="/home/people/12309511/merged_maps/" + pid +"/" + vid + "/mergedKillMap.csv"
merged_tmap="/home/people/12309511/merged_maps/" + pid + "/" + vid + "/mergedTestMap.csv"
trig_test="14f-evosuite-1-org.apache.commons.cli2.option.GroupImpl_ESTest.test16"

tmap_rf = open(merged_tmap, 'r')
kmap_rf = open(merged_kmap, 'r')

with tmap_rf, kmap_rf:
	reader_tmap = csv.reader(tmap_rf)
	reader_kmap = csv.reader(kmap_rf)

	# Skip headers
	next(reader_tmap)
	next(reader_kmap)

	for row in reader_tmap:
		if row[1] == trig_test:
			print(trig_test, "\n", row[1])
			print(row)
			trig_test_id = row[0]
	for row in reader_kmap:
		if row[0] == trig_test_id:
			print(row)
			row_idx=0
			mutant_idxs = []
			unique = []
			for col in row:
				if col in ("EXC", "FAIL", "TIME"):
					mutant_idxs.append(row_idx)
					unique.append(True)
				row_idx+=1			
			print(mutant_idxs)
			break
	
	for row in reader_kmap:
		for i in range(0, len(mutant_idxs), +1):
			if unique[i] == True:
				# Check this mutant
				if row[mutant_idxs[i]] in ("EXC", "FAIL", "TIME"):
					#Check that this test isn't also a triggering test
					print(row)
					unique[i] = False
		# Break out when all unique == False

	print(unique)
kmap_rf.close()
tmap_rf.close()
