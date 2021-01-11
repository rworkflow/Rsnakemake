#' load snakemake files.
#'
#' @param snakefile Path to the snakefile.
#' @importFrom tools file_ext
#' @importFrom yaml read_yaml
#' @importFrom jsonlite read_json

loadSnakemake <- function(snakefile){
    sn <- readLines(snakefile)
    conf <- grep("configfile", sn, value = TRUE)
    conf <- trimQuote(sub("configfile: ", "", conf))
    conf_file <- file.path(dirname(snakefile), conf)
    ## inputs
    if(file_ext(conf_file) %in% c("yml", "yaml")){
        inputs <- read_yaml(conf_file)
    }else{
        inputs <- read_json(conf_file)
    }
    ## outputs
    idx_out <- grep("output:", sn)
    outputs <- c()
    for(i in idx_out){
        out1 <- unlist(strsplit(sn[i], split = " "))
        ns0 <- sum(out1 == "")
        nidx <- i + 1
        while(TRUE){
            o1 <- unlist(strsplit(sn[nidx], split = " "))
            ns1 <- sum(o1 == "")
            o1 <- trimQuote(o1[o1 != ""])
            outputs <- c(outputs, o1)
            nidx <- nidx + 1
            if(ns1 >= ns0)
                break
        }
    }
    ## workflow
    rules <- sub(":", "",
                 sub("rule ", "", grep("rule", sn, value = TRUE)))

    Snakemake(workflow = normalizePath(snakefile),
              inputs = inputs,
              outputs = as.list(outputs),
              rules = as.list(rules))
}

trimQuote <- function(str){
    gsub("\"", "", str)
}
