#brendon dal comp 483
from Bio import SeqIO
import sys
import argparse

#function to parse command line arguments
def check_arg(args=None):
    parser = argparse.ArgumentParser(description="making cd index")
    parser.add_argument("-i", "--input", help="input file", required=True)
    parser.add_argument("-o", "--output", help="output file", required=True)
    parser.add_argument("-r", "--report", help="report file", required=True)
    return parser.parse_args(args)

#retrieve command line arguments
arguments = check_arg(sys.argv[1:])
infile = arguments.input
outfile = arguments.output
report_file = arguments.report

fasta = infile
gff_file = "ncbi_dataset/data/GCF_000845245.1/genomic.gff"
output_fasta = outfile

# Load genome (HCMV has one chromosome)
record = SeqIO.read(fasta, "fasta")
genome_seq = record.seq

cds_count = 0

with open(gff_file) as gff, open(output_fasta, "w") as out:
    for line in gff:
        if line.startswith("#"):
            continue

        fields = line.strip().split("\t")
        if len(fields) != 9:
            continue

        seqid, source, feature_type, start, end, score, strand, phase, attributes = fields

        if feature_type != "CDS":
            continue

        # Parse attributes field
        attr_dict = {}
        for attr in attributes.split(";"):
            if "=" in attr:
                key, value = attr.split("=", 1)
                attr_dict[key] = value

        if "protein_id" not in attr_dict:
            continue

        protein_id = attr_dict["protein_id"]

        # GFF is 1-based inclusive
        start = int(start) - 1
        end = int(end)

        cds_seq = genome_seq[start:end]

        if strand == "-":
            cds_seq = cds_seq.reverse_complement()

        out.write(f">{protein_id}\n")
        out.write(str(cds_seq) + "\n")

        cds_count += 1
    with open(report_file,"w") as file:
        file.write("Problem 2 \n")
        file.write(f"The HCMV genome (GCF_000845245.1) has {cds_count} CDS. \n")

