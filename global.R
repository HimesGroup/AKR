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

read_akr_msa <- function(aln, format = "clustal") {
    readAAMultipleAlignment(aln, format = format)
}

## existing_members <- as.data.frame(
##     jsonlite::fromJSON("./data/table/existing_members.json")
## )
## existing_members <- existing_members[, -8]

## potential_members <- as.data.frame(
##     jsonlite::fromJSON("./data/table/potential_members.json")
## )
## potential_members <- potential_members[, -4]
## potential_members$Name <- gsub("\n", "<br/>", potential_members$Name, fixed = TRUE)
## potential_members$Accession <- sub("^<td>", "", potential_members$Accession)
## potential_members$Accession <- sub("<td>$", "", potential_members$Accession)
## potential_members$Accession <- sub("\n", "", potential_members$Accession, fixed = TRUE)

## check.names = FALSE to prevent from html tag auto correction in col names
existing_members <- read.csv("./data/table/existing_members.csv", check.names = FALSE)
potential_members <- read.csv("./data/table/potential_members.csv")

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
  c("./data/msa/All_AKR.aln", paste0("./data/msa/AKR", 1:13, ".aln"))
)
names(akr_msa_by_fam) <- c(
  "All AKR sequence alignment",
  paste0("AKR", 1:13, " sequence alignment")
)
akr_msa_by_taxonomy <-  list(
  "Eukarya" = "./data/msa/Domain_Eukarya.aln",
  "Animalia" = "./data/msa/Kingdom_Animalia.aln",
  "Bacteria" = "./data/msa/Kingdom_Bacteria.aln",
  "Fungi" = "./data/msa/Kingdom_Fungi.aln",
  "Plantae" = "./data/msa/Kingdom_Plantae.aln",
  "Amphibia" = "./data/msa/Class_Amphibia.aln",
  "Insecta" = "./data/msa/Class_Insecta.aln",
  "Mammalia" = "./data/msa/Class_Mammalia.aln",
  "Anura" = "./data/msa/Order_Anura.aln",
  "Artiodactyla" = "./data/msa/Order_Artiodactyla.aln",
  "Lagomorpha" = "./data/msa/Order_Lagomorpha.aln",
  "Lepidoptera" = "./data/msa/Order_Lepidoptera.aln",
  "Rodentia" = "./data/msa/Order_Rodentia.aln",
  "Homo Sapiens" = "./data/msa/Species_Homo_sapiens.aln"
)

pdb_list <- as.data.frame(
    jsonlite::fromJSON("./data/table/pdb_list.json")
)

email_pw <- scan(".emailpw", what = "character")
