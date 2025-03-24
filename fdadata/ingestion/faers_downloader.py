import os
import requests
import zipfile
from datetime import datetime

OPEN_FDA_FAERS_URL = "https://api.fda.gov/download.json"

def get_faers_zip_links(year):
    """Fetches FAERS ZIP file links from OpenFDA API for the given year."""
    response = requests.get(OPEN_FDA_FAERS_URL)
    if response.status_code != 200:
        raise Exception(f"Failed to fetch FAERS data: {response.status_code}")
    
    data = response.json()
    faers_files = data.get("results", {}).get("drug", {}).get("event", {}).get("partitions", [])
    
    # Filter files for the given year
    return [entry["file"] for entry in faers_files if str(year) in entry["file"]]

def download_and_extract_zip(url, download_dir):
    """Downloads and extracts a ZIP file."""
    os.makedirs(download_dir, exist_ok=True)
    filename = os.path.join(download_dir, os.path.basename(url))

    print(f"Downloading {url}...")
    response = requests.get(url, stream=True)
    if response.status_code == 200:
        with open(filename, "wb") as file:
            for chunk in response.iter_content(chunk_size=1024):
                file.write(chunk)
        print(f"Saved: {filename}")

        with zipfile.ZipFile(filename, "r") as zip_ref:
            zip_ref.extractall(download_dir)
        print(f"Extracted: {filename}")

        os.remove(filename)
    else:
        print(f"Failed to download {url}")

def download_faers_data(year=None, output_dir="data/faers"):
    """
    Fetch FAERS data for a given year and save it to 'data/faers'.
    
    :param year: Year of FAERS data to download (default: current year)
    :param output_dir: Directory to save extracted data
    """
    if year is None:
        year = datetime.now().year

    print(f"Fetching FAERS data links for {year}...")
    try:
        faers_links = get_faers_zip_links(year)
        if not faers_links:
            print(f"No FAERS data found for {year}.")
            return

        for link in faers_links:
            download_and_extract_zip(link, output_dir)
        
        print("✅ FAERS Data Download Complete!")
    except Exception as e:
        print(f"❌ Error: {e}")


# Rename files on download? (names can be the same across quaters)
# You can limit download to single file by providing part of the url to filter
# Full url is like: https://download.open.fda.gov/drug/event/2024q3/drug-event-0031-of-0032.json.zip
# You can check more here: https://api.fda.gov/download.json
download_faers_data('2024q3')
