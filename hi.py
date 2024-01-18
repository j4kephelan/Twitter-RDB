import pyodbc as pyodbc
import sqlalchemy as sal
from sqlalchemy import create_engine, text
import pandas as pd

username = 'twitter_user'
password = 'tweet'
engine = sal.create_engine(f'mysql+pymysql://{username}:{password}@localhost/twitter_rdb')

follows_samples = pd.read_csv('data/follows_sample.csv')
tweet_samples: pd.DataFrame = pd.read_csv('data/tweet.csv')

def insert_tweet(row: pd.Series):
    user_id: int = row['USER_ID']
    tweet_text: str = row['TWEET_TEXT']
    with engine.connect() as conn:
        executable = text(f'CALL tweet_insert_procedure({user_id}, "{tweet_text}")')
        conn.execute(executable)
        conn.commit()


tweet_samples.apply(insert_tweet, axis=1)
with engine.connect() as conn:
    tweet_testing = conn.execute(text("SELECT * FROM TWEET")).fetchall()
tweet_testing = pd.DataFrame.from_dict(tweet_testing)
print(tweet_testing)
