########################################  
# QIIME2 ----------------
########################################  

# Start new session of qiime2
source activate qiime2-2018.11 

# Define variables
SEQS1=~/FILELOCATION/fastq/

# import files as artifact 
qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path $SEQS1 \
--input-format CasavaOneEightSingleLanePerSampleDirFmt \
--output-path demux-paired-end.qza

# generate visualization file 
qiime demux summarize \
--i-data demux-paired-end.qza \
--o-visualization demux.qzv
# now drag and drop your demux.qzv file into view.qiime2.org, determine L1 and L2 values
# download the resulting csv file with read counds 

L1=240 # truncate length forward
L2=220 # truncate length reverse

# now use dada2 to quality filter (this will take a while) 
qiime dada2 denoise-paired \
--i-demultiplexed-seqs demux-paired-end.qza \
--p-trim-left-f 0 \
--p-trim-left-r 0 \
--p-trunc-len-f $L1 \
--p-trunc-len-r $L2 \
--p-trunc-q 2 \
--p-n-threads 0 \
--o-representative-sequences rep-seqs.qza \
--o-table table.qza \
--verbose \
--o-denoising-stats stats.gza

# done correctly, dada2 will generate 
# Saved FeatureTable[Frequency] to: table.qza
# Saved FeatureData[Sequence] to: rep-seqs.qza


###################################################
# assign taxonomy ------
###################################################

FASTA=~/Documents/DBS/SILVA_138/dna.algae.fasta
TAX=~/Documents/DBS/SILVA_138/tax.euk.algae.txt

# import fasta db -----
qiime tools import \
--type FeatureData[Sequence] \
--input-path $FASTA \
--output-path refseqs

# import taxonomy \
qiime tools import \
--type FeatureData[Taxonomy] \
--input-path $TAX \
--input-format HeaderlessTSVTaxonomyFormat \
--output-path reftax

# classify 
qiime feature-classifier classify-consensus-blast \
--i-query rep-seqs.qza \
--i-reference-taxonomy reftax.qza \
--i-reference-reads refseqs.qza \
--o-classification taxonomy \
--p-perc-identity 0.90 \
--p-maxaccepts 1

###################################################
#### Export OTU (ASV) Table 
###################################################

# export biom with taxonomy
# from here: https://forum.qiime2.org/t/exporting-and-modifying-biom-tables-e-g-adding-taxonomy-annotations/3630
qiime tools export --input-path stats.gza.qza --output-path exported_stats
qiime tools export --input-path table.qza --output-path exported
qiime tools export --input-path taxonomy.qza --output-path exported
cd exported

# edit the taxonomy.tsv header to be #OTUID	taxonomy	confidence
biom add-metadata -i feature-table.biom -o table-with-taxonomy.biom --observation-metadata-fp taxonomy.tsv --sc-separated taxonomy

# convert to txt 
biom convert -i table-with-taxonomy.biom \
-o table.txt \
--to-tsv --header-key taxonomy \
--output-metadata-id "ConsensusLineage"


