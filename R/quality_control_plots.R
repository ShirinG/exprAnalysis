#' quality_control_plots (using arrayQualityMetrics).
#'
#' Produces quality control plots.
#'
#' @param eset expression set object.
#' @param projectfolder Projectfolder. Creates a subfolder "QC" here and saves output to it.
#' @param groupColumn Column name denoting treatment information
#' @return Produces quality control plots.
#' @export
quality_control_plots <- function(eset, projectfolder=getwd(), groupColumn = "Sample_Group") {

  orig_par <- par(no.readonly=T)

  if (!file.exists(file.path(projectfolder, "QC"))) {dir.create(file.path(projectfolder, "QC"), recursive=T) }

  preparedData = arrayQualityMetrics::prepdata(expressionset = eset,
                          intgroup = groupColumn,
                          do.logtransform = FALSE)

  bo = arrayQualityMetrics::aqm.boxplot(preparedData)
  de = arrayQualityMetrics::aqm.density(preparedData)
  qm = list("Boxplot" = bo, "Density" = de)

  arrayQualityMetrics::aqm.writereport(modules = qm, reporttitle = "My example", outdir = file.path(projectfolder, "QC"),
                  arrayTable = Biobase::pData(eset))

  closeAllConnections() # if arrayQualityMetrics produces error and leaves connection open

  # restore graphical parameter settings
  par(orig_par)

}

# devtools::document()