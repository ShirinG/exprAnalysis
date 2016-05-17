#' TF_networks.
#'
#' Ceates the input files for TF network analysis using Biolayout3D and Cytoscape.
#'
#' @details The .expression matrix of TF expression data will have to be opened with Biolayout3D: Set Minimum Correlation and Correlation metric (by default 0.7 and Pearson). Then choose a suitable correlation coefficient (Graph Degree Distribution should be close to linear). Save the resulting network as a TGF file.
#' Open the TGF file in Cytoscape: Open network from file. Then got to Advanced Options: untick "Use first column names" and add " to "Other:". Now set Column 2 as Source and Column 5 as Target.
#' Then open the node annotation table that was also saved by this function: Open table from file, import data as Node Table Columns. YOu can then customize the look of your network.
#'
#' @param expmatrix An input matrix with gene names as row names and sample names as column names.
#' @param nodeAnno A data frame with node annotation, e.g. logFC and differential expression (e.g. limma output). Rownames have to correspond to rownames of expmatrix!
#' @param adjPcol Column name for adjusted p-values (used for creating a column "DE" in the output node annotation).
#' @param p.value Significance threshold. Defaults to 0.05.
#' @param projectfolder File path where to save the output to. Defaults to working directory. Here, it saves the output to a subfolder called "Networks".
#' @return A .expression output matrix of gene expression of transkription factors in dataset used as Biolayout3D input.
#' And based on these TFs, it also produces a .txt with node annotations of e.g. logFC and differential expression (e.g. limma output)
#' @examples
#' TF_networks(expmatrix, nodeAnno=Allgenes_limma_pw)
#' @export
TF_networks <- function(expmatrix, nodeAnno, adjPcol="adj.P.Val", p.value=0.05, projectfolder = getwd()){

  if (!file.exists(file.path(projectfolder, "Networks"))) {dir.create(file.path(projectfolder, "Networks")) }

  TFs_human <- TFs[,2:3]

  TF_gene_exprs <- merge(TFs_human,expmatrix, by.x = "Human", by.y = "row.names", all = FALSE)

  utils::write.table(TF_gene_exprs, file.path(projectfolder, "Networks", "TF_gene_exprs.expression"), col.names = T, row.names = F, sep = "\t")
  cat("\n-------------------------\n", "TF expression matrix saved to", file.path(projectfolder, "Networks", "TF_gene_exprs.expression"), "\n-------------------------\n")


  DEunfiltered <- merge(TF_gene_exprs[,1:2], nodeAnno, by.x = "Human", by.y = "row.names", all = TRUE)
  DEunfiltered$DE <- ifelse(DEunfiltered[,adjPcol] < p.value, "1", "0")

  utils::write.table(DEunfiltered, file.path(projectfolder, "Networks", "TF_nodeAnno.txt"), col.names = T, row.names = F, sep = "\t", quote = F)
  cat("\n-------------------------\n", "TF network node annotation saved to", file.path(projectfolder, "Networks", "TF_nodeAnno.txt"), "\n-------------------------\n")

}

# devtools::document()
