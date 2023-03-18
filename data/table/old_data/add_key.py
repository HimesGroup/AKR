#!/usr/bin/env python3
import json

with open("existing_members_original.json", "r") as f:
    contents = json.load(f)

    headers = ["AKR", "Enzyme", "Species", "Accession<sup>1</sup>",
               "Alt Splicing", "PDB Link", "dbSNP", "Ref"]
    d = contents['data']
    d = [[i.replace(" <sup>",  "<sup>") for i in x] for x in d]
    d = [dict(zip(headers, x)) for x in d]

with open("existing_members.json", "w", encoding='utf-8') as f:
    json.dump(d, f, ensure_ascii=False, indent=4)
