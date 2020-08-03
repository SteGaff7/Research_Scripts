#!/bin/bash -l

# speficity number of nodes 
#SBATCH -N 1

# specify number of tasks/cores per node required
#SBATCH --ntasks-per-node 1

# specify the walltime e.g 20 mins
#SBATCH -t 120:00:00

# set to email at start,end and failed jobs
#SBATCH --mail-type=NONE
#SBATCH --mail-user=stephen.gaffney@ucdconnect.ie

# run from current directory
cd $SLURM_SUBMIT_DIR

project="$1"
gen="$2"
seed="$3"
version="$4"

log_dir="/home/people/12309511/logging/9_PIT_mut_analysis"
suites="/home/people/12309511/test_suites/fixed_suites/${project}/${gen}/${seed}"
out_dir="/home/people/12309511/scratch/pit_mutation_results"

# Checkout project version temporarly to scratch space
tmp_dir=/home/people/12309511/scratch/PIT_temp_checkouts

defects4j checkout -p $project -v $version -w "${tmp_dir}/${project}_${version}_${gen}_${seed}" || echo "${project}_${version}_${gen}_${seed}" >> "${log_dir}/failed_checkouts"

# Switch to checkout as working directory
cd "${tmp_dir}/${project}_${version}_${gen}_${seed}"

# Compile project
defects4j compile || echo "${project}_${version}_${gen}_${seed}" >> "${log_dir}/failed_compiles"

# Run PIT
(run_pit.pl -p ${project} -o . -d ${suites} -v ${version}) || echo "${project}-${version}-${gen}-${seed}" >> "${log_dir}/failed_pit_suites.log"

# If mutations file exists (PIT worked)
if [ -f "mutation_log/${project}/${gen}/${version}-${seed}-pitReports/mutations.xml" ]; then

	# Make output directories
	mkdir -p ${out_dir}/${project}/${version}

	# Move matrix
	(cd mutation_log/${project}/${gen} && mv "${version}-${seed}-pitReports/mutations.xml" "${out_dir}/${project}/${version}/${version}-${gen}-${seed}-mutations.xml" && echo "${project}_${version}_${gen}_${seed}" >> "${log_dir}/success_pit_suites.log") || echo "${project}_${version}_${gen}_${seed}" >> "${log_dir}/not_moved.err"

else
	# No mutation file means error?
	# Avoid duplicates in error file
	if ! grep -Fxq "${project}-${version}-${gen}-${seed}" "${log_dir}/failed_pit_suites.log"; then
		echo "${project}-${version}-${gen}-${seed}" >> "${log_dir}/failed_pit_suites.log"
	fi
fi

# Remove temporary checkout
rm -rf "${tmp_dir}/${project}_${version}_${gen}_${seed}"
