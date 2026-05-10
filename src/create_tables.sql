\connect datanommer2

CREATE TABLE alembic_version (
    version_num varchar(32) NOT NULL
);

CREATE TABLE messages (
    id SERIAL,
    msg_id varchar,
    i integer NOT NULL,
    topic varchar NOT NULL,
    timestamp timestamp NOT NULL,
    certificate text,
    signature text,
    category varchar NOT NULL,
    agent_name varchar,
    crypto text,
    source_name varchar,
    source_version varchar,
    msg text,
    headers text
);

CREATE TABLE packages (
    id SERIAL,
    name text
);

CREATE TABLE packages_messages (
    package_id integer NOT NULL,
    msg_id integer NOT NULL,
    msg_timestamp timestamp NOT NULL
);

CREATE TABLE users (
    id SERIAL,
    name text
);

CREATE TABLE users_messages (
    user_id integer NOT NULL,
    msg_id integer NOT NULL,
    msg_timestamp timestamp NOT NULL
);
