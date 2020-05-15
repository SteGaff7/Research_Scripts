import subprocess
import os
import csv

# Determine number of mutants for this project version
num_mutants = int(subprocess.check_output(['wc', '-l', '83f/mutants.log']).split()[0])
#print(num_mutants)

# Create two files, mergedKillMap and mergedTestMap
wf_kill = open('mergedKillMap.csv', 'w')
wf_test = open('mergedTestMap.csv', 'w')

with wf_kill, wf_test:
	writer_kill = csv.writer(wf_kill)
	header = [None] * (num_mutants+1)
	header[0] = "Test ID"
	for i in range(1,num_mutants+1,1):
		header[i] = i
	# Write header for killMap
	writer_kill.writerow(header)
	
	# Write header for testMap
	writer_test = csv.writer(wf_test)
	header = ["TestNo", "TestName"]
	writer_test.writerow(header)
	
	directory = "83f/"
	k_directory = directory + "kill_maps/"
	t_directory = directory + "test_maps/"

	kill_map_dir = os.fsencode(k_directory)
	#test_map_dir = os.fsencode("83f/test_maps")
	
	test_counter = 1
	# Iterate through kill map csvs
	for file in os.listdir(kill_map_dir):
		filename = os.fsdecode(file)

		if filename.endswith("killMap.csv"):
			
			rf_kill = open(os.path.join(kill_map_dir, file))
			with rf_kill:
				reader_kill = csv.reader(rf_kill)
				# Skip header
				next(reader_kill)
				# Create data for row to be written
				data = [""] * (num_mutants +1)
				test_id = test_counter
				data[0] = test_id

				# Iterate through the rows in the killMap
				for row in reader_kill:
					#print(row)
					mutant_id = int(row[1])
					status = row[2]
					
					# Add mutant status to data
					data[mutant_id] = status
			rf_kill.close()
		
			# Write data to mergedKillMap.csv
			writer_kill.writerow(data)

			# Get test class and method to generate unique test name & assign new test id
			test_class = filename.split("-")[0]
			test_method = filename.split("-")[1]
			# This should match triggering tests format			
			test_name = test_class + "." + test_method

			data = [test_counter, test_name]
			writer_test.writerow(data)

			test_counter+=1

			'''
			# Get matching testMap csv
                        #test_name = filename.split("killMap.csv")[0]
                        #print(test_name)
			
			#print(test_class, " ", test_method)
                        #test_csv = test_name + "testMap.csv"

			try:
				rf_test = open(os.path.join(t_directory, test_csv))
				
				# Write new test id with test name to merged Test Map
							
				data = [test_counter]
				with rf_test:
					reader_test = csv.reader(rf_test)
					# Skip header
					next(reader_test)
					test_name = reader_row[0][1]
					data[1] = test_name

				
				writer_test.writerow(data)
			except:
				pass
			'''
