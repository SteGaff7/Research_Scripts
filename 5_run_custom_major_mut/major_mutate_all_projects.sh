#!/bin/bash

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
# Location of fixed test suites
dir="/home/people/12309511/mutation_testing/cleaned_test_suites/"

# Iterate through all fixed test suites
for project in "${projects[@]}"; do
	project_dir="${dir}${project}"

	# Iterate through generators
	for generator in $project_dir/*; do
	        generator_str=$(echo "$generator" | rev | cut -d'/' -f1 | rev)

		# Iterate through seeds
        	for seed in $generator/*; do
                	seed_str=$(echo "$seed" | rev | cut -d'/' -f1 | rev)

			# 
			for version in $seed/*; do
       		                if [[ $version == *.tar.bz2 ]]; then
                	                version_id=$(echo "$version" | cut -f2 -d'-')
					sbatch SBATCH_mutation2_test_suite.sh $project $generator_str $seed_str $version_id
				fi
			done
		done
	done
done           
