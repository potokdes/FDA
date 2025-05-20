import os
import json
import psycopg2

DATA_DIR = "./data/faers/"

def get_db():
    return psycopg2.connect(
        database="fda",
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT")
    )

def create_table():
    """Ensure the table exists before inserting data."""
    conn = get_db()
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS raw_fda.faers (
            id SERIAL PRIMARY KEY,
            source_file TEXT,
            result JSONB
        )
    """)
    conn.commit()
    cur.close()
    conn.close()
    print("✅ Table checked/created.")

def load_json_file(file_path):
    """Loads large JSON files in smaller chunks to avoid memory errors."""
    print(f"📥 Loading {file_path}...")
    filename = os.path.basename(file_path)

    with open(file_path, "r", encoding="utf-8") as f:
        try:
            data = json.load(f)  # Load the full JSON file
            
            conn = get_db()
            cur = conn.cursor()

            # Identify where the records are stored in the JSON structure
            if "results" in data and isinstance(data["results"], list):
                records = data["results"]
            else:
                print(f"⚠️ No 'results' array found in {file_path}, skipping.")
                return

            # Insert each record separately with source file info
            for record in records:
                cur.execute("INSERT INTO raw_fda.faers (result, source_file) VALUES (%s, %s)", [json.dumps(record), filename])
            
            conn.commit()
            cur.close()
            conn.close()
            print(f"✅ Successfully inserted {len(records)} records from {file_path}")

        except Exception as e:
            print(f"❌ Error loading {file_path}: {e}")

def load_faers_data():
    """Iterate through FAERS JSON files and load them into the database."""
    files = [f for f in os.listdir(DATA_DIR) if f.endswith(".json")]
    
    if not files:
        print("❌ No JSON files found in data/faers/")
        return

    print(f"📂 Found {len(files)} JSON files.")
    
    for file_name in files:
        file_path = os.path.join(DATA_DIR, file_name)
        load_json_file(file_path)

if __name__ == "__main__":
    create_table()
    load_faers_data()
