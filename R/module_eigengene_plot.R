#' module_eigengene_plot (from WGCNA output).
#'
#' This function implements module eigengene plots from wgcna output.
#'
#' @param groups Define sample groups.
#' @param MEs Module eigengenes.
#' @param color Module color.
#' @return Produces module eigengene plots.
#' @examples
#' groups <- as.factor(c(rep("Ctrl",4), rep("TolLPS",4), rep("TolS100A8",4), rep("ActLPS",4)))
#' module_eigengene_plot(groups, MEs, color="red")
#' @export
module_eigengene_plot <- function(groups, MEs, color){

  MEs_color <- MEs[,which(colnames(MEs) == paste0("ME", color)), drop=FALSE]

  traitsinfo <- cbind(MEs_color, groups)

  MEs_color_mean <- data.frame(row.names = unique(groups))

  for (i in 1:length(unique(groups))){

    trait <- MEs_color[grep(unique(groups)[i], rownames(MEs_color)),1, drop = FALSE]

    if (i == 1) {
      MEs_color_replicates <- trait
    } else {
      MEs_color_replicates <- rbind(MEs_color_replicates, trait)
    }

    MEs_color_mean[i,1] <- mean(trait[,1])

  }

  bp <- graphics::barplot(MEs_color_mean[,1], ylab = "module eigengene values", ylim = c(min(MEs_color[,1])-0.2, max(MEs_color[,1])+0.2), main=paste0("Eigengenes of \n", color, " module"), col = "grey")
  graphics::points(y = MEs_color_replicates[,1], x=rep(bp,each=length(unique(groups))), pch = 16, col = scales::alpha("black", 0.5))
  box()
}

# devtools::document()