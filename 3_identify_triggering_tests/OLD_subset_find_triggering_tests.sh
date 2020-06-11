#!/bin/bash

is_fixed_test_suite () {
	project="$1"
	gen="$2"
	test_id="$3"

	flag='######  End fixing tests'

	if [ "$(tail -n 1 ~/mutation_testing/cleaned_test_suites/"$project"/"$gen"/"$test_id"/fix_test_suite.summary.log | grep -c "$flag")" = "1" ]; then
		return 0
	else
		return 1
	fi
}

dir=~/mutation_testing/cleaned_test_suites/

for file in $(ls "$dir"); do
	if [ -d "$dir$file" ] && [ "$file" != "logs" ] && [ "$file" = "Chart" ]; then
		project_dir="$dir$file/"
		project="$file"

		for generator in $(ls "$project_dir"); do

                        for test_id in $(ls "$project_dir$generator"); do
				
				if [ "$test_id" != "all" ]; then
	                                suite_dir="$project_dir$generator/$test_id/"
                               				
					if is_fixed_test_suite "$project" "$generator" "$test_id" ; then
						#sbatch
						sbatch ./nested_run_bug_detection_thomas_SBATCH.sh "$project" "$suite_dir" "$generator" "$test_id"
					fi
				fi
                        done
                done
	fi
done
