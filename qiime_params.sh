# Working directory
DIR = ~/Documents/QIIME/ 

# Location of fastq files
SEQS1= ~/Documents/SEQS/

# Cutadapt 
# Copy and paste appropriate primers into cutadapt commands
# P1 fwd primer
# P2 rev primer
# PE perc accept
P1 = AGGTGAAGTAAAAGGTTCWTACTTAAA
P2 = CCTTCTAATTTACCWACWACTG
PE = 0.2 

# Forward (L1) and Reverse (L2) trim lengths
L1=240
L2=240

# DNA reference database Fasta and Taxonomy files 
FASTA= ~/Documents/DBS/SILVA_138/dna.cyano.fasta
TAX= ~/Documents/DBS/SILVA_138/tax.cyano.txt

# Blast 
B1 = 0.97
B2 = 1

