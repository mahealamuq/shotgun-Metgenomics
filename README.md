# Shotgun Metagenomics for Gut Microbiome of cattle
Metagenomics is a vastly advancing field within microbial sciences, it provides a unique insight into the diversity of microbial communities. there are two sorts of metagenomics; 16s rRNA nmetagenomics and shotgun metagenomics. The shotgun metagenomics has beed focused in this project. . A basic understanding of the Linux command line and the R programming language will be beneficial, but we will introduce a lot of the basics here. we will analyse of samples (N = 9) from three anatomical sites: colon, cecum, and rumen. Illumina(Miseq) sequencing protocol used to produce paired end reads that are 250 nucleotides long. The perpose of this project was the microbiome composition of the rumen, cecum and colon at the genus level.
## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
## Installation
```sh
#install fastqc for quality control statistics
sudo apt update
sudo apt install fastqc
# install Trimmomatic for Trimming and Filtering Reads
sudo apt update
sudo apt install default-jdk
wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip
sudo unzip Trimmomatic-0.39.zip -d /opt
sudo ln -s /opt/Trimmomatic-0.39/trimmomatic-0.39.jar /usr/local/bin/trimmomatic.jar
#Create a Symbolic Link: To make it easier to run Trimmomatic from anywhere, create a symbolic link to the trimmomatic-0.39.jar file in a directory that is included #in your PATH, such as /usr/local/bin
sudo ln -s /opt/Trimmomatic-0.39/trimmomatic-0.39.jar /usr/local/bin/trimmomatic.jar
#Verify Installation: Verify that Trimmomatic is accessible by checking its version. You can run the following command:
java -jar /usr/local/bin/trimmomatic.jar
#install metaphlan for taxonomic classification
pip install metaphlan
metaphlan --install
git clone 
