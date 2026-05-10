set -e
if [[ $FILL_TABLES_INITIALIZE == false || $FILL_TABLES_INITIALIZE == 0 ]]; then
    exit
fi

INIT_FILL_DAY=$(date -d "3 days ago" +%Y-%m-%d)
# INIT_FILL_DAY=$(date -d "@$(($(date +%s) - 259200))" +%Y-%m-%d)
/datanommer-ctl/curl_day_data.sh $INIT_FILL_DAY
/datanommer-ctl/ingest_day.sh $INIT_FILL_DAY
