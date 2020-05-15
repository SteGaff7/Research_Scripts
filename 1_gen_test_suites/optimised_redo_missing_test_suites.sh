#!/bin/bash


check_failed_commands () {
   `grep -F "$1" ~/mutation_testing/failed_test_suite_generation.txt  >/dev/null; return $?`
}


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


				evo_command="gen_tests.pl -g evosuite -p $project -v "${bug_id}"f -n $int"				

				evo_file_path="${dir}evosuite/${int}/${project}-${bug_id}f-evosuite.${int}.tar.bz2"
				if [ ! -f "$evo_file_path" ] && ! check_failed_commands "$evo_command"; then
                        		sbatch nested_test_gen_SBATCH.sh evosuite $project $bug_id $int >> "${HOME}/redo_log.txt"
					#echo "$evo_file_path" >> "${HOME}/missing_tests.txt"
					#echo Not in file
					#echo "$evo_command"
				fi

				
				ran_command="gen_tests.pl -g randoop -p $project -v "${bug_id}"f -n $int"
				
				ran_file_path="${dir}randoop/${int}/${project}-${bug_id}f-randoop.${int}.tar.bz2"
				if [ ! -f "$ran_file_path" ] && ! check_failed_commands "$ran_command"; then
					sbatch nested_test_gen_SBATCH.sh randoop $project $bug_id $int >> "${HOME}/redo_log.txt"
					#echo "$ran_file_path" >> "${HOME}/missing_tests.txt"
					#echo Not in file
					#echo "$ran_command"
				fi
			done
                done
        fi
done
