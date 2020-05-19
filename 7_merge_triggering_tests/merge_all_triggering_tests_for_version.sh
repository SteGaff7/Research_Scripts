#!/bin/bash

read_properties_file() {
	pid=$1
	vid=$2
	gen=$3
	seed=$4
	file=$5

	#Read each line in file, if matches format then extract test method and appedn ids etc
	#if [ "$gen" = "evosuite" ]; then
	
	#elif [ "$gen" = "randoop" ]; then

	#fi

		# Remove target tests part
		tests=$(cat $file | cut -d" " -f3)
		echo $tests
		# Multiple deliminted test names
		if [[ $tests == *";"* ]]; then
			i=1
			while :; do
				echo $i
				test_name=$(echo $tests | cut -d";" -f"$i" | cut -d"(" -f1)
				echo $test_name
				if [[ $test_name == "" ]]; then
					break
				fi
				i=$((i+1))
			done
		else
			test_name=$(echo $tests | cut -d"(" -f1)
			echo $test_name
		fi
}


triggering_tests_dir="/home/people/12309511/triggering_tests"

pid="Cli"

cli_dir="${triggering_tests_dir}/${pid}"

for gen_dir in $cli_dir/*; do
	gen_str=$(echo "$gen_dir" | rev | cut -d'/' -f1 | rev)
	if [ "$gen_str" = "evosuite" ] || [ "$gen_str" = "randoop" ]; then
		for seed_dir in $gen_dir/*; do
			seed=$(echo "$seed_dir" | rev | cut -d'/' -f1 | rev)
			for file_path in $seed_dir/*; do
				file=$(echo "$file_path" | rev | cut -d'/' -f1 | rev)
				if [[ $file == ${pid}-*-*.properties ]]; then
					echo $file
					vid=$(echo $file | cut -d'-' -f2)
					echo $vid
					read_properties_file $pid $vid $gen_str $seed $file_path
				fi
			done
		done
	fi
done
        
