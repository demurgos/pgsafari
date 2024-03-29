-- OAuth clients
CREATE TABLE public.oauth_clients (
  -- OAuth client id
  oauth_client_id UUID PRIMARY KEY NOT NULL,
  -- The key is a small string serving as a secondary identifier for system clients
  -- Its goal is to provide an easier way to identify the app: while the `oauth_client_id` is generated by the server,
  -- the `key` is defined by the client (and can be known before the registration of the client).
  key VARCHAR(32) NULL,
  -- OAuth client creation time
  ctime TIMESTAMP(0),
  -- Display name for the OAuth client
  display_name VARCHAR(64) NOT NULL,
  -- Time of the last change to `display_name`
  display_name_mtime TIMESTAMP(0) NOT NULL,
  -- URI to the homepage of the app
  app_uri VARCHAR(512) NOT NULL,
  -- Time of the last change to `app_uri`
  app_uri_mtime TIMESTAMP(0) NOT NULL,
  -- Redirection URI (matched exactly against `redirect_uri` during the OAuth flow)
  callback_uri VARCHAR(512) NOT NULL,
  -- Time of the last change to `callback_uri_mtime`
  callback_uri_mtime TIMESTAMP(0) NOT NULL,
  -- Encrypted password hash (hashed with `scrypt`, encrypted with `pgp_sym_encrypt_bytea`)
  secret BYTEA NOT NULL,
  -- Time of the last change to `password`
  secret_mtime TIMESTAMP(0) NOT NULL,
  -- ID of the user owning this client. `null` indicates that it is a pre-defined client owned by the system.
  owner_id UUID NULL,
  CHECK (display_name_mtime >= ctime),
  CHECK (app_uri_mtime >= ctime),
  CHECK (callback_uri_mtime >= ctime),
  CHECK (secret_mtime >= ctime),
  -- System apps have a key and no owner, third-party apps have an owner but no key
  CHECK ((key IS NULL) <> (owner_id IS NULL)),
  UNIQUE (key)
);
