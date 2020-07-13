#!/bin/bash

log_dir="/home/people/12309511/logging/dev_test_pipeline/redo_out"

mkdir --parents ${log_dir}

while read -r line; do

        if [ -n "$line" ] && [[ $line == *"TIMEOUT"* ]]; then

		f1=$(echo $line | cut -d" " -f1)
                pid=$(echo $f1 | cut -d"-" -f1)
                vid=$(echo $f1 | cut -d"-" -f2)
		
		job_name="${pid}-${vid}-dev-pipe-redo"
                log_file="${log_dir}/${pid}-${vid}-dev-redo"

		sbatch -J $job_name -o /dev/null -e ${log_file} SBATCH_redo_dev_tests.sh $pid ${vid}f

	fi
done < dev_pipeline_timeout.log
