library(treeio)
library(ggtree)

dir.create("plot", showWarnings = FALSE)

tree_files <- list.files(path = "tree", pattern = "treefile$", full.names = TRUE)

subfam_files <- grep("tree/AKR", tree_files, value = TRUE)
taxon_files <- setdiff(tree_files, subfam_files)

## taxon files
plot_tree <- function(x, subfam = FALSE) {
  ## filename
  fname <- tools::file_path_sans_ext(basename(x))
  ## Read file
  akr_tree <- read.tree(x)
  akr_tree$tip.label <- sub("(.*?)\\|(.*)", "\\1", akr_tree$tip.label) # non-greedy
  ## Grouping by fam
  if (subfam) {
    akr_fam <- sub("^(AKR)(\\d+)([[:alpha:]]+)(.*)", "\\1\\2\\3",
                   akr_tree$tip.label)
  } else {
    akr_fam <- sub("^(AKR)(\\d+)(.*)", "\\1\\2", akr_tree$tip.label)
  }
  akr_tree <- groupOTU(akr_tree, split(akr_tree$tip.label, akr_fam), "Family")
  ## Plot
  p <- ggtree(akr_tree, aes(color = Family),
         layout = "circular",
         ladderize = FALSE,
         branch.length = "none") +
    geom_tiplab() +
    theme(legend.position = "none")
  out_path <- file.path("plot", paste0(fname, ".png"))
  ggsave(out_path, p, width = 12, height = 12, dpi = "retina")
}

invisible(lapply(taxon_files, function(x) plot_tree(x, subfam = FALSE)))
invisible(lapply(subfam_files, function(x) plot_tree(x, subfam = TRUE)))
