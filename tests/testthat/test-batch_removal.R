context("Test of batch removal function")

test_that("Testing input expression data",{
  set.seed(12345)

  test_expmatrix <- as.data.frame(matrix(rnorm(100*30),nrow=100,ncol=8, dimnames=list(c(rownames(expmatrix[1:100,1:8])), c(colnames(expmatrix[1:100,1:8])))))
  pheno <- data.frame(batch=rep(c(1,2), 4), row.names = colnames(test_expmatrix))

  expect_that(batch_removal(expmatrix=test_expmatrix, pheno),throws_error("Input expression matrix is not of class matrix. Please change it."))
})


test_that("Testing input phenotype data",{
  set.seed(12345)

  test_expmatrix <- matrix(rnorm(100*30),nrow=100,ncol=8, dimnames=list(c(rownames(expmatrix[1:100,1:8])), c(colnames(expmatrix[1:100,1:8]))))

  pheno <- matrix(rep(c(1,2), 4), dimnames = list(colnames(test_expmatrix), "batch"))
  expect_that(batch_removal(expmatrix=test_expmatrix, pheno),throws_error("Input phenotype data is not of class data.frame Please change it."))

  pheno <- data.frame(batches=rep(c(1,2), 4), row.names = colnames(test_expmatrix))
  expect_that(batch_removal(expmatrix=test_expmatrix, pheno),throws_error("Input phenotype data frame needs a column called 'batch' denoting the batch group."))

  pheno <- data.frame(batch=as.numeric(rep(c(1,2), 4)), row.names = colnames(test_expmatrix))
  expect_that(batch_removal(expmatrix=test_expmatrix, pheno),throws_error("Batch column must be a factor."))

  pheno <- data.frame(batch=rep(c("batch1","batch2"), 4), row.names = colnames(test_expmatrix), stringsAsFactors = FALSE)
  expect_that(batch_removal(expmatrix=test_expmatrix, pheno),throws_error("Batch column must be a factor."))

})

