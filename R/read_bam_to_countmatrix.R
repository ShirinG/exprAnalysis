#' read_bam_to_countmatrix
#'
#' Reads in bam files and creates a count matrix based on a gtf file.
#'
#' @details So far, it is only implemented for obtaining read counts for genes based on summarized counts of reads overlapping all exons of each gene.
#'
#' @param sampleTable Sample Table. See Vignette for instructions on how to build this data frame.
#' @param gtffile GTF file.
#' @param projectfolder File path where to save the output to. Defaults to working directory. Here, it saves the output to a subfolder called "Networks".
#' @param outPrefix Prefix added to output name.
#' @param singleEnd A logical indicating if reads are single or paired-end. In Bioconductor > 2.12 it is not necessary to sort paired-end BAM files by qname. When counting with summarizeOverlaps, setting singleEnd=FALSE will trigger paired-end reading and counting. It is fine to also set asMates=TRUE in the BamFile but is not necessary when singleEnd=FALSE.
#' @param ignore.strand A logical indicating if strand should be considered when matching.
#' @param fragments A logical; applied to paired-end data only. fragments controls which function is used to read the data which subsequently affects which records are included in counting.
#' When fragments=FALSE, data are read with readGAlignmentPairs and returned in a GAlignmentPairs class. This class only holds 'mated pairs' from opposite strands; same-strand pairs singletons, reads with unmapped pairs and other fragments are dropped.
#' When fragments=TRUE, data are read with readGAlignmentsList and returned in a GAlignmentsList class. This class holds 'mated pairs' as well as same-strand pairs, singletons, reads with unmapped pairs and other fragments. Because more records are kept, generally counts will be higher when fragments=TRUE.
#' The term 'mated pairs' refers to records paired with the algorithm described on the ?readGAlignmentsList man page.
#' @return Writes the count matrix as .txt to file and returns a DESeq data set, which can then be used further with DESeq2.
#' @examples
#' read_bam_to_countmatrix(sampleTable,
#'                         gtffile = "Homo_sapiens.GRCh38.83.gtf",
#'                         projectfolder = getwd(), outPrefix="Test")
#' @export
read_bam_to_countmatrix <- function(sampleTable, gtffile, projectfolder = getwd(), outPrefix, singleEnd=FALSE, ignore.strand=TRUE, fragments=TRUE){

  if (!requireNamespace("Rsamtools", quietly = TRUE)) {
    stop("Rsamtools needed for this function to work. Please install it.",
         call. = FALSE)
  }

  if (!requireNamespace("GenomicFeatures", quietly = TRUE)) {
    stop("GenomicFeatures needed for this function to work. Please install it.",
         call. = FALSE)
  }

  if (!requireNamespace("BiocParallel", quietly = TRUE)) {
    stop("BiocParallel needed for this function to work. Please install it.",
         call. = FALSE)
  }

  if (!requireNamespace("GenomicAlignments", quietly = TRUE)) {
    stop("GenomicAlignments needed for this function to work. Please install it.",
         call. = FALSE)
  }

  if (!requireNamespace("SummarizedExperiment", quietly = TRUE)) {
    stop("SummarizedExperiment needed for this function to work. Please install it.",
         call. = FALSE)
  }


  filenames <- file.path(dir, paste0(sampleTable$filenames))

  if(any(!file.exists(filenames))) stop("Bam file path does not exist, check spelling!")

  bamfiles <- Rsamtools::BamFileList(filenames, yieldSize=2000000)

  # Defining gene models
    txdb <- GenomicFeatures::makeTxDbFromGFF(gtffile, format="gtf", circ_seqs=character())

    # The following line produces a GRangesList of all the exons grouped by gene. Each element of the list is a GRanges object of the exons for a gene.
    ebg <- GenomicFeatures::exonsBy(txdb, by="gene")

    ## Read counting step
    BiocParallel::register(BiocParallel::SerialParam())

    #The following call creates the SummarizedExperiment object with counts:

    se <- GenomicAlignments::summarizeOverlaps(features=ebg, reads=bamfiles,
                            mode="Union",
                            singleEnd=singleEnd,
                            ignore.strand=ignore.strand,
                            fragments=fragments)

    SummarizedExperiment::colData(se) <- DataFrame(sampleTable)

    data <- DESeq2::DESeqDataSet(se, design = ~colData)

    if (!file.exists(file.path(projectfolder, "Countdata"))) {dir.create(file.path(projectfolder, "Countdata")) }

    utils::write.table(SummarizedExperiment::assay(data), file.path(projectfolder, "Countdata", paste0(outPrefix, "_Summarize_overlaps_count_matrix.txt")), col.names = T, row.names = T, sep = "\t")
    cat("\n-------------------------\n", "Count matrix saved to", file.path(projectfolder, "Countdata", paste0(outPrefix, "_Summarize_overlaps_count_matrix.txt")), "\n-------------------------\n")

    return(data)
}

# devtools::document()
