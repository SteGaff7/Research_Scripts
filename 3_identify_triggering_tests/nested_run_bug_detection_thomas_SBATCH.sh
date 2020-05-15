#!/bin/bash -l
#SBATCH --job-name=run_bug_det_tom_subset

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

project="$1"
suite_dir="$2"
gen="$3"
test_id="$4"

run_bug_detection_thomas.pl -p "$project" -d "$suite_dir" -o "${HOME}"/triggering_tests/"$project"/"$gen"/"$test_id"/ || echo "$suite_dir" >> ~/temp_failed_logs/failed_run_bug_detection_thomas
