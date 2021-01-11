#' snakemake
#'
#' The snakemake function interface to the `snakemake` python module.
#' @param snakefile The path to the Snakefile.
#' @param workdir The path to working directory.
#' @param configfiles The list of config files.
#' @param ... More options for `snakemake`.
#' @return logs.
#' @importFrom reticulate py_module_available
#' @importFrom basilisk basiliskStart basiliskRun basiliskStop
#' @export
snakemake <- function(snakefile,
                      workdir = NULL,
                      configfiles = NULL,
                      ...){
    if(!is.null(workdir)){
        workdir <- normalizePath(workdir)
    }
    if(!is.null(configfiles)){
        configfiles <- as.list(normalizePath(configfiles))
    }
    args <- list(snakefile = normalizePath(snakefile),
                 workdir = workdir,
                 configfiles = configfiles,
                 ...)
    if(py_module_available("snakemake")){
        sn <- reticulate::import("snakemake")  
        do.call(sn$snakemake, args)
    }else{
        cl <- basiliskStart(env_snakemake)    
        basiliskRun(cl, function(args){
            sn <- reticulate::import("snakemake")  
            do.call(sn$snakemake, args)
        }, args = args)
        basiliskStop(cl)
    }
}

#' snakemake cmd
#'
#' Run workflow by snakemake cmd
#' @param snakefile The path to the Snakefile.
#' @param workdir The path to working directory.
#' @param configfile The list of config files.
#' @param cores The number of CPU cores to use.
#' @param Args More arguments for `snakemake`. Details can be found
#'     at:
#'     https://snakemake.readthedocs.io/en/stable/executing/cli.html
#' @param showLog Whether to print stdout and stderr.
#' @return The logs.
#' @export
snakemake_cmd <- function(snakefile, configfile = NULL, workdir = NULL,
                          cores = 1, Args = character(), showLog = TRUE){
    if(!file.exists(Sys.which("snakemake"))){
        cl <- basiliskStart(env_snakemake)
        basiliskStop(cl)
    }
    if(showLog) {
        stdout <- stderr <- ""
    }else{
        stdout <- stdout <- TRUE
    }
    Args <- paste("--snakefile", snakefile, Args)
    if(!is.null(configfile)){
        Args <- paste("--configfile", configfile, Args)
    }
    if(!is.null(workdir)){
        Args <- paste("--directory", workdir, Args)
    }
    system2("snakemake",
            args = paste("--cores", cores, Args),
            stdout = stdout,
            stderr = stderr)
}
