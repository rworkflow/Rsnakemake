![R-CMD-check](https://github.com/hubentu/Rsnakemake/workflows/R-CMD-check/badge.svg)

# Rsnakemake
R interface to `snakemake` and more.

## Installation
```{r}
devtools::install_github("rworkflow/Rsnakemake")
```

The package is built on
[basilisk](https://bioconductor.org/packages/release/bioc/html/basilisk.html). The
dependent python library
[snakemake](https://snakemake.github.io/) will be installed
automatically inside its conda environment.

## User Guide
``` r
vignette(package = "Rsnakemake")
```
