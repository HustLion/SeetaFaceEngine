#!/usr/bin/env bash
# ##################################################
# Function:
# Extract features from multiple files
#
# Usage:
# call with the path of images
# 
# Example:
# ./extract.sh ../build /Volumes/Knowledge/Projects/seeta/photos
#
# Copyright © 2016 Hustlion (hustlionm@qq.com)
#
#
# HISTORY:
#
# * 10-28-2016 - v1.0.0  - First Creation
#
# Known Bugs:
# 
#
#
# TODO:
# 
# ##################################################

version="1.0."              # Sets version variable

build_dir=$1
eg_model=$build_dir/resources/model
dtc_model=${eg_model}/seeta_fd_frontal_v1.0.bin
alg_model=${eg_model}/seeta_fa_v1.1.bin
vrf_model=${eg_model}/seeta_fr_v1.0.bin
result_dir=$build_dir/result

files=$(find $2 -type f)

echo $build_dir
echo ${result_dir}

for file in ${files[*]}
do
    echo $file
    echo ${result_dir}/$(basename $file .JPG).txt
    $build_dir/bin/extract_output ${dtc_model} ${alg_model} ${vrf_model} $file ${result_dir}/$(basename $file .JPG).txt
done





