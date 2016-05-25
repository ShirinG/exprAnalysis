#' geneAnnotations (with AnnotationDbi).
#'
#' Adds gene annotations
#'
#' @param input Can be a) a data frame with keys as rownames or b) a vector of keys.
#' @param keys The keys to select records for from the database. Find keytypes with keytypes(org.Hs.eg.db).
#' @param column The columns or kinds of things that can be retrieved from the database. As with keys, all possible columns are returned by using columns(org.Hs.eg.db).
#' @param keytype Allows the user to discover which keytypes can be passed in to select or keys and the keytype argument.
#' @param organism Set organism. Defaults to human, can also be mouse.
#' @return a) will return the same data frame as input with additional column(s) containing the annotation(s). b) will convert input to data frame and add column(s) containing the annotation(s).
#' @export
geneAnnotations <- function(input, keys, column, keytype, organism = "human"){

  if (!requireNamespace("AnnotationDbi", quietly = TRUE)) {
    stop("AnnotationDbi needed for this function to work. Please install it.",
         call. = FALSE)
  }

  if (organism == "human"){
  if (!requireNamespace("org.Hs.eg.db", quietly = TRUE)) {
    stop("org.Hs.eg.db needed for this function to work. Please install it.",
         call. = FALSE)
  }
  }

  if (organism == "mouse"){
    if (!requireNamespace("org.Mm.eg.db", quietly = TRUE)) {
      stop("org.Mm.eg.db needed for this function to work. Please install it.",
           call. = FALSE)
    }
  }


  if (is.data.frame(input)){

    for (i in 1:length(column)){

      if (organism == "human"){
        input[,column[i]] <- AnnotationDbi::mapIds(org.Hs.eg.db::org.Hs.eg.db,
                                                   keys=keys,
                                                   column=column[i],
                                                   keytype=keytype,
                                                   multiVals="first")
      }

      if (organism == "mouse"){
        input[,column[i]] <- AnnotationDbi::mapIds(org.Mm.eg.db::org.Mm.eg.db,
                                                   keys=keys,
                                                   column=column[i],
                                                   keytype=keytype,
                                                   multiVals="first")
      }

    }
  }

  if (is.vector(input)){

    for (i in 1:length(column)){
      input <- as.data.frame(input)

      if (organism == "human"){
      input[,column[i]] <- AnnotationDbi::mapIds(org.Hs.eg.db::org.Hs.eg.db,
                                                 keys=keys,
                                                 column=column[i],
                                                 keytype=keytype,
                                                 multiVals="first")
      }

      if (organism == "mouse"){
        input[,column[i]] <- AnnotationDbi::mapIds(org.Mm.eg.db::org.Mm.eg.db,
                                                   keys=keys,
                                                   column=column[i],
                                                   keytype=keytype,
                                                   multiVals="first")
      }
    }
  }

  return(input)

}

# devtools::document()