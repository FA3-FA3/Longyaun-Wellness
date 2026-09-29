# Longyuan Wellness

Flutter web frontend with Firebase email/password authentication, a Fastify
Cloud Run API, and Neon Postgres user profiles.

- Website: https://longyuan-wellness.web.app
- API: https://longyuan-api-878440911637.europe-west2.run.app

The login flow is sign-in only; accounts are created by an administrator.
The dashboard's **Check API connection** verifies the current ID token with
Cloud Run and provisions a profile in Postgres. Internal database UUIDs stay
server-side. The contact form uses the deployed API and its Resend secret.

## Local development

Use the existing scripts/start-local-stack-emulator.sh or
scripts/start-local-stack-live.sh, then run Flutter in another terminal:

```sh
flutter run -d chrome
# For real Firebase login:
flutter run -d chrome --dart-define=USE_EMULATOR=false
```

These existing local scripts use the real Neon database in both modes, as
specified in CLAUDE.md. Use disposable local identities carefully.

## Tests

```sh
flutter analyze
flutter test
npm --prefix cloud-run test
```

## Deploy

From the project root in PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/deploy-api.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/deploy-web.ps1
```

The web deployment script sets API_BASE_URL to the deployed service URL before
building. Release builds never default to localhost. The API deployment uses
project-specific service accounts and pinned Secret Manager versions.

See [deployment details](docs/deployment.md) for infrastructure and verification.
