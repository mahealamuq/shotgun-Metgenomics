#!/bin/bash
#mkdir raw_data
cd raw_data
#Download the data from the SRA
#for x in 'SRR5738067' 'SRR5738068' 'SRR5738074' 'SRR5738079' 'SRR5738080' 'SRR5738085' 'SRR5738092' 'SRR5738091' 'SRR5738094'; do ~/sratoolkit.3.1.0-ubuntu64/bin/prefetch $x; done
#Extract FastQ files
#for x in 'SRR5738067' 'SRR5738068' 'SRR5738074' 'SRR5738079' 'SRR5738080' 'SRR5738085' 'SRR5738092' 'SRR5738091' 'SRR5738094'; do ~/sratoolkit.3.1.0-ubuntu64/bin/fastq-dump -I --split-files $x; done
#rename the files to something more illustrative
#mv SRR5738068_1.fastq 03-Colon_1.fastq 
#mv SRR5738068_2.fastq 03-Colon_2.fastq 
#mv SRR5738067_1.fastq 04-Colon_1.fastq 
#mv SRR5738067_2.fastq 04-Colon_2.fastq 
#mv SRR5738074_1.fastq 05-Colon_1.fastq 
#mv SRR5738074_2.fastq 05-Colon_2.fastq 
#mv SRR5738079_1.fastq 03-Cecum_1.fastq 
#mv SRR5738079_2.fastq 03-Cecum_2.fastq 
#mv SRR5738080_1.fastq 04-Cecum_1.fastq 
#mv SRR5738080_2.fastq 04-Cecum_2.fastq 
#mv SRR5738085_1.fastq 05-Cecum_1.fastq 
#mv SRR5738085_2.fastq 05-Cecum_2.fastq 
#mv SRR5738092_1.fastq 03_Rumen_1.fastq 
#mv SRR5738092_2.fastq 03_Rumen_2.fastq 
#mv SRR5738091_1.fastq 04_Rumen_1.fastq
#mv SRR5738091_2.fastq 04_Rumen_2.fastq 
#mv SRR5738094_1.fastq 05_Rumen_1.fastq 
#mv SRR5738094_2.fastq 05_Rumen_2.fastq  
#compress fastq files to save space
#gzip *fastq
#remove SRR file for save some space
#rm -r SRR*
#Quality control statistics
#make directory for  fastQC result
#mkdir fastQC_results
#run fastqc on all raw data, the asterisk matches any pattern and by adding .fastq.gz to the end 
#we ensure that only .fastq.gz files are matched
#fastqc *fastq.gz -o fastQC_results/
#Trimming and filtering Reads
# Ensure adapter sequence files are downloaded from trimmomatic github
#wget -nc -O NexteraPE-PE.fa https://github.com/timflutre/trimmomatic/blob/master/adapters/NexteraPE-PE.fa?raw=true
# I have written the bash script for trimming the paired-end reads. This bash script helps to 
# avoid repeating commanda  save in raw_data folder. script file_name: quality_trim.sh.
# I create a for loop to make processing these files a bit more simple.
#for s in '03-Colon_' '04-Colon_' '05-Colon_' '03-Cecum_' '04-Cecum_' '05-Cecum_' '03-Rumen_' '04-Rumen_' '05-Rumen_'; do 
#./quality_trim.sh $s\1.fastq.gz $s\2.fastq.gz $s\R1_trimmed.fastq.gz $s\1_unpaired.fastq.gz $s\R2_trimmed.fastq.gz $s\R2_unpaired.fastq.gz; done
#Removing Host Derived Content
#A large portion of DNA and RNA content in metagenomics samples obtained from host derived. 
#It is advisable to delete host sequences from samples. There are many tools for this job, 
#but I use BBDuck from the BBTools suite. In this case, 
#we will use a reference genome for cattle (bos taurus) from NCBI and download it using wget command:
#Wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/002/263/795/GCA_002263795.4_ARS-UCD2.0/GCA_002263795.4_ARS-UCD2.0_genomic.fna.gz
#For loop to process all samples
#for s in '03-Colon_' '04-Colon_' '05-Colon_' '03-Cecum_' '04-Cecum_' '05-Cecum_' '03-Rumen_' '04-Rumen_' '05-Rumen_'; do
#./bbtools/bbmap/bbduk.sh -Xmx4g \
#in=${s}R1_trimmed.fastq.gz \
#in2=${s}R2_trimmed.fastq.gz \
#out=${s}R1_depleted.fastq.gz \
#out2=${s}R2_depleted.fastq.gz \
#outs=${s}R3_depleted.fastq.gz \
#ref=bbtools/GCA_002263795.4_ARS-UCD2.0_genomic.fna.gz \
#mcf=0.5 \
#threads=2 \
#k=10
#done

#for Taxonomic classification, In this walkthrough we will run MetaPhlAn on the quality trimmed bovine metagenome data.
#To do so, we will use a Snakemake pipeline (implemented in Python) to make processing all samples easier. The pipeline 
#will be kept simple by only analyzing the paired end samples that have undergone quality trimming (another potential source 
#of data could be the unpaired reads that were produced as a result of quality trimming and/or host depletion).
#i havewritten bash script for metaphlan which name is "mph.snake".
#gunzip *trimmed.fastq.gz
snakemake --snakefile mph.snake --jobs 1 
