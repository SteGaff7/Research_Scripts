#!/bin/bash

project_dir=/home/people/12309511/test_suites/fixed_suites/Lang/randoop/5
for version in $project_dir/*; do
	if [[ $version == *.tar.bz2 ]]; then
        	vid=$(echo "$version" | cut -f2 -d'-')
		sbatch -J Lang_ran_5_${vid}_retry -o /dev/null -e /dev/null SBATCH_new.sh Lang randoop 5 $vid
        fi
done
