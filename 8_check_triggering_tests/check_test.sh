#!/bin/bash

pid=Cli
vid=14f
gen=evosuite
seed=1

merged_kmap="/home/people/12309511/merged_maps/${pid}/${vid}/mergedKillMap.csv"
merged_tmap="/home/people/12309511/merged_maps/${pid}/${vid}/mergedTestMap.csv"
trig_test="14f-evosuite-1-org.apache.commons.cli2.option.GroupImpl_ESTest.test16"

trig_test_id=$(grep "$merged_tmap" -e "$trig_test" | cut -d',' -f1)

echo $trig_test_id

kmap_row=$(grep "^${trig_test_id}," "$merged_kmap")

echo $kmap_row

#cat $merged_kmap | while read -r line; do
#	echo $line
#done
