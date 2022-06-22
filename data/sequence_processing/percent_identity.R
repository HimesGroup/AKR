#!/usr/bin/env Rscript

if (!requireNamespace("seqinr", quietly = TRUE)) install.packages("seqinr")

fasta <- commandArgs(TRUE)

aln <- seqinr::read.alignment(fasta, "fasta")
dm <- seqinr::dist.alignment(aln, matrix = "identity")
pim <- 100 * (1 - as.matrix(dm)**2)
seq_combn <- t(combn(colnames(pim), 2))
out <- data.frame(seq_combn, pim[seq_combn])

out_file <- paste0(tools::file_path_sans_ext(basename(fasta)), "_PI.csv")
write.table(out, out_file, row.names = FALSE, col.names = FALSE,
            sep = ",", quote = FALSE)
message("Result was written to '", out_file, "'.")
