export async function whoamiRoutes(fastify, { authHooks }) {
  fastify.get('/whoami', {preHandler:[authHooks.verifyAuth, authHooks.ensureUserProfile]}, async request => ({
    firebase_uid: request.callerFUID,
    email: request.callerEmail,
  }));
}