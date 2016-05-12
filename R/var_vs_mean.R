#' var_vs_mean
#'
#' This function plots mean against variance of gene expression across samples and calculates the linear correlation.
#'
#' @param expmatrix An input matrix with gene names as row names and sample names as column names.
#' @return Returns a plot of mean against variance of gene expression across samples and cor.test output of the linear correlation.
#' @examples
#' expmatrix <- read.table(system.file("extdata", "Random_exprMatrix.txt",
#'              package = "exprAnalysis"), header = TRUE, sep = "\t")
#' var_vs_mean(expmatrix)
#' @export
var_vs_mean <- function(expmatrix){
  ####plotting variance against mean
  means <- rowMeans(as.matrix(expmatrix))
  vars <- matrixStats::rowVars(as.matrix(expmatrix))

  plot(log2(vars+1)~log2(means+1), xlab="Mean gene expression (log2+1)", ylab="Mean variance of gene expression (log2+1)", main="Means vs. variance of gene expression\nacross samples", pch=16, col=scales::alpha("black", alpha = 0.1))
  abline(lm(log2(vars+1)~log2(means+1)), lwd=2, col="red")
  print(cor.test(means, vars))
}