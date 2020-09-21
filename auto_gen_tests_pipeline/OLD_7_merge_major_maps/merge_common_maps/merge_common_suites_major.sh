#!/bin/bash

while read -r line; do
	pid=$(echo $line | cut -d"-" -f1)
	vid=$(echo $line | cut -d"-" -f2)
	
	job_name="${pid}-${vid}-merge_common_suites_MAJOR"

	sbatch -J ${job_name} -o /dev/null -e /dev/null SBATCH_optimized_list_merge_bug.sh $pid $vid

done < merge_common_bugs
