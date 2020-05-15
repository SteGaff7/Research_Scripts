#!/bin/bash

dir=$1

for file in $dir/*; do
	
	#if [ "$file" != "${dir}/logs" ]; then
	if [ "$file" = "${dir}/Csv" ]; then
		for generator in $file/*; do
			if [ "$generator" = "${file}/evosuite" ]; then
				generator_str=$(echo "$generator" | rev | cut -d'/' -f1 | rev)
				for int in $generator/*; do
					if [ "$int" = "${generator}/1" ]; then
						int_str=$(echo "$int" | rev | cut -d'/' -f1 | rev)
						mkdir -p ~/test_unzips/${generator_str}/${int_str}
						for version in $int/*; do
							if [[ $version == *.tar.bz2 ]]; then
								version_id=$(echo "$version" | cut -f2 -d'-')
								mkdir -p ~/test_unzips/${generator_str}/${int_str}/${version_id}
								tar -xvjf "$version" -C ~/test_unzips/${generator_str}/${int_str}/${version_id}
							fi
						done
					fi
				done
			fi
		done
	fi
done
