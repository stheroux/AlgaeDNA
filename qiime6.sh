########################################  
# QIIME2 ----------------
########################################  

cd ~/Documents/QIIME/Algae/Plate1/rbcL
conda activate qiime2-2022.11   # use this to start new session of qiime

SEQS1= "~/Documents/SEQS/Run1/fastq/"

# import files as artifact -------------
qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path $SEQS1 \
--input-format CasavaOneEightSingleLanePerSampleDirFmt \
--output-path demux-paired-end.qza

qiime cutadapt trim-paired \
--i-demultiplexed-sequences demux-paired-end.qza \
--p-cores 1 \
--p-front-f AGGTGAAGTAAAAGGTTCWTACTTAAA \
--p-front-r CCTTCTAATTTACCWACWACTG \
--p-error-rate 0.2 \
--o-trimmed-sequences demux-paired-end-tr.qza

# generate visualization file ----------
qiime demux summarize \
--i-data demux-paired-end-tr.qza \
--o-visualization demux.qzv
# now drag and drop your demux.qzv file into view.qiime2.org
# download the resulting csv file with read counds 

L1=220
L2=220

# now use dada2 to quality filter (this will take a while) -------
qiime dada2 denoise-paired \
--i-demultiplexed-seqs demux-paired-end-tr.qza \
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
#Saved FeatureTable[Frequency] to: table.qza
#Saved FeatureData[Sequence] to: rep-seqs.qza


###################################################
# assign taxonomy ------
###################################################

# taxonomy 
FASTA=~/Documents/DBS/rbcL_gen_rsyst/fasta.fasta
TAX=~/Documents/DBS/rbcL_gen_rsyst/tax.txt


# import fasta db -----
qiime tools import \
--type FeatureData[Sequence] \
--input-path $FASTA \
--output-path fasta

# import taxonomy \
qiime tools import \
--type FeatureData[Taxonomy] \
--input-path $TAX \
--input-format HeaderlessTSVTaxonomyFormat \
--output-path tax

# classify 

qiime feature-classifier classify-consensus-blast \
--i-query rep-seqs.qza \
--i-reference-taxonomy tax.qza \
--i-reference-reads fasta.qza \
--output-dir taxonomy \
--p-perc-identity 0.97 \
--p-maxaccepts 1

#######################################
# export  -----------
#######################################

#### export taxonomy ---------------
# export biom with taxonomy
# from here: https://forum.qiime2.org/t/exporting-and-modifying-biom-tables-e-g-adding-taxonomy-annotations/3630
qiime tools export --input-path table.qza --output-path exported
qiime tools export --input-path taxonomy/classification.qza --output-path exported
cd exported

sed 's/Feature ID/#OTUID/' taxonomy.tsv> taxonomy_ed.tsv
sed 's/Taxon/taxonomy/' taxonomy_ed.tsv> taxonomy_ed2.tsv
sed 's/Confidence/confidence/' taxonomy_ed2.tsv> taxonomy_ed3.tsv

biom add-metadata -i feature-table.biom -o table-with-taxonomy.biom --observation-metadata-fp taxonomy_ed3.tsv --sc-separated taxonomy

# convert to txt 
biom convert -i table-with-taxonomy.biom \
-o table.txt \
--to-tsv --header-key taxonomy \
--output-metadata-id "ConsensusLineage"

cd ..

# export fasta 
qiime tools export --input-path rep-seqs.qza  --output-path exported_fasta

# export stats
qiime tools export --input-path stats.gza.qza  --output-path exported_stats

# data viz 
qiime taxa barplot \
  --i-table {TABLE}.qza \
  --i-taxonomy {BLAST-TAXONOMY}.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization {BLAST-TAXA-BAR-PLOTS_VIZ}.qzv
  
  
