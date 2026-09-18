import { verifyAuth, ensureUserProfile } from '../middleware/auth.js';

// Temporary smoke-test route: proves the full chain end to end — client
// token -> verifyAuth -> ensureUserProfile -> a real users row. Once the
// first real feature route exists, this can go.
export async function whoamiRoutes(fastify) {
  fastify.get(
    '/whoami',
    { preHandler: [verifyAuth, ensureUserProfile] },
    async (request) => ({
      firebaseUid: request.callerFUID,
      internalId: request.callerUUID,
    }),
  );
}
