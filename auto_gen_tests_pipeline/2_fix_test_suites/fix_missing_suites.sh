#!/bin/bash

raw_suites="/home/people/12309511/test_suites/raw_suites"
fixed_suites="/home/people/12309511/test_suites/fixed_suites"

log_dir="/home/people/12309511/logging/2_fix_test_suites/failed_retry_suites"
mkdir -p $log_dir

while read -r line || [[ -n $line ]]; do

	pid=$(echo $line | cut -d'-' -f1)
	gen=$(echo $line | cut -d'-' -f3 | cut -d'.' -f1)
	seed=$(echo $line | cut -d'-' -f3 | cut -d'.' -f2)
	vid=$(echo $line | cut -d'-' -f2)

	file=${raw_suites}/${pid}/${gen}/${seed}/${pid}-${vid}-${gen}.${seed}.tar.bz2
	dir=${fixed_suites}/${pid}/${gen}/${seed}/

	#Copy file
	cp $file $dir
	
	#Run batch job to fix
	job_name=${pid}_${vid}_${gen}_${seed}_fix

	sbatch -J ${job_name} -o /dev/null -e "${log_dir}/${job_name}.error" SBATCH_fix_suite_by_vid.sh $pid $vid "${dir}/"


done < "/home/people/12309511/logging/2_fix_test_suites/missing_fixed_suites.log"
