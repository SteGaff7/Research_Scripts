#!/bin/bash

project=Time
version=1f
#seed=4
gen=randoop

# Checkout and switch to Dir
defects4j checkout -p ${project} -v ${version} -w ~/scratch/temp_checkouts/${project}_${version}
cd ~/scratch/temp_checkouts/${project}_${version}

for seed in {1..5}; do
	tests_file=/home/people/12309511/all_tests/${project}/${gen}/${seed}/${version}/tests.txt
	echo "$tests_file"

	while read -r line || [[ -n "$line" ]]; do
		#echo "$line"

		if [ -n "$line" ] && [[ $line == *"Test"* ]]; then
			test_class="$line"
		elif [ -n "$line" ] && [[ $line == *"test"* ]]; then
			test_method="$line"
			test_method=$(echo "$test_method" | tr -d '()')

			test=${test_class}::${test_method}
			echo "$test"

			# Run
			defects4j mutation -t ${test} -s ~/mutation_testing/cleaned_test_suites/${project}/${gen}/${seed}/${project}-${version}-${gen}.${seed}.tar.bz2
			#echo "defects4j mutation -t ${test} -s ~/mutation_testing/cleaned_test_suites/${project}/${gen}/${seed}/${project}-${version}-${gen}.${seed}.tar.bz2"
		fi

	done < "$tests_file"
done
