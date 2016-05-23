#' wgcna_plotDendroAndColors (from WGCNA functions).
#'
#' This function implements module-trait correlation dendrogram plotting with wgcna.
#'
#' @param datExpr Tranposed input matrix with gene names as column names and sample names as row names.
#' @param datTraits Phenotype data.
#' @param net Output from blockwiseModules().
#' @return Plots module-trait correlation dendrogram
#' @examples
#' wgcna_plotDendroAndColors(datExpr, datTraits)
#' @export
wgcna_plotDendroAndColors <- function(datExpr, datTraits, net){

  if (!requireNamespace("WGCNA", quietly = TRUE)) {
    stop("WGCNA needed for this function to work. Please install it.",
         call. = FALSE)
  }

  # Convert labels to colors for plotting
  moduleColors = WGCNA::labels2colors(net$colors)

  blocknumber=length(unique(na.omit(net$blocks)))
  datColors=data.frame(moduleColors)[net$blockGenes[[blocknumber]],]

  # Create tables of correlations and correlation p-values
  colnames(datExpr)[which(is.na(colnames(datExpr)) == TRUE)] <- "NA.0"
  GS.datTraits <- data.frame(row.names=colnames(datExpr))
  GSPvalue <- data.frame(row.names=colnames(datExpr))

  for(i in 1:length(colnames(datTraits))) {

    # if phenotype is numeric variable, correlation with expression by pearson correlation
    GS.datTraits[i] <- as.data.frame(WGCNA::cor(datExpr, datTraits[i], use="pairwise.complete.obs"))
    names(GS.datTraits)[i] <- paste("WGCNA::cor",names(datTraits)[i], sep=".")

    # Calculation of correlation p-value independantly of type of correlation
    GSPvalue[i] <- as.data.frame(WGCNA::corPvalueStudent(as.matrix(GS.datTraits[i]), nrow(datTraits)))  # not used for Dendrogram
    colnames(GSPvalue)[i] <- paste("p", names(GS.datTraits)[i], sep=".")

  }

  GS.TraitColor <- WGCNA::numbers2colors(GS.datTraits, signed=T)
  colnames(GS.TraitColor) <- colnames(GS.datTraits)

  # 'moduleColors' (first row underneath dendrogram) are module names.
  datColors <- data.frame(moduleColors, GS.TraitColor)

  # The dendrogram can be displayed (blockwise) together with the color assignment using the following code:
  for (b in 1:blocknumber) {
    # Plot the dendrogram and the module colors underneath

    WGCNA::plotDendroAndColors(net$dendrograms[[b]], colors=datColors[net$blockGenes[[b]],],
                        groupLabels=colnames(datColors),
                        main=paste("Cluster Dendrogram - Block",b,"of",blocknumber),
                        dendroLabels = FALSE, hang = 0.03,
                        addGuide = TRUE, guideHang = 0.05)
  }

  return(moduleColors)

}

# devtools::document()