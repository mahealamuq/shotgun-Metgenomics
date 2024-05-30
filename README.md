# Shotgun Metagenomics for Gut Microbiome of cattle
Metagenomics is a vastly advancing field within microbial sciences, it provides a unique insight into the diversity of microbial communities. there are two sorts of metagenomics; 16s rRNA nmetagenomics and shotgun metagenomics. The shotgun metagenomics has beed focused in this project. . A basic understanding of the Linux command line and the R programming language will be beneficial, but we will introduce a lot of the basics here. we will analyse of samples (N = 9) from three anatomical sites: colon, cecum, and rumen. Illumina(Miseq) sequencing protocol used to produce paired end reads that are 250 nucleotides long. The perpose of this project was the microbiome composition of the rumen, cecum and colon at the genus level.
## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
## Installation
### Install fastqc for quality control statistics
```sh
sudo apt update
sudo apt install fastqc
```
### Install Trimmomatic for Trimming and Filtering Reads
```sh
sudo apt update
sudo apt install default-jdk
wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip
sudo unzip Trimmomatic-0.39.zip -d /opt
sudo ln -s /opt/Trimmomatic-0.39/trimmomatic-0.39.jar /usr/local/bin/trimmomatic.jar
#Create a Symbolic Link: To make it easier to run Trimmomatic from anywhere, create a symbolic link to the trimmomatic-0.39.jar file in a directory that is included #in your PATH, such as /usr/local/bin
sudo ln -s /opt/Trimmomatic-0.39/trimmomatic-0.39.jar /usr/local/bin/trimmomatic.jar
#Verify Installation: Verify that Trimmomatic is accessible by checking its version. You can run the following command:
java -jar /usr/local/bin/trimmomatic.jar
```
### Removing Host Derived Content
A large portion of DNA and RNA content in metagenomics samples obtained from host derived. It is advisable to delete host sequences from samples. There are many tools for this job, but I use BBDuck from the BBTools suite. In this case, we will use a reference genome for cattle (bos taurus) from NCBI and download it using wget command:
```sh
Wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/002/263/795/GCA_002263795.4_ARS-UCD2.0/GCA_002263795.4_ARS-UCD2.0_genomic.fna.gz
mkdir ~/bbtools
wget https://sourceforge.net/projects/bbmap/files/latest/download -O bbtools.tar.gz
tar -xzf bbtools.tar.gz
rm bbtools.tar.gz
cd bbmap/
./bbduk.sh -h
```
### Install metaphlan for taxonomic classification
```sh
pip install metaphlan
metaphlan --install
git clone 
