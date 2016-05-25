#' read_Illumina (using beadarray).
#'
#' Reads in Illumina expression data.
#'
#' @param dataFile SampleProbeProfile.
#' @param qcFile ControlProbeProfile.
#' @param sampleSheet samplesheet.
#' @param expressionchipType Expression chip name.
#' @param ProbeID Column name of probe ID in SampleProbeProfile.
#' @param controlID Column name of probe ID in ControlProbeProfile
#' @param method_norm Normalisation method. See ?beadarray::readBeadSummaryData for details.
#' @param transform Transformation method. See ?beadarray::readBeadSummaryData for details.
#' @return Returns expression set object.
#' @export
read_Illumina <- function(dataFile, qcFile, sampleSheet, expressionchipType, ProbeID = "PROBE_ID", controlID="ProbeID", method_norm ="none", transform="log2") {

  # Reading Bead-Summary Data
  eset <- beadarray::readBeadSummaryData(dataFile = dataFile, qcFile = qcFile, sampleSheet = sampleSheet, sep="\t",
                             columns = list(exprs = "AVG_Signal", se.exprs="BEAD_STDERR",
                                            nObservations = "Avg_NBEADS", Detection="Detection Pval"),
                             ProbeID = ProbeID, skip = 0,
                             controlID = controlID, qc.skip = 0,
                             qc.columns = list(exprs = "AVG_Signal", Detection = "Detection Pval"),
                             illuminaAnnotation = expressionchipType,
                             annoCols = c("PROBE_ID","SYMBOL"))

  # transforming expression values (default is log2-transformation)
  eset <- beadarray::normaliseIllumina(eset, method=method_norm, transform=transform)

  return(eset)
}

# devtools::document()
