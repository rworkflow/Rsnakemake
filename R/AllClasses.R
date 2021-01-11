#' workflow-class
#' @export
setClass("Workflow",
         slots = c(
             workflow = "character",
             inputs = "list",
             outputs = "list"
         ),
         prototype = c(
             workflow = character(),
             inputs = list(),
             outputs = list()
         ))

#' @rdname Snakemake-class
setClass("Snakemake", contains = "Workflow",
         slots = c(
             rules = "list"
         ),
         prototype = c(
             rules = list()
         ))

#' Snakemake class
#'
#' @rdname Snakemake-class
#' @param workflow The path of the Snakemake file.
#' @param inputs The list of inputs from configure file.
#' @param outputs The list of outputs.
#' @param rules The list of rules.
#' @return A `snakemake` object
#' @export
#' @importFrom methods is new
Snakemake <- function(workflow,
                      inputs,
                      outputs,
                      rules){
    new("Snakemake",
        workflow = workflow,
        inputs = inputs,
        outputs = outputs,
        rules = rules)
}

#' @importFrom yaml as.yaml
setMethod("show", "Snakemake", function(object){
    clist <- list(workflow = object@workflow,
                  inputs = object@inputs,
                  outputs = object@outputs,
                  rules = object@rules)
    cat("class: snakemake\n")
    cat(as.yaml(clist))
})

#' workflow path
#'
#' @param object A snakemake object.
#' @return The workflow path.
#' @export
workflow <- function(object){
    object@workflow
}

#' inputs
#'
#' @rdname inputs
#' @param object A `snakemake` object.
#' @return The workflow inputs.
#' @export
inputs <- function(object){
    object@inputs
}

#' inputs
#' @rdname inputs
#' @param object A `snakemake` object.
#' @param value The value to assigin to inputs.
#' @export
"inputs<-" <- function(object, value){
    object@inputs <- value
    object
}


#' outputs
#'
#' @param object A snakemake object.
#' @return The workflow outputs
#' @export
outputs <- function(object){
    object@outputs
}

#' rules
#' 
#' @param object A snakemake object.
#' @return The workflow rules
#' @export
rules <- function(object){
    object@rules
}

