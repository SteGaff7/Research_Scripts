#!/bin/bash

# Combine all failed logs and timed out log too
# Check all bugs for dev suite?
# Increment counter

# Read valid bugs file
while read -r line; do
	# Search success file for valid bug
	echo $line
	# If found log to merge
	count=$(grep success_mut_suites.log -e "$line" | wc -l)
	if [ "$count" -eq 4 ]; then
		echo "4 suites, checking if dev suite exists"
		
		pid=$(echo $line | cut -d"-" -f1)
		vid=$(echo $line | cut -d"-" -f2)
		
		# Implement this better? -- Get sacct list of those that completed
		# If dev suite failed then still 4 and write to dont merge
		if grep -Fxq ${pid}_${vid} combined.log; then
			echo "Dev suite failed -- still only 4"
			echo "$line - $count" >> dont_merge.txt
		else
			echo "Dev suite success -- 5 suites"
			echo "$line - $count" >> merge.txt
		fi

	elif [ "$count" -gt 4 ]; then
		echo "Greater than 5"
		echo "$line - $count" >> merge.txt
	else
		echo "Not enoughs suites"
		echo "$line - $count" >> dont_merge.txt
	fi

done < valid_mut_bugs.log

