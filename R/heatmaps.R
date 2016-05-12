#' heatmaps (using heatmaps.2 of "gplots").
#'
#' This calculates the differentially expressed genes among pairwise group comparisons (one comparison at a time).
#'
#' @param expmatrix An input matrix with gene names as row names and sample names as column names.
#' @param method_dist the distance measure to be used. This must be one of "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski". Any unambiguous substring can be given. Defaults to canberra.
#' @param method_hclust the agglomeration method to be used. This should be (an unambiguous abbreviation of) one of "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC). Defaults to ward.D2.
#' @param samplecols Colors indicating samples' treatment group.
#' @param main Main title for heatmap plot. Defaults to "Heatmap of genes".
#' @return Returns a heatmap plot.
#' @examples
#' expmatrix <- read.table(system.file("extdata", "Random_exprMatrix.txt", package = "exprAnalysis"),
#'              header = TRUE, sep = "\t")
#' heatmaps(expmatrix[1:100,], samplecols = rep(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3"), each=4))
#' @export
heatmaps <- function(expmatrix, method_dist = "canberra", method_hclust = "ward.D2", samplecols, main = "Heatmap of genes"){
  # transpose the matrix and cluster columns
  hc.cols <- stats::hclust(dist(t(as.matrix(expmatrix)), method = method_dist), method = method_hclust)

  cols <- rev(grDevices::colorRampPalette(RColorBrewer::brewer.pal(9,"RdYlBu"))(100))

  gplots::heatmap.2(as.matrix(expmatrix),
            Rowv = TRUE, Colv=as.dendrogram(hc.cols), dendrogram = "column",
            scale = "row", margins = c(8,5), col = cols,
            xlab = "Samples", srtCol = 45, labRow = NA,
            main = main,
            ColSideColors=samplecols, cexRow=0.5, key=TRUE, symkey=FALSE, density.info="density", trace="none")
}
# devtools::document()