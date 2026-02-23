from pathlib import Path
import os
from Bio import SeqIO

pairs = {}

r1_files = sorted(Path("Data").glob("*_1.fastq"))

for r1 in r1_files:
    r2 = str(r1).replace("_1.fastq", "_2.fastq")

    count = sum(1 for _ in SeqIO.parse(r1, "fastq"))
    pairs[r1.name] = {"total_pairs": count, "mapped_pairs": 0}

for r1, i in zip(r1_files, range(1, 5)):
    sam_file = f"HCMVmap{i}.sam"

    # samtools command: count mapped paired reads
    cmd = f"samtools view -f 1 -F 12 {sam_file} | wc -l"

    mapped_reads = int(os.popen(cmd).read().strip())

    # samtools counts reads, not pairs
    mapped_pairs = mapped_reads // 2
    pairs[r1.name]["mapped_pairs"] = mapped_pairs

for r1_name in sorted(pairs):
    total = pairs[r1_name]["total_pairs"]
    mapped = pairs[r1_name]["mapped_pairs"]

    print(f"{r1_name}\t{total}\t{mapped}")