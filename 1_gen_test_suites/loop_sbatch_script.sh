#!/bin/bash

for i in {1..3..1}; do
	sbatch nested_test_gen_SBATCH.sh evosuite Lang 3 $i
done
