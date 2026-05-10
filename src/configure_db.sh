
set -e

# Increase checkpointing interval from 1Gb to 32Gb for less churn during restore
echo "Increasing checkpointing..."
psql --username=postgres --command="ALTER SYSTEM SET max_wal_size TO '32GB';"
psql --username=postgres --command="ALTER SYSTEM SET checkpoint_timeout TO '1h';"
psql --username=postgres --command="ALTER SYSTEM SET synchronous_commit TO 'off';"
psql --username=postgres --command="ALTER SYSTEM SET full_page_writes TO 'off';"
psql --username=postgres --command="SELECT pg_reload_conf();"

# Create the database owner
echo "Creating roles..."
psql --username=postgres --command="CREATE ROLE datanommer WITH superuser PASSWORD '${RW_PASS}';"
# Create other users -- avoids GRANT errors at the end
psql --username=postgres --command="CREATE ROLE datanommer_ro WITH PASSWORD '${RO_PASS}';"
psql --username=postgres --command="CREATE ROLE datanommer_metrics_ro WITH PASSWORD '${RO_PASS}';"
psql --username=postgres --command="CREATE ROLE tahrir WITH PASSWORD '${RW_PASS}';"
psql --username=postgres --command="CREATE ROLE datagrepper WITH PASSWORD '${RW_PASS}';"

echo "Creating empty database..."
psql --username=postgres --command="CREATE DATABASE datanommer2 WITH OWNER datanommer ENCODING = 'UTF8' LOCALE = 'en_US.utf8' TEMPLATE template0;"

echo "Creating timescaledb extension..."
psql --username=postgres --dbname=datanommer2 --command="CREATE EXTENSION IF NOT EXISTS timescaledb;"

echo "Increasing maintenance work memory..."
# Note: this is a session-level setting so no need to reset later
psql --username=postgres --command="SET maintenance_work_mem = '4GB';"
