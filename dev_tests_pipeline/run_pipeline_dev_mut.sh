#!/bin/bash

# Iterate through all projects and bugs and run SBATCH

projects=(
        Chart
        Cli
        Closure
        Codec
        Collections
        Compress
        Csv
        Gson
        JacksonCore
        JacksonDatabind
        JacksonXml
        Jsoup
        JxPath
        Lang
        Math
        Mockito
        Time
)

projects_dir="/home/people/12309511/defects4j/framework/projects"
log_dir="/home/people/12309511/logging/dev_test_pipeline/dev_pipeline_err_out"

mkdir --parents ${log_dir}

# Iterate through projects in framework/projects folder
for project in "${projects[@]}"; do
        p_dir="${projects_dir}/${project}"

        if [ -d "$p_dir" ]; then

		#Iterate through each active bug ID
                bugs_file="${p_dir}/commit-db"

                while read -r line || [[ -n $line ]]; do
                        bug_id=$(echo "$line" | cut -d, -f1)
			
			job_name="${project}-${bug_id}-dev-pipeline"
			log_file="${log_dir}/${project}-${bug_id}.err"
			# Sbatch
			sbatch -J $job_name -o /dev/null -e ${log_file} SBATCH_dev_tests.sh $project ${bug_id}f
                done < "$bugs_file"
        fi
done
