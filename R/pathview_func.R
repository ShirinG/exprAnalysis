#' pathview_func (from pathview functions).
#'
#' This produces pathview plots of differentially expressed genes and their fold changes for given pathways.
#'
#' @param DE_genes_pw List of differentially expressed genes as output given by diff_limma_pairwise(). Rownames should be gene names (SMYBOLS).
#' @param pathway.id KEGG pathway identification number.
#' @param out.suffix Output suffix to be added to file name.
#' @return Three output files are produced for each pathway: An .xml, a .png of the pathway and a .png of the pathway with DE genes and their fold change.
#' @examples
#' pathview_func(DE_genes_pw, pathway.id = "04620", out.suffix = "DE_TolLPS")
#'                            #Toll-like-receptor signaling
#' @export
pathview_func <- function(DE_genes_pw, pathway.id, out.suffix){

  DE_genes_pw$entrez <- AnnotationDbi::mapIds(org.Hs.eg.db::org.Hs.eg.db,
                               keys=row.names(DE_genes_pw),
                               column="ENTREZID",
                               keytype="SYMBOL",
                               multiVals="first")

  vals <- as.vector(DE_genes_pw$logFC)
  keys <- DE_genes_pw$entrez
  names(vals) <- keys

  pathview::pathview(gene.data = vals, pathway.id = pathway.id, gene.idtype = "entrez", species = "hsa", out.suffix = out.suffix)

}

# devtools::document()