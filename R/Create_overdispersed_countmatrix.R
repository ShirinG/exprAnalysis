
#allGenes <- read.table("W:/Shirin/AID-NET/ATACSeq/mRNA/readCounts/Summarize_overlaps_DESeq2/Summarize_overlaps_DESeq2_count_matrix.txt", header=T)
#colnames(allGenes) <- sub("Toll", "Tol", colnames(allGenes))
#colnames(allGenes) <- sub("MRP8", "S100A8", colnames(allGenes))
#allGenes <- allGenes[,c(1,5,9,13,2,6,10,14,3,7,11,15,4,8,12,16)]
#head(allGenes)

#countmatrix2 <- allGenes[sample(nrow(allGenes)),]
#rownames(countmatrix2) <- sample(rownames(countmatrix2))

#countmatrix2 <- countmatrix2+runif(1, 5, 20)
#countmatrix2 <- round(countmatrix2*runif(1, 0.1, 0.5))
#countmatrix2 <- countmatrix2[rowSums(countmatrix2) > 5*16, ]

#countmatrix2 <- countmatrix2[sample(nrow(countmatrix2), size = 10000),]

#head(countmatrix2)
#nrow(countmatrix2)

#var_vs_mean(countmatrix2)

#rownames(ExpDesign) <- colnames(countmatrix2)
#data <- DESeq2::DESeqDataSetFromMatrix(countData = countmatrix2, colData=ExpDesign, design=~treatment)

#data <- data[rowSums(counts(data)) > 1, ]

#data_DESeq <- DESeq(data)

#expmatrix_DESeq <- rlog(data_DESeq)
#expmatrix <- assay(expmatrix_DESeq)

#var_vs_mean(expmatrix)

#countmatrix <- countmatrix2
#devtools::use_data(countmatrix, overwrite = T)
#devtools::use_data(expmatrix, overwrite = T)
