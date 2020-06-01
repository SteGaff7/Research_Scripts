#!/bin/bash

log_dir=/home/people/12309511/logging/1_gen_test_suites

while read -r line || [[ -n $line ]]; do
	if [[ $line == "gen_tests.pl -g "* ]]; then
		gen=$(echo $line | cut -d" " -f3)
		pid=$(echo $line | cut -d" " -f5)
		vid=$(echo $line | cut -d" " -f7)
		vid=$(echo $vid | cut -d"f" -f1)
		seed=$(echo $line | cut -d" " -f9)
		
		proj_log_dir=${log_dir}/${pid}
		
		mkdir -p "${proj_log_dir}/outputs2"
                mkdir -p "${proj_log_dir}/errors2"
		
		job_name=${pid}_${vid}_${gen}_${seed}
		
                sbatch -J ${job_name}_gen --output "${proj_log_dir}/outputs2/${job_name}.out" --error "${proj_log_dir}/errors2/${job_name}.error" SBATCH_gen_test_suite.sh $gen $pid $vid $seed

	fi
done < /home/people/12309511/logging/1_gen_test_suites/failed_gen_test_suites.log
