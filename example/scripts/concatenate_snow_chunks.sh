#!/bin/bash

snow_directory="$1"
if [ ! -d "${snow_directory}" ]; then
    echo "Directory ${snow_directory} not found."
    echo 'Example Usage:    ./concatenate_snow_chunks.sh "snowblossom.7.chunked" > "snowblossom.7"'
    exit 1
fi
if [ ! -f "${snow_directory}/snowblossom."*".snow."* ]; then
    echo "Chunked files not found in ${snow_directory}."
    echo 'Expecting snowblossom.7/snowblossom.7.snow.0001 and such'
    exit 2
fi

for i in $(seq 0 127); do
    chunk=$(printf '%x\n' ${i})

    while [ ${#chunk} -lt 4 ]; do
        chunk="0${chunk}"
    done

    cat "${snow_directory}/snowblossom."*".snow.${chunk}"

done
