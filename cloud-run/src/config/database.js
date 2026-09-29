import pg from 'pg';

const { Pool } = pg;

// Single shared pool — always import this, never create a new Pool/Client
// elsewhere. Neon (and Postgres generally) has a limited connection budget,
// and Cloud Run can scale to multiple instances each holding their own pool.
export const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  max: 5,
  connectionTimeoutMillis: 10000,
  idleTimeoutMillis: 30000,
  statement_timeout: 10000,
  enableChannelBinding: true,
});
