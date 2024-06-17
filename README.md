# Shotgun Metagenomics Pipeline
Metagenomics is a vastly advancing field within microbial sciences, it provides a unique insight into the diversity of microbial communities. there are two sorts of metagenomics; 16s rRNA nmetagenomics and shotgun metagenomics. The shotgun metagenomics has beed focused in this project. . A basic understanding of the Linux command line and the R programming language will be beneficial, but we will introduce a lot of the basics here. we will analyse of samples (N = 9) from three anatomical sites: colon, cecum, and rumen. Illumina(Miseq) sequencing protocol used to produce paired end reads that are 250 nucleotides long. The perpose of this project was the microbiome composition of the rumen, cecum and colon at the genus level.
This repository contains a Bash script for processing shotgun metagenomics data. The script downloads sequence data, performs quality control, trims adapters, removes host DNA, and runs a taxonomic profiling analysis using MetaPhlAn.
## Table of Contents
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Pipeline Steps](#pipeline-steps)
- [Output](#output)
- [Contributing](#contributing)
- [License](#license)

## Requirements
For upstream analysis
- Ubuntu (or any Debian-based Linux distribution)
- Internet connection (to download data and tools)
- Sufficient disk space for storing sequence data
For Downstream analysis
- R studio
## Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/shotgun-metagenomics-pipeline.git
    cd shotgun-metagenomics-pipeline
    ```

2. **Make the script executable**:
    ```bash
    chmod +x upstream_analysis.sh
    ```

3. **Install required software packages**:
    The script will install several software packages and dependencies. You may need to run it with `sudo` privileges.

## Usage

Run the script with the following command:
```bash
./upstream_analysis.sh
```
The script will automatically perform the following steps.
## Pipeline Steps

The script performs the following steps to process shotgun metagenomics data:

1. **Create a directory for shotgun metagenomics data**:
    - The script creates a directory called `shotgun_metagenomics` and changes to this directory to organize all subsequent data processing.

2. **Update system packages**:
    - Ensures that the system's package list is up to date by running `sudo apt-get update`.

3. **Install necessary dependencies**:
    - Installs essential libraries for the subsequent tools:
      ```bash
      sudo apt-get install libxml2-dev libncurses5-dev
      ```

4. **Download and set up the SRA Toolkit**:
    - Downloads the SRA Toolkit, extracts it, and adds it to the system `PATH` to allow for easy access to its utilities:
      ```bash
      wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
      tar -xzvf sratoolkit.current-ubuntu64.tar.gz
      export PATH=$PATH:$(pwd)/sratoolkit.current-ubuntu64/bin
      ```

5. **Download sequence data**:
    - Uses `prefetch` from the SRA Toolkit to download sequence data specified by SRA accession numbers.

6. **Convert SRA files to FastQ format**:
    - Converts downloaded SRA files to FastQ format using `fastq-dump`:
      ```bash
      fastq-dump --split-files <SRA_accession>
      ```

7. **Rename FastQ files**:
    - Renames the FastQ files based on sample information for better clarity.

8. **Compress FastQ files**:
    - Compresses the FastQ files to save disk space:
      ```bash
      gzip *.fastq
      ```

9. **Remove original SRA files**:
    - Deletes the original SRA files to free up disk space:
      ```bash
      rm *.sra
      ```

10. **Quality control with FastQC**:
    - Runs FastQC on all FastQ files to generate quality control reports:
      ```bash
      fastqc *.fastq.gz -o fastQC_results/
      ```

11. **Install and set up Trimmomatic**:
    - Downloads and sets up Trimmomatic for adapter trimming:
      ```bash
      wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip
      unzip Trimmomatic-0.39.zip
      ```

12. **Trim adapters**:
    - Uses `quality_trim.sh` to trim adapters from the reads with Trimmomatic:
      ```bash
      ./quality_trim.sh input.fastq.gz output.trimmed.fastq.gz
      ```

13. **Download the reference genome**:
    - Downloads the Bos taurus (cattle) reference genome to remove host DNA:
      ```bash
      wget ftp://ftp.ensembl.org/pub/release-100/fasta/bos_taurus/dna/Bos_taurus.ARS-UCD1.2.dna.toplevel.fa.gz
      ```

14. **Install and set up BBTools**:
    - Installs BBTools and sets up `bbduk.sh` for host DNA removal:
      ```bash
      sudo apt-get install bbmap
      ```

15. **Remove host-derived sequences**:
    - Uses `bbduk.sh` to remove host-derived sequences:
      ```bash
      bbduk.sh in=input.fastq.gz out=output.cleaned.fastq.gz ref=Bos_taurus.ARS-UCD1.2.dna.toplevel.fa.gz
      ```

16. **Install MetaPhlAn and dependencies**:
    - Installs MetaPhlAn and its dependencies including Bowtie2, PuLP, and Snakemake:
      ```bash
      pip install metaphlan
      conda install -c bioconda bowtie2 pulp snakemake
      ```

17. **Taxonomic profiling with MetaPhlAn**:
    - Runs MetaPhlAn for taxonomic profiling of the sequences:
      ```bash
      metaphlan input.cleaned.fastq.gz --bowtie2out output.bowtie2.bz2 --nproc 4 > output_profile.txt
      ```

18. **Merge MetaPhlAn tables**:
    - Merges the MetaPhlAn output tables into a final table:
      ```bash
      merge_metaphlan_tables.py *_profile.txt > all_final_metaphlan_genera.tsv
      ```

### Additional Steps for Running Trimmomatic and MetaPhlAn

1. **Ensure adapter sequence files are available**:
    - Adapter sequence files such as `NexteraPE-PE.fa` are downloaded from the Trimmomatic GitHub repository:
      ```bash
      wget https://github.com/usadellab/Trimmomatic/raw/master/adapters/NexteraPE-PE.fa
      ```

2. **Trimming reads with Trimmomatic**:
    - The script runs `quality_trim.sh` for each pair of FastQ files to trim adapters and low-quality bases. The `quality_trim.sh` script should contain commands similar to the following:
      ```bash
      java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 \
      input_R1.fastq.gz input_R2.fastq.gz \
      output_R1_paired.fastq.gz output_R1_unpaired.fastq.gz \
      output_R2_paired.fastq.gz output_R2_unpaired.fastq.gz \
      ILLUMINACLIP:NexteraPE-PE.fa:2:30:10 SLIDINGWINDOW:4:20 MINLEN:50
      ```

3. **Running bbduk.sh with BBTools**:
    - BBTools' `bbduk.sh` is used to remove host-derived sequences using the cattle reference genome. The parameters include a memory allocation of 50 GB and a minimum coverage fraction of 0.5:
      ```bash
      bbduk.sh in=output_R1_paired.fastq.gz in2=output_R2_paired.fastq.gz \
      out=output_R1_clean.fastq.gz out2=output_R2_clean.fastq.gz \
      ref=Bos_taurus.ARS-UCD1.2.dna.toplevel.fa.gz k=31 hdist=1 stats=stats.txt
      ```

4. **Unzip depleted FastQ files**:
    - The depleted FastQ files are unzipped for further processing:
      ```bash
      gunzip output_R1_clean.fastq.gz
      gunzip output_R2_clean.fastq.gz
      ```

5. **Running Snakemake for MetaPhlAn analysis**:
    - Snakemake is used with the provided `mph.snake` Snakefile to perform the MetaPhlAn analysis. Ensure the `mph.snake` file is correctly set up to process the cleaned FastQ files:
      ```bash
      snakemake -s mph.snake --cores 4
      ```

6. **Merging MetaPhlAn tables**:
    - The final MetaPhlAn output tables are merged into `all_final_metaphlan_genera.tsv` using the provided merge script:
      ```bash
      merge_metaphlan_tables.py *_profile.txt > all_final_metaphlan_genera.tsv
      ```

By following these steps, the script processes shotgun metagenomics data from downloading raw sequence data to generating taxonomic profiles. Each step is designed to ensure data quality and accurate taxonomic assignment.

## Output

- **Quality Control Reports**:
    FastQC reports are stored in the `fastQC_results` directory.
    
- **Trimmed and Host-Depleted Reads**:
    Trimmed and host-depleted FastQ files are generated.

- **Taxonomic Profiles**:
    A merged table of taxonomic profiles is generated as `all_final_metaphlan_genera.tsv`.

## Contributing

Please feel free to submit issues or pull requests to improve this script or add new features.

## License

This project is licensed under the MIT License - see the LICENSE file for details.


