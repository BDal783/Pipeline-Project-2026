# Pipeline-Project-2026
Comp 483 Pipeline project 

Required coding languages: Python, R

Required python coding libraries: Biopython, pathlib, os

Required R libraries: dyplr and kallisto

Required unix libraries: Snakemake, Bowtie 2, spades, blast, datasets

Getting started:
1) git clone the directory
```
git clone https://github.com/BDal783/Pipeline-Project-2026.git
```
2) Transfer into the directory
```
cd Pipeline-Project-2026
```
3) Run the snake file
```
snakemake --cores 1 --rerun-incomplete --latency-wait 120
```
This is done with 1 core, which has issues with finishing faster than other processes. While the flag --latency-wait makes sure that if a file struggles to load, it will wait for it for 2 mins or the limit of time the project can run with the sample data.

4) While the Snake file is running
While it is running, it will prompt you about whether you would like to override certain files while it grabs databases for GCF_000845245.1 and Betaherpesvirinae. Whenever it asks to overwrite the READ.md say no, but for everything else, say yes. (you can say yes for the READ.me aswell if u really want)


My steps:
Started working on problem 1
1) Used wget to get all SRR
```
wget https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR5660030/SRR5660030
wget https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR5660033/SRR5660033
wget https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR5660044/SRR5660044
wget https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR5660045/SRR5660045
```
3) used fasterq-dump ./SRR on all downloaded SRR
4) Created Snakefile and Report txt files

5) Started working on problem 2
```
datasets download genome accession GCF_000845245.1 --include gff3,rna,cds,protein,genome,seq-report
unzip ncbi_dataset.zip
kallisto index -i index.idx HCMV_CDS.fna --make-unique
```
6) Started working on 3
```
time kallisto quant -i index.idx -o Results/SRR5660030 -b 30 -t 4 Data/SRR5660030_1.fastq Data/SRR5660030_2.fastq
time kallisto quant -i index.idx -o Results/SRR5660033 -b 30 -t 4 Data/SRR5660033_1.fastq Data/SRR5660033_2.fastq
time kallisto quant -i index.idx -o Results/SRR5660044 -b 30 -t 4 Data/SRR5660044_1.fastq Data/SRR5660044_2.fastq
time kallisto quant -i index.idx -o Results/SRR5660045 -b 30 -t 4 Data/SRR5660045_1.fastq Data/SRR5660045_2.fastq
```
7) made an R file to run sleuth and produce an output

8) Started working on 4
```
bowtie2-build ncbi_dataset/data/GCF_000845245.1/GCF_0008452
45.1_ViralProj14559_genomic.fna HCMV
bowtie2 --quiet -x HCMV -1 Data/SRR5660030_1.fastq -2 Data/SRR5660030_2.fastq -S HCMVmap1.sam --al-conc-gz SRR5660030_mapped_%.fq.gz
bowtie2 --quiet -x HCMV -1 Data/SRR5660033_1.fastq -2 Data/SRR5660033_2.fastq -S HCMVmap2.sam --al-conc-gz SRR5660033_mapped_%.fq.gz
bowtie2 --quiet -x HCMV -1 Data/SRR5660044_1.fastq -2 Data/SRR5660044_2.fastq -S HCMVmap3.sam --al-conc-gz SRR5660044_mapped_%.fq.gz
bowtie2 --quiet -x HCMV -1 Data/SRR5660045_1.fastq -2 Data/SRR5660045_2.fastq -S HCMVmap4.sam --al-conc-gz SRR5660045_mapped_%.fq.gz
```
9) made and ran PairsBeforeandAfter.py to count pairs before and after mapping 

10 ) started working on 5
```
spades.py -t 2 --only-assembler -1 SRR5660030_mapped_1.fq.gz -2 SRR5660030_mapped_2.fq.gz -k 127 -o SRR5660030_assembly
spades.py -t 2 --only-assembler -1 SRR5660033_mapped_1.fq.gz -2 SRR5660033_mapped_2.fq.gz -k 127 -o SRR5660033_assembly
spades.py -t 2 --only-assembler -1 SRR5660044_mapped_1.fq.gz -2 SRR5660044_mapped_2.fq.gz -k 127 -o SRR5660044_assembly
spades.py -t 2 --only-assembler -1 SRR5660045_mapped_1.fq.gz -2 SRR5660045_mapped_2.fq.gz -k 127 -o SRR5660045_assembly
```
11) started question 6
12) created a blast py file and let it make a blast database and run all blast commands
13) Then reconstructed what I've done in the snake file and confirmed results seemed accurate
14) creates samples of data containing the first 10000 read
```
#just an example
 head -n 40000 data.fastq > sampledata.fastq
```
15) uploaded final versions of code

