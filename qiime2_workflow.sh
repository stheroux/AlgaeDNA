########################################  
# QIIME2 ----------------
########################################  

source activate qiime2-2018.11 # use this to start new session of qiime
# source tab-qiime 

cd ~/Documents/QIIME/Algae/16S_V4_plate1

# import files as artifact -------------
qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path ~/Documents/SEQS/2019_Plate1/Susanna-806/fastq/ \
--input-format CasavaOneEightSingleLanePerSampleDirFmt \
--output-path demux-paired-end.qza

# generate visualization file ----------
qiime demux summarize \
--i-data demux-paired-end.qza \
--o-visualization demux.qzv

# now drag and drop your demux.qzv file into view.qiime2.org
# download the resulting csv file with read counds 

# now use dada2 to quality filter (this will take a while) -------
qiime dada2 denoise-paired \
--i-demultiplexed-seqs demux-paired-end.qza \
--p-trim-left-f 1 \
--p-trim-left-r 1 \
--p-trunc-len-f 150 \
--p-trunc-len-r 150 \
--p-n-threads 12 \
--o-representative-sequences rep-seqs.qza \
--o-table table.qza \
--o-denoising-stats stats.gza

# done correctly, dada2 will generate 
Saved FeatureTable[Frequency] to: table.qza
Saved FeatureData[Sequence] to: rep-seqs.qza

qiime feature-table tabulate-seqs \
--i-data rep-seqs.qza \
--o-visualization rep-seqs.qzv


############ 
# assign taxonomy ------
############

# import 16S reference files  
qiime tools import \
--type FeatureData[Sequence] \
--input-path ~/Documents/SILVA/SILVA_132_QIIME_release/rep_set/rep_set_16S_only/99/silva_132_99_16S.fna \
--output-path 99_otus_16S

qiime tools import \
--type FeatureData[Taxonomy] \
--input-path ~/Documents/SILVA/SILVA_132_QIIME_release/taxonomy/16S_only/99/majority_taxonomy_7_levels_ed2.txt \
--input-format HeaderlessTSVTaxonomyFormat \
--output-path majority_taxonomy_7_levels

# classify using BLAST 
qiime feature-classifier classify-consensus-blast \
--i-query rep-seqs.qza \
--i-reference-taxonomy majority_taxonomy_7_levels.qza \
--i-reference-reads 99_otus_16S.qza \
--o-classification taxonomy \
--p-perc-identity 0.90 \
--p-maxaccepts 1

#######################################
# export  -----------
#######################################

# export biom file , skip if you want 
qiime tools export \
  --input-path table.qza \
  --output-path exported-feature-table

# export biom with taxonomy
# from here: https://forum.qiime2.org/t/exporting-and-modifying-biom-tables-e-g-adding-taxonomy-annotations/3630
qiime tools export --input-path table.qza --output-path exported
qiime tools export --input-path taxonomy.qza --output-path exported
# edit the taxonomy.tsv header to be #OTUID	taxonomy	confidence
cd exported/
biom add-metadata -i feature-table.biom --observation-metadata-fp taxonomy.tsv --sc-separated taxonomy -o table-with-taxonomy.biom

# convert to txt 
biom convert -i table-with-taxonomy.biom \
-o table-with-taxonomy.txt \
--to-tsv --header-key taxonomy \
--output-metadata-id "ConsensusLineage"





#######################################
# optional : filter -------------------
#######################################

# filter # didn't work bc of whitespace in file because of # sign in name, converted to _
qiime taxa filter-table \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --p-include cyanobacteria \
  --o-filtered-table cyano_table.qza

# filter to remove singletons across all samples 
qiime feature-table filter-features \
  --i-table table.qza \
  --p-min-frequency 2 \
  --o-filtered-table table_gt1.qza

# filter to remove samples with < 1500 seqs
qiime feature-table filter-samples \
  --i-table table_gt1.qza \
  --p-min-frequency 1500 \
  --o-filtered-table table_gt1_gt1500seqs.qza

# summarize 
qiime feature-table summarize \
--i-table table.qza \
--o-visualization table.qzv \
--m-sample-metadata-file map.txt

qiime feature-table tabulate-seqs \
--i-data rep-seqs.qza \
--o-visualization rep-seqs.qzv



  

