#!/usr/bin/env bash
# ##################################################
# Function:
# Compare images
#
# Usage:
# Automatically called by system
# Example:
# ./compare.sh ../build ../build/result  /Volumes/Knowledge/Projects/seeta/photos/DSCF462.JPG
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

version="1.0.0"              # Sets version variable

[ -e tmp.txt ] && rm tmp.txt
[ -e filelist.txt ] && rm filelist.txt


build_dir=$1
eg_model=$build_dir/resources/model
dtc_model=${eg_model}/seeta_fd_frontal_v1.0.bin
alg_model=${eg_model}/seeta_fa_v1.1.bin
vrf_model=${eg_model}/seeta_fr_v1.0.bin
result_dir=$build_dir/result

featureFiles=$(find $2 -type f)
targetFile=$3
targetFeatureFile=$(basename $targetFile).txt

$build_dir/bin/extract_output ${dtc_model} ${alg_model} ${vrf_model} $targetFile $targetFeatureFile


for file in ${featureFiles[*]}
do
    $build_dir/bin/compare_features ${dtc_model} ${alg_model} ${vrf_model} $file $targetFeatureFile >> tmp.txt
    echo $file >> filelist.txt
done

paste tmp.txt filelist.txt | sort -n | tail -1 
# > result.txt

