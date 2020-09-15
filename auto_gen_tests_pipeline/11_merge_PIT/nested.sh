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

# Pass project and bug id
pid=$1
vid=$2

# Iterate through valid suites
pit_dir="/home/people/12309511/scratch/pit_mutation_results/${pid}/${vid}"
valid_suites="/home/people/12309511/logging/10_stats/5gte_suite_bugs/${pid}-${vid}-suites"
out_dir="/home/people/12309511/scratch/PIT_valid_maps/${pid}/${vid}"
log_dir="/home/people/12309511/logging/11_PIT_merge"

mkdir -p ${out_dir}

# Set flag
first_run=true

while read -r line; do
	gen=$(echo $line | cut -d"-" -f3)
	seed=$(echo $line | cut -d"-" -f4)

	current_map="${pit_dir}/${vid}-${gen}-${seed}-mutations.xml"
	
	if [ "$first_run" = true ]; then
		echo "First run"
		first_run=false
		
		# Copy xml file for master map
		master="${out_dir}/${pid}-${vid}-PITmerged.xml"
		cp "${current_map}" "${master}"

		# Copy a template to iterate through
		template="${out_dir}/template.xml"
		cp "${current_map}" "${template}"
		
	else
		# Append to master
		echo "Not first run" $gen $seed
		
		# Iterate through the template file to get the mutants
		while read -r line; do
			mutant=$(echo $line | grep "<mutatedClass>.*</block>")
			mut_id=$(echo $mutant | grep -o "<mutatedClass>.*</block>")
			killing_tests=$(echo "$mutant" | sed -e 's/.*<killingTests>\(.*\)<\/killingTests>.*/\1/')
			# Could add succeeding tests too if needed
			echo $mutant
			echo ""
			echo $mut_id
			echo ""
			if [[ ! -z "${killing_tests// }" ]]; then
				echo $killing_tests
				name="${vid}-${gen}-${seed}-"
				# Replace first test
				killing_tests="${name}${killing_tests}"
				echo $killing_tests
				# Replace each other case using '|'
				killing_tests=$(echo $killing_tests | sed -e 's/|/,'${name}'/g')
				echo ""
				echo $killing_tests
			else
				echo "Empty"
			fi
			echo ""
			echo ""
		done < ${template}

	fi

done < ${valid_suites}

rm -f ${template}
# Echo Success
#echo ${pid}-${vid} > "/home/people/12309511/logging/7_merge_major_maps/MAJOR_valid_suites_merge/success_merge.log"
