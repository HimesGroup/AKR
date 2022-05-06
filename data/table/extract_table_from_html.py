#!/usr/bin/env python3
from bs4 import BeautifulSoup
import argparse
import json

def main():
    parser = argparse.ArgumentParser(description = "Extract a table from html.")
    parser.add_argument("fin", help="The name of html file to read")
    parser.add_argument("fout", help="The name of json file to write")
    args = parser.parse_args()
    with open(args.fin, 'r') as f:
        contents = f.read()
        s = BeautifulSoup(contents, "html.parser").table
        h = [i.text for i in s.tr.find_all('th')]
        # [_, *d] = [[i.text for i in b.find_all('td')] for b in s.find_all('tr')]
        # [_, *d] = [[str(i.a) if "href" in str(i) else i.text for i in b.find_all('td')] for b in s.find_all('tr')]
        # [_, *d] = [[str(i.find_all('a')) if "href" in str(i) else i.text for i in b.find_all('td')] for b in s.find_all('tr')]
        [_, *d] = [[str(i) if "href" in str(i) else i.text for i in b.find_all('td')] for b in s.find_all('tr')]
        result = [dict(zip(h, i)) for i in d]

        with open(args.fout, 'w', encoding='utf-8') as f:
            json.dump(result, f, ensure_ascii=False, indent=4)


if __name__ == "__main__":
    main()
