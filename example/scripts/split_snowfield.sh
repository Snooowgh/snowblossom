#!/bin/bash

snow_dir=$1
output_chunk_dir=$2
snowfield=$(basename -- "${snowfield_dir}"

if [ ! -d "${snow_dir}" ]; then
    echo "Directory ${snow_dir} not found."
    echo 'Example Usage:    ./split_snowfield.sh "snowblossom.7" "snowblossom.7.chunked"'
    exit 1
fi
if [ ! -f "${snow_dir}/${snowfield}.snow" ]; then
    echo "Snow file not found in ${snow_dir}"
    echo 'Expecting snowblossom.7/snowblossom.7.snow or similar.'
    exit 2
fi

mkdir -p "${output_chunk_dir}"

for i in $(seq 0 127); do
    offset=$((1024 * i))
    chunk=$(printf '%x\n' ${i})

    # left zero pad number
    while [ ${#chunk} -lt 4 ]; do
        name="0${chunk}"
    done
    echo "${chunk}"

    dd if="${snow_dir}/${snowfield}.snow" of="${output_chunk_dir}/${snowfield}.snow.${chunk}" skip=${offset} bs=1024k count=1024

done
