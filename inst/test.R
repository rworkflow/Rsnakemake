
demo <- system.file("snakemake-tutorial-data", "Snakefile", package = "Rsnakemake")

## run snakemake
## snakemake(demo, workdir = dirname(demo))
snakemake_cmd(demo, workdir = dirname(demo))

## runWorkflow
dnaseq <- loadSnakemake(demo)
inputList <- inputs(dnaseq)
inputList$SAMPLES <- c("A")
runWorkflow(dnaseq, inputList, outdir = "/tmp/dna")

library(BiocParallel)
inputList$SAMPLES <- c("A", "B")
runWorkflowBatch(dnaseq, inputList, batch_by = "SAMPLES", outdir = "/tmp/dna",
                 BPPARAM = MulticoreParam())
