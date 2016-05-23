#' wgcna_heatmaps (from WGCNA functions).
#'
#' This function implements module-trait correlation heatmap plotting with wgcna.
#'
#' @param datExpr Tranposed input matrix with gene names as column names and sample names as row names.
#' @param MEs Module eigengenes.
#' @param datTraits Phenotype data.
#' @param projectfolder File path where to save the output to. Defaults to working directory. Here, it saves the output to a subfolder called "WGCNA".
#' @return Writes Module_trait_correlations.txt and Module_CorPval.txt Plots module-trait correlation heatmap.
#' @examples
#' wgcna_heatmaps(MEs, datExpr, datTraits)
#' @export
wgcna_heatmaps <- function(MEs, datExpr, datTraits, projectfolder = getwd()){

  if (!requireNamespace("WGCNA", quietly = TRUE)) {
    stop("WGCNA needed for this function to work. Please install it.",
         call. = FALSE)
  }


  if (!file.exists(file.path(projectfolder, "WGCNA"))) {dir.create(file.path(projectfolder, "WGCNA")) }

  # names (colors) of the modules
  modNames = substring(names(MEs), 3)  # remove "ME" at the beginning of module eigengene names

  ### Correlation of Eigengenes with traits (separated by trait type)
  # initialisation of data.frames
  moduleTraitCor <- data.frame(row.names=colnames(MEs))
  moduleTraitPvalue <- data.frame(row.names=colnames(MEs))


  for(i in 1:length(colnames(datTraits))) {

    # if phenotype is numeric variable, correlation with expression by pearson correlation

    moduleTraitCor[i] <- as.data.frame(WGCNA::cor(MEs, datTraits[i], use="pairwise.complete.obs"))
    names(moduleTraitCor)[i] <- paste("WGCNA::cor",names(datTraits)[i], sep=".")

    # Calculation of correlation p-value independantly of type of correlation
    moduleTraitPvalue[i] <- WGCNA::corPvalueStudent(as.matrix(moduleTraitCor[i]), nrow(datTraits))  # not used for Dendrogram
    colnames(moduleTraitPvalue)[i] <- paste0("p.", colnames(moduleTraitCor)[i])
  }

  utils::write.table(moduleTraitCor, file.path(projectfolder, "WGCNA", "Module_trait_correlations.txt"), row.names = T, col.names = T, sep="\t")
  utils::write.table(moduleTraitPvalue, file.path(projectfolder, "WGCNA", "Module_CorPval.txt"), row.names = T, col.names = T, sep="\t")

  cat("\n-------------------------\n", "Module trait correlations saved to", file.path(projectfolder, "WGCNA", "Module_trait_correlations.txt"), "and", file.path(projectfolder, "WGCNA", "Module_CorPval.txt"), "\n-------------------------\n")


  #### HEATMAP Module-trait relationships
  # Will display correlations and their p-values, we color code each association by the correlation value:

  textMatrix = paste(signif(as.matrix(moduleTraitCor), 2), " (", signif(as.matrix(moduleTraitPvalue), 1), ")", sep = "")
  dim(textMatrix) = dim(moduleTraitCor)
  colnames(textMatrix) <- colnames(moduleTraitCor)
  rownames(textMatrix) <- rownames(moduleTraitCor)

  # Display the correlation values within a heatmap plot
  par(mar = c(6, 10, 4, 4));
  # Display the correlation values within a heatmap plot
  WGCNA::labeledHeatmap(Matrix = moduleTraitCor,
                 xLabels = colnames(moduleTraitCor),
                 yLabels = names(MEs),
                 ySymbols = names(MEs),
                 colorLabels = FALSE,
                 colors = WGCNA::blueWhiteRed(50),
                 textMatrix = textMatrix,
                 setStdMargins = FALSE,
                 cex.text = 0.5,
                 cex.lab = 0.8,
                 zlim = c(-1,1),
                 main = "Module-trait relationships - normalised beta values")
}

# devtools::document()