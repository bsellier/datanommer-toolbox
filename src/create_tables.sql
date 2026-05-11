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
    headers text,
    msg_json jsonb
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

-- ALTER TABLE messages ADD COLUMN msg_json jsonb;
-- COMMENT ON COLUMN messages.msg_json IS 'Parsed from msg where possible';

CREATE OR REPLACE FUNCTION hatlas_safe_text_to_jsonb(input_text text)
RETURNS jsonb
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN
    -- Check for null or empty
    IF input_text IS NULL OR input_text = '' THEN
        RETURN NULL;
    END IF;

    -- Check for size > 256MB
    IF octet_length(input_text) > 268435455 THEN
        RETURN NULL;
    END IF;

    -- Check for null characters (both Unicode escape and literal)
    IF position(E'\\u0000' IN input_text) > 0 OR position('\x00' IN input_text) > 0 THEN
        RETURN NULL;
    END IF;

    -- Try to parse as JSON
    BEGIN
        RETURN input_text::jsonb;
    EXCEPTION
        WHEN OTHERS THEN
            -- Any JSON parsing error returns NULL
            RETURN NULL;
    END;
END;
$$;

CREATE OR REPLACE FUNCTION hatlas_msg_json_trigger()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.msg_json := hatlas_safe_text_to_jsonb(NEW.msg);
    RETURN NEW;
END;
$$;

CREATE TRIGGER hatlas_trg_sync_msg_json
BEFORE INSERT OR UPDATE OF msg
ON messages
FOR EACH ROW
EXECUTE FUNCTION hatlas_msg_json_trigger();