#!/bin/sh

for file in msa/*.aln
do
    basename="${file##*/}"
    filename="${basename%.*}"
    iqtree -s $file --prefix tree/${filename}
done
