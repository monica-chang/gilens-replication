# Gov 52 Replication Project

This is a replication of the results from the paper "Testing Theories of American Politics: Elites, Interest Groups, and Average Citizens” by Martin Gilens and Benjamin Page, published in 2014 in Perspectives on Politics. This replication was done as part of my coursework in GOV 52: Models, taught be Professor Jefferson Gill.

## Description of what files are included in the material

replication_report.Rmd - This R Markdown file contains the code to generate tables and figures from the cleaned dataset as well as the descriptive text for the report.

replication_report.pdf - A PDF version of the replication report.

/scripts folder
clean_gilens.R - This script cleans the raw dataset by excluding questions about policy changes that would require a constitutional amendment or Supreme Court ruling, proposed changes that were partially but not fully adopted, and questions that lacked income breakdowns. 1,779 questions from 1981–2002 remain for the analyses.

/raw_data folder
- DS1_v2_0.sav - The raw dataset that is publicly available. This is a SPSS formatted dataset for 1981-2002. Each observation is one survey question asking about a proposed policy change; n=1863 with 27 cases missing data on preference by income level.

/clean_data folder
- clean_gilens.csv - The cleaned dataset that is output after running clean_gilens.R.

/documents folder
- gilens_appendixes.docx - Appendices of the original paper. Appendix 1 includes a list of business-oriented and mass-based interest groups. Appendix 2 includes the authors' rationale for how they corrected for correlated measurement errors in their model. Appendix 2 also contains a supplementary table of result from an OLS regression that is analogous to the structual equation modeling used in the paper. Since I use OLS regression in my replication, Appendix 2 is particularly important to check whether my results are correct.

- data_coding.pdf - A text document explaining the coding procedures for policy outcomes (variables OUTCOME and SWITCHER), for intuitional responsibility (variable INSTRRESP), and for interest group alignments (variables INTGRP_STFAV, INTGRP_SWFAV, INTGRP_STOPP, and INTGRP_SWOPP). Provided by the original author.

- variable_descriptions.pdf - A text document describing the variables in the raw data.

- testing_theories.pdf - PDF copy of the paper being replicated.

## How to run the code and what is the output

Open replication_report.Rmd and knit the R Markdown file into a PDF to
generate the report.

## Computational environment

R version 4.0.2 (2020-06-22)

Platform: x86_64-apple-darwin17.0 (64-bit)

Running under: macOS Mojave 10.14.6

R packages:

tidyverse   1.3.1

janitor     2.1.0

rstanarm    2.21.1

stargazer   5.2.2

haven       2.4.1

modEvA      2.0

dplyr       1.0.5

statxp      0.2

gt          0.2.2

cowplot     1.1.1
