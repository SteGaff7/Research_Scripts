#!/bin/bash

projects=(
        Chart
        Cli
        Closure
        Codec
        Collections
        Compress
        Csv
        Gson
        JacksonCore
        JacksonDatabind
        JacksonXml
        Jsoup
        JxPath
        Lang
        Math
        Mockito
        Time
)

for str in "${projects[@]}"; do
        sbatch ./get_all_tests.sh "$str"
done
