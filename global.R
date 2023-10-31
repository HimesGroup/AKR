library(shiny)
library(bslib)
library(msaR)
library(Biostrings)
options(repos = BiocManager::repositories())

linebreaks <- function(n = 1) {
  HTML(strrep(br(), n))
}

renderImageWidthPct <- function(path, pct = 50) {
  renderImage({
    list(
      src = file.path(path),
      width = paste0(pct, "%"),
      style="display: block; margin-left: auto; margin-right: auto;"
    )
  }, deleteFile = FALSE)
}

epoch_time <- function() {
  as.integer(Sys.time())
}
human_time <- function() {
  format(Sys.time(), "%Y%m%d-%H%M%OS")
}

mandatory_star <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}

read_akr_msa <- function(aln, format = "fasta") {
  x <- readAAMultipleAlignment(aln, format = format)
  rownames(x) <- sub("^(AKR)(\\d+)(.*)", "\\1\\2", rownames(x))
  x
}

## check.names = FALSE to prevent from html tag auto correction in col names
existing_members <- read.csv("./data/table/existing_members.csv",
                             check.names = FALSE)
potential_members <- read.csv("./data/table/potential_members.csv",
                              check.names = FALSE)

pdb_list <- as.data.frame(
  jsonlite::fromJSON("./data/table/pdb_list.json")
)

email_pw <- scan(".emailpw", what = "character")

all_fields <- c(
  "name", "email", "phone", "address1", "address2", "city", "state", "zipcode",
  "country", "trivial_name", "protein_expressed", "protein_function",
  "protein_sequence", "origin", "expression_system", "substrate", "accession",
  "pub_status", "citation"
)
if (!dir.exists(file.path("submission"))) {
  dir.create(file.path("submission"))
}
submission_dir <- file.path("submission")

mandatory_fields <- setdiff(all_fields, c("address2", "state"))
mandatory_star_css <- ".mandatory_star {color: red;}"

akr_msa_by_fam <- as.list(
  c("./data/msa/All_AKRs.aln", paste0("./data/msa/AKR", 1:17, ".aln"))
)
names(akr_msa_by_fam) <- c(
  "All AKR sequence alignment",
  paste0("AKR", 1:17, " sequence alignment")
)

akr_msa_by_taxonomy <-  list(
  "Animalia" = "./data/msa/Animalia_AKRs.aln",
  "Bacteria" = "./data/msa/Bacteria_AKRs.aln",
  "Fungi" = "./data/msa/Fungi_AKRs.aln",
  "Plantae" = "./data/msa/Plantae_AKRs.aln",
  "Insecta" = "./data/msa/Insecta_AKRs.aln",
  "Mammalia" = "./data/msa/Mammalia_AKRs.aln",
  "Lagomorpha" = "./data/msa/Lagomorpha_AKRs.aln",
  "Rodentia" = "./data/msa/Rodentia_AKRs.aln",
  "Homo Sapiens" = "./data/msa/Homo_sapiens_AKRs.aln"
)

