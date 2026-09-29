import { applicationDefault, getApps, getApp, initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';

// In Cloud Run, this picks up the service's runtime identity automatically
// — no key file needed there. Locally, run
// `gcloud auth application-default login` once.
if ((process.env.K_SERVICE || process.env.NODE_ENV === 'production') && process.env.FIREBASE_AUTH_EMULATOR_HOST) {
  throw new Error('Auth Emulator is forbidden in production');
}
export const firebaseApp = getApps().length ? getApp() : initializeApp({
  credential: applicationDefault(),
  projectId: process.env.FIREBASE_PROJECT_ID,
});
export const firebaseAuth = getAuth(firebaseApp);
