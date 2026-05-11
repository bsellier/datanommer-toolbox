FROM timescale/timescaledb-ha:pg18-oss
# FROM timescale/timescaledb:latest-pg18
USER root

RUN apt update && apt install -y xz-utils
# RUN apk add xz
COPY src /datanommer-ctl

COPY .env /docker-entrypoint-initdb.d/02-env.sh
RUN ln -s /datanommer-ctl/configure_db.sh /docker-entrypoint-initdb.d/03-configure_db.sh
RUN ln -s /datanommer-ctl/create_tables.sql /docker-entrypoint-initdb.d/04-create_tables.sql
RUN ln -s /datanommer-ctl/initialize_fill_tables.sh /docker-entrypoint-initdb.d/05-initialize_fill_tables.sh

USER postgres

CMD ["postgres"]