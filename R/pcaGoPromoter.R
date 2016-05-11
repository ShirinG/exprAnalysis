#' pca_plot_enrich (from pcaGoPromoter functions).
#'
#' This is a collection of functions from the package "pcaGoPromoter".
#' It calculates the principle components and plots them.
#' It also calculates TF and GO term enrichments.
#'
#' Both, PC plot (as .pdf) and tables (as tab delimited .txt) of enriched TFs and GO terms are saved by default to the working directory or to the given path.
#'
#' @param expmatrix An input matrix with gene names as row names and sample names as column names.
#' @param groups Define sample groups.
#' @param PCs Principle components to plot (pick two). Defaults to PCs 1 and 2.
#' @param main Main title of PCA plot. Defaults to "PCA plot".
#' @param percentage Percentage of genes with top loadings to use for TF and GO enrichment analysis. Defauls to 2.5.
#' @param inputType a character vector description the input type. Must be Affymetrix chip type, "geneSymbol" or "entrezID". The following Affymetrix chip type are supported: hgu133plus2, mouse4302, rat2302, hugene10st and mogene10st. Default is Affymetrix chip type "hgu133plus2".
#' @param org a character vector with the organism. Can be "Hs", "Mm" or "Rn". Only needed if inputType is "geneSymbol" or "entrezID". See details. Default is "Hs".
#' @param projectfolder File path where to save the tables to. Defaults to working directory. Here, it saves the output to a subfolder called "pcaGoPromoter".
#' @return A PCA plot and tables of enriched TFs and GO terms.
#' @examples
#'  expmatrix <- read.table(system.file("extdata", "Random_exprMatrix.txt", package = "exprAnalysis"),
#'                header = TRUE, sep = "\t")
#'  groups <- as.factor(c(rep("control",4), rep("TolLPS",4), rep("TolS100A8",4), rep("ActLPS",4)))
#'  pca_plot_enrich(expmatrix, groups)
#' @export
pca_plot_enrich <- function(expmatrix, groups, PCs = c(1,2), main = "PCA plot", percentage = 2.5, inputType = "geneSymbol", org = "Hs", projectfolder = getwd()){

  if (!file.exists(file.path(projectfolder, "pcaGoPromoter"))) {dir.create(file.path(projectfolder, "pcaGoPromoter")) }

    if (!requireNamespace("pcaGoPromoter", quietly = TRUE)) {
      stop("pcaGoPromoter needed for this function to work. Please install it.",
           call. = FALSE)
    }

  # Produce PCA
  pcaOutput <- pcaGoPromoter::pca(expmatrix, printDropped = FALSE, scale=TRUE, center=TRUE)

  # Plot PCA
  pdf(file=file.path(projectfolder, "pcaGoPromoter", paste0("PCAplot_PCs_", PCs[1], "_", PCs[2], ".pdf")))
  pcaGoPromoter::plot.pca(pcaOutput, groups, PCs = PCs, printNames = TRUE, symbolColors = TRUE, plotCI = TRUE, main=main)
  dev.off()

  # Calculate enrichments
  percent <- round(nrow(expmatrix)/100*percentage, digits = 0)

  for (PC in PCs){

    load <- pcaOutput$loadings
    load_PC <- load[,PC, drop=F]
    load_PC_order <- load_PC[order(load_PC[,1]), , drop=F]

    loadsNeg <- names(load_PC_order[1:percent,])
    loadsPos <- names(load_PC_order[(nrow(load_PC_order)-percent+1):nrow(load_PC_order),])

    # TFs
    TFtableNeg <- pcaGoPromoter::primo(loadsNeg, inputType = inputType, org = org, PvalueCutOff = 0.05, cutOff = 0.9, p.adjust.method = "fdr", printIgnored = FALSE , primoData = NULL)
    write.table(TFtableNeg$overRepresented, file.path(projectfolder, "pcaGoPromoter", paste0("TFtableNeg_PC_", PC, ".txt")), col.names = T, row.names = F, sep = "\t")
    cat("\n-------------------------\n", "Table of enriched TFs of negative loadings of PC", PC, "saved to", file.path(projectfolder, paste0("TFtableNeg_PC_", PC, ".txt")), "\n-------------------------\n")

    TFtablePos <- pcaGoPromoter::primo(loadsPos, inputType = inputType, org = org, PvalueCutOff = 0.05, cutOff = 0.9, p.adjust.method = "fdr", printIgnored = FALSE , primoData = NULL)
    write.table(TFtablePos$overRepresented, file.path(projectfolder, "pcaGoPromoter", paste0("TFtablePos_PC_", PC, ".txt")), col.names = T, row.names = F, sep = "\t")
    cat("\n-------------------------\n", "Table of enriched TFs of positive loadings of PC", PC, "saved to", file.path(projectfolder, paste0("TFtablePos_PC_", PC, ".txt")), "\n-------------------------\n")

    # GO
    GOtreeOutputPos <- pcaGoPromoter::GOtree(input = loadsPos, inputType = inputType, org = org, statisticalTest = "fisher", binomAlpha = 0.05, p.adjust.method = "fdr")
    sigGOTermsPos <- GOtreeOutputPos[["sigGOs"]]
    write.table(sigGOTermsPos, file.path(projectfolder, "pcaGoPromoter", paste0("sigGOTermsPos_PC_", PC, ".txt")), col.names = T, row.names = F, sep = "\t")
    cat("\n-------------------------\n", "Table of enriched GO terms of positive loadings of PC", PC, "saved to", file.path(projectfolder, paste0("sigGOTermsPos_PC_", PC, ".txt")), "\n-------------------------\n")

    GOtreeOutputNeg <- pcaGoPromoter::GOtree(input = loadsNeg, inputType = inputType, org = org, statisticalTest = "fisher", binomAlpha = 0.05, p.adjust.method = "fdr")
    sigGOTermsNeg <- GOtreeOutputNeg[["sigGOs"]]
    write.table(sigGOTermsNeg, file.path(projectfolder, "pcaGoPromoter", paste0("sigGOTermsNeg_PC_", PC, ".txt")), col.names = T, row.names = F, sep = "\t")
    cat("\n-------------------------\n", "Table of enriched GO terms of negative loadings of PC", PC, "saved to", file.path(projectfolder, paste0("sigGOTermsNeg_PC_", PC, ".txt")), "\n-------------------------\n")
  }

}

# devtools::document()



