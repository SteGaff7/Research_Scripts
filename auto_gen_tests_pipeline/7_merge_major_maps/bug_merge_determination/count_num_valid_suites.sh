#!/bin/bash


major_dir="/home/people/12309511/scratch/major_mutation_results/"
valid_bugs="/home/people/12309511/scripts/auto_gen_tests_pipeline/7_merge_major_maps/bug_merge_determination/valid_mut_bugs.log"

for dir in ${major_dir}/*; do
	pid=$(echo "$dir" | rev | cut -d'/' -f1 | rev)
	for subdir in ${dir}/*; do
		vid=$(echo "$subdir" | rev | cut -d'/' -f1 | rev)

		kmap_dir="${subdir}/kill_maps"
		cd $kmap_dir
		num_suites=$(ls | cut -d"-" -f2,3 | sort -u | wc -l)
		
		if [ "$num_suites" -gt 4 ]; then
			echo $pid $vid $num_suites - Greater than 4

			if grep -Fxq ${pid}-${vid} ${valid_bugs}; then
				echo $pid-$vid - Valid suite
				echo $pid-$vid-$num_suites >> ~/merge_bugs.log
			else
				echo $pid-$vid - Not a valid suite
				echo $pid-$vid-$num_suites >> ~/dont_merge_bugs.log
			fi
		else
			echo $pid $vid $num_suites - Less than 5
                        echo $pid-$vid-$num_suites >> ~/dont_merge_bugs.log
		fi
	done
done
