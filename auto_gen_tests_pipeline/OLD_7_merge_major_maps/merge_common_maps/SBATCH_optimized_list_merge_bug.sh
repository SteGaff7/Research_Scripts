#!/bin/bash -l

# speficity number of nodes 
#SBATCH -N 1

# specify number of tasks/cores per node required
#SBATCH --ntasks-per-node 1

# specify the walltime e.g 20 mins
#SBATCH -t 240:00:00

# set to email at start,end and failed jobs
#SBATCH --mail-type=NONE
#SBATCH --mail-user=stephen.gaffney@ucdconnect.ie

# run from current directory
cd $SLURM_SUBMIT_DIR

pid=$1
vid=$2

major_dir="/home/people/12309511/scratch/major_mutation_results/${pid}/${vid}"
out_dir="/home/people/12309511/scratch/MAJOR_valid_maps/${pid}/${vid}"
merged_map="${out_dir}/${pid}-${vid}-mergedMap.csv"
valid_suites="/home/people/12309511/logging/10_stats/5gte_suite_bugs/${pid}-${vid}-suites"

mkdir -p ${out_dir}
rm -f ${merged_map}

# Get number of mutants
num_mutants=$(tail -n1 ${major_dir}/mutants.log | cut -d':' -f1)

# Set up merged map
echo "Mutant ID, Killing tests" >> ${merged_map}
for (( i = 1; i <= $num_mutants; i++ )); do
	echo "${i}," >> ${merged_map}
done

while read -r line; do
	gen=$(echo $line | cut -d"-" -f3)
	seed=$(echo $line | cut -d"-" -f4)

	# Iterate through each kill map in major results for project-vid
	for file in ${major_dir}/kill_maps/${vid}-${gen}-${seed}*-killMap.csv; do

			test_name=$(echo "$file" | rev | cut -d'/' -f1 | rev)
			test_name=${test_name%-killMap.csv}

			# Change test name
			if [[ $test_name == *-dev-dev-* ]]; then
				# Dev test
				test_class=$(echo $test_name | cut -d'-' --output-delimiter='-' -f1-4)
				test_method=$(echo $test_name | cut -d'-' -f5)
				test_name=${test_class}::${test_method}
			else
				# Non-dev test
				test_class=$(echo $test_name | cut -d'-' --output-delimiter='-' -f1-4)
				test_method=$(echo $test_name | cut -d'-' -f5)
				test_name=${test_class}.${test_method}
			fi

			# Read kill map, skipping header
			sed -e 1d $file | while read -r line; do

				mut=$(echo $line | cut -d"," -f2)
				sed -i '/'\^${mut}\,'/s/$/'${test_name}\,'/' ${merged_map}
			done

	done

done < ${valid_suites}

# Copy mutants log
cp ${major_dir}/mutants.log ${out_dir}/${pid}-${vid}-mutants.log

echo ${pid}-${vid} > "/home/people/12309511/logging/7_merge_major_maps/MAJOR_valid_suites_merge/success_merge.log"
