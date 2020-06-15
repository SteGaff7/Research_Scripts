#!/bin/bash


read_properties_file() {
	pid=$1
	vid=$2
	gen=$3
	seed=$4
	file=$5

	#Read each line in file, if matches format then extract test method and append IDS

	# Remove target tests part
	tests=$(cat $file | cut -d" " -f3)
		
	# Multiple deliminted test names
	if [[ $tests == *";"* ]]; then
		make_trig_test_folder $pid $vid $gen $seed
		i=1
		while :; do
			test_name=$(echo $tests | cut -d";" -f"$i" | cut -d"(" -f1)
			
			if [[ $test_name == "" ]]; then
				break
			fi
			#echo $test_name
			write_test_to_file $pid $vid $gen $seed $test_name
			i=$((i+1))
		done
	# Single test in properties file
	else
		make_trig_test_folder $pid $vid $gen $seed
		test_name=$(echo $tests | cut -d"(" -f1)
		#echo $test_name
		write_test_to_file $pid $vid $gen $seed $test_name
	fi
}

make_trig_test_folder() {
	pid=$1
	vid=$2
	gen=$3
	seed=$4

	mkdir --parents "/home/people/12309511/triggering_tests/${pid}/${vid}"
}

write_test_to_file() {
	pid=$1
        vid=$2
        gen=$3
        seed=$4
	test_name=$5

	echo "${vid}-${gen}-${seed}-${test_name}" >> "/home/people/12309511/triggering_tests/${pid}/${vid}/${pid}-${vid}-triggering_tests"
}

# Location of all triggering tests for each suite
triggering_tests_dir="/home/people/12309511/triggering_tests"

for proj_dir in $triggering_tests_dir/*; do
        pid=$(echo "$proj_dir" | rev | cut -d'/' -f1 | rev)
	
	#Condtional remove
	if [ "$pid" = "Chart" ]; then

	for gen_dir in $proj_dir/*; do
		gen_str=$(echo "$gen_dir" | rev | cut -d'/' -f1 | rev)

		# Problem eith randoop atm
		#if [ "$gen_str" = "evosuite" ] || [ "$gen_str" = "randoop" ]; then
		if [ "$gen_str" = "evosuite" ]; then

			for seed_dir in $gen_dir/*; do
				seed=$(echo "$seed_dir" | rev | cut -d'/' -f1 | rev)

				for file_path in $seed_dir/*; do
					file=$(echo "$file_path" | rev | cut -d'/' -f1 | rev)

					if [[ $file == ${pid}-*-*.properties ]]; then
						echo "Working on file-" $file
						vid=$(echo $file | cut -d'-' -f2)
						
						# COnditional remove
						if [ "$vid" = 14f ]; then
						echo $vid
						read_properties_file $pid $vid $gen_str $seed $file_path
						fi
					fi
				done
			done
		fi
	done
	fi
done
        
