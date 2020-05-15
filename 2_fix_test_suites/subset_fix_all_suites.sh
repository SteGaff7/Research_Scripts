#!/bin/bash

all_suites="${HOME}/mutation_testing/cleaned_test_suites/"

for file in $(ls "$all_suites"); do
	if [ -d "$all_suites$file" ] && [ "$file" != "logs" ] && [ "$file" = "JacksonXml" ]; then
		project_dir="$all_suites$file/"
		project="$file"
		
		for generator in $(ls "$project_dir"); do
			
			if [ "$generator" = "randoop" ]; then
				for test_id in $(ls "$project_dir$generator"); do
					
					if [ "$test_id" = "2" ]; then
						suite_dir="$project_dir$generator/$test_id/"
			
						sbatch ./nested_fix_suite_SBATCH.sh "$project" "$suite_dir" >> "${HOME}/subset_log.text"
					fi
				done
			fi
		done
		
	fi
done

