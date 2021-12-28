
<!-- README.md is generated from README.Rmd. Please edit that file -->

# doppelgangerIdentifier

<!-- badges: start -->

<!-- badges: end -->

The goal of doppelgangerIdentifier is to find PPCC data doppelgangers
that may have an inflationary effect on model accuracy.

*PPCC*: Pairwise Pearson’s Correlation Coefficient, the Pearson’s
Correlation Coefficient between samples from two different batches.

## Installation

You can install the development version of doppelgangerIdentifier from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("lr98769/doppelgangerIdentifier")
```

## Functions

There are 4 main functions in this package:

### 1\. getPPCCDoppelgangers

Finds PPCC data doppelgangers in the data using batch, class and patient
id meta data.

\*Note: The effectiveness of getPPCCDoppelganger is affected by the
efficacy of the sva::ComBat. Differences in the distribution of classes
between batches affects the effectiveness of ComBat and as a result PPCC
doppelganger identification.

``` r
library(doppelgangerIdentifier)
ppccDoppelgangerResults = getPPCCDoppelgangers(raw_data, meta_data)
```

### 2\. visualisePPCCDoppelgangers

Shows the distribution of PPCCs of different sample pairs.

``` r
library(doppelgangerIdentifier)
visualisePPCCDoppelgangers(ppccDoppelgangerResults)
```

### 3\. doppelgangerVerification

Tests inflationary effects of the PPCC data doppelganger.

  - Note: Refer to the documentation for the format of the experiment
    plan file.

<!-- end list -->

``` r
library(doppelgangerIdentifier)
veri_result = doppelgangerVerification(experimentPlanFilename, raw_data, meta_data)
```

### 4\. displayVerificationResults

Visualise the accuracy of each Train-Valid Pair.

``` r
library(doppelgangerIdentifier)
displayVerificationResults(veri_result)
```
