#' Randomly generated expression data (normalized)
#'
#' A dataset containing randomly generated normalized expression data in form for 4 replicates of 4 treatment groups.
#'
#' @format A data frame with 10000 rows and 16 variables. Rownames show gene names, Colnames are samples.
#' \describe{
#'   \item{Ctrl_0}{Treatment Ctrl replicate 1}
#'   \item{Ctrl_1}{Treatment Ctrl replicate 2}
#'   \item{Ctrl_2}{Treatment Ctrl replicate 3}
#'   \item{Ctrl_3}{Treatment Ctrl replicate 4}
#'   \item{TollLPS_0}{Treatment TolLPS replicate 1}
#'   \item{TollLPS_1}{Treatment TolLPS replicate 2}
#'   \item{TollLPS_2}{Treatment TolLPS replicate 3}
#'   \item{TollLPS_3}{Treatment TolLPS replicate 4}
#'   \item{TolS100A8_0}{Treatment TolMRP8/S100A8 replicate 1}
#'   \item{TolS100A8_1}{Treatment TolMRP8/S100A8 replicate 2}
#'   \item{TolS100A8_2}{Treatment TolMRP8/S100A8 replicate 3}
#'   \item{TolS100A8_3}{Treatment TolMRP8/S100A8 replicate 4}
#'   \item{ActLPS_0}{Treatment ActLPS replicate 1}
#'   \item{ActLPS_1}{Treatment ActLPS replicate 2}
#'   \item{ActLPS_2}{Treatment ActLPS replicate 3}
#'   \item{ActLPS_3}{Treatment ActLPS replicate 4}
#' }
#' @source Randomly generated expression data (R)
#' @usage data(expmatrix)
"expmatrix"

#' Randomly generated expression data (raw)
#'
#' A dataset containing randomly generated expression data in form of raw read counts for 4 replicates of 4 treatment groups.
#'
#' @format A data frame with 10000 rows and 16 variables. Rownames show gene names, Colnames are samples.
#' \describe{
#'   \item{Ctrl_0}{Treatment Ctrl replicate 1}
#'   \item{Ctrl_1}{Treatment Ctrl replicate 2}
#'   \item{Ctrl_2}{Treatment Ctrl replicate 3}
#'   \item{Ctrl_3}{Treatment Ctrl replicate 4}
#'   \item{TollLPS_0}{Treatment TolLPS replicate 1}
#'   \item{TollLPS_1}{Treatment TolLPS replicate 2}
#'   \item{TollLPS_2}{Treatment TolLPS replicate 3}
#'   \item{TollLPS_3}{Treatment TolLPS replicate 4}
#'   \item{TolS100A8_0}{Treatment TolMRP8/S100A8 replicate 1}
#'   \item{TolS100A8_1}{Treatment TolMRP8/S100A8 replicate 2}
#'   \item{TolS100A8_2}{Treatment TolMRP8/S100A8 replicate 3}
#'   \item{TolS100A8_3}{Treatment TolMRP8/S100A8 replicate 4}
#'   \item{ActLPS_0}{Treatment ActLPS replicate 1}
#'   \item{ActLPS_1}{Treatment ActLPS replicate 2}
#'   \item{ActLPS_2}{Treatment ActLPS replicate 3}
#'   \item{ActLPS_3}{Treatment ActLPS replicate 4}
#' }
#' @source Randomly generated expression data (R)
#' @usage data(countmatrix)
"countmatrix"

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
#' @usage data(DEgenes_pw)
"DEgenes_pw"


#' Output data frame from diff_limma_pw_unfiltered()
#'
#' A dataset containing output data frame from diff_limma_pw_unfiltered().
#'
#' @format A data frame with 10000 rows and 8 variables. Rownames show gene names.
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
#' @source Output data frame from diff_limma_pw_unfiltered() (R package "exprAnalysis")
#' @usage data(Allgenes_limma_pw)
"Allgenes_limma_pw"


#' Transcription factors from mouse and human
#'
#' A dataset containing transcription factors from mouse and human (from Bonn)
#'
#' @format A data frame with 929 rows and 3 variables. Rownames show gene names.
#' \describe{
#'   \item{Mouse}{Mouse TFs}
#'   \item{Human}{Human TFs}
#'   \item{Merged_Taxa}{Type of TF}
#' }
#' @source Bonner list used for TF networks
#' @usage data(TFs)
"TFs"


#' Mapping data on KEGG species code and corresponding Bioconductor gene annotation package
#'
#' Data on KEGG species, including KEGG code, scientific name,
#' common name, corresponding gene ID types, and gene annotation package
#' names in Bioconductor
#'
#' @format korg is a character matrix of ~3000 rows and 6 columns. First 3 columns are KEGG species
#' code, scientific name and common name, followed columns on gene ID types used
#' for each species: entrez.gnodes ("1" or "0", whether EntrezGene is the
#' default gene ID) and representative KEGG gene ID and EntrezGene ID.
#'
#' bods is a character matrix of 19 rows and 3 columns on the mapping
#' between gene annotation package names in Bioconductor, common name and
#' KEGG code of most common research species.
#' @source
#' http://www.genome.jp/kegg-bin/get_htext?br08601.keg
#' http://bioconductor.org/packages/release/BiocViews.html#___OrgDb
#' @usage
#' data(korg)
#' data(bods)
#' @examples
#' data(korg)
#' data(bods)
#' head(korg)
#' head(bods)
#' @keywords datasets
#' @aliases bods
"korg"
