#!/bin/sh

for file in msa/*.aln
do Rscript percent_identity.R $file
done
