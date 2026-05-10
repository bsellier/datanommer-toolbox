docker exec --user root datanommer2 bash /datanommer-ctl/curl_day_data.sh $1
docker exec --user root datanommer2 bash /datanommer-ctl/ingest_day.sh $1