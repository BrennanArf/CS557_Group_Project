# tfrrs_import.py

"""
Script: TFRRS Import
Purpose: Retrieve meet results from TFRRS and prepare them for MySQL insertion.
Author: Carmel Ilunga
"""

import requests
from bs4 import BeautifulSoup

def fetch_tfrrs_page(url):
    """Download the HTML content from a TFRRS team page."""
    response = requests.get(url)
    response.raise_for_status()
    return response.text

def parse_meet_results(html):
    """Extract meet results from the TFRRS HTML page."""
    soup = BeautifulSoup(html, "html.parser")
    results = []

    # Placeholder logic — you will refine this later
    for row in soup.find_all("tr"):
        results.append(row.text.strip())

    return results

def main():
    url = "https://www.tfrrs.org/teams/tf/WI_college_m_Milwaukee.html"
    html = fetch_tfrrs_page(url)
    results = parse_meet_results(html)

    print("Sample extracted rows:")
    for r in results[:10]:
        print(r)

if __name__ == "__main__":
    main()
