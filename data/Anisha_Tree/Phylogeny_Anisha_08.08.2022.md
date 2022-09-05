# AKR Family Phylogenetic Tree Method

## Downloading AKR Files

1. All known AKR amino acid sequences were collected (while there are 16 AKR
families, lack of availability of sequences in Family’s 14-16 make it impossible
to construct a phylogenetic tree).

2. The meta file of AKR protein sequences was used to create files for each individual family
   - AKR1, AKR2, AKR3, AKR4, and etc.
   - The protein sequence for each AKR based on family was stored in FASTA files

## Using MAFFT to Conduct a Sequence Alignment Using the Amino Acid Sequences Organized by AKR Family

- [MAFFT](https://mafft.cbrc.jp/alignment/software/) is a multiple sequence
  alignment program for Unix-like operating systems. It offers a range of
  multiple alignment methods, L-INS-i (accurate; for alignment of < ~ 200
  sequences), FFT-NS-2 (fast; for alignment of <~30,000 sequences), etc.

- Multiple sequence alignment was performed via L-INS-i method.

## Using IQ-TREE to Create a 'treefile' Based on the AKR Family Aligned Sequences

- [IQ-Tree](http://www.iqtree.org/) takes as input a multiple sequence alignment
  and will reconstruct an evolutionary tree that is best explained by the input
  data.

- For each family, a phylogenetic tree was constructed with the default setting,
  which infer a maximum likelihood tree with model selection.

- The R codes used for visualizing phylogenetic trees are available
  [here](https://htmlpreview.github.io/?https://github.com/HimesGroup/AKR/blob/main/data/Anisha_Tree/AKR-Phylogenetic-Trees.html).
