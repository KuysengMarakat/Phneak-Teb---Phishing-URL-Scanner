# Architecture

Phneak Teb follows a **layered architecture** to keep UI, business logic and
data access cleanly separated.

```
┌─────────────────────────────────────────────┐
│  UI Layer  (lib/ui)                           │
│  screens/  +  widgets/                        │
└───────────────┬───────────────────────────────┘
                │ calls
┌───────────────▼───────────────────────────────┐
│  Service Layer  (lib/services)                 │
│  ScanService · BiometricService · Notification │
└───────────────┬───────────────────────────────┘
                │ uses
┌───────────────▼───────────────────────────────┐
│  Data Layer  (lib/data)                        │
│  repositories/  +  database/                   │
└───────────────┬───────────────────────────────┘
                │ maps to
┌───────────────▼───────────────────────────────┐
│  Models  (lib/models)                          │
│  User · UrlRecord · ScanResult · ScanReport    │
└────────────────────────────────────────────────┘
```

## Scan pipeline

`ScanService.scan(url)` runs these steps in order:

1. **Validate & normalize** the URL (`UrlValidator`).
2. **Static blocklist** check (`BlocklistRepository`, offline JSON).
3. **Smart blocklist** check (`SmartBlocklistRepository`, learning SQLite table).
4. **VirusTotal API** lookup (`UrlRepository`) if no local match.
5. **Persist** the result to history and **teach** the smart blocklist when a
   URL is flagged as dangerous.

## Persistence

SQLite (via `sqflite`) stores three tables:

| Table             | Purpose                                  |
|-------------------|------------------------------------------|
| `users`           | Local user accounts                      |
| `url_history`     | Every scan performed                     |
| `smart_blocklist` | Domains flagged before (learning layer)  |

`SharedPreferences` stores lightweight flags (login state, language, theme,
biometric toggle).

## Security

- Passwords are hashed (SHA-256) before storage. For production, migrate to a
  salted KDF such as bcrypt/argon2.
- The VirusTotal key lives in `lib/config/api_keys.dart` and should be injected
  at build time via `--dart-define=VT_API_KEY=...` rather than committed.
- Optional biometric gate via `local_auth`.
