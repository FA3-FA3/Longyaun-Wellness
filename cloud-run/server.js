import 'dotenv/config';
import { firebaseAuth, firebaseApp } from './src/config/firebase.js';
import { deleteApp } from 'firebase-admin/app';
import { pool } from './src/config/database.js';
import { buildApp } from './src/app.js';

if (!process.env.DATABASE_URL || !process.env.FIREBASE_PROJECT_ID) throw new Error('DATABASE_URL and FIREBASE_PROJECT_ID are required');
const origins=(process.env.CORS_ORIGINS || '').split(',').map(value=>value.trim()).filter(Boolean);
if (!origins.length && (process.env.K_SERVICE || process.env.NODE_ENV==='production')) throw new Error('CORS_ORIGINS is required in production');
for (const origin of origins) {
  const parsed=new URL(origin);
  if (!['https:','http:'].includes(parsed.protocol) || parsed.origin!==origin) throw new Error('CORS requires exact HTTP(S) origins');
}
const app=await buildApp({pool, verifyIdToken:token=>firebaseAuth.verifyIdToken(token,true), origins:origins.length ? origins : /^http:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/});
pool.on('error',()=>app.log.error('Idle database connection failed'));
for (const signal of ['SIGTERM','SIGINT']) process.once(signal,async()=>{await app.close(); await deleteApp(firebaseApp);});
await app.listen({port:Number(process.env.PORT)||8080,host:'0.0.0.0'});
