[![Travis-CI Build Status](https://travis-ci.org/ShirinG/exprAnalysis.svg?branch=master)](https://travis-ci.org/ShirinG/exprAnalysis)

This package implements methods to analyze and visualize expression data.

It supports normalized input as e.g. from Cufflinks or expression chip arrays and raw count data from bam file input.

It supports mRNA, miRNA, protein or other expression data.

So far, it is only implemented for human data!

It uses function from the following packages:
    + AnnotationDbi for annotating gene information
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

`devtools::install_github("ShirinG/exprAnalysis",build_vignettes=TRUE)`

Beware that the vignette is rather large and thus takes a minute to compile. You can also see the Vignette at https://github.com/ShirinG/exprAnalysis/blob/master/vignettes/exprAnalysis.Rmd.

To view the vignette if you built it with the package:
```r
vignette("exprAnalysis", package="exprAnalysis")
vignette("CummeRbund", package="exprAnalysis")

browseVignettes("exprAnalysis")
```
