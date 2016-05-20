#' batch_removal with sva's ComBat() function
#'
#' Removes batch effects in combined datasets using sva's ComBat() function.
#'
#' @param expmatrix An input matrix with gene names as row names and sample names as column names.
#' @param pheno Phenotype table with batch information.
#' @return Returns batch corrected expression matrix.
#' @examples
#' pheno <- data.frame(sample=c(1:16), treatment=sub("(.*)(_[0-9])", "\\1", colnames(expmatrix)),
#'                    batch=ifelse(grepl("Ctrl", colnames(expmatrix)) == TRUE, "1",
#'                    ifelse(grepl("ActLPS", colnames(expmatrix)) == TRUE, "1", "2")),
#'                    row.names = colnames(expmatrix))
#' expmatrix <- batch_removal(expmatrix, pheno)
#'  @export
batch_removal <- function(expmatrix, pheno){

  batch = pheno$batch
  modcombat = stats::model.matrix(~1, data=pheno)
  combat_expmatrix = sva::ComBat(dat=expmatrix, batch=batch, mod=modcombat, par.prior=TRUE, prior.plots=FALSE)

  return(combat_expmatrix)
}

# devtools::document()