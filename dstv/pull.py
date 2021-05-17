import pandas as pd

url = "https://fbref.com/en/comps/52/schedule/Premier-Division-Scores-and-Fixtures"

tables = pd.read_html(url, converters={'Wk': str,'Attendance': str})

results = tables[0]

results = results.dropna(subset=['Home'])
results.drop(results[results['Day'] == 'Day'].index, inplace = True)

results.insert(0,'Season',2021)
results.insert(1,'Wk','')
results.to_csv('csv/dstv-2021.csv', index=False)

