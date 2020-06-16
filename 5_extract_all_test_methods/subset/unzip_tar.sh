#!/bin/bash

pid=$1
gen=$2
seed=$3
vid=$4


mkdir -p ~/scratch/tmp_unzipped/${pid}/${gen}/${seed}/${vid}

tar -xvjf ~/test_suites/fixed_suites/${pid}/${gen}/${seed}/${pid}-${vid}-${gen}.${seed}.tar.bz2 -C ~/scratch/tmp_unzipped/${pid}/${gen}/${seed}/${vid} >> /dev/null 2>> /dev/null
