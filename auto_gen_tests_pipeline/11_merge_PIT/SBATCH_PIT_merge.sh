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

pit_dir="/home/people/12309511/scratch/pit_mutation_results/${pid}/${vid}"
valid_suites="/home/people/12309511/logging/10_stats/5gte_suite_bugs/${pid}-${vid}-suites"
out_dir="/home/people/12309511/scratch/PIT_valid_maps/${pid}/${vid}"
log_dir="/home/people/12309511/logging/11_PIT_merge"

mkdir -p ${out_dir}

# Setup master file structure
rm -f ${master}
master="${out_dir}/${pid}-${vid}-PITmerged.xml"

f_line=$(head -n1 "${valid_suites}")
gen=$(echo $f_line | cut -d"-" -f3)
seed=$(echo $f_line | cut -d"-" -f4)

# Iterate through file
file="${pit_dir}/${vid}-${gen}-${seed}-mutations.xml"

len=$(wc -l ${file} | cut -d" " -f1)
len="$(($len-1))"

for i in $(seq 3 $len); do 
	
	line=$(sed -n "${i}p" "${file}")
	
	class=$(echo $line | sed -e 's/.*<mutatedClass>\(.*\)<\/mutatedClass>.*/\1/')
	method=$(echo $line | sed -e 's/.*<mutatedMethod>\(.*\)<\/mutatedMethod>.*/\1/')
	lineNum=$(echo $line | sed -e 's/.*<lineNumber>\(.*\)<\/lineNumber>.*/\1/')
	mut=$(echo $line | sed -e 's/.*<mutator>\(.*\)<\/mutator>.*/\1/')
	idx=$(echo $line | sed -e 's/.*<index>\(.*\)<\/index>.*/\1/')
	block=$(echo $line | sed -e 's/.*<block>\(.*\)<\/block>.*/\1/')
	
	id="${class}-${method}-${lineNum}-${mut}-${idx}-${block}"
	
	echo "${id}," >> ${master}
done


# Iterate through valid suites
while read -r line; do
        gen=$(echo $line | cut -d"-" -f3)
        seed=$(echo $line | cut -d"-" -f4)

        current_map="${pit_dir}/${vid}-${gen}-${seed}-mutations.xml"

	# Iterate through valid suite map
	len=$(wc -l ${current_map} | cut -d" " -f1)
	len="$(($len-1))"

	for i in $(seq 3 $len); do 
		line=$(sed -n "${i}p" "${current_map}")

		class=$(echo $line | sed -e 's/.*<mutatedClass>\(.*\)<\/mutatedClass>.*/\1/')
		method=$(echo $line | sed -e 's/.*<mutatedMethod>\(.*\)<\/mutatedMethod>.*/\1/')
		lineNum=$(echo $line | sed -e 's/.*<lineNumber>\(.*\)<\/lineNumber>.*/\1/')
		mut=$(echo $line | sed -e 's/.*<mutator>\(.*\)<\/mutator>.*/\1/')
		idx=$(echo $line | sed -e 's/.*<index>\(.*\)<\/index>.*/\1/')
		block=$(echo $line | sed -e 's/.*<block>\(.*\)<\/block>.*/\1/')

		id="${class}-${method}-${lineNum}-${mut}-${idx}-${block}"

		# Get killing tests		
		k_tests=$(echo $line | sed -e 's/.*<killingTests>\(.*\)<\/killingTests>.*/\1/')

		if [[ ! -z "${k_tests// }" ]]; then
			# Add a suffix and comma to each test
			suffix="${vid}-${gen}-${seed}-"
			k_tests="${suffix}${k_tests}"
			k_tests=$(echo $k_tests | sed -e 's/|/,'${suffix}'/g')
			
			IFS=',' read -r -a array <<< "$k_tests"

			for string in "${array[@]}"; do

				# Get matching line in master, appending killing tests
				sed -i '/^'${id},'/s/$/'${string},'/' ${master}
			done
		fi
	done
done < ${valid_suites}

echo ${pid}-${vid} >> "/home/people/12309511/logging/11_PIT_merge/success_PIT_merge.log"

