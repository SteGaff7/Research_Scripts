#!/bin/bash -l
#SBATCH --job-name=get_test_methods

# speficity number of nodes 
#SBATCH -N 1

# specify number of tasks/cores per node required
#SBATCH --ntasks-per-node 3

# specify the walltime e.g 20 mins
#SBATCH -t 24:00:00

# set to email at start,end and failed jobs
#SBATCH --mail-type=ALL
#SBATCH --mail-user=stephen.gaffney@ucdconnect.ie

# run from current directory
cd $SLURM_SUBMIT_DIR


#Iterate through all projects
#project="JacksonXml"

project="$1"

#Unzip each project
./unzip_project.sh "$project"

#Call the copy test scripts for the unzipped directory for each gen for each project
./copy_test_names.sh "$project"

#Delete the project dir when tests are retrieved
rm -rf /home/people/12309511/scratch/test_unzips/${project}
