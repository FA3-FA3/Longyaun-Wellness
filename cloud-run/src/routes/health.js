// Unauthenticated — used for Cloud Run's own health checks and as a quick
// "is the service up" smoke test.
export async function healthRoutes(fastify) {
  fastify.get('/health', async () => ({ status: 'ok' }));
}
