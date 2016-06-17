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

    trait <- traitsinfo[grep(unique(groups)[i], traitsinfo$groups),, drop = FALSE]

    if (i == 1) {
      MEs_color_replicates <- trait
    } else {
      MEs_color_replicates <- rbind(MEs_color_replicates, trait)
    }

    MEs_color_mean[i,1] <- mean(trait[,1])

  }

  bp <- graphics::barplot(MEs_color_mean[,1], ylab = "module eigengene values", ylim = c(min(MEs_color[,1])-0.2, max(MEs_color[,1])+0.2), main=paste0("Eigengenes of \n", color, " module"), col = "grey")
  for (i in 1:length(unique(groups))){
    graphics::points(y = MEs_color_replicates[grep(unique(groups)[i], MEs_color_replicates$groups),1], x=rep(bp[i],length(grep(unique(groups)[i], MEs_color_replicates$groups))), pch = 16, col = scales::alpha("black", 0.5))
  }
  graphics::axis(1, at=bp, labels=as.character(unique(groups)))
  box()
}

# devtools::document()