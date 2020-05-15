#!/bin/bash

projects_dir=~/mutation_testing/defects4j/framework/projects

# Iterate through projects in framework/projects folder
for file in $(ls "$projects_dir"); do
        if [ -d "$projects_dir/$file" ] && [ "$file" != "lib" ]; then
                project=$file

                #Iterate through each active bug ID
                bug_ids_dir="$projects_dir/$file/commit-db"

                cat "$projects_dir/$file/commit-db" | while read line || [[ -n $line ]]; do
                        
                        bug_id=$(echo "$line" | cut -d, -f1)
                        
                        #Loop how many different versions we need 
                        #Try different criteria for Randoop and Evosuite
                        #Try catch and best effort policy

			for int in {1..5..1}; do
                                #evo_command="gen_tests.pl -g evosuite -p $project -v "${bug_id}"f -n $int -o ~/all_tests -b 600"
                        	sbatch nested_test_gen_SBATCH.sh evosuite $project $bug_id $int >> /dev/null
				sbatch nested_test_gen_SBATCH.sh randoop $project $bug_id $int >> /dev/null
			done
                done
        fi
done
