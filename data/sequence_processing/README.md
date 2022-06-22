# New AKR sequence submission processing

Procedures to 1) perform a multiple sequence alignment, 2) calculate a
percentage of identity between a pair of aligned sequence and 3) generate a
phylogenetic tree.

## Prerequisite

Necessary programs can be installed via
[Conda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html)
or
[micromamba](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html)
with the environment.yml available on the repository. The following commands
install necessary programs.

```shell
# Conda
conda env create -f environment.yml
conda activate akr

# micromamba
micromamba create -f environment.yml
micromamba activate akr
```

## Multiple sequence alignment (MSA)

Multiple sequence alignment will be performed with
[MAFFT](https://mafft.cbrc.jp/alignment/software/) that offers a range of
multiple alignment methods. Currently the number of AKR sequence is < ~200, and
thus, one of [three accurate
algorithms](https://mafft.cbrc.jp/alignment/software/algorithms/algorithms.html)
(L-INS-i, E-INS-i, and G-INS-i) are recommended.

```shell
# Help
mafft -h

# L-INS-i alignment (einis for E-INS-i and ginsi for G-INS-i)
linsi akr.fasta > akr_msa.fasta
```

## Percent identity

Different programs could report different percent identities for the same
sequence due to varying definitions of identity (e.g., treatment of gaps and/or
wildcard mismatch). Here, the commands below check non-gapped positions and
count the number of mismatches using R
[seqinr](https://cran.r-project.org/web/packages/seqinr/index.html) package. See
`dist.alignment` function and set `gap = TRUE` if you want to consider gaps in
the identity measure.

```shell
# Pairwise percent identities will be written to akr_msa_PI.csv
Rscript percent_identity.R akr_msa.fasta
```

## Phylogenetic tree

[IQ-TREE](http://www.iqtree.org/) will be used to infer a phylogenetic tree by
maximum likelihood. Please check [Tutorial](http://www.iqtree.org/doc/Tutorial).

```shell
# Help
iqtree -h

# Maximum likelihood tree with model selection (check -m MFP)
iqtree -s akr_msa.fasta

# Optional arguments for assessing branch supports with bootstrap and SH-aLRT
iqtree -s akr_msa.fasta -B 1000 -alrt 1000
```

The resulting tree (`akr_msa.treefile`) can be visualized using R with `treeio`
and `ggtree` packages. Please check [Data Inegration, Manipulation and
Visualization of Phylogenetic Trees](https://yulab-smu.top/treedata-book/).
