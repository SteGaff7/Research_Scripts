#!/bin/bash

pid=$1
suite_dir=$2

cmd="perl /home/people/12309511/defects4j/framework/util/fix_test_suite.pl -p $pid -d $suite_dir -A"

eval "$cmd" || echo "$cmd" >> /home/people/12309511/logging/2_fix_test_suites/failed_fix_suites.log
