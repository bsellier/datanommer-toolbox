# datanommer-toolbox

This repo contains utilities that aims to facilitate the use of datanomer2 data in order to create analytics.

### Getting started

After cloning the repo, you can start the PostgreSQL/TimescaleDB server by building and starting the Docker image.

First copy .env.example to .env.
```bash
cp .env.example .env
```

Then you can start building the image.
```bash
sudo docker build -t datanommer2 .
```

Start the container with the `container-utils/start_db.sh` script. It can take up to 5-10 minutes to complete.
```bash
sudo ./container-utils/start_db.sh
```

When started, it will create a `pg_data` directory. You can change this path by modifying the `HOST_BASE` variable in the .env file.

It will automatically download data from 2 days ago and populate the postgre database with it.

You can add more data using the following command. The script take a date at YYYY-mm-dd format as an argument. 
```bash
sudo ./add_day_data.sh YYYY-mm-dd
```

To test it:
```bash
sudo ./query_db.sh "select distinct date(timestamp) from messages;"
```

### Use with Python

You can connect to database in Python with psycopg or DuckDB. `demo.py` demonstrates how to do so.

### Clean database

If you neeed to reset the data for some reasons (e.g. bad db initialization) you can restore a clean state with:
```bash
sudo ./container-utils/clean.sh
```


