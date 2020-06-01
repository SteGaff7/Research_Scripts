#!/bin/bash

p=Cli
g=evo

mkdir -p /home/people/12309511/${p}/${g}

for i in {1..4..1}; do
	sbatch -J "${p}_${g}_test" -o /home/people/12309511/${p}/${g}/%x.out -e /home/people/12309511/${p}/${g}/%x.error test_SBATCH.sh $i
done
