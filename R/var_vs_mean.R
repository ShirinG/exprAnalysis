#' var_vs_mean
#'
#' This function plots mean against variance of gene expression across samples and calculates the linear correlation.
#'
#' @param expmatrix An input matrix with gene names as row names and sample names as column names.
#' @return Returns a plot of mean against variance of gene expression across samples and cor.test output of the linear correlation.
#' @examples
#' var_vs_mean(expmatrix)
#' @export
var_vs_mean <- function(expmatrix){

  dispersion <- data.frame()

  for (i in 1: nrow(expmatrix)){
    dispersion[i,1] <- rowMeans(as.matrix(expmatrix)[i, , drop=FALSE])
    dispersion[i,2] <- matrixStats::rowVars(as.matrix(expmatrix)[i, , drop=FALSE])
  }

  plot(log2(dispersion[,1]+1), log2(dispersion[,2]+1),pch=16, xlab="Mean gene expression (log2+1)", ylab="Mean variance of gene expression (log2+1)", main="Means vs. variance of gene expression\nacross samples", col=grDevices::rgb(0,100,0,50,maxColorValue=255))
  abline(0, 1)
  abline(lm(log2(dispersion[,2]+1)~log2(dispersion[,1]+1)), lwd=2, col="red")
  print(cor.test(log2(dispersion[,1]+1), log2(dispersion[,2]+1)))
}