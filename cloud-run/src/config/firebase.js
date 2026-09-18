import admin from 'firebase-admin';

// In Cloud Run, this picks up the service's runtime identity automatically
// — no key file needed there. Locally, set GOOGLE_APPLICATION_CREDENTIALS
// to a downloaded service account JSON (Firebase console → Project
// Settings → Service Accounts → Generate new private key), or run
// `gcloud auth application-default login` once.
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    projectId: process.env.FIREBASE_PROJECT_ID,
  });
}

export { admin };
