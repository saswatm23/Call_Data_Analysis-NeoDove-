import pandas as pd
from sqlalchemy import create_engine

conn_string = 'postgresql://postgres:system@localhost/MY_Database'
db = create_engine(conn_string)
conn = db.connect()
file_names = ["Organisation","Call_Log","Properties"]

for file in file_names:
    df = pd.read_csv(f'{file}.csv')
    df.to_sql(file,con=conn,if_exists='replace',index=False)