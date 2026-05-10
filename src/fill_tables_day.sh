set -e
[ -z "$1" ] && echo "No argument supplied" && exit 1

# if [ $# != 1 ]; then
#     echo "Expected 1 argument but found $#."
#     exit 1
# fi


if [[ "$1" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then 
    true
else 
    echo "Invalid argument."
    exit 1
fi

PATTERN=$1-datanommer-incremental
# psql --username=postgres -d $DBNAME --command="COPY alembic_version FROM '$DATA_DIR/$PATTERN/$1-alembic_version.txt';"
psql --username=postgres -d datanommer2 --command="COPY messages FROM '$DATA_DIR/$PATTERN/$1-messages.csv' CSV HEADER;"
psql --username=postgres -d datanommer2 --command="COPY packages FROM '$DATA_DIR/$PATTERN/$1-packages.csv' CSV HEADER;"
psql --username=postgres -d datanommer2 --command="COPY packages_messages FROM '$DATA_DIR/$PATTERN/$1-packages_messages.csv' CSV HEADER;"
psql --username=postgres -d datanommer2 --command="COPY users FROM '$DATA_DIR/$PATTERN/$1-users.csv' CSV HEADER;"
psql --username=postgres -d datanommer2 --command="COPY users_messages FROM '$DATA_DIR/$PATTERN/$1-users_messages.csv' CSV HEADER;"
