#!/bin/bash
# This is a script to quality trim files
# To run the script use ./quality_trim.sh R1.fastq.gz R2.fastq.gz output_paired1.fastq.gz output_unpaired1.fastq.gz output_paired2.fastq.gz output_unpaired2.fastq.gz
set -euxo pipefail

# Get which file to trim from the command line
raw_fastq1="$1"
raw_fastq2="$2"
out_paired1="$3"
out_unpaired1="$4"
out_paired2="$5"
out_unpaired2="$6"

# Ensure adapter sequence files are downloaded from trimmomatic github
#wget -nc -O NexteraPE-PE.fa https://raw.githubusercontent.com/timflutre/trimmomatic/master/adapters/NexteraPE-PE.fa

# Run Trimmomatic for quality trimming
java -jar /usr/local/bin/trimmomatic.jar PE -threads 4 \
  $raw_fastq1 $raw_fastq2 \
  $out_paired1 $out_unpaired1 \
  $out_paired2 $out_unpaired2 \
  ILLUMINACLIP:NexteraPE-PE.fa:2:30:10 \
  LEADING:3 TRAILING:3 HEADCROP:12 SLIDINGWINDOW:4:20 MINLEN:50
