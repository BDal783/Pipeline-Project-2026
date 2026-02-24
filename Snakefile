rule all:
    input:
        "results.tsv",
        "SRR5660030.blast.txt",
        "SRR5660033.blast.txt",
        "SRR5660044.blast.txt",
        "SRR5660045.blast.txt"

rule full_pipeline:
    output:
        sleuth_tsv="results.tsv",
        blast1="SRR5660030.blast.txt",
        blast2="SRR5660033.blast.txt",
        blast3="SRR5660044.blast.txt",
        blast4="SRR5660045.blast.txt",
        report="PipelineReport.txt",
        index="index.idx"
    shell:
        """
        set -euo pipefail

        # Download and prepare CDS
        datasets download genome accession GCF_000845245.1 --include gff3,rna,cds,protein,genome,seq-report --filename ncbi_dataset.zip
        unzip ncbi_dataset.zip
        python Making_cd_index.py -i "ncbi_dataset/data/GCF_000845245.1/cds_from_genomic.fna" -o HCMV_CDS.fna -r {output.report}

        # Build kallisto index
        kallisto index -i {output.index} HCMV_CDS.fna

        # Quantify all samples
        kallisto quant -i {output.index} -o Results/SRR5660030 -b 30 -t 4 Data/SampleSRR5660030_1.fastq Data/SampleSRR5660030_2.fastq
        kallisto quant -i {output.index} -o Results/SRR5660033 -b 30 -t 4 Data/SampleSRR5660033_1.fastq Data/SampleSRR5660033_2.fastq
        kallisto quant -i {output.index} -o Results/SRR5660044 -b 30 -t 4 Data/SampleSRR5660044_1.fastq Data/SampleSRR5660044_2.fastq
        kallisto quant -i {output.index} -o Results/SRR5660045 -b 30 -t 4 Data/SampleSRR5660045_1.fastq Data/SampleSRR5660045_2.fastq

        # Run sleuth
        Rscript Quantifying_tpmAndSleuth.R {output.sleuth_tsv} {output.report}

        # Bowtie mapping
        bowtie2-build ncbi_dataset/data/GCF_000845245.1/GCF_000845245.1_ViralProj14559_genomic.fna HCMV
        bowtie2 -x HCMV -1 Data/SampleSRR5660030_1.fastq -2 Data/SampleSRR5660030_2.fastq -S HCMVmap1.sam --al-conc-gz SRR5660030_mapped_%.fq.gz
        bowtie2 -x HCMV -1 Data/SampleSRR5660033_1.fastq -2 Data/SampleSRR5660033_2.fastq -S HCMVmap2.sam --al-conc-gz SRR5660033_mapped_%.fq.gz
        bowtie2 -x HCMV -1 Data/SampleSRR5660044_1.fastq -2 Data/SampleSRR5660044_2.fastq -S HCMVmap3.sam --al-conc-gz SRR5660044_mapped_%.fq.gz
        bowtie2 -x HCMV -1 Data/SampleSRR5660045_1.fastq -2 Data/SampleSRR5660045_2.fastq -S HCMVmap4.sam --al-conc-gz SRR5660045_mapped_%.fq.gz
        python PairsBeforeandAfter.py

        # SPAdes assembly
        spades.py -t 2 --only-assembler -1 SRR5660030_mapped_1.fq.gz -2 SRR5660030_mapped_2.fq.gz -k 127 -o SRR5660030_assembly
        spades.py -t 2 --only-assembler -1 SRR5660033_mapped_1.fq.gz -2 SRR5660033_mapped_2.fq.gz -k 127 -o SRR5660033_assembly
        spades.py -t 2 --only-assembler -1 SRR5660044_mapped_1.fq.gz -2 SRR5660044_mapped_2.fq.gz -k 127 -o SRR5660044_assembly
        spades.py -t 2 --only-assembler -1 SRR5660045_mapped_1.fq.gz -2 SRR5660045_mapped_2.fq.gz -k 127 -o SRR5660045_assembly

        # Blast
        python Blast.py
        """