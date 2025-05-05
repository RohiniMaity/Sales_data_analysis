# # Step 1: Data Exploration and Leading

import pandas as pd

df = pd.read_csv('Walmart.csv')
print(df.head())
print(df.describe())
print(df.info())

#Drop all duplicates
df.duplicated().sum()
df.drop_duplicates(inplace=True)
df.duplicated().sum()

#Drop all null values
df.isnull().sum()
df.dropna(inplace=True)
df.isnull().sum()
print(df.shape)
print(df.dtypes)

#Change the unit_price value to float
df['unit_price']
df['unit_price'] = df['unit_price'].str.replace('$', '').astype('float')
print(df.head())
print(df.columns)

#Calculate total price
df['total'] = df['unit_price'] * df['quantity']
print(df.head())

# Step 2: Connect Database
#postgresql
import psycopg2
from sqlalchemy import create_engine

# host = localhost
# port = 5433
# user = postgres
# password = ''

#Converting all the columns to lower
df.columns = df.columns.str.lower()
print(df.columns)
df.to_csv('walmart_clean_data.csv', index=False)

import os
from dotenv import load_dotenv
load_dotenv()
password = os.getenv("POSTGRES_PASSWORD")
engine_postgres = create_engine(f"postgresql+psycopg2://postgres:{password}@localhost:5433/walmart_db")

try:
    engine_postgres.connect()
    print("Connection to PostgreSQL successful!")
except Exception as e:
    print("Error connecting to PostgreSQL:", e)

df.to_sql(name='walmart', con=engine_postgres, if_exists='append', index=False)
print(df.columns)
print(df.head())