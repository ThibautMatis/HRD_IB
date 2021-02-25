
#BioClite pour installer les packages

install.packages("BioClite")

packages <- c("BSgenome",
              "BSgenome.Hsapiens.UCSC.hg19",
              "devtools",
              "DT",
              "GenomicRanges",
              "ggplot2",
              "gbm",
              "gridExtra",
              "IRanges",
              "nnls",
              "pheatmap",
              "reshape2",
              "Rmisc",
              "VariantAnnotation")

if(getRversion() >= "3.6.0"){
  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager", repos = "http://cran.us.r-project.org")
  BiocManager::install(packages)
}
if(getRversion() < "3.6.0" & getRversion() >= "3.5.0"){
  source("https://bioconductor.org/biocLite.R")
  biocLite(packages)
}


# short example 2 simulated panels for testing the tool
devtools::load_all()
data_dir <- "E:/QBFC/Result/Tumor/SigMA_IB_PASS_Qual/Classe3"
genomes_matrix <- make_matrix(data_dir, file_type = 'vcf')
genomes <- conv_snv_matrix_to_df(genomes_matrix)
genome_file = "IB_PASS_Classe3.csv"
write.table(genomes, genome_file, sep = ',', row.names = F, col.names = T , quote = F)
run(genome_file ="IB_PASS_Classe3.csv", data = "msk", tumor_type = 'ovary')

message(paste0('96-dimensional matrix is saved in ', genome_file))
message('Running SigMA')
run(genome_file,
  data = "seqcap",
  do_assign = T,
  do_mva = F,
  tumor_type = 'breast',
  lite_format = F)

run(genome_file = "QBFC.csv", data = "msk", tumor_type = 'breast', lite_format = F)

  #data option 'msk' for Targeted Gene Panels
  #data option 'seqcap' for Whole Exome Sequencing 37 Mb
  #data option 'seqcap_probe' for Whole Exome Sequencing 64 Mb
  #data option 'tcga_mc3' for Whole Exome Sequencing TCGA MC3
  #data option 'wgs' for Whole Genome Sequencing
  #data option 'wgs_pancan' for Whole Genome Sequencing Pancan Classifier
