
source ./.env
mkdir -p ./$DATA_DIR
DATA_DIR_FULL_PATH=$(realpath ./$DATA_DIR)
echo $DATA_DIR_FULL_PATH
chown 1000:1000 $DATA_DIR_FULL_PATH

# Creating data dirs
mkdir -p {$HOST_BASE/pg_data,$HOST_BASE/misc}
chown 1000:1000 "$HOST_BASE"/{misc,pg_data}
# chmod -R 777 "$HOST_BASE"/{misc,pg_data}

docker run \
    --rm \
    -d \
    --name datanommer2 \
    -p 5432:5432 \
    -v "${HOST_BASE}/pg_data":/pgdata \
    -e PGDATA=/pgdata \
    -e POSTGRES_PASSWORD=postgres \
    -e DATA_DIR=$DATA_DIR \
    --shm-size=2g \
    --mount type=bind,src=$DATA_DIR_FULL_PATH,dst=/$DATA_DIR \
    datanommer2 \
    && docker logs -f datanommer2
