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
#num_mutants=$(cat ${major_dir}/mutants.log | wc -l)

# Set up merged map
echo "Mutant ID, Killing tests" >> ${merged_map}
for (( i = 1; i <= $num_mutants; i++ )); do
	echo "${i}," >> ${merged_map}
done

# Iterate through each kill map in major results for project-vid
for file in ${major_dir}/kill_maps/*; do

	echo "$(echo $file | rev | cut -d"/" -f1 | rev)"

	if [[ $file == *-killMap.csv ]]; then

		gen=$(echo $file | cut -d"-" -f2)
		seed=$(echo $file | cut -d"-" -f3)		

		echo "${gen}-${seed} csv file"

		# Check if in valid common suites file
		if grep -q "${gen}-${seed}" "${valid_suites}"; then

			echo "${gen}-${seed} in valid suites"

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
				
				echo "RUnning sed"

				mut=$(echo $line | cut -d"," -f2)
				sed -i '/'\^${mut}\,'/s/$/'${test_name}\,'/' ${merged_map}
			done
			echo "FInished sed"
		fi
	fi
done

# Copy mutants log
cp ${major_dir}/mutants.log ${out_dir}/${pid}-${vid}-mutants.log
