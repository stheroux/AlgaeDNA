########################################  
# QIIME2 ----------------
########################################  

source activate qiime2-2018.11 # use this to start new session of qiime

# import files as artifact -------------
qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path $SEQS1 \
--input-format CasavaOneEightSingleLanePerSampleDirFmt \
--output-path $DIR/demux-paired-end.qza

# generate visualization file ----------
qiime demux summarize \
--i-data $DIR/demux-paired-end.qza \
--o-visualization $DIR/demux.qzv
# now drag and drop your demux.qzv file into view.qiime2.org
# download the resulting csv file with read counds 

# now use dada2 to quality filter (this will take a while) -------
qiime dada2 denoise-paired \
--i-demultiplexed-seqs $DIR/demux-paired-end.qza \
--p-trim-left-f 0 \
--p-trim-left-r 0 \
--p-trunc-len-f $L1 \
--p-trunc-len-r $L2 \
--p-trunc-q 2 \
--p-n-threads 0 \
--o-representative-sequences $DIR/rep-seqs.qza \
--o-table $DIR/table.qza \
--verbose \
--o-denoising-stats $DIR/stats.gza

# done correctly, dada2 will generate 
#Saved FeatureTable[Frequency] to: table.qza
#Saved FeatureData[Sequence] to: rep-seqs.qza


###################################################
# assign taxonomy ------
###################################################

# import fasta db -----
qiime tools import \
--type FeatureData[Sequence] \
--input-path $FASTA \
--output-path $DIR/fasta

# import taxonomy \
qiime tools import \
--type FeatureData[Taxonomy] \
--input-path $TAX \
--input-format HeaderlessTSVTaxonomyFormat \
--output-path $DIR/tax

# classify 

qiime feature-classifier classify-consensus-blast \
--i-query $DIR/rep-seqs.qza \
--i-reference-taxonomy $DIR/tax.qza \
--i-reference-reads $DIR/fasta.qza \
--o-classification $DIR/taxonomy \
--p-perc-identity 0.97 \
--p-maxaccepts 10

# export fasta 
qiime tools export --input-path $DIR/rep-seqs.qza  --output-path $DIR/exported_fasta

# export stats
qiime tools export --input-path $DIR/stats.gza.qza  --output-path $DIR/exported_stats


#######################################
# export  -----------
#######################################

# export biom with taxonomy
# from here: https://forum.qiime2.org/t/exporting-and-modifying-biom-tables-e-g-adding-taxonomy-annotations/3630
qiime tools export --input-path $DIR/table.qza --output-path $DIR/exported
qiime tools export --input-path $DIR/taxonomy.qza --output-path $DIR/exported

# edit the taxonomy.tsv header from 'Feature ID	Taxon	Confidence' to be '#OTUID	taxonomy	confidence'
sed 's/Feature ID/#OTUID/' $DIR/exported/taxonomy.tsv> $DIR/exported/taxonomy_ed.tsv
sed 's/Taxon/taxonomy/' $DIR/exported/taxonomy_ed.tsv> $DIR/exported/taxonomy_ed2.tsv
sed 's/Confidence/confidence/' $DIR/exported/taxonomy_ed2.tsv> $DIR/exported/taxonomy_ed3.tsv

biom add-metadata -i $DIR/exported/feature-table.biom -o $DIR/exported/table-with-taxonomy.biom --observation-metadata-fp $DIR/exported/taxonomy.tsv --sc-separated $DIR/exported/taxonomy

# convert to txt 
biom convert -i $DIR/exported/table-with-taxonomy.biom \
-o $DIR/exported/table.txt \
--to-tsv --header-key taxonomy \
--output-metadata-id "ConsensusLineage"


# data viz 
qiime taxa barplot \
  --i-table $DIR/table.qza \
  --i-taxonomy $DIR/taxonomy.qza \
  --m-metadata-file $DIR/sample-metadata.tsv \
  --o-visualization $DIR/barplot.qzv
  
  
