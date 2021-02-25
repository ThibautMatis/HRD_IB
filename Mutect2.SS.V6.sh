./gatk Mutect2 -R /data/Reference/hg19.fa \
-I /data/Bam_data/Tumor/AFN-2174.bam \
-I /data/Bam_data/Blood/AFN-2492.bam \
-normal AFN-02492 \
--min-base-quality-score 30 \
--germline-resource /data/gnomAD/af-only-gnomad.raw.sites.hg19.vcf.gz \
-pon /data/PON/PoN.vcf.gz \
--f1r2-tar-gz Pair23-f1r2.tar.gz \
--native-pair-hmm-threads 2 \
-O /data/VCF/Pair23.vcf.gz
#
./gatk LearnReadOrientationModel -I Pair23-f1r2.tar.gz -O Pair23-read-orientation-model.tar.gz
#
./gatk GetPileupSummaries \
-I /data/Bam_data/Tumor/AFN-2174.bam \
-V /data/gnomAD/small_exac_common_3_hg19.vcf \
-L /data/gnomAD/small_exac_common_3_hg19.vcf \
-O Tumor-table/AFN-2214.getpileupsummaries.table
#
./gatk GetPileupSummaries \
-I /data/Bam_data/Blood/AFN-2205.bam \
-V /data/gnomAD/small_exac_common_3_hg19.vcf \
-L /data/gnomAD/small_exac_common_3_hg19.vcf \
-O Normal-table/AFN-2205.getpileupsummaries.table
#
./gatk CalculateContamination \
-I Tumor-table/AFN-2214.getpileupsummaries.table \
-matched Normal-table/AFN-2205.getpileupsummaries.table \
-O Tumor-table/AFN-2214.calculatecontamination.table
#-------------------------Variant Call-10%----------------------------------------
./gatk FilterMutectCalls -V /data/VCF/Unfiltered/Pair19.vcf.gz \
-R /data/Reference/hg19.fa \
--contamination-table Tumor-table/AFN-2214.calculatecontamination.table \
--ob-priors Pair19-read-orientation-model.tar.gz \
--min-allele-fraction 0.1 \
--min-reads-per-strand 10 \
-O /data/VCF/Prefiltered/Pair19.prefiltered_10%.vcf
awk -F '\t' '{if($0 ~ /\#/) print; else if($7 == "PASS") print}' /data/VCF/Prefiltered/Pair19.prefiltered_10%.vcf > /data/VCF/Filtered_10%/Pair19.filtered.vcf
cut  --complement -f10 /data/VCF/Filtered_10%/Pair19.filtered.vcf >  /data/VCF/Filtered_10%/AFN-2214.filtered.vcf

./gatk Funcotator --variant /data/VCF/Filtered_10%/Pair19.filtered.vcf --reference /data/Reference/hg19.fa --ref-version hg19 --data-sources-path /data/Bam_data/Funcotator/funcotator_dataSources.v1.6.20190124s --output /data/VCF/Funcotator/AFN-2214.funcotated.vcf --output-file-format VCF
#-------------------------Variant Call-0%----------------------------------------
./gatk FilterMutectCalls -V /data/VCF/Unfiltered/Pair2.vcf.gz \
-R /data/Reference/hg19.fa \
--contamination-table /data/gatk-copy/Tumor-table/AFN-1985.calculatecontamination.table \
--ob-priors /data/gatk-copy/Pair19-read-orientation-model.tar.gz \
--min-reads-per-strand 10 \
-O /data/Pair2.prefiltered_0%.vcf
awk -F '\t' '{if($0 ~ /\#/) print; else if($7 == "PASS") print}' /data/Pair2.prefiltered_0%.vcf > /data/Pair2.filtered.vcf

cut  --complement -f10 /data/VCF/Filtered_0%/Pair19.filtered.vcf >  /data/VCF/Filtered_0%/AFN-2214.filtered.vcf


./gatk Funcotator --variant /data/VCF/Filtered_10%/Pair2.filtered.vcf --reference /data/Reference/hg19.fa --ref-version hg19 --data-sources-path /data/Bam_data/Funcotator/funcotator_dataSources.v1.6.20190124s --output /data/VCF/Funcotator/AFN-1985.funcotated.vcf --output-file-format VCF

#----------------------Tumor variant call for MS---------------------------------

./gatk FilterMutectCalls \
-V /data/VCF/Unfiltered/Pair2.vcf.gz \
        -R /data/Reference/hg19.fa \
        --contamination-table /data/gatk-copy/Tumor-table/AFN-1587.calculatecontamination.table \
        --ob-priors /data/gatk-copy/Pair2-read-orientation-model.tar.gz \
        -O /data/SignatureAnalyser/VCF/Pair2.MS.vcf
        awk -F '\t' '{if($0 ~ /\#/) print; else if($7 == "PASS") print}' /data/SignatureAnalyser/VCF/Pair2.MS.vcf > /data/SignatureAnalyser/VCF/Pair2.MS.filtered.vcf

cut  --complement -f10 /data/VCF/Filtered_0%/Pair25.filtered.vcf >  /data/VCF/Filtered_0%/AFN-2766.filtered.vcf


#------------------------Force calling mode--------------------------------------
./gatk Mutect2 \
-R /data/Reference/hg19.fa \
-I /data/Bam_data/Tumor/AFN-2766.bam \
-alleles /data/WES_analysis/allele.vcf \
-L /data/WES_analysis/coordinates.bed \
-O /data/WES_analysis/AFN-2766.vcf.gz
