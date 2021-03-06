#!/usr/bin/env R

#-----------------------------------------------------------------------------------------------
# SCRIPT: compute_BIC_wts_for_pan-genome_matrix_shell_estimates_tab_output.R
# AUTHOR: Pablo Vinuesa, CCG-UNAM, http://www.ccg.unam.mx/~vinuesa/, March, 11th, 2019
# AIM: select the best binomial mixture model among those fitted to 
#      pan-genome data with GET_HOMOLOGUES and parse_pangenome_matrix.pl
# VERSION: 0.2 12Mar19
#
# HOW TO RUN:
# Run the following line in the directory containing the angenome_matrix_t0__shell_estimates.tab
#     produced by parse_pangenome_matrix.pl from the GET_HOMOLOGUES suite:
# Rscript compute_BIC_wts_for_pan-genome_matrix_shell_estimates_tab_output.R
#-----------------------------------------------------------------------------------------------

# 1. Edit the header and other componentes of the pangenome_matrix_t0__shell_estimates.tab file,
# computed with  parse_pangenome_matrix.pl -m pangenome_matrix_t0.tab -s, t
# o generate a proper tsv file

if( file.exists("pangenome_matrix_t0__shell_estimates.tab") ){
  system("sed 's/Core.size/N.comp Core.size/; s/components //; s/Sample.*//; s/ /\t/g' pangenome_matrix_t0__shell_estimates.tab > pangenome_matrix_t0__shell_estimates.tabed")
}else  stop(" ERROR: file pangenome_matrix_t0__shell_estimates.tab was not found in working directory!")

if( file.exists("pangenome_matrix_t0__shell_estimates.tabed") ) {
   cat(">>> Created file pangenome_matrix_t0__shell_estimates.tabed", "\n")
}else stop(" ERROR: file pangenome_matrix_t0__shell_estimates.tabed was not created!")



# 2. read the resulting table into an R data frame
cat(">>> Reading file pangenome_matrix_t0__shell_estimates.tabed into data frame ...", "\n")
dfr <- read.table(file="pangenome_matrix_t0__shell_estimates.tabed", header = TRUE, sep ="\t")

cat(">>> The data:", "\n")
(dfr)

# 3. print BICs by number of components. Note: the lower the BIC, the bettter
# Interpretation of BICs, based on deltaBIC 
# deltaBIC (difference respect to the BICmin model)
# deltaBIC  Evidence against higher BIC 
# 0 to 2  Not worth more than a bare mention
# 2 to 6  Positive
# 6 to 10 	Strong
# >10 	Very Strong 

cat("\n# NOTE: Interpretation of BICs, based on deltaBIC 
# deltaBIC (difference respect to the BICmin model)
===================================================
deltaBIC  Evidence against higher BIC 
---------------------------------------------------
0 - 2     Not worth more than a bare mention
2 - 6     Positive
6 - 10    Strong
>10       Very Strong
--------------------------------------------------\n\n")


BICs <- dfr$BIC
names(BICs) <- dfr$N.comp

cat("\n# The BIC values for the indicated number of components of the binomial mixture models fitted are:", "\n")
BICs

cat("\n# The (best) BICmin value and associated number of components are:", "\n")
(BICs[order(BICs)])[1]

# 4. Compute the AIC weight fot the BICs and print them out, for each N.Comp
require(qpcR, quietly = TRUE) # only required for this section

wts <- akaike.weights(dfr$BIC)$weights
names(wts) <- dfr$N.comp

cat("\n# The AIC weights for the indicated number of components are:", "\n")
wts
