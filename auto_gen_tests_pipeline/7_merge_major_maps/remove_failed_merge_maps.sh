#!/bin/bash

while read -r line; do
        echo $line
        pid=$(echo $line | cut -d"-" -f1)
        vid=$(echo $line | cut -d"-" -f2)

        partial_map="/home/people/12309511/scratch/merged_major_maps/${pid}/${vid}/${pid}-${vid}-mergedMap.csv"
	partial_dir="/home/people/12309511/scratch/merged_major_maps/${pid}/${vid}"

	#rm -f ${partial_map}
	rm -rf ${partial_dir}

done < timeout_merges.log

