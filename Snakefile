rule all:
    input:
        "HCMV_CDS.fna"
rule download_dataset:
    output:
        zip="ncbi_dataset.zip"
    shell:
        """
        datasets download genome accession GCF_000845245.1 \
            --include gff3,rna,cds,protein,genome,seq-report \
            --filename {output.zip}
        """
rule unzip_and_process:
    input:
        zip="ncbi_dataset.zip"
    output:
        fna="HCMV_CDS.fna",
        report="Dal_PipelineReport.txt"
    shell:
        """
        unzip {input.zip}

        python Making_cd_index.py -i "ncbi_dataset/data/GCF_000845245.1/GCF_000845245.1_ViralProj14559_genomic.fna" -o {output.fna} -r {output.report}
        """