#!/bin/bash

for file in ./fasta/*.fasta
do
    basename="${file##*/}"
    filename="${basename%.*}"
    linsi ${file} > ./msa/${filename}.aln
done
