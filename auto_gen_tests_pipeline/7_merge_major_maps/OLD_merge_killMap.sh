#!/bin/bash

project=$1
gen=$2
seed=$3
version=$4

dir="/home/people/12309511/major_mutation_results/Jsoup/evosuite/1/83f"

killMapDir="${dir}/kill_maps"

# Use mutants.log to generate headers

touch killMap.csv




echo $killMapDir

for k_map in ${killMapDir}/*; do
	echo $k_map
done
