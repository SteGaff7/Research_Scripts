#!/bin/bash

# Script that generates the all_test_methods file which contains all the relevant test methods for the mutation3 script to execute in it's mutation analysis

modified_classes=$1
all_tests=$2
all_test_methods=all_test_methods

if [ -f $all_test_methods ]; then
	rm all_test_methods
fi

# Read the modified classes
while read -r test_class; do
	echo $test_class >> $all_test_methods
	
	# Get the matching test methods for this modified class
	grep -F $test_class $all_tests | while read -r match; do
		
		test_method=$(echo $match | cut -d"(" -f1)
		echo ${test_method}"()" >> $all_test_methods
	done

done < $modified_classes
