#!/bin/bash -l
#SBATCH --job-name=12309511_nested_suite_generation

# speficity number of nodes 
#SBATCH -N 1

# specify number of tasks/cores per node required
#SBATCH --ntasks-per-node 3

# specify the walltime e.g 20 mins
#SBATCH -t 48:00:00

# set to email at start,end and failed jobs
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=stephen.gaffney@ucdconnect.ie

# run from current directory
cd $SLURM_SUBMIT_DIR

generator=$1
project=$2
bug_id=$3
test_id=$4

evo_command="gen_tests.pl -g $generator -p $project -v "${bug_id}"f -n $test_id -o ~/mutation_testing/all_test_suites -b 1200"

eval "$evo_command" || eval "$evo_command" || eval "$evo_command" || echo "$evo_command" >> ~/mutation_testing/failed_test_suite_generation.txt
