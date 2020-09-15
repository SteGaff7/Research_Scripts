#!/bin/bash

while read -r line; do
	pid=$(echo $line | cut -d"-" -f1)
	vid=$(echo $line | cut -d"-" -f2)
	
	job_name="${pid}-${vid}-merge_common_suites_PIT"

	echo "sbatch -J ${job_name} -o /dev/null -e /dev/null SBATCH_pit_merge.sh $pid $vid"

done < merge_common_bugs
