import sys
import csv

'''
Mutant indices conveniently match mutant IDs
'''


def iterate_triggering_tests(trig_tests_file):
    triggering_tests_rf = open(trig_tests_file, 'r')
    with triggering_tests_rf:
        reader_trig_tests = csv.reader(triggering_tests_rf)
        for row in reader_trig_tests:
            # Get Id
            test_id = get_test_id(row[0])
            mutants_killed = get_mutants_killed(test_id)
            killed_by_trig_only = form_killed_by_trig_only(len(mutants_killed))

            print(mutants_killed, killed_by_trig_only)

            mutants_killed, killed_by_trig_only = check_all_tests(mutants_killed, killed_by_trig_only)
            print(mutants_killed, killed_by_trig_only)

    return


def get_test_id(trig_test):
    merged_t_map = "/home/people/12309511/merged_maps/" + PID + "/" + VID + "/mergedTestMap.csv"
    t_map_rf = open(merged_t_map, 'r')
    with t_map_rf:
        reader_t_map = csv.reader(t_map_rf)
        # Skip header
        next(reader_t_map)

        for row in reader_t_map:
            if row[1].strip() == trig_test.strip():
                trig_test_id = row[0]
                return trig_test_id


def get_mutants_killed(test_id):
    merged_k_map = "/home/people/12309511/merged_maps/" + PID + "/" + VID + "/mergedKillMap.csv"
    k_map_rf = open(merged_k_map, 'r')
    with k_map_rf:
        reader_k_map = csv.reader(k_map_rf)
        # Skip header
        next(reader_k_map)

        for row in reader_k_map:
            if row[0] == test_id:
                mutant_indices = []
                for i in range(1, len(row), +1):
                    if row[i] in ("EXC", "FAIL", "TIME"):
                        mutant_indices.append(i)
                return mutant_indices


def form_killed_by_trig_only(length):
    killed_by_trig_only = [True] * length
    return killed_by_trig_only


def check_all_tests(mutants_killed, killed_by_trig_only):
    merged_k_map = "/home/people/12309511/merged_maps/" + PID + "/" + VID + "/mergedKillMap.csv"
    k_map_rf = open(merged_k_map, 'r')
    with k_map_rf:
        reader_k_map = csv.reader(k_map_rf)
        # Skip header
        next(reader_k_map)

        for row in reader_k_map:
            print(row[0])
            # Check if triggering test
            if check_test_is_triggering(row[0]):
                # Go to next row
                continue
            else:
                # Check if same mutants are killed
                for i in range(0, len(mutants_killed), +1):
                    if killed_by_trig_only[i]:
                        if row[mutants_killed[i]] in ("EXC", "FAIL", "TIME"):
                            # Not only killed by triggering tests
                            killed_by_trig_only[i] = False

            if all_false(killed_by_trig_only):
                break

    return mutants_killed, killed_by_trig_only


def check_test_is_triggering(test_id):
    # Get test name from Id
    test_name = get_test_name(test_id)

    # Check that it is triggering test from test name
    triggering_tests_rf = open(TRIGGERING_TESTS, 'r')
    with triggering_tests_rf:
        reader_trig_tests = csv.reader(triggering_tests_rf)
        for row in reader_trig_tests:
            if row[0].strip() == test_name.strip():
                print("Same")
                return True
            else:
                return False


def get_test_name(test_id):
    merged_t_map = "/home/people/12309511/merged_maps/" + PID + "/" + VID + "/mergedTestMap.csv"
    t_map_rf = open(merged_t_map, 'r')
    with t_map_rf:
        reader_t_map = csv.reader(t_map_rf)
        # Skip header
        next(reader_t_map)

        for row in reader_t_map:
            if row[0] == test_id:
                test_name = row[1]
                return test_name


def all_false(killed_by_trig_only):
    for boolean in killed_by_trig_only:
        if boolean:
            return False
    return True


PID = sys.argv[1]
VID = sys.argv[2]

# Identify triggering test file e.g Trigs/Cli/10f/t_tests.csv

# Iterate through this file

TRIGGERING_TESTS = "/home/people/12309511/triggering_tests/" + PID + "/" + VID + "/test_version_trigs.txt"
dummy_file = ["14f-evosuite-1-org.apache.commons.cli2.option.GroupImpl_ESTest.test16"]

iterate_triggering_tests(TRIGGERING_TESTS)
