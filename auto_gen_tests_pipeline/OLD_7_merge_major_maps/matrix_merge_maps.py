import sys
import subprocess
import os
import csv

project = sys.argv[1]
version = sys.argv[2]

mutants_log = "/home/people/12309511/scratch/major_mutation_results/" + project + "/" + version + "/mutants.log"

print(mutants_log)

# Determine number of mutants for this project version
num_mutants = int(subprocess.check_output(['wc', '-l', mutants_log]).split()[0])
print(num_mutants)

# Create directory to store maps if it does not exist
directories = '/home/people/12309511/merged_maps/' + project + '/'
subprocess.call(['mkdir', '--parents', directories])

# Create one file, mergedMap
wf_map = open('/home/people/12309511/merged_maps/' + project + '/' + version + '-mergedMap.csv', 'w')

with wf_map:
    writer_map = csv.writer(wf_map)
    header = [None] * (num_mutants + 1)
    header[0] = "Test Name"
    for i in range(1, num_mutants + 1, 1):
        header[i] = i
    # Write header for killMap
    writer_map.writerow(header)

    project_major_results = '/home/people/12309511/scratch/major_mutation_results/' + project + '/' + version + '/'

    kill_dir = project_major_results + 'kill_maps/'
    test_dir = project_major_results + 'test_maps/'
    summaries = project_major_results + 'summaries/'

    kill_map_dir = os.fsencode(kill_dir)

    # Iterate through kill map csvs
    file_list = os.listdir(kill_map_dir)
    file_list.sort()
    for file in file_list:
        filename = os.fsdecode(file)

        if filename.endswith("killMap.csv"):

            # Get test class and method to generate unique test name for this method
            v, g, s, test_class, test_method, *leftover = filename.split("-")

            # This should match triggering tests format
            test_name = v + "-" + g + "-" + s + "-" + test_class + "." + test_method

            rf_kill = open(os.path.join(kill_map_dir, file))
            with rf_kill:
                reader_kill = csv.reader(rf_kill)
                # Skip header
                next(reader_kill)
                # Create data for row to be written
                data = [""] * (num_mutants + 1)
                data[0] = test_name

                # Iterate through the rows in the killMap
                for row in reader_kill:
                    mutant_id = int(row[1])
                    status = row[2]

                    # Add mutant status to data
                    data[mutant_id] = status
            rf_kill.close()

            # Write data to mergedMap.csv
            writer_map.writerow(data)

wf_map.close()
