#' normalise_eset (using beadarray).
#'
#' Reads in Illumina expression data.
#'
#' @param eset expression set
#' @param method_norm Normalisation method. See ?beadarray::readBeadSummaryData for details
#' @param transform Transformation method. See ?beadarray::readBeadSummaryData for details
#' @return Returns (normalized) expression set object.
#' @examples
#' normalise_eset(...)
#' @export
normalise_eset <- function(eset, method_norm="quantile", transform="none"){

  eset <- beadarray::normaliseIllumina(eset, method=method_norm, transform=transform)

  # Change object class from 'ExpressionSetIllumina' to 'ExpressionSet'
  if(class(eset)!="ExpressionSet") {
    helpset <- eset
    eset <- Biobase::ExpressionSet(assayData = Biobase::exprs(helpset),
                                   phenoData = Biobase::phenoData(helpset),
                                   experimentData = Biobase::experimentData(helpset),
                                   annotation = beadarray::annotation(helpset))
    Biobase::fData(eset) <- Biobase::fData(helpset)
  }

  # return ExpressionSet
  return(eset)
}

# devtools::document()