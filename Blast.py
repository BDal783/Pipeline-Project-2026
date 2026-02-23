from pathlib import Path
import os
from Bio import SeqIO

contig_files = sorted(
    Path(".").glob("*_assembly/contigs.fasta")
)

#downloading data base for betaherpsvirinae
subfamily = 'datasets download virus genome taxon Betaherpesvirinae --include genome'
os.system(subfamily)
os.system("unzip ncbi_dataset.zip")

#making database
db = 'makeblastdb -in ncbi_dataset/data/genomic.fna -out Betaherpesbirinae -title Betaherpesbirinae -dbtype nucl'
os.system(db)


with open("longestContig.txt", "w") as report:

    for contig_path in contig_files:
        sample = contig_path.parent.name.replace("_assembly", "")
        longest = None

        for record in SeqIO.parse(contig_path, "fasta"):
            if longest is None or len(record.seq) > len(longest.seq):
                longest = record

        longest_fasta = f"{sample}_longest.fasta"
        SeqIO.write(longest, longest_fasta, "fasta")

        report.write(f"{sample}\n")

        blast_command = 'blastn -query '+longest_fasta+' -db Betaherpesbirinae -outfmt \"6 sacc pident length qstart qend sstart send bitscore evalue stitle\" -out {sample}.blast.txt'
        
        os.system(blast_command)

        with open('{sample}.blast.txt', 'r') as f:
            lines = f.readlines()
            f.close()
        with open("Dal_PipelineReport.txt", 'a') as file:
            for i in lines:
                file.write(i)
            file.close()