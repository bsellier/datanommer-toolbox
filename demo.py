

# Using psycopg
print("psycopg demo:")
import psycopg

with psycopg.connect("dbname=datanommer2 user=postgres password=postgres host=127.0.0.1") as conn:
    # Open a cursor to perform database operations
    with conn.cursor() as cur:
        cur.execute("select date(timestamp), count(1) as cnt from messages group by 1 order by 2 desc;")

        for rec in cur:
            print(rec)


# Using DuckDB
print("DuckDB demo:")

import duckdb

dcon = duckdb.connect()
dcon.install_extension("postgres")
dcon.load_extension("postgres")
dcon.sql("""
    ATTACH 'dbname=datanommer2 user=postgres password=postgres host=127.0.0.1' as pgdb (TYPE POSTGRES);
""")
print(dcon.sql("""      
    SELECT table_schema, table_name FROM pgdb.INFORMATION_SCHEMA.TABLES WHERE table_schema = 'public';
"""))
print(dcon.sql("""
    select date(timestamp), count(1) as cnt from pgdb.messages group by 1 order by 2 desc;
"""))
dcon.sql(""" 
    DETACH pgdb;
""")