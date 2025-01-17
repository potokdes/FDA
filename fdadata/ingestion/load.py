import json
import psycopg2
from psycopg2.extras import Json
from dotenv import load_dotenv
import os
load_dotenv('./config/local/.env')

psycopg2.extensions.register_adapter(dict, psycopg2.extras.Json)


def get_db():
    conn = psycopg2.connect(
        database="fda", user=os.getenv("POSTGRES_USER"), password=os.getenv("POSTGRES_PASSWORD"), host=os.getenv("DB_HOST"), port=os.getenv("DB_PORT")
    )
    yield conn


with open("./data/drug-ndc-0001-of-0001.json") as f:
    data = json.load(f)
    data = data["results"]


ndc = list(
    map(
        lambda x: json.dumps(x),
        data,
    ),
)


conn = next(get_db())
insert_query = "INSERT INTO raw_fda.ndc (result) VALUES (%s)"

for x in ndc:
    with conn.cursor() as cursor:
        cursor.execute(insert_query, (x,))

conn.commit()
