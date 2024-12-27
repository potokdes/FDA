import json
import psycopg2
from psycopg2.extras import Json

psycopg2.extensions.register_adapter(dict, psycopg2.extras.Json)


def get_db():
    conn = psycopg2.connect(
        database="fda", user="potok", password="potok", host="localhost", port=5432
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
insert_query = "INSERT INTO bronze.drug_ndc (result) VALUES (%s)"

for x in ndc:
    with conn.cursor() as cursor:
        cursor.execute(insert_query, (x,))

conn.commit()
