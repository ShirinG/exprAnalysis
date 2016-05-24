#' quality_control_plots (using arrayQualityMetrics).
#'
#' Produces quality control plots.
#'
#' @param eset expression set object.
#' @param projectfolder Projectfolder. Creates a subfolder "QC" here and saves output to it.
#' @param groupColumn Column name denoting treatment information
#' @return Produces quality control plots.
#' @examples
#' quality_control_plots(eset)
#' @export
quality_control_plots <- function(eset, projectfolder=getwd(), groupColumn = "Sample_Group") {

  orig_par <- par(no.readonly=T)

  if (!file.exists(file.path(projectfolder, "QC"))) {dir.create(file.path(projectfolder, "QC"), recursive=T) }


  aqMetrics <- arrayQualityMetrics::arrayQualityMetrics(eset, outdir=file.path(projectfolder, "QC"),
                                                        force=T, spatial=T, do.logtransform=F, intgroup=groupColumn,
                                                        reporttitle = paste("arrayQualityMetrics report"))

  closeAllConnections() # if arrayQualityMetrics produces error and leaves connection open

  # restore graphical parameter settings
  par(orig_par)

}

# devtools::document()