context("test test")

test_that("testing works",{
  expect_that(10, equals(10))
})


test_that("testing can access package function",{
  test_expmatrix <- matrix(rnorm(100*30),nrow=100,ncol=8,
                           dimnames=list(c(rownames(expmatrix[1:100,1:8])),
                                         c(colnames(expmatrix[1:100,1:8]))))
  pheno <- data.frame(batch=rep(c(1,2), 4), row.names = colnames(test_expmatrix))
  pheno$batch <- as.factor(pheno$batch)
  test_expmatrix_batch <- batch_removal(expmatrix=test_expmatrix, pheno)

  expect_that(ncol(test_expmatrix), equals(ncol(test_expmatrix_batch)))
  expect_that(nrow(test_expmatrix), equals(nrow(test_expmatrix_batch)))

})