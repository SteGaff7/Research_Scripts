#!/bin/bash
pid="Time"

vids=(
	11f
	13f
	1f
	2f
	15f
	22f
	24f
	27f
	5f
)

for vid in "${vids[@]}"; do
	python3 reveal_faults_MAJOR.py $pid $vid
	python3 reveal_faults_PIT.py $pid $vid
	echo "***********************************"
done
