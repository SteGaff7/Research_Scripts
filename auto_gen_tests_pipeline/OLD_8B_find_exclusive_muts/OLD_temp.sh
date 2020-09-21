#!/bin/bash

for i in {1..22}; do
	echo $i
	python3 check_map.py JxPath $i
done
