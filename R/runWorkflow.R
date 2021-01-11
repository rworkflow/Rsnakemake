#' run Workflow
#'
#' To run workflow from `Snakemake` object and list of inputs.
#' @param sobject A `Snakemake` object.
#' @param inputList A list of inputs.
#' @param outdir The output directory.
#' @param workdir The `snakemake` work directory.
#' @param ... More arguments from `snakemake_cmd`.
#' @importFrom yaml as.yaml
#' @export
runWorkflow <- function(sobject, inputList,
                        outdir = NULL, workdir = NULL, ...){
    stopifnot(is(sobject, "Snakemake"))
    stopifnot(all(names(inputList) %in% names(inputs(sobject))))

    script_wf <- workflow(sobject)

    if(!is.null(outdir) && !dir.exists(outdir)){
        dir.create(outdir, recursive = TRUE)
    }
    if(!is.null(outdir) &&
       outdir != dirname(script_wf)){
        file.copy(dirname(script_wf), outdir, recursive = TRUE,
                  overwrite = FALSE)
        if(is.null(workdir)){
            workdir <- file.path(outdir, basename(dirname(script_wf)))
        }
    }
    conf_file <- paste0(tempfile(), ".yaml")
    write(as.yaml(inputList), conf_file)
    snakemake_cmd(snakefile = workflow(sobject),
                  workdir = workdir,
                  configfile = conf_file,
                  ...)
}

runFun <- function(idx, sobject, inputList,
                   outdir = NULL, workdir = NULL, batch_by, ...){
    for(b in batch_by){
        inputList[[b]] <- inputList[[b]][idx]
    }
    Rsnakemake::runWorkflow(sobject, inputList,
                            outdir = outdir, workdir = workdir,
                            ...)
}

#' run Workflow in Batch
#'
#' @param sobject A `Snakemake` object.
#' @param inputList The list of inputs.
#' @param batch_by To run the workflow in batches by splitting the
#'     input list.
#' @param outdir The output directory.
#' @param workdir The `Snakemake` directory if not the same as the
#'     output directory.
#' @param BPPARAM The options for `BiocParallelParam`.
#' @param ... More arguments for `snakemake_cmd`.
#' @importFrom BiocParallel bplapply bptry
#' @export
runWorkflowBatch <- function(sobject, inputList, batch_by,
                             outdir = NULL, workdir = NULL,
                             BPPARAM = BatchtoolsParam(), ...){
    batch_n <- inputList[[batch_by[1]]]
    bptry(bplapply(seq(batch_n), runFun, BPPARAM = BPPARAM,
                   sobject = sobject, inputList = inputList,
                   batch_by = batch_by,
                   outdir = outdir, workdir = workdir,
                   ...))
}
