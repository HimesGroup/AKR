library(shiny)
library(bslib)
library(msaR)
library(Biostrings)
options(repos = BiocManager::repositories())

linebreaks <- function(n = 1) {
    HTML(strrep(br(), n))
}

renderImage100 <- function(path) {
    renderImage({
        list(
            src = file.path(path),
            width = "100%",
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

existing_members <- as.data.frame(
    jsonlite::fromJSON("./data/table/existing_members.json")
)
existing_members <- existing_members[, -8]

potential_members <- as.data.frame(
    jsonlite::fromJSON("./data/table/potential_members.json")
)
potential_members <- potential_members[, -4]
potential_members$Name <- gsub("\n", "<br/>", potential_members$Name, fixed = TRUE)
potential_members$Accession <- sub("^<td>", "", potential_members$Accession)
potential_members$Accession <- sub("<td>$", "", potential_members$Accession)
potential_members$Accession <- sub("\n", "", potential_members$Accession, fixed = TRUE)

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

akr_msa_files <- c(paste0("./data/msa/", setdiff(1:13, 10), ".aln"),
                   "./data/msa/all_akr.aln")
names(akr_msa_files) <- c(paste0("AKR", setdiff(1:13, 10), " Sequence Alignment"),
                          "All AKR sequence alignment")

pdb_list <- as.data.frame(
    jsonlite::fromJSON("./data/table/pdb_list.json")
)
