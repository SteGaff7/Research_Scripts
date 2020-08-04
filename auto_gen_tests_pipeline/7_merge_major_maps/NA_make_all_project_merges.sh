#!/bin/bash

major_results_dir="/home/people/12309511/scratch/major_mutation_results"

for project in $major_results_dir/*; do
	pid=$(echo "$project" | rev | cut -d'/' -f1 | rev)

	# REMOVE CONDITIONAL
	if [ "$pid" = "Codec" ]; then
	
	for version in $project/*; do
		vid=$(echo "$version" | rev | cut -d'/' -f1 | rev)
		
		python3 suite_killMap_merge.py $pid $vid
	done
	fi
done
