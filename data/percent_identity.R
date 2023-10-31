#!/usr/bin/env Rscript

if (!requireNamespace("seqinr", quietly = TRUE)) install.packages("seqinr")

fasta <- commandArgs(TRUE)

aln <- seqinr::read.alignment(fasta, "fasta")
if (aln$nb == 1) {
  stop("Only 1 entry in ", basename(fasta), ". Execution aborted.")
}
aln$nam <- sub("(.*?)\\|(.*)", "\\1", aln$nam) # non-greedy
dm <- seqinr::dist.alignment(aln, matrix = "identity")
pim <- 100 * (1 - as.matrix(dm)**2)
seq_combn <- t(combn(colnames(pim), 2))
out <- data.frame(seq_combn, pim[seq_combn])

dir.create("percent_identity", showWarnings = FALSE)
out_file <- file.path(
  "percent_identity",
  paste0(tools::file_path_sans_ext(basename(fasta)), "_PI.csv")
)
write.table(out, out_file, row.names = FALSE, col.names = FALSE,
            sep = ",", quote = FALSE)
message("Result was written to '", out_file, "'.")
