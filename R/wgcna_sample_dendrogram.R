#' wgcna_sample_dendrogram (from WGCNA functions).
#'
#' This function implements optimal hierarchical clustering based on an adjacency matrix
#' and plots a cluster tree with sample heatmap. It also identifies samples with too many entries and zero variance.
#'
#' The function goodSamplesGenes iteratively identifies samples and genes with too many missing entries and genes with zero variance. Iterations may be required since excluding samples effectively changes criteria on genes and vice versa. The process is repeated until the lists of good samples and genes are stable. The constants ..minNSamples and ..minNGenes are both set to the value 4.
#'
#' @param expmatrix An input matrix with gene names as row names and sample names as column names.
#' @param thresholdZ.k Connectivity threshold. If scaled connectibity of a sample is below this value, it is marked as an outlier. Defaults to -2.5 but can also be changed to e.g. -5.
#' @param datTraits Numeric matrix of phenotypes belonging to each sample in columns of matrix.
#' @return Shows a sample dendrogram plot with sample heatmap and returns the object datExpr, which is the transformed expmatrix input and can be used for the next steps in the WGCNA pipeline.
#' @examples
#' datTraits <- data.frame(Ctrl = c(rep(1, 4), rep(0,12)), TolLPS = c(rep(0, 4), rep(1, 4),
#'              rep(0, 8)), TolS100A8 = c(rep(0, 8), rep(1, 4), rep(0, 4)), ActLPS = c(rep(0, 12),
#'              rep(1, 4)), Tol = c(rep(0, 4), rep(1, 8), rep(0, 4)), row.names = colnames(expmatrix))
#' datExpr <- wgcna_sample_dendrogram(expmatrix, datTraits)
#' @export
wgcna_sample_dendrogram <- function(expmatrix, datTraits, thresholdZ.k=-2.5){

  if (!requireNamespace("WGCNA", quietly = TRUE)) {
    stop("WGCNA needed for this function to work. Please install it.",
         call. = FALSE)
  }

  if (!requireNamespace("flashClust", quietly = TRUE)) {
    stop("flashClust needed for this function to work. Please install it.",
         call. = FALSE)
  }


  # transpose the expression data to have rows for samples and columns for genes
  datExpr=t(expmatrix)

  # show that row names agree
  if(!table(rownames(datTraits)==rownames(datExpr))) stop("Rownames of expmatrix and datTraits don't match")

  #adjacency matrix
  A=WGCNA::adjacency(expmatrix,type="distance")

  # standardized connectivity
  k=as.numeric(apply(A,2,sum))-1
  Z.k=scale(k)

  # the color vector indicates outlyingness (red)
  outlierColor=ifelse(Z.k<thresholdZ.k,"red","black")

  # calculate the cluster tree using flahsClust or hclust
  sampleTree = flashClust::flashClust(as.dist(1-A), method = "average")
  # Convert traits to a color representation:
  # where red indicates high values

  traitColors=WGCNA::numbers2colors(datTraits,signed=FALSE)
  dimnames(traitColors)[[2]]=paste(names(datTraits),"C",sep="")
  datColors=data.frame(outlierC=outlierColor,traitColors)

  # Plot the sample dendrogram and the colors underneath.
  WGCNA::plotDendroAndColors(sampleTree,groupLabels=names(datColors),colors=datColors,main="Sample dendrogram and trait heatmap")

  # Check for genes and samples with too many missing values
  gsg = WGCNA::goodSamplesGenes(t(expmatrix), verbose = 3)

  # Optionally, print the gene and sample names that were removed:
  if (sum(!gsg$goodGenes)>0){
    dynamicTreeCut::printFlush(paste("Remove genes:", paste(names(t(expmatrix))[!gsg$goodGenes], collapse = ", ")))
  } else {
    dynamicTreeCut::printFlush("All genes are okay!")
  }

  if (sum(!gsg$goodSamples)>0){
    dynamicTreeCut::printFlush(paste("Remove samples:", paste(rownames(t(expmatrix))[!gsg$goodSamples], collapse = ", ")))
  } else {
    dynamicTreeCut::printFlush("All samples are okay!")
  }

  return(datExpr)

}

# devtools::document()