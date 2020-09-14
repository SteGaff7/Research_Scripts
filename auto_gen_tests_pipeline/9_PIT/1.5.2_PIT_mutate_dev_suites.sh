#!/bin/bash

projects=(
        Chart
        Cli
        Closure
        Codec
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

# Iterate through projects in framework/projects folder
for project in "${projects[@]}"; do
        
        tmp_log_dir="/home/people/12309511/scratch/tmp_logging/PIT_dev_mut/${project}"
        mkdir --parents $tmp_log_dir

	p_dir="${projects_dir}/${project}"

        if [ -d "$p_dir" ]; then

                #Iterate through each active bug ID
                bugs_file="${p_dir}/commit-db"

                while read -r line || [[ -n $line ]]; do

                        bug_id=$(echo "$line" | cut -d, -f1)
			bug_id=$(echo ${bug_id}f)
                        
			# If vid is in trig tests dir then run mut otherwise don't
                        if [ -d /home/people/12309511/triggering_tests/${project}/${bug_id} ]; then
				job_name="${project}-dev-${bug_id}-PIT-mutation-1.5.2-Run2"

                                # Run mut HERE
                                sbatch --exclude=sonic37 -J ${job_name} -o /dev/null -e ${tmp_log_dir}/${job_name}.out SBATCH_1.5.2_PIT_dev_mutation.sh $project $bug_id
                       fi

                done < "$bugs_file"
        fi
done

