#' batch_removal with sva's ComBat() function
#'
#' Removes batch effects in combined datasets using sva's ComBat() function.
#'
#' @param expmatrix An input matrix with gene names as row names and sample names as column names.
#' @param pheno Phenotype table with batch information.
#' @return Returns batch corrected expression matrix.
#' @examples
#' test_expmatrix <- matrix(rnorm(100*30),nrow=100,ncol=8,
#'                          dimnames=list(c(rownames(expmatrix[1:100,1:8])),
#'                          c(colnames(expmatrix[1:100,1:8]))))
#' pheno <- data.frame(batch=rep(c(1,2), 4), row.names = colnames(test_expmatrix))
#' test_expmatrix <- batch_removal(expmatrix=test_expmatrix, pheno)
#' @export
batch_removal <- function(expmatrix, pheno){

  if (!requireNamespace("sva", quietly = TRUE)) {stop("sva needed for this function to work. Please install it.", call. = FALSE)}

  if (!is.matrix(expmatrix)) {stop("Input expression matrix is not of class matrix. Please change it.", call. = FALSE)}
  if (!is.data.frame(pheno)) {stop("Input phenotype data is not of class data.frame Please change it.", call. = FALSE)}
  if (!any(colnames(pheno) == "batch")) {stop("Input phenotype data frame needs a column called 'batch' denoting the batch group.", call. = FALSE)}
  if (!is.factor(pheno$batch)) {stop("Batch column must be a factor.", call. = FALSE)}

  batch = pheno$batch
  modcombat = stats::model.matrix(~1, data=pheno)
  combat_expmatrix = sva::ComBat(dat=expmatrix, batch=batch, mod=modcombat, par.prior=TRUE, prior.plots=FALSE)

  return(combat_expmatrix)
}

# devtools::document()