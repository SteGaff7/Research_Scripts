#!/bin/bash

dir="${HOME}/mutation_testing/all_test_suites/Closure/evosuite/1/"
project="Closure"
bug_id="152"
gen="evosuite"
int="1"

file="${project}-${bug_id}f-${gen}.${int}.tar.bz2"

echo "${dir}${file}"

full_path=$dir$file

if [ -f "$full_path" ]; then
	echo exists!
fi
