library(Biostrings)
library(gtools)

fa_files <- mixedsort(
  list.files(path = ".", pattern = "^AKR.*\\.fasta$", full.names = TRUE)
)

all_akrs <- do.call(c, lapply(fa_files, readAAStringSet))
writeXStringSet(all_akrs, "All_AKRs.fasta", width = 70)

animalia_idx <- grep("Animalia", names(all_akrs))
writeXStringSet(all_akrs[animalia_idx], "Animalia_AKRs.fasta", width = 70)

bacteria_idx <- grep("Bacteria", names(all_akrs))
writeXStringSet(all_akrs[bacteria_idx], "Bacteria_AKRs.fasta", width = 70)

fungi_idx <- grep("Fungi", names(all_akrs))
writeXStringSet(all_akrs[fungi_idx], "Fungi_AKRs.fasta", width = 70)

plantae_idx <- grep("Plantae", names(all_akrs))
writeXStringSet(all_akrs[plantae_idx], "Plantae_AKRs.fasta", width = 70)

mammalia_idx <- grep("Mammalia", names(all_akrs))
writeXStringSet(all_akrs[mammalia_idx], "Mammalia_AKRs.fasta", width = 70)

insecta_idx <- grep("Insecta", names(all_akrs))
writeXStringSet(all_akrs[insecta_idx], "Insecta_AKRs.fasta", width = 70)

rodentia_idx <- grep("Rodentia", names(all_akrs))
writeXStringSet(all_akrs[rodentia_idx], "Rodentia_AKRs.fasta", width = 70)

lagomorpha_idx <- grep("Lagomorpha", names(all_akrs))
writeXStringSet(all_akrs[lagomorpha_idx], "Lagomorpha_AKRs.fasta", width = 70)

homosapiens_idx <- grep("Homo sapiens", names(all_akrs))
writeXStringSet(all_akrs[homosapiens_idx], "Homo_sapiens_AKRs.fasta", width = 70)
