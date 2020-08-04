import subprocess
import sys
import csv


def triggering_test(test):
    # Check t test file for method
    if test in open(TRIGGERING_TEST_FILE).read():
        return True

    return False


def exclusive_mutant(row):

    if len(row) <= 2:
        no_cov_writer.writerow([mutant_id])
        return False

    # Don't account for empty col after last ',' hence length - 1
    for i in range(1, len(row) - 1, 1):
        test = row[i]

        # Check if t test
        if not triggering_test(test):
            non_excl_writer.writerow([mutant_id])
            return False

    return True


PID = sys.argv[1]
VID = sys.argv[2]

# Identify triggering test file e.g triggering_tests/Cli/10f/Cli-10f-triggering_tests
TRIGGERING_TEST_FILE = "/home/people/12309511/triggering_tests/" + PID + "/" + VID + "/" + PID + "-" + VID + "-triggering_tests"

# Identify map file
MAP_FILE = "/home/people/12309511/scratch/merged_major_maps/" + PID + "/" + PID + "-" + VID + "-mergedMap.csv"

# File to write exclusive mutants
EXCLUSIVE = "/home/people/12309511/mutation_analysis/major/" + PID + "/" + VID + "/exclusive"

# File to write non-exclusive mutants
NON_EXCLUSIVE = "/home/people/12309511/mutation_analysis/major/" + PID + "/" + VID + "/non_exclusive"

# File to write mutants not covered
NO_COV = "/home/people/12309511/mutation_analysis/major/" + PID + "/" + VID + "/no_coverage"

subprocess.call(['mkdir', '--parents', "/home/people/12309511/mutation_analysis/major/" + PID + "/" + VID])

f_t_tests = open(TRIGGERING_TEST_FILE, "r")
f_map = open(MAP_FILE, "r")
f_exclusive = open(EXCLUSIVE, "w")
f_non = open(NON_EXCLUSIVE, "w")
f_no_cov = open(NO_COV, "w")

# For each mutant in map
with f_t_tests, f_map, f_exclusive, f_non, f_no_cov:
    excl_writer = csv.writer(f_exclusive)
    non_excl_writer = csv.writer(f_non)
    no_cov_writer = csv.writer(f_no_cov)

    t_test_reader = csv.reader(f_t_tests)
    map_reader = csv.reader(f_map)

    # Skip header
    next(map_reader)
    for r in map_reader:
        mutant_id = r[0]

        if exclusive_mutant(r):
            excl_writer.writerow([mutant_id])
