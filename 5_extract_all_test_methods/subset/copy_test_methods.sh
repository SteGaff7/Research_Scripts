#!/bin/bash

find_java_files_recur () {
	dir=$1
	for file in $dir/*; do
		if [ -d "$file" ]; then
			find_java_files_recur "$file" $2 $3 $4 $5
		else
			check_file_type "$file" $2 $3 $4 $5
		fi
	done
}

check_file_type () {
	file=$1
	
	if [[ ${file} != *"scaffolding.java"* ]] && [[ ${file} = *".java" ]]; then
		search_for_tests "$file" $2 $3 $4 $5
	fi
}

search_for_tests () {
	file=$1
	pid=$2
	gen=$3
	seed=$4
	vid=$5

	package=""

	if [ "$gen" = "evosuite" ]; then
		package=$(grep "$file" -e "package" | cut -d " " -f2)
		package=$(echo "${package//;}")
		package="${package}." 	
	fi

	grep "$file" -e "public" | while read -r line; do
		result=$( echo "$line" | cut -d" " -f3)
		if [ -n "$result" ] && [[ $result == *"Test"* ]]; then
			echo "${package}${result}" >> /home/people/12309511/all_test_methods/${pid}/${gen}/${seed}/${vid}/test_methods.txt 
		elif [ -n "$result" ] && [[ $result == *"test"* ]]; then
			echo "${result}" >> /home/people/12309511/all_test_methods/${pid}/${gen}/${seed}/${vid}/test_methods.txt
		fi
	done
}

pid=$1
gen=$2
seed=$3
vid=$4

vid_dir=/home/people/12309511/scratch/tmp_unzipped/${pid}/${gen}/${seed}/${vid}

mkdir -p /home/people/12309511/all_test_methods/${pid}/${gen}/${seed}/${vid}

find_java_files_recur "$vid_dir" "$pid" "$gen" "$seed" "$vid"
