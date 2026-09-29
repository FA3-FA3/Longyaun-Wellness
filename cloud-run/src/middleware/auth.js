// Verifies identity before provisioning. Internal UUIDs remain server-side.
export function createAuthHooks({ verifyIdToken, pool }) {
  async function verifyAuth(request, reply) {
    reply.header('Cache-Control', 'no-store');
    const match = /^Bearer ([^\s]+)$/i.exec(request.headers.authorization || '');
    if (!match) return reply.code(401).send({ error: 'Authentication required' });
    try {
      const decoded = await verifyIdToken(match[1]);
      request.callerFUID = decoded.uid;
      request.callerEmail = typeof decoded.email === 'string' ? decoded.email : null;
    } catch (error) {
      const invalid = ['auth/argument-error','auth/invalid-argument','auth/invalid-id-token','auth/id-token-expired','auth/id-token-revoked','auth/user-disabled','auth/user-not-found'];
      const status = invalid.includes(error.code) ? 401 : 503;
      request.log.warn({ errorCode: error.code || 'AUTH_UNAVAILABLE' }, 'Token verification failed');
      return reply.code(status).send({ error: status === 401 ? 'Invalid or expired token' : 'Authentication unavailable' });
    }
  }
  async function ensureUserProfile(request, reply) {
    if (!request.callerFUID) return reply.code(401).send({ error: 'Authentication required' });
    try {
      const {rows} = await pool.query(
        `INSERT INTO public.users (firebase_uid, email) VALUES ($1, $2)
         ON CONFLICT (firebase_uid) DO UPDATE SET email = EXCLUDED.email
         RETURNING id`, [request.callerFUID, request.callerEmail],
      );
      request.callerUUID = rows[0].id;
    } catch (error) {
      request.log.error({errorCode:error.code || 'DATABASE_UNAVAILABLE'}, 'Profile provisioning failed');
      return reply.code(503).send({error:'Database unavailable'});
    }
  }
  return {verifyAuth, ensureUserProfile};
}