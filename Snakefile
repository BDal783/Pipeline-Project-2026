rule all:
    input:
        "index.idx",
        expand("Results/{sample}/abundance.h5", sample=[
            "SRR5660030",
            "SRR5660033",
            "SRR5660044",
            "SRR5660045"]),
        "results.tsv",
        "SRR5660030.blast.txt",
        "SRR5660033.blast.txt",
        "SRR5660044.blast.txt",
        "SRR5660045.blast.txt"

rule download_dataset:
    output:
        zip="ncbi_dataset.zip"
    shell:
        """
        datasets download genome accession GCF_000845245.1 --include gff3,rna,cds,protein,genome,seq-report --filename {output.zip}
        """
rule unzip_and_process:
    input:
        zip="ncbi_dataset.zip"
    output:
        fna="HCMV_CDS.fna",
        report="PipelineReport.txt"
    shell:
        """
        unzip {input.zip}

        python Making_cd_index.py -i "ncbi_dataset/data/GCF_000845245.1/cds_from_genomic.fna" -o {output.fna} -r {output.report}
        """
rule kallisto_index:
    input:
        "HCMV_CDS.fna"
    output:
        "index.idx"
    shell:
        """
        kallisto index -i {output} {input}
        """
rule Sleuth_prep:
    input:
        index="index.idx",
        r1="Data/{sample}_1.fastq",
        r2="Data/{sample}_2.fastq"
    output:
        directory("Results/{sample}")
    shell:
        """
        time kallisto quant -i {input.index} -o {output} -b 30 -t 4 {input.r1} {input.r2}
        """
rule sleuth:
    input:
        expand("Results/{sample}/abundance.h5", sample=[
            "SRR5660030",
            "SRR5660033",
            "SRR5660044",
            "SRR5660045"
        ])
    output:
        tsv="results.tsv",
        report="PipelineReport.txt"
    shell:
        """
        Rscript Quantifying_tpmAndSleuth.R {output.tsv} {output.report}
        """
rule bowtie_analysis:
    output:
        report="PipelineReport.txt"
    shell:
        """
        bowtie2-build ncbi_dataset/data/GCF_000845245.1/GCF_000845245.1_ViralProj14559_genomic.fna HCMV
        bowtie2 --quiet -x HCMV -1 Data/SampleSRR5660030_1.fastq -2 Data/SRR5660030_2.fastq -S HCMVmap1.sam --al-conc-gz SRR5660030_mapped_%.fq.gz
        bowtie2 --quiet -x HCMV -1 Data/SampleSRR5660033_1.fastq -2 Data/SRR5660033_2.fastq -S HCMVmap2.sam --al-conc-gz SRR5660033_mapped_%.fq.gz
        bowtie2 --quiet -x HCMV -1 Data/SampleSRR5660044_1.fastq -2 Data/SRR5660044_2.fastq -S HCMVmap3.sam --al-conc-gz SRR5660044_mapped_%.fq.gz
        bowtie2 --quiet -x HCMV -1 Data/SampleSRR5660045_1.fastq -2 Data/SRR5660045_2.fastq -S HCMVmap4.sam --al-conc-gz SRR5660045_mapped_%.fq.gz
        python PairsBeforeandAfter.py
        """
rule spades_analysis:
    output:
        report="Dal_PipelineReport.txt"
    shell:
        """
        spades.py -t 2 --only-assembler -1 SRR5660030_mapped_1.fq.gz -2 SRR5660030_mapped_2.fq.gz -k 127 -o SRR5660030_assembly
        spades.py -t 2 --only-assembler -1 SRR5660033_mapped_1.fq.gz -2 SRR5660033_mapped_2.fq.gz -k 127 -o SRR5660033_assembly
        spades.py -t 2 --only-assembler -1 SRR5660044_mapped_1.fq.gz -2 SRR5660044_mapped_2.fq.gz -k 127 -o SRR5660044_assembly
        spades.py -t 2 --only-assembler -1 SRR5660045_mapped_1.fq.gz -2 SRR5660045_mapped_2.fq.gz -k 127 -o SRR5660045_assembly
        """
rule blast:
    output:
        report="PipelineReport.txt",
        blast1="SRR5660030.blast.txt",
        blast2="SRR5660033.blast.txt",
        blast3="SRR5660044.blast.txt",
        blast4="SRR5660045.blast.txt"
    shell:
        """
        python Blast.py
        """


