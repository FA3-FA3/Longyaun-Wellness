import Fastify from 'fastify';
import cors from '@fastify/cors';
import { createAuthHooks } from './middleware/auth.js';
import { healthRoutes } from './routes/health.js';
import { whoamiRoutes } from './routes/whoami.js';
import { contactRoutes } from './routes/contact.js';

export async function buildApp({pool, verifyIdToken, origins, logger=true}) {
  const app=Fastify({logger:logger ? {redact:['req.headers.authorization','req.headers.cookie']} : false, bodyLimit:32768});
  await app.register(cors,{origin:origins,methods:['GET','POST'],allowedHeaders:['Authorization','Content-Type']});
  app.decorateRequest('callerFUID',null);
  app.decorateRequest('callerUUID',null);
  app.decorateRequest('callerEmail',null);
  app.setErrorHandler((error,request,reply)=>{
    request.log.error({errorCode:error.code || 'INTERNAL_ERROR'},'Request failed');
    const status=error.statusCode>=400 && error.statusCode<500 ? error.statusCode : 500;
    reply.code(status).send({error:status===500 ? 'Internal server error' : 'Invalid request'});
  });
  await app.register(healthRoutes);
  await app.register(whoamiRoutes,{authHooks:createAuthHooks({pool,verifyIdToken})});
  await app.register(contactRoutes);
  app.addHook('onClose',()=>pool.end());
  return app;
}