# Production deployment

Project: `longyuan-wellness` (878440911637). Deployed on 2026-09-29 after
billing was attached by the owner.

- Web: https://longyuan-wellness.web.app
- Alternate domain: https://longyuan-wellness.firebaseapp.com
- API: https://longyuan-api-878440911637.europe-west2.run.app
- API URL used by the Flutter build: https://longyuan-api-dweghoju5a-nw.a.run.app
- Region: europe-west2 (London).
- Revision: longyuan-api-00002-vpr.
- Cloud Build: e1a51222-ebc0-419f-a973-45b194d11cac (successful).
- Firebase Hosting version: d7909956f4812149.

## Credentials and service identities

Runtime: longyuan-api@longyuan-wellness.iam.gserviceaccount.com.
Custom role longyuanAuthReader grants only firebaseauth.users.get for token
revocation/disabled-user checks. Secret accessor is scoped to these two secrets:

- longyuan-database-url:1 -> DATABASE_URL
- longyuan-resend-api-key:1 -> RESEND_API_KEY

Build identity: longyuan-build@longyuan-wellness.iam.gserviceaccount.com, with
Cloud Run Builder. No service-account keys were downloaded. Secret values stay
out of source uploads, Docker layers, and Flutter assets.

The container uses Node 24 and runs as the unprivileged node user. Deployment
uses 512 MiB, one CPU, concurrency 40, a 30-second request timeout, zero minimum
instances, and a maximum of two instances. API invocation is public intentionally;
/whoami requires valid Firebase authentication. CORS allows only the two Hosting
origins. Emulator mode is rejected in production.

## Behavior

/whoami returns `{ firebase_uid, email }`. It atomically creates/updates a profile
using verified claims and never returns the internal UUID. The API logs sanitized
errors and redacts authentication headers. The contact route now reports Resend
provider errors as failures instead of claiming that the message was sent.

Email/password authentication and the existing site content remain in place.
No anonymous-login flow was added. The contact form uses the existing Resend key
and sender configuration. Its key is scoped to sending, so a read-only domain
listing is disallowed by Resend. Actual email delivery was not exercised; no
contact email was sent during deployment verification.

## Verification

Flutter analysis and 14 widget tests pass. Five API tests pass, including token
rejection, private-ID protection, CORS, and simulated contact-provider failure.
The dependency audit reports zero vulnerabilities. Cloud Build and the release
Flutter build succeeded. Live health, missing/invalid token rejection, CORS,
and invalid contact submission checks passed.

The actual hosted Flutter app also passed a Chrome browser test with a temporary
admin-created email/password account: sign-in, two authenticated API requests,
one Neon profile with matching email, logout, and signed-out dashboard redirection.
All temporary accounts and their rows were removed. Existing user data was preserved.

## Updating

Run scripts/deploy-api.ps1 and scripts/deploy-web.ps1 from the project root.
The web script resolves the current API URL automatically. Production CORS is
configured in cloud-run/deploy.env.yaml. To rotate credentials, add new secret
versions, update the pinned versions in deploy-api.ps1, and redeploy.
