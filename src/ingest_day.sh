
echo "Starting ingest script..."
set -e

[ -z "$1" ] && echo "No argument supplied" && exit 1

# if [ $# != 1 ]; then
#     echo "Expected 1 argument but found $#."
#     exit 1
# fi

echo $1

if [[ "$1" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then 
    true
else 
    echo "Invalid argument."
    exit 1
fi


PATTERN=$1-datanommer-incremental
TAR_PATH=$DATA_DIR/$PATTERN.csv.tar
# Extract from tar
mkdir -p $DATA_DIR/$PATTERN
echo $DATA_DIR/$PATTERN directory created.
tar -xf $TAR_PATH -C $DATA_DIR/$PATTERN

for fname in $(ls $DATA_DIR/$PATTERN/*.xz) ; do
    echo Decompressing $fname...
    xz -df $fname
done

/datanommer-ctl/fill_tables_day.sh $1