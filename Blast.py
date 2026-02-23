from pathlib import Path
import os
from Bio import SeqIO
###### go back and undo commented out os
contig_files = sorted(
    Path(".").glob("*_assembly/contigs.fasta")
)
#print(contig_files)

#downloading data base for betaherpsvirinae
subfamily = 'datasets download virus genome taxon Betaherpesvirinae --include genome'
#os.system(subfamily)
#os.system("unzip ncbi_dataset.zip")


with open("Dal_PipelineReport.txt", 'a') as prompt:
    prompt.write("\nProblem6\n")
    prompt.close()

#making database
db = 'makeblastdb -in ncbi_dataset/data/genomic.fna -out Betaherpesbirinae -title Betaherpesbirinae -dbtype nucl'
#os.system(db)


with open("longestContig.txt", "w") as report:

    for contig_path in contig_files:
        sample = contig_path.parent.name.replace("_assembly", "")
        longest = None

        for record in SeqIO.parse(contig_path, "fasta"):
            if longest is None or len(record.seq) > len(longest.seq):
                longest = record

        longest_fasta = f"{sample}_longest.fasta"
        SeqIO.write(longest, longest_fasta, "fasta")
        name = str(contig_path)[:10]
        #print(name)
        
        blast_out = name+".blast.txt"

        blast_command = 'blastn -query '+longest_fasta+' -db Betaherpesbirinae -outfmt \"6 sacc pident length qstart qend sstart send bitscore evalue stitle\" -out '+blast_out
        
        os.system(blast_command)

        with open(name+".blast.txt", 'r') as f:
            lines = f.readlines()[:5]
            #print(lines)
            f.close()
        with open("Dal_PipelineReport.txt", 'a') as file:
            file.write(name+"\n")
            file.write('sacc\tpident\tlength\tqstart\tqend\tsstart\tsend\tbitscore\tevalue\tstitle\n')
            for i in lines:
                file.write(i)
                #print(i)
            file.write("\n")
            file.close()
    