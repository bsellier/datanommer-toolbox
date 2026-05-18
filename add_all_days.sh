
for (( i=2 ; $i<30 ; i++ )) ; do
    ./add_day_data.sh $(date -d "$i days ago" -I)
done

