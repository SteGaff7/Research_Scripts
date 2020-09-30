#!/bin/bash -l

# speficity number of nodes 
#SBATCH -N 1

# specify number of tasks/cores per node required
#SBATCH --ntasks-per-node 4

# specify the walltime e.g 20 mins
#SBATCH -t 240:00:00

# set to email at start,end and failed jobs
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=stephen.gaffney@ucdconnect.ie

# run from current directory
cd "/home/people/12309511/scratch"
file="$1"

XZ_OPT=-e9 tar cJf "${file}.tar.xz" "${file}/"

