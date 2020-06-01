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
				
				dir="${HOME}/mutation_testing/all_test_suites/${project}/"				

				evo_file_path="${dir}evosuite/${int}/${project}-${bug_id}f-evosuite.${int}.tar.bz2"
				if [ ! -f "$evo_file_path" ]; then
                        		echo "$evo_file_path" >> "${HOME}/missing_test_suites.txt"
				fi
				
				ran_file_path="${dir}randoop/${int}/${project}-${bug_id}f-randoop.${int}.tar.bz2"
				if [ ! -f "$ran_file_path" ]; then
					echo "$ran_file_path" >> "${HOME}/missing_test_suites.txt"
				fi
			done
                done
        fi
done
