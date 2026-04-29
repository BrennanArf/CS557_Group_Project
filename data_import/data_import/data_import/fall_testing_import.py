import pandas as pd

folder = "sample_data/"



def clean_format_a(path, season):
    all_data = []
    for tab in ["Men", "Women"]:
        gender = "M" if "Men" in tab else "W"
        df = pd.read_excel(path, sheet_name=tab, header=None)
        df.columns = df.iloc[2]
        df = df.drop([0, 1, 2, 3]).reset_index(drop=True)
        clean = df[['NAME', df.columns[1], 'EVENT', 'VERT (in)', 'SLJ    (m)', 'STJ (m)', '50m', 'OHB (m)', 'BLF (m)', '150m']].copy()
        clean.columns = ['last', 'first', 'event', 'vert', 'slj', 'stj', '50m', 'ohb', 'blf', '150m']
        clean['season'] = season
        clean['gender'] = gender
        clean = clean[clean['last'].notna()]
        all_data.append(clean)
    return pd.concat(all_data).reset_index(drop=True)

def clean_format_b(path, season):
    all_data = []
    for tab in ["Men - Recording", "Women - Recording"]:
        gender = "M" if "Men" in tab else "W"
        df = pd.read_excel(path, sheet_name=tab, header=None)
        df.columns = df.iloc[2]
        df = df.drop([0, 1, 2, 3]).reset_index(drop=True)
        a1 = df.iloc[::2].reset_index(drop=True)
        a2 = df.iloc[1::2].reset_index(drop=True)
        a1['50m Start'] = pd.to_numeric(a1['50m Start'], errors='coerce')
        a2['50m Start'] = pd.to_numeric(a2['50m Start'], errors='coerce')
        a1['50m Start'] = a1['50m Start'].combine(a2['50m Start'], min)
        clean = a1[['NAME', a1.columns[1], 'EVENT', 'VERT (in)', 'SLJ    (m)', 'STJ (m)', '50m Start', 'OHB (m)', 'BLF (m)', '150m']].copy()
        clean.columns = ['last', 'first', 'event', 'vert', 'slj', 'stj', '50m', 'ohb', 'blf', '150m']
        clean['season'] = season
        clean['gender'] = gender
        clean = clean[clean['last'].notna()]
        all_data.append(clean)
    return pd.concat(all_data).reset_index(drop=True)


files = [
    (clean_format_a, "20-21 Fall Testing Scoresheet Version1.xlsx", "2020-21"),
    (clean_format_a, "21-22 Fall Testing Scoresheet.xlsx",           "2021-22"),
    (clean_format_b, "22-23 Fall Testing.xlsx",                      "2022-23"),
    (clean_format_b, "23-24 Fall Testing Compiled Results.xlsx",     "2023-24"),
    (clean_format_b, "24-25 Fall Testing Compiled Results.xlsx",     "2024-25"),
    (clean_format_b, "25-26 Fall Testing Compiled Results.xlsx",     "2025-26"),
]

all_data = []
for func, filename, season in files:
    df = func(folder + filename, season)
    all_data.append(df)

fall_testing = pd.concat(all_data).reset_index(drop=True)
print(fall_testing.head(20).to_string())

