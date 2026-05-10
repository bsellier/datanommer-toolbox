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

set -e

PATTERN=$1-datanommer-incremental
echo $PATTERN
# URL=https://infrastructure.fedoraproject.org/infra/db-dumps/datanommer-incremental/2026-04-29-datanommer-incremental-csv.tar
URL=https://infrastructure.fedoraproject.org/infra/db-dumps/datanommer-incremental/$PATTERN-csv.tar
echo $URL
# DATA_DIR=/datanommer_incremental_data
mkdir -p $DATA_DIR
curl $URL --output $DATA_DIR/$PATTERN.csv.tar
echo "curl successful"