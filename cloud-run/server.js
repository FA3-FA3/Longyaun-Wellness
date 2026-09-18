import 'dotenv/config';
import Fastify from 'fastify';
import cors from '@fastify/cors';

import { healthRoutes } from './src/routes/health.js';
import { whoamiRoutes } from './src/routes/whoami.js';
import { contactRoutes } from './src/routes/contact.js';

const fastify = Fastify({ logger: true });

await fastify.register(cors, {
  // Dev-open for now — tighten to the real deployed frontend origin(s)
  // before this goes anywhere near production traffic.
  origin: true,
});

await fastify.register(healthRoutes);
await fastify.register(whoamiRoutes);
await fastify.register(contactRoutes);

const port = Number(process.env.PORT) || 8080;
await fastify.listen({ port, host: '0.0.0.0' });
