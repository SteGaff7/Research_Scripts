#!/bin/bash

all_suites="${HOME}/mutation_testing/cleaned_test_suites/"

for file in $(ls "$all_suites"); do
	if [ -d "$all_suites$file" ] && [ "$file" != "logs" ]; then
                project_dir="$all_suites$file/"
                project="$file"

                for generator in $(ls "$project_dir"); do

                	for test_id in $(ls "$project_dir$generator"); do

                        	suite_dir="$project_dir$generator/$test_id/"
	                        sbatch ./nested_fix_suite_SBATCH.sh "$project" "$suite_dir" >> "${HOME}/subset_log.text"
                                
                	done
                done
        fi
done
