# AGENTS.md

Single-package Flutter app ("OfertaLocal"/"RematesYa", package name `luranapp`) backed by Supabase. No monorepo, no CI workflows, no codegen.

## Commands

- `flutter pub get` — after any `pubspec.yaml` change
- `flutter analyze` — lints (flutter_lints via `analysis_options.yaml`)
- `flutter test` — run tests; single test: `flutter test test/<file>_test.dart`
- `flutter run` — dev app

### Known current state (as of 2026-09)

- `flutter analyze` exits non-zero with ~22 pre-existing issues (unused imports/vars, `avoid_print`, deprecations). Don't assume you caused them.
- `flutter test` currently **fails**: `test/widget_test.dart` pumps `OfertaLocalApp` without calling `SupabaseClientService.initialize()`, and `AuthRepository`'s constructor reads `SupabaseClientService.client` eagerly, so `InitialBinding` throws. The test also expects text `'OfertaLocal'` while `AppConstants.appName` is now `'RematesYa'`. New tests must initialize Supabase (or mock the auth repository) and not depend on the splash page's real auth flow.
- Working tree intentionally renames the app to `'RematesYa'` (`app_constants.dart`, `AndroidManifest.xml`) — keep that spelling consistent.

## Architecture

- **GetX everywhere**: `GetMaterialApp` + named routes in `lib/core/routes/app_pages.dart` / `app_routes.dart`, DI via `Bindings` (global: `lib/config/dependencies/initial_binding.dart`; per-route bindings alongside pages).
- **Feature-first, 3 layers** under `lib/features/<feature>/`:
  - `domain/` — entities + `*_interface.dart` repository contracts
  - `data/` — `*_repository.dart` implementing those interfaces
  - `presentation/` — `pages/`, `controllers/` (GetxControllers), `bindings/`
- **Data layer**: repositories extend `lib/core/database/database_repository.dart` (generic CRUD over Supabase) and get the client from `SupabaseClientService` (`lib/core/database/supabase_client.dart`). Table names live in `lib/core/constants/database_tables.dart` (Spanish: `negocios`, `productos`, `sucursales`…) — always use those constants, never string literals.
- **Controllers**: use `ViewStateMixin` from `lib/core/utils/view_state.dart` for loading/error/success state; errors surface through `lib/core/utils/failure_message_mapper.dart`.
- Supabase is initialized in `main()` **before** `runApp`; anything touching `SupabaseClientService.client` before that throws. Credentials are hardcoded in `lib/config/environment/supabase_config.dart` (no env files).

## Conventions

- Code, identifiers, comments, and UI strings are **Spanish** (`Producto`, `Negocio`, `Oferta`, `getAllProducts()`). Match it.
- New feature routes: add route constant to `app_routes.dart`, `GetPage` (+ binding) to `app_pages.dart`.
- DB schema lives in Supabase; there are no SQL migrations in this repo — infer schema from `database_tables.dart` and entity `fromJson`/`toJson`.

## Do not

- **Don't run `supabase_migration.ps1`.** It's a completed one-off migration script; re-running deletes `lib/core/network` and overwrites `supabase_config.dart`, repositories, and `pubspec.yaml` with placeholder values.
- Ignore `README.md` — stale Flutter boilerplate with a corrupted UTF-16 fragment appended.
