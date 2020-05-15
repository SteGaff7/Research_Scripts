#!/bin/bash -l
#SBATCH --job-name=subset_fix_suites

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


project=$1
suite_dir=$2

#fix_suite_command="perl ${HOME}/mutation_testing/defects4j/framework/util/fix_test_suite.pl -p $project -d $suite_dir"
perl ${HOME}/mutation_testing/defects4j/framework/util/fix_test_suite.pl -p "$project" -d "$suite_dir" || echo "$suite_dir" >> ~/failed_fix_suites.txt
