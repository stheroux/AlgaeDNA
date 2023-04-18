

# 16S Cyanobacteria CYB359F/ CYB784R = Monchamp et al., 2016 425bp
qiime cutadapt trim-paired \
--i-demultiplexed-sequences demux-paired-end.qza \
--p-cores 4 \
--p-front-f GGGGAATYTTCCGCAATGGG \
--p-front-r GACTACWGGGGTATCTAATCCC \
--p-error-rate 0.1 \
--o-trimmed-sequences demux-paired-end-tr.qza


# 16S V4a Apprill et al., 2015; Parada et al., 2015
qiime cutadapt trim-paired \
--i-demultiplexed-sequences demux-paired-end.qza \
--p-cores 4 \
--p-front-f GTGYCAGCMGCCGCGGTAA \
--p-front-r GGACTACNVGGGTWTCTAAT \
--p-error-rate 0.1 \
--o-trimmed-sequences demux-paired-end-tr.qza

# 16S V4a Apprill et al., 2015; Parada et al., 2015 515F-Y/806RB
qiime cutadapt trim-paired \
--i-demultiplexed-sequences demux-paired-end.qza \
--p-cores 4 \
--p-front-f GTGYCAGCMGCCGCGGTAA \
--p-front-r GGACTACNVGGGTWTCTAAT \
--p-error-rate 0.2 \
--o-trimmed-sequences demux-paired-end-tr.qza

# 16S V4a original Caporaso 515F/806R
qiime cutadapt trim-paired \
--i-demultiplexed-sequences demux-paired-end.qza \
--p-cores 4 \
--p-front-f GTGCCAGCMGCCGCGGTAA \
--p-front-r GGACTACHVGGGTWTCTAAT \
--p-error-rate 0.2 \
--o-trimmed-sequences demux-paired-end-tr.qza

# 16S V4b 515F-Y/926R Needham and Fuhrman, 2016; Parada et al., 2015
qiime cutadapt trim-paired \
--i-demultiplexed-sequences demux-paired-end.qza \
--p-cores 4 \
--p-front-f GTGCCAGCMGCCGCGGTAA \
--p-front-r CCGYCAATTYMTTTRAGTTT \ 
--p-error-rate 0.1 \
--o-trimmed-sequences demux-paired-end-tr.qza

# rbcL Vasselon 201?
qiime cutadapt trim-paired \
--i-demultiplexed-sequences demux-paired-end.qza \
--p-cores 4 \
--p-front-f AGGTGAAGTAAAAGGTTCWTACTTAAA \
--p-front-r CCTTCTAATTTACCWACWACTG \
--p-error-rate 0.1 \
--o-trimmed-sequences demux-paired-end-tr.qza

# 18S V9 Amaral Zettler
qiime cutadapt trim-paired \
--i-demultiplexed-sequences demux-paired-end.qza \
--p-cores 4 \
--p-front-f CCCTGCCHTTTGTACACAC \
--p-front-r CCTTCYGCAGGTTCACCTAC \
--p-error-rate 0.2 \
--o-trimmed-sequences demux-paired-end-tr.qza

# 18S V4 Stoeck TarEuk 417bp
qiime cutadapt trim-paired \
--i-demultiplexed-sequences demux-paired-end.qza \
--p-cores 4 \
--p-front-f CCAGCASCYGCGGTAATTCC \
--p-front-r ACTTTCGTTCTTGATYRA \
--p-error-rate 0.1 \
--o-trimmed-sequences demux-paired-end-tr.qza

# CO1 Leray bp (mlCO1intF/jgHCO2198R)
qiime cutadapt trim-paired \
--i-demultiplexed-sequences demux-paired-end.qza \
--p-cores 4 \
--p-front-f GGWACWGGWTGAACWGTWTAYCCYCC \
--p-front-r GGRGGRTASACSGTTCASCCSGTSCC \
--p-error-rate 0.1 \
--o-trimmed-sequences demux-paired-end-tr.qza

# CO1 fwhF2/EPTDr2n Leese 
qiime cutadapt trim-paired \
--i-demultiplexed-sequences demux-paired-end.qza \
--p-cores 4 \
--p-front-f GGDACWGGWTGAACWGTWTAYCCHCC \
--p-front-r CAAACAAATARDGGTATTCGDTY \
--p-error-rate 0.1 \
--o-trimmed-sequences demux-paired-end-tr.qza