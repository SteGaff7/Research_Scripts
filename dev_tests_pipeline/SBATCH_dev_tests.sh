#!/bin/bash -l

# speficity number of nodes 
#SBATCH -N 1

# specify number of tasks/cores per node required
#SBATCH --ntasks-per-node 1

# specify the walltime e.g 20 mins
#SBATCH -t 72:00:00

# set to email at start,end and failed jobs
#SBATCH --mail-type=NONE
#SBATCH --mail-user=stephen.gaffney@ucdconnect.ie

# run from current directory
#cd $SLURM_SUBMIT_DIR

log_exit () {
	local log_file=$1
	local message=$2

	# Log error
	mkdir --parents ${log_dir}
	echo $message >> ${log_dir}/${log_file}

	# Remove tmp checkout
	rm -rf "${checkouts_dir}/${checkout}"
	
	# Exit with failure exit code
	exit 1
}


log_dir="/home/people/12309511/logging/dev_test_pipeline"
submit_dir=$(pwd)

pid=$1
vid=$2

# Checkout project
checkouts_dir=/home/people/12309511/scratch/dev_checkouts
mkdir --parents $checkouts_dir

cd $checkouts_dir

checkout=${pid}_${vid}
(defects4j checkout -p $pid -v $vid -w ./${checkout}) || log_exit "dev_checkout.err" "$checkout"

cd $checkout

# Compile Project
(defects4j compile) || log_exit "dev_compile.err" "$checkout"


# Generate all_tests file (all methods)
(defects4j test) || log_exit "dev_test.err" "$checkout"


# Get triggering test methods
dev_t_test_dir=/home/people/12309511/dev_triggering_tests/${pid}/${vid}/
(defects4j export -p tests.trigger -o ./t_test_methods && mkdir --parents ${dev_t_test_dir} && cp t_test_methods ${dev_t_test_dir}/${pid}-${vid}-triggering_tests) || log_exit "dev_export_tt.err" "$checkout"


# Get all modified test classes
(defects4j export -p tests.relevant -o ./modified_test_classes) || log_exit "dev_export_mod_classes.err" "$checkout"


# Use all_tests and modified_test_classes to generate a file with all_test_methods
dev_all_t_methods=/home/people/12309511/dev_all_test_methods/${pid}/${vid}/
(${submit_dir}/get_all_test_methods.sh modified_test_classes all_tests && mkdir --parents ${dev_all_t_methods} && cp all_test_methods ${dev_all_t_methods}/test_methods.txt) || log_exit "dev_get_all_t_methods.err" "$checkout"


# Run mutation analysis
(defects4j mutation3 -p $pid -v $vid -t x::x) || log_exit "dev_major_mut_analysis" "$checkout"

# Remove tmp checkout
rm -rf "${checkouts_dir}/${checkout}"

