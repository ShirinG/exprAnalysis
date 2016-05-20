#' diff_limma_all (from limma functions).
#'
#' This calculates the differentially expressed genes among all group comparisons.
#'
#' @param expmatrix An input matrix with gene names as row names and sample names as column names.
#' @param design Binary design matrix of samples' treatment groups.
#' @param groupcomparisons Group comparisons for differential expression analysis.
#' @param p.value Significance threshold. Defaults to 0.05
#' @param lfc Log fold change threshold. Defaults to 1.5
#' @param projectfolder File path where to save the output to. Defaults to working directory. Here, it saves the output to a subfolder called "Diff_limma".
#' @return Differential expression output table for all group comparisons - outputs information for all genes, including non-significant ones.
#' @examples
#' design <- data.frame(Ctrl = c(rep(1, 4), rep(0,12)), TolLPS = c(rep(0, 4), rep(1, 4),
#'              rep(0, 8)), TollMRP8 = c(rep(0, 8), rep(1, 4), rep(0, 4)), ActLPS = c(rep(0, 12),
#'              rep(1, 4)), row.names = colnames(expmatrix))
#' groupcomparisons=c("TolLPS-Ctrl", "TollMRP8-Ctrl", "ActLPS-Ctrl")
#' diff_limma_all(expmatrix, design, groupcomparisons)
#' @export
diff_limma_all <- function(expmatrix, design, groupcomparisons, p.value=0.05, lfc=log2(1.5), projectfolder = getwd()){

  if (!file.exists(file.path(projectfolder, "Diff_limma"))) {dir.create(file.path(projectfolder, "Diff_limma")) }

  ##make pair-wise comparisons between the groups
  #Differentially expressed genes can be found by

  aw <- limma::arrayWeights(as.matrix(expmatrix), design)
  cont.matrix <- limma::makeContrasts(contrasts=groupcomparisons, levels=design)

  fit <- limma::lmFit(as.matrix(expmatrix), design, weights=aw)
  fit <- limma::eBayes(limma::contrasts.fit(fit, cont.matrix))

  resultDiffGenes <- limma::decideTests(fit, p.value=p.value, lfc=lfc, adjust.method="BH")
  grDevices::pdf(file=file.path(projectfolder, "Diff_limma", "DiffAllGroups_vennDiagram.pdf"))
  limma::vennDiagram(resultDiffGenes)
  grDevices::dev.off()

  DiffAllGroups_Ftest <- limma::topTable(fit, confint=TRUE, p.value=p.value, lfc=lfc, adjust.method="BH", number=Inf)

  utils::write.table(data.frame(DiffAllGroups_Ftest), file.path(projectfolder, "Diff_limma", "DiffAllGroups_Ftest.txt"), col.names = T, row.names = F, sep = "\t")
  cat("\n-------------------------\n", "Differential Expression Analysis Output of all groups (limma Ftest) were saved to", file.path(projectfolder, "Diff_limma", "DiffAllGroups_Ftest.txt"), "\n-------------------------\n")

  AllGroups_Ftest_unfiltered <- limma::topTable(fit, confint=TRUE, p.value=1, adjust.method="BH", number=Inf)

  utils::write.table(data.frame(AllGroups_Ftest_unfiltered), file.path(projectfolder, "Diff_limma", "AllGroups_Ftest_unfiltered.txt"), col.names = T, row.names = F, sep = "\t")
  cat("\n-------------------------\n", "Unfiltered Differential Expression Analysis Output of all groups (limma Ftest) were saved to", file.path(projectfolder, "Diff_limma", "AllGroups_Ftest_unfiltered.txt"), "\n-------------------------\n")

  return(data.frame(AllGroups_Ftest_unfiltered))
}