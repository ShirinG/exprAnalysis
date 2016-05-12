#' Randomly generated expression data
#'
#' A dataset containing randomly generated expression data for 4 replicates of 4 treatment groups.
#'
#' @format A data frame with 10000 rows and 16 variables. Rownames show gene names, Colnames are samples.
#' \describe{
#'   \item{ActLPS_0}{Treatment ActLPS replicate 1}
#'   \item{ActLPS_1}{Treatment ActLPS replicate 2}
#'   \item{ActLPS_2}{Treatment ActLPS replicate 3}
#'   \item{ActLPS_3}{Treatment ActLPS replicate 4}
#'   \item{Ctrl_0}{Treatment Ctrl replicate 1}
#'   \item{Ctrl_1}{Treatment Ctrl replicate 2}
#'   \item{Ctrl_2}{Treatment Ctrl replicate 3}
#'   \item{Ctrl_3}{Treatment Ctrl replicate 4}
#'   \item{TollLPS_0}{Treatment TolLPS replicate 1}
#'   \item{TollLPS_1}{Treatment TolLPS replicate 2}
#'   \item{TollLPS_2}{Treatment TolLPS replicate 3}
#'   \item{TollLPS_3}{Treatment TolLPS replicate 4}
#'   \item{TollMRP8_0}{Treatment TolMRP8/S100A8 replicate 1}
#'   \item{TollMRP8_1}{Treatment TolMRP8/S100A8 replicate 2}
#'   \item{TollMRP8_2}{Treatment TolMRP8/S100A8 replicate 3}
#'   \item{TollMRP8_3}{Treatment TolMRP8/S100A8 replicate 4}
#' }
#' @source Randomly generated expression data (R)
"expmatrix"

#' Output data frame from diff_limma_pairwise()
#'
#' A dataset containing output data frame from diff_limma_pairwise().
#'
#' @format A data frame with 9956 rows and 8 variables. Rownames show gene names.
#' \describe{
#'   \item{logFC}{log fold change}
#'   \item{CI.L}{left confidence interval}
#'   \item{CI.R}{right confidence interval}
#'   \item{AveExpr}{Average expression}
#'   \item{t}{t statstics}
#'   \item{P.Value}{p-value}
#'   \item{adj.P.Val}{adjusted p-value}
#'   \item{B}{B statistics}
#' }
#' @source Output data frame from diff_limma_pairwise() (R package "exprAnalysis")
"DEgenes_pw"