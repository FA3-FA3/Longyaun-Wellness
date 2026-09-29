import test from 'node:test';
import assert from 'node:assert/strict';
import { buildApp } from '../src/app.js';
import Fastify from 'fastify';
import { contactRoutes } from '../src/routes/contact.js';

async function setup(t, overrides={}) {
  const calls=[];
  const app=await buildApp({logger:false,origins:['https://longyuan-wellness.web.app'],
    pool:{query:async(sql,params)=>{calls.push({sql,params});return {rows:[{id:'private-uuid'}]};},end:async()=>{}},
    verifyIdToken:async()=>({uid:'verified-uid',email:'test@example.test'}),...overrides});
  t.after(()=>app.close());
  return {app,calls};
}
test('whoami uses verified claims and keeps database IDs private',async t=>{
  const {app,calls}=await setup(t);
  const result=await app.inject({url:'/whoami?firebase_uid=attacker',headers:{authorization:'Bearer token'}});
  assert.equal(result.statusCode,200);
  assert.deepEqual(result.json(),{firebase_uid:'verified-uid',email:'test@example.test'});
  assert.deepEqual(calls[0].params,['verified-uid','test@example.test']);
  assert.ok(!result.body.includes('private-uuid'));
  assert.equal(result.headers['cache-control'],'no-store');
});
test('missing and expired tokens never reach the database',async t=>{
  const {app,calls}=await setup(t,{verifyIdToken:async()=>{throw Object.assign(new Error('private-token'),{code:'auth/id-token-expired'});}});
  for(const headers of [{},{authorization:'Basic token'},{authorization:'Bearer expired'}]){
    const result=await app.inject({url:'/whoami',headers});
    assert.equal(result.statusCode,401);
    assert.ok(!result.body.includes('private-token'));
  }
  assert.equal(calls.length,0);
});
test('database failures are sanitized',async t=>{
  const {app}=await setup(t,{pool:{query:async()=>{throw new Error('database-secret');},end:async()=>{}}});
  const result=await app.inject({url:'/whoami',headers:{authorization:'Bearer token'}});
  assert.equal(result.statusCode,503);
  assert.ok(!result.body.includes('database-secret'));
});
test('health, CORS and invalid contact requests require no emails',async t=>{
  const {app,calls}=await setup(t);
  assert.equal((await app.inject('/health')).statusCode,200);
  const allowed=await app.inject({url:'/health',headers:{origin:'https://longyuan-wellness.web.app'}});
  assert.equal(allowed.headers['access-control-allow-origin'],'https://longyuan-wellness.web.app');
  const denied=await app.inject({url:'/health',headers:{origin:'https://other.example'}});
  assert.equal(denied.headers['access-control-allow-origin'],undefined);
  assert.equal((await app.inject({url:'/contact',method:'POST',payload:{}})).statusCode,400);
  assert.equal(calls.length,0);
});
test('contact provider rejection is not reported as a sent message',async t=>{
  const app=Fastify();
  t.after(()=>app.close());
  await app.register(contactRoutes,{getClient:()=>({emails:{send:async()=>({error:{name:'validation_error'}})}})});
  const response=await app.inject({url:'/contact',method:'POST',payload:{name:'Test',email:'test@example.test',message:'Local test only'}});
  assert.equal(response.statusCode,502);
  assert.equal(response.json().sent,undefined);
});
