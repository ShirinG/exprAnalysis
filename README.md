[![Travis-CI Build Status](https://travis-ci.org/ShirinG/exprAnalysis.svg?branch=master)](https://travis-ci.org/ShirinG/exprAnalysis)

# exprAnalysis

This package implements methods to analyze and visualize expression data.

  + It supports normalized input as e.g. from Cufflinks or expression chip arrays and raw count data from bam file input.
  + It supports mRNA, miRNA, protein or other expression data.

So far, it is only implemented for human and mouse data!

It uses function from the following packages:

  + AnnotationDbi for annotating gene information
  + beadarray for importing Illumina expression chip files from GenomeStudio
  + clusterProfiler and DOSE for functional enrichment analysis
  + DESeq2 for differential expression analysis of raw count data
  + GenomicAlignments, GenomicFeatures, Rsamtools for reading bam files
  + pcaGoPromoter for principle component analysis
  + limma for differential expression analysis of normalised expression data
  + pathview for mapping KEGG pathways
  + pheatmap for heatmaps
  + sva for batch correction
  + WGCNA for coregulatory network determination

## Author ##

Dr. Shirin Glander

## Installation ##

```r
# install package from github
# either the latest stable release that passed TRAVIS CI check
devtools::install_github("ShirinG/exprAnalysis", build_vignettes=TRUE, ref = "stable.version0.1.0")

# or the development version
devtools::install_github("ShirinG/exprAnalysis", build_vignettes=TRUE, ref = "master")
```

Beware that the vignette is rather large and thus takes a minute to compile. You can also see the Vignette at https://github.com/ShirinG/exprAnalysis/blob/master/vignettes/exprAnalysis.Rmd.

To view the vignette if you built it with the package:
```r
vignette("exprAnalysis", package="exprAnalysis")
vignette("CummeRbund", package="exprAnalysis")

browseVignettes("exprAnalysis")

# There might be problems with installation of packages. In order to install them manually:
list.of.packages <- c("list", "of", "packages")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

# CRAN
if(length(new.packages)>0) install.packages(new.packages)

# Bioconductor
if(length(new.packages)>0) {
  source("https://bioconductor.org/biocLite.R")
  biocLite(new.packages)
}
```
