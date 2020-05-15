#!/bin/bash

file=/home/people/12309511/unzipped/Cli_15f/org/apache/commons/cli2/commandline/WriteableCommandLineImpl_ESTest.java

basename "${file}"
dir=$(dirname "${file}")

project=Cli
version=15f

split="${project}_${version}"
echo $split

cut "${dir}" -d"/" 
