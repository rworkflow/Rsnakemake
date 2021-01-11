#' @importFrom basilisk BasiliskEnvironment
env_snakemake <- BasiliskEnvironment("snakemake", pkgname="Rsnakemake",
                                     packages = c("snakemake==5.31.1"))
