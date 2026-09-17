# CLAUDE.md

When I ask you to do something, start implementing code changes immediately. Do not spend entire sessions on planning documents unless I explicitly ask for a plan. Prefer action over analysis.

## Project Architecture

Longyuan Wellness is a Flutter web app with **no backend and no persistence**. All state lives in memory (widget state / `ChangeNotifier` / similar) and resets on reload — there is no server, no database, no Firebase, no local storage. Do not introduce `http`, `shared_preferences`, `firebase_*`, or any other persistence/network dependency without discussing it first; that's a deliberate constraint, not an oversight.

- **Frontend only:** `lib/` — Flutter (Dart) app, `go_router` navigation
- Key files: `main.dart` (app entry, theming), `router.dart` (routes), `pages/` (screens), `widgets/` (reusable components), `utils/app_colors.dart` (theming)

## Code Style & Conventions

### Flutter colours
All colours in pages and widgets must reference `lib/utils/app_colors.dart` (`AppColors.*`). Do not hardcode `Color(0x...)`, `Colors.grey[100]`, etc. — when you need a new shade, add it to `AppColors` first. For light/dark variants, branch on `Theme.of(context).brightness`.

Prefer simplicity and directness over abstraction layers. No transformation layers unless explicitly asked.

## Testing

- `test/unit/` — pure Dart logic tests
- `test/widget/` — widget tests (`flutter_test`)
- `integration_test/` — end-to-end, if/when added

Run: `flutter test`

## Development Commands

```
flutter run -d chrome
```
