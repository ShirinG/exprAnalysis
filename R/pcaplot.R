#' pca_plot (from pcaGoPromoter functions).
#'
#' This is a collection of functions from the package "pcaGoPromoter".
#' It calculates the principle components and plots them.
#'
#' @param expmatrix An input matrix with gene names as row names and sample names as column names.
#' @param groups Define sample groups.
#' @param PCs Principle components to plot (pick two). Defaults to PCs 1 and 2.
#' @param main Main title. Defaults to "PCA plot".
#' @return A PCA plot.
#' @export
pca_plot <- function(expmatrix, groups, PCs = c(1,2), main = "PCA plot"){

    if (!requireNamespace("pcaGoPromoter", quietly = TRUE)) {
      stop("pcaGoPromoter needed for this function to work. Please install it.",
           call. = FALSE)
    }

  # Produce PCA
  pcaOutput <- pcaGoPromoter::pca(expmatrix, printDropped = FALSE, scale=TRUE, center=TRUE)

  # Plot PCA
  pcaGoPromoter::plot.pca(pcaOutput, groups, PCs = PCs, printNames = TRUE, symbolColors = TRUE, plotCI = TRUE, main=main)
}

# devtools::document()