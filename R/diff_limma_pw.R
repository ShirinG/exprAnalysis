#' diff_limma_pairwise (from limma functions).
#'
#' This calculates the differentially expressed genes among pairwise group comparisons (one comparison at a time).
#'
#' @param expmatrix An input matrix with gene names as row names and sample names as column names.
#' @param design Binary design matrix of samples' treatment groups.
#' @param comparison Single comparisons for differential expression analysis.
#' @param p.value Significance threshold. Defaults to 0.05
#' @param lfc Log fold change threshold. Defaults to 1.5
#' @param projectfolder File path where to save the output to. Defaults to working directory. Here, it saves the output to a subfolder called "Diff_limma".
#' @return Differential expression output table for the given comparison. The table and Venn diagram are saved to files in the folder "diff_limma" and the table is also returned by the function.
#' @examples
#' design <- data.frame(Ctrl = c(rep(1, 4), rep(0,12)), TolLPS = c(rep(0, 4), rep(1, 4),
#'              rep(0, 8)), TollMRP8 = c(rep(0, 8), rep(1, 4), rep(0, 4)), ActLPS = c(rep(0, 12),
#'              rep(1, 4)), row.names = colnames(expmatrix))
#' comparison="TolLPS-Ctrl"
#' diff_limma_pairwise(expmatrix, design, comparison)
#' @export
diff_limma_pairwise <- function(expmatrix, design, comparison, p.value=0.05, lfc=1.5, projectfolder = getwd()){

  if (!file.exists(file.path(projectfolder, "Diff_limma"))) {dir.create(file.path(projectfolder, "Diff_limma")) }

  ##make pair-wise comparisons between the groups
  #Differentially expressed genes can be found by

  aw <- limma::arrayWeights(as.matrix(expmatrix), design)
  cont.matrix <- limma::makeContrasts(contrasts=comparison, levels=design)

  fit <- limma::lmFit(as.matrix(expmatrix), design, weights=aw)
  fit <- limma::eBayes(limma::contrasts.fit(fit, cont.matrix))

  resultDiffGenes <- limma::decideTests(fit, p.value=p.value, lfc=lfc, adjust.method="BH")
  grDevices::pdf(file=file.path(projectfolder, "Diff_limma", paste0(comparison, "_Diff_vennDiagram.pdf")))
  limma::vennDiagram(resultDiffGenes)
  grDevices::dev.off()

  Diff_Ftest <- limma::topTable(fit, confint=TRUE, p.value=p.value, lfc=lfc, adjust.method="BH", number=Inf)

  utils::write.table(data.frame(Diff_Ftest), file.path(projectfolder, "Diff_limma", "Diff_Ftest.txt"), col.names = T, row.names = F, sep = "\t")
  cat("\n-------------------------\n", "Differential Expression Analysis Output of", comparison, "groups (limma Ftest) were saved to", file.path(projectfolder, "Diff_limma", paste0(comparison, "_Diff_Ftest.txt")), "\n-------------------------\n")

  return(data.frame(Diff_Ftest))
}
# devtools::document()
