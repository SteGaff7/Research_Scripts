#!/bin/bash

k_map_dir=/home/people/12309511/scratch/major_mutation_results/Time/14f/kill_maps
vid=14f
gen=randoop
seed=4

echo "${vid}-${gen}-${seed}-*-*-killMap.csv"
find $k_map_dir -type f -name "${vid}-${gen}-${seed}-*-*-killMap.csv"
