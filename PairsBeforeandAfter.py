#libraries
from pathlib import Path
import os
from Bio import SeqIO
#dictionary for storage
pairs = {}
#grabs r1 files 
r1_files = sorted(Path("Data").glob("*_1.fastq"))
#goes through and grabs index for # of pairs
for r1 in r1_files:
    seq_index = SeqIO.index(str(r1), "fastq")  
    total_pairs = len(seq_index)  
    pairs[r1.name] = {"total_pairs": total_pairs, "mapped_pairs": 0}
#goes to the appropriate sam
for r1, i in zip(r1_files, range(1, 5)):
    sam_file = f"HCMVmap{i}.sam"

    # count mapped paired reads
    cmd = f"samtools view -f 1 -F 12 {sam_file} | wc -l"

    mapped_reads = int(os.popen(cmd).read().strip())

    # samtools counts reads, not pairs so have to divide by 2
    mapped_pairs = mapped_reads // 2
    pairs[r1.name]["mapped_pairs"] = mapped_pairs
#writes to report
with open("PipelineReport.txt","a") as file:
    file.write("\n Problem 4 \n")
    for r1_name in sorted(pairs):
        total = pairs[r1_name]["total_pairs"]
        mapped = pairs[r1_name]["mapped_pairs"]
        file.write("Sample "+str(r1_name)+" had "+str(total)+" read pairs before and "+str(mapped)+" read pairs after Bowtie2 filtering. \n")
