#' diff_limma_pairwise (from limma functions).
#'
#' This calculates the differentially expressed genes among pairwise group comparisons (one comparison at a time) and outputs results for DE genes only.
#'
#' @param expmatrix An input matrix with gene names as row names and sample names as column names.
#' @param design Binary design matrix of samples' treatment groups.
#' @param comparison Single comparisons for differential expression analysis.
#' @param p.value Significance threshold. Defaults to 0.05
#' @param lfc Log fold change threshold. Defaults to 1.5
#' @param projectfolder File path where to save the output to. Defaults to working directory. Here, it saves the output to a subfolder called "Diff_limma".
#' @return Differential expression output table for the given comparison. The table and Venn diagram are saved to files in the folder "diff_limma" and the table is also returned by the function.
#' @examples
#' design <- as.matrix(data.frame(Ctrl = c(rep(1, 4), rep(0,12)), TolLPS = c(rep(0, 4), rep(1, 4),
#'              rep(0, 8)), TollMRP8 = c(rep(0, 8), rep(1, 4), rep(0, 4)), ActLPS = c(rep(0, 12),
#'              rep(1, 4)), row.names = colnames(expmatrix)))
#' comparison="TolLPS-Ctrl"
#' diff_limma_pairwise_output <- diff_limma_pairwise(expmatrix, design, comparison)
#' @export
diff_limma_pairwise <- function(expmatrix, design, comparison, p.value=log2(0.05), lfc=log2(1.5), projectfolder = getwd()){

  if (!requireNamespace("limma", quietly = TRUE)) {stop("limma needed for this function to work. Please install it.", call. = FALSE)}

  if (!is.matrix(expmatrix)) {stop("Input expression matrix is not of class matrix. Please change it.", call. = FALSE)}
  if (mode(design) != "numeric") {stop("Design is not a numeric matrix. Please change it.", call. = FALSE)}
  if (mode(comparison) != "character") {stop("Comparison is not a character vector. Please change it.", call. = FALSE)}

  # Create output folder if it doesn't already exist.
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

  utils::write.table(data.frame(Diff_Ftest), file.path(projectfolder, "Diff_limma", paste0("Diff_Ftest_", comparison, ".txt")), col.names = T, row.names = F, sep = "\t")
  cat("\n-------------------------\n", "Differential Expression Analysis Output of", comparison, "groups (limma Ftest) were saved to", file.path(projectfolder, "Diff_limma", paste0("Diff_Ftest_", comparison, ".txt")), "\n-------------------------\n")

  return(data.frame(Diff_Ftest))
}
# devtools::document()


#' diff_limma_pw_unfiltered (from limma functions).
#'
#' This calculates the differentially expressed genes among pairwise group comparisons (one comparison at a time) and outputs results for all genes (including non-significant genes).
#'
#' @param expmatrix An input matrix with gene names as row names and sample names as column names.
#' @param design Binary design matrix of samples' treatment groups.
#' @param comparison Single comparisons for differential expression analysis.
#' @param p.value Significance threshold. Defaults to 0.05
#' @param lfc Log fold change threshold. Defaults to 1.5
#' @param projectfolder File path where to save the output to. Defaults to working directory. Here, it saves the output to a subfolder called "Diff_limma".
#' @return Unfiltered Differential expression output table for the given comparison. The table and Venn diagram are saved to files in the folder "diff_limma" and the table is also returned by the function.
#' @examples
#' design <- as.matrix(data.frame(Ctrl = c(rep(1, 4), rep(0,12)), TolLPS = c(rep(0, 4), rep(1, 4),
#'              rep(0, 8)), TollMRP8 = c(rep(0, 8), rep(1, 4), rep(0, 4)), ActLPS = c(rep(0, 12),
#'              rep(1, 4)), row.names = colnames(expmatrix)))
#' comparison="TolLPS-Ctrl"
#' diff_limma_pw_unfiltered_output <- diff_limma_pw_unfiltered(expmatrix, design, comparison)
#' @export
diff_limma_pw_unfiltered <- function(expmatrix, design, comparison, p.value=0.05, lfc=log2(1.5), projectfolder = getwd()){

  if (!requireNamespace("limma", quietly = TRUE)) {stop("limma needed for this function to work. Please install it.", call. = FALSE)}

  if (!is.matrix(expmatrix)) {stop("Input expression matrix is not of class matrix. Please change it.", call. = FALSE)}
  if (mode(design) != "numeric") {stop("Design is not a numeric matrix. Please change it.", call. = FALSE)}
  if (mode(comparison) != "character") {stop("Comparison is not a character vector. Please change it.", call. = FALSE)}

  # Create output folder if it doesn't already exist.
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

  Diff_Ftest_unfiltered <- limma::topTable(fit, confint=TRUE, p.value=1, adjust.method="BH", number=Inf)

  utils::write.table(data.frame(Diff_Ftest_unfiltered), file.path(projectfolder, "Diff_limma", paste0("Unfiltered_Diff_Ftest_", comparison, ".txt")), col.names = T, row.names = F, sep = "\t")
  cat("\n-------------------------\n", "Differential Expression Analysis Output of", comparison, "groups (limma Ftest) were saved to", file.path(projectfolder, "Diff_limma", paste0("Unfiltered_Diff_Ftest_", comparison, ".txt")), "\n-------------------------\n")

  return(data.frame(Diff_Ftest_unfiltered))
}
# devtools::document()
