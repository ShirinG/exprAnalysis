#' wgcna_modulememberships (from WGCNA functions).
#'
#' This function implements module membership analysis with wgcna.
#'
#' @param datExpr Tranposed input matrix with gene names as column names and sample names as row names.
#' @param datTraits Phenotype data.
#' @param MEs Module eigengenes.
#' @param moduleColors Module colors.
#' @param projectfolder File path where to save the output to. Defaults to working directory. Here, it saves the output to a subfolder called "WGCNA".
#' @return Writes geneModuleMembership.txt and geneModuleMembershipPvalue.txt. Saves Intramodular analysis plots to pdf. Returns datKME.
#' @examples
#' wgcna_modulememberships(datExpr, MEs, moduleColors)
#' @export
wgcna_modulememberships <- function(datExpr, datTraits, MEs, moduleColors, projectfolder = getwd()){

  if (!requireNamespace("WGCNA", quietly = TRUE)) {
    stop("WGCNA needed for this function to work. Please install it.",
         call. = FALSE)
  }

  if (!file.exists(file.path(projectfolder, "WGCNA"))) {dir.create(file.path(projectfolder, "WGCNA")) }

  # calculate the module membership values (aka. module eigengene based connectivity kME):
  datKME <- WGCNA::signedKME(datExpr, MEs)  # equals geneModuleMembership
  colnames(datKME) <- sub("kME", "MM.", colnames(datKME))

  MMPvalue <- as.data.frame(WGCNA:: corPvalueStudent(as.matrix(datKME), nrow(datTraits)));
  colnames(MMPvalue) <- sub("MM.", "p.MM.", colnames(MMPvalue))

  utils::write.table(datKME, file.path(projectfolder, "WGCNA", "geneModuleMembership.txt"), col.names = T, row.names = T, sep= "\t")
  utils::write.table(MMPvalue, file.path(projectfolder, "WGCNA", "geneModuleMembershipPvalue.txt"), col.names = T, row.names = T, sep= "\t")

  cat("\n-------------------------\n", "Gene module memberships saved to", file.path(projectfolder, "WGCNA", "geneModuleMembership.txt"), "and", file.path(projectfolder, "WGCNA", "geneModuleMembershipPvalue.txt"), "\n-------------------------\n")

  colorOfColumn <- substring(names(datKME),4)

  ### Correlation of Eigengenes with traits (separated by trait type)
  # initialisation of data.frames
  moduleTraitCor <- data.frame(row.names=colnames(MEs))
  moduleTraitPvalue <- data.frame(row.names=colnames(MEs))


  for(i in 1:length(colnames(datTraits))) {

    # if phenotype is numeric variable, correlation with expression by pearson correlation

    moduleTraitCor[i] <- as.data.frame(WGCNA::cor(MEs, datTraits[i], use="pairwise.complete.obs"))
    names(moduleTraitCor)[i] <- paste("WGCNA::cor",names(datTraits)[i], sep=".")

    # Calculation of correlation p-value independantly of type of correlation
    moduleTraitPvalue[i] <- WGCNA:: corPvalueStudent(as.matrix(moduleTraitCor[i]), nrow(datTraits))  # not used for Dendrogram
    colnames(moduleTraitPvalue)[i] <- paste0("p.", colnames(moduleTraitCor)[i])
  }

  names(moduleTraitPvalue) <- sub("^p\\.WGCNA::cor\\.", "", names(moduleTraitPvalue)) # remove prefix "p.WGCNA::cor."
  names(moduleTraitPvalue) <- sub("^p\\.icc\\.", "", names(moduleTraitPvalue)) # remove prefix "p.icc."


  GS.datTraits <- data.frame(row.names=colnames(datExpr))
  GSPvalue <- data.frame(row.names=colnames(datExpr))

  for(i in 1:length(colnames(datTraits))) {

    # if phenotype is numeric variable, correlation with expression by pearson correlation
    GS.datTraits[i] <- as.data.frame(WGCNA::cor(datExpr, datTraits[i], use="pairwise.complete.obs"))
    names(GS.datTraits)[i] <- paste("WGCNA::cor",names(datTraits)[i], sep=".")

    # Calculation of correlation p-value independantly of type of correlation
    GSPvalue[i] <- as.data.frame(WGCNA:: corPvalueStudent(as.matrix(GS.datTraits[i]), 16))  # not used for Dendrogram
    colnames(GSPvalue)[i] <- paste("p", names(GS.datTraits)[i], sep=".")

  }

  for (trait in colnames(datTraits)) {
    # select top associated module for each trait
    cat(paste("\ntrait:", trait, "\n"))
    selectModules <- rownames(moduleTraitPvalue[order(moduleTraitPvalue[,trait], decreasing=F), , drop=F])
    selectModules <- substring(selectModules,3) # remove substring "ME"

    # plot scatter plots for each trait
    grDevices::pdf(paste0("Intramodular_analysis_", trait, ".pdf"), width = 10, height = 14)
    par(mar=c(6, 8, 4, 4) + 0.1)

    for (module in selectModules) {
      column <- match(module,colorOfColumn)
      restModule <- moduleColors==module
      try(WGCNA::verboseScatterplot(datKME[restModule,column],GS.datTraits[restModule, grep(trait,names(moduleTraitCor), value=T)],
                             xlab=paste("Module Membership:",module,"module"),ylab=paste("Gene significance:", trait),
                             main="Module membership vs. gene significance",
                             pch=21, col="black", bg=module))
    }
    grDevices::dev.off()
  }

  return(datKME)
}

# devtools::document()