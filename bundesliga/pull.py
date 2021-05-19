import pandas as pd

url = "https://fbref.com/en/comps/20/schedule/Bundesliga-Scores-and-Fixtures"

tables = pd.read_html(url, converters={'Wk': str,'Attendance': str})

results = tables[0]

results = results.dropna(subset=['Home'])
results.drop(results[results['Day'] == 'Day'].index, inplace = True)

results.rename(columns={'xG': 'Home_xG', 'xG.1': 'Away_xG'}, inplace=True)

results.insert(0,'Season',2021)
results.insert(1,'Round','')

results.to_csv('csv/bundesliga-2021.csv', index=False)

