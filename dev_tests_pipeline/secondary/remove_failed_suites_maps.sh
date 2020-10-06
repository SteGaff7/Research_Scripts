#!/bin/bash

while read -r line; do
	echo $line
	pid=$(echo $line | cut -d"_" -f1)
	vid=$(echo $line | cut -d"_" -f2)

	major_dir=/home/people/12309511/scratch/major_mutation_results
	
	project_dir=${major_dir}/${pid}
	bug_dir=${project_dir}/${vid}
	
	k_map_dir="${bug_dir}/kill_maps"
	t_map_dir="${bug_dir}/test_maps"
	summ_dir="${bug_dir}/summaries"

	# Use find command with -delete option
	find $k_map_dir -type f -name "${vid}-dev-dev-*-*-killMap.csv" -delete
	find $t_map_dir -type f -name "${vid}-dev-dev-*-*-testMap.csv" -delete
	find $summ_dir -type f -name "${vid}-dev-dev-*-*-summary.csv" -delete

done < dev_remove.log
