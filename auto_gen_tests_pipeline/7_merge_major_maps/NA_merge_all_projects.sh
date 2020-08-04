#!/bin/bash

major_dir="/home/people/12309511/scratch/major_mutation_results"

for dir in $major_dir/*; do
	pid=$(echo "$dir" | rev | cut -d'/' -f1 | rev)

	for subdir in $dir/*; do
		vid=$(echo "$subdir" | rev | cut -d'/' -f1 | rev)
		
		echo $pid $vid
		# Call merge_map.sh
		# ./merge_map.sh $pid $vid
	
	done
done
