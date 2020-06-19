#!/bin/bash -l

# speficity number of nodes 
#SBATCH -N 1

# specify number of tasks/cores per node required
#SBATCH --ntasks-per-node 1

# specify the walltime e.g 20 mins
#SBATCH -t 24:00:00

# set to email at start,end and failed jobs

# run from current directory
cd $SLURM_SUBMIT_DIR

pid=$1
gen=$2
seed=$3
vid=$4

#Unzip tar
./unzip_tar.sh $pid $gen $seed $vid || echo ${vid} >> ~/my_unzip.log

#Copy test methods
./copy_test_methods.sh $pid $gen $seed $vid || echo ${vid} >> ~/my_copy.log
