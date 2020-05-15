#!/bin/bash

#Iterate through all projects
project="JacksonXml"

#Unzip each project
./unzip_project.sh "$project"

#Call the copy test scripts for the unzipped directory for each gen for each project
./copy_test_names.sh "$project"

#Delete the project dir when tests are retrieved
rm -rf /home/people/12309511/scratch/test_unzips/${project}
