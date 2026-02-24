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
This is done with 1 core as issues with it finishing faster than other processes occurred. While the flag --latency-wait makes sure that if a file struggles to load it will wait for it for 2 mins or the limit of time the project can run with the sample data.

4) While Snake file is running

Started working on problem 1
1) used wget to get all SRR
2) used fasterq-dump ./SRR
3) Created Snakefile and Report txt fileS

Started working on problem 2
4) datasets download genome accession GCF_000845245.1 --include gff3,rna,cds,protein,genome,seq-report
5) unzip ncbi_dataset.zip
6) kallisto index -i index.idx HCMV_CDS.fna --make-unique

Started working on 3
7) time kallisto quant -i index.idx -o Results/SRR5660030 -b 30 -t 4 Data/SRR5660030_1.fastq Data/SRR5660030_2.fastq
8) time kallisto quant -i index.idx -o Results/SRR5660033 -b 30 -t 4 Data/SRR5660033_1.fastq Data/SRR5660033_2.fastq
9) time kallisto quant -i index.idx -o Results/SRR5660044 -b 30 -t 4 Data/SRR5660044_1.fastq Data/SRR5660044_2.fastq
10) time kallisto quant -i index.idx -o Results/SRR5660045 -b 30 -t 4 Data/SRR5660045_1.fastq Data/SRR5660045_2.fastq
11) made a R file to run sleuth and produce an output

Started working on 4
12) bowtie2-build ncbi_dataset/data/GCF_000845245.1/GCF_0008452
45.1_ViralProj14559_genomic.fna HCMV
13) bowtie2 --quiet -x HCMV -1 Data/SRR5660030_1.fastq -2 Data/SRR5660030_2.fastq -S HCMVmap1.sam --al-conc-gz SRR5660030_mapped_%.fq.gz
14) bowtie2 --quiet -x HCMV -1 Data/SRR5660033_1.fastq -2 Data/SRR5660033_2.fastq -S HCMVmap2.sam --al-conc-gz SRR5660033_mapped_%.fq.gz
15) bowtie2 --quiet -x HCMV -1 Data/SRR5660044_1.fastq -2 Data/SRR5660044_2.fastq -S HCMVmap3.sam --al-conc-gz SRR5660044_mapped_%.fq.gz
16) bowtie2 --quiet -x HCMV -1 Data/SRR5660045_1.fastq -2 Data/SRR5660045_2.fastq -S HCMVmap4.sam --al-conc-gz SRR5660045_mapped_%.fq.gz
17) ran PairsBeforeandAfter.py to count pairs before and after mapping and print to the results txt

started working on 5
18) spades.py -t 2 --only-assembler -1 SRR5660030_mapped_1.fq.gz -2 SRR5660030_mapped_2.fq.gz -k 127 -o SRR5660030_assembly
19) spades.py -t 2 --only-assembler -1 SRR5660033_mapped_1.fq.gz -2 SRR5660033_mapped_2.fq.gz -k 127 -o SRR5660033_assembly
20) spades.py -t 2 --only-assembler -1 SRR5660044_mapped_1.fq.gz -2 SRR5660044_mapped_2.fq.gz -k 127 -o SRR5660044_assembly
21) spades.py -t 2 --only-assembler -1 SRR5660045_mapped_1.fq.gz -2 SRR5660045_mapped_2.fq.gz -k 127 -o SRR5660045_assembly

started question 6
22) 

