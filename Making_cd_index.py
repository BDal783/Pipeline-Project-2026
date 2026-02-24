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

#start counter
cds_count = 0

with open(outfile, "w") as out_f:
    for record in SeqIO.parse(infile, "fasta"):
        header = record.description
        protein_id = header.split("protein_id=")[1].split("]")[0]

        out_f.write(f">{protein_id}\n")
        out_f.write(str(record.seq) + "\n")

        cds_count += 1

with open(report_file, "a") as report:
        report.write("Problem 2\n")
        report.write("The HCMV genome (GCF_000845245.1) has "+str(cds_count)+" CDS. \n")
        report.close