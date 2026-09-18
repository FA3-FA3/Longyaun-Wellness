-- Longyuan Wellness initial schema. Idempotent (safe to re-run) — for fresh
-- installs and to keep local/Neon in sync with new migrations.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Every user has two identifiers: `id` (internal UUID, used for all DB
-- foreign keys, never exposed to the client) and `firebase_uid` (used in
-- all client <-> backend communication). Profiles are created
-- automatically on a user's first authenticated request — there is no
-- separate registration step.
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    firebase_uid TEXT UNIQUE NOT NULL,
    email TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_users_firebase_uid ON users (firebase_uid);
