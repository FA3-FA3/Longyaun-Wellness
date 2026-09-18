import { admin } from '../config/firebase.js';
import { pool } from '../config/database.js';

// Verifies the Firebase ID token on the Authorization header and attaches
// the caller's Firebase UID to the request. Client input is always a
// Firebase UID — suffix `FUID` — never the internal Postgres UUID.
export async function verifyAuth(request, reply) {
  const authHeader = request.headers.authorization;
  if (!authHeader?.startsWith('Bearer ')) {
    return reply.code(401).send({ error: 'Missing or malformed Authorization header' });
  }

  const token = authHeader.slice(7);
  try {
    const decoded = await admin.auth().verifyIdToken(token);
    request.callerFUID = decoded.uid;
  } catch (error) {
    request.log.warn({ error }, 'ID token verification failed');
    return reply.code(401).send({ error: 'Invalid or expired token' });
  }
}

// Resolves request.callerFUID to an internal UUID, creating the users row
// on first sight — there is no separate registration step. Must run after
// verifyAuth. Attaches request.callerUUID for downstream handlers.
export async function ensureUserProfile(request, reply) {
  const { callerFUID } = request;
  if (!callerFUID) {
    return reply.code(401).send({ error: 'verifyAuth must run before ensureUserProfile' });
  }

  const { rows } = await pool.query(
    `INSERT INTO users (firebase_uid)
     VALUES ($1)
     ON CONFLICT (firebase_uid) DO UPDATE SET firebase_uid = EXCLUDED.firebase_uid
     RETURNING id`,
    [callerFUID],
  );
  request.callerUUID = rows[0].id;
}
