import sys

def triggering_test(test):
    # Check t test file for method
    if test in open(TRIGGERING_TEST_FILE).read():
        return True

    return False


PID = sys.argv[1]
VID = sys.argv[2]
test = sys.argv[3]

# Identify triggering test file e.g triggering_tests/Cli/10f/Cli-10f-triggering_tests
TRIGGERING_TEST_FILE = "/home/people/12309511/triggering_tests/" + PID + "/" + VID + "/" + PID + "-" + VID + "-triggering_tests"


print(triggering_test(test))
