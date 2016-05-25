#' pathview_func (from pathview functions).
#'
#' This produces pathview plots of differentially expressed genes and their fold changes for given pathways.
#'
#' @details If you get the error message(s) data set 'korg' not found and/or data set 'bods' not found, it didn't properly extract these datasets from the pathview package. Run data(korg) and data(bods) manually!
#'
#' @param DEgenes List of differentially expressed genes as output given by diff_limma_pairwise(). Rownames should be gene names (SMYBOLS).
#' @param logFCcolumn Name of column that contains log fold change information.
#' @param pathway.id KEGG pathway identification number.
#' @param out.suffix Output suffix to be added to file name.
#' @return Three output files are produced for each pathway: An .xml, a .png of the pathway and a .png of the pathway with DE genes and their fold change.
#' @export
pathview_func <- function(DEgenes, logFCcolumn="logFC", pathway.id, out.suffix){

  if (!requireNamespace("pathview", quietly = TRUE)) {
    stop("pathview needed for this function to work. Please install it.",
         call. = FALSE)
  }

  DEgenes$entrez <- AnnotationDbi::mapIds(org.Hs.eg.db::org.Hs.eg.db,
                               keys=row.names(DEgenes),
                               column="ENTREZID",
                               keytype="SYMBOL",
                               multiVals="first")

  vals <- as.vector(DEgenes[,logFCcolumn])
  keys <- DEgenes$entrez
  names(vals) <- keys

  pathview::pathview(gene.data = vals, pathway.id = pathway.id, gene.idtype = "entrez", species = "hsa", out.suffix = out.suffix)

}

# devtools::document()