# CLAUDE.md

When I ask you to do something, start implementing code changes immediately. Do not spend entire sessions on planning documents unless I explicitly ask for a plan. Prefer action over analysis.

## Project Architecture

Longyuan Wellness is a Flutter web frontend backed by a Cloud Run API and a Postgres (Neon) database, with Firebase Auth for identity.

- **Frontend:** `lib/` — Flutter (Dart) app, `go_router` navigation. Key files: `main.dart` (app entry, theming, Firebase init), `router.dart` (routes), `pages/` (screens), `widgets/` (reusable components), `utils/app_colors.dart` (theming), `utils/api_config.dart` (backend base URL, once added)
- **Backend:** `cloud-run/` — Fastify (Node, ESM). `server.js` entry point; `src/config/` (Firebase Admin, Postgres pool), `src/middleware/auth.js` (`verifyAuth` + `ensureUserProfile`), `src/routes/`
- **Database:** Postgres on Neon (no local Postgres instance — see `postgres/init/01-schema.sql` for schema). `.env.local` (repo root, gitignored) and `cloud-run/.env` (gitignored) hold the connection string

### Key design decisions

- **Dual-ID system:** every user has a Firebase UID (`firebase_uid`, used in all client↔backend communication) and an internal Postgres UUID (`id`, used for foreign keys, never exposed to the client). Suffix variables `FUID`/`UUID` in backend code to keep the distinction explicit — see `cloud-run/src/middleware/auth.js`.
- **Auto-profile creation:** `ensureUserProfile` creates a `users` row on a caller's first authenticated request (upsert on `firebase_uid`) — there is no separate registration step.
- **No self-serve registration:** `/login` signs in only; accounts are created by an admin, not by visitors.

## Local development

Two things need to be running: the local stack and the Flutter app. There are two stack modes, started with different scripts but stopped with the same one:

**Emulator mode** (default, safe/throwaway) — Auth emulator + Cloud Run verifying against it:
```
scripts/start-local-stack-emulator.sh
flutter run -d chrome                    # separate terminal — USE_EMULATOR defaults to true
scripts/stop-local-stack.sh              # when done
```

**Live mode** — Cloud Run verifying real Firebase ID tokens, no emulator. Use when testing a sign-in provider that doesn't behave well in the emulator, or production-like auth behavior. Real user tokens and real Neon rows, same as the deployed service — not a throwaway mode:
```
scripts/start-local-stack-live.sh
flutter run -d chrome --dart-define=USE_EMULATOR=false   # separate terminal
scripts/stop-local-stack.sh                               # when done
```

`stop-local-stack.sh` handles both — it kills by port (9099/4000/4400/4500 for the emulator, 8080 for Cloud Run), so it harmlessly no-ops on the emulator ports when nothing's there in live mode.

Postgres is unaffected by either mode — both local and deployed backends talk to the same real Neon database, since there's no local Postgres instance.

The Auth Emulator starts empty — sign-in fails with "no user record" until a test account exists. Create one via the Emulator UI (http://127.0.0.1:4000/auth) or:
```
curl -X POST "http://localhost:9099/identitytoolkit.googleapis.com/v1/accounts:signUp?key=fake-api-key" \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123","returnSecureToken":true}'
```

Logs: `scripts/.local/emulator.log` (emulator mode only), `scripts/.local/cloud-run.log`. Emulator UI: http://127.0.0.1:4000/auth.

## Code Style & Conventions

### Flutter colours
All colours in pages and widgets must reference `lib/utils/app_colors.dart` (`AppColors.*`). Do not hardcode `Color(0x...)`, `Colors.grey[100]`, etc. — when you need a new shade, add it to `AppColors` first. For light/dark variants, branch on `Theme.of(context).brightness`.

Prefer simplicity and directness over abstraction layers. No transformation layers unless explicitly asked.

### Backend
Use snake_case for database column names and API fields. Never write to the Neon database directly without being asked — schema/data changes go through migrations in `postgres/init/` or an explicit request.

## Testing

- `test/unit/` — pure Dart logic tests
- `test/widget/` — widget tests (`flutter_test`)
- `integration_test/` — end-to-end, if/when added

Run: `flutter test`
