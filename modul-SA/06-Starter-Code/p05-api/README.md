# p05-api, REST API & Error Handling

> **Pertemuan 5**, fokus: HTTP/JSON, remote datasource, error type terstruktur, fallback mock/fixture, konfigurasi via `--dart-define`.
> **Role starter:** shell remote layer lengkap (api config -> error type -> client interface -> http impl -> mock impl -> datasource -> repository -> provider). Provider CRUD wiring sengaja no-op TODO; `loadTasks` sudah terhubung sehingga GET memperlihatkan data.

## Prasyarat

- Selesai P04 (SQLite/repository), P05 memakai abstraksi `TaskRepository` yang sama dengan sumber remote.
- `flutter doctor` bersih.

## Instruksi run

Default tanpa `--dart-define` -> **mode mock** (fixture offline). Cukup untuk demo tanpa server.

```bash
flutter create --platforms=android,web. # di dalam folder ini
flutter pub get
flutter analyze
flutter test
flutter run
```

Mode live (bila dosen menyediakan endpoint):

```bash
flutter run \
 --dart-define=API_BASE_URL=https://your-server.example.com \
 --dart-define=API_TOKEN=*** # opsional, jangan di-commit
```

> Jangan hardcode secret. Lihat `06-Starter-Code/.env.example` dan `API-CONTRACT.md`.

## Struktur penting

```text
lib/
├── main.dart # pilih client: Mock atau Http by ApiConfig
├── app.dart
├── core/
│ ├── constants/{app_colors,app_strings}.dart
│ ├── errors/api_error.dart # sealed ApiError + mapResponseToError
│ └── theme/app_theme.dart
└── features/tasks/
 ├── domain/task.dart # toJson/fromJson sesuai API-CONTRACT
 ├── data/
 │ ├── remote/
 │ │ ├── api_config.dart # --dart-define: API_BASE_URL, API_TOKEN
 │ │ ├── task_api_client.dart # abstract interface
 │ │ ├── http_task_api_client.dart # impl via package:http
 │ │ ├── mock_task_api_client.dart # fixture fallback (offline)
 │ │ ├── remote_task_datasource.dart # pembungkus tipis
 │ │ └── fixtures/task_fixtures.dart # JSON fixture
 │ └── repositories/task_repository.dart # RemoteTaskRepository (upsert)
 └── presentation/
 ├── providers/task_provider.dart # CRUD wiring = TODO; loadTasks sudah jalan
 └── screens/{task_list_screen,task_form_screen}.dart
test/
├── api_error_test.dart # hijau: pemetaan status -> error
├── mock_task_api_client_test.dart # hijau: fixture fallback + simulasi error
└── widget_test.dart # hijau: mode mock tampil tanpa server
```

## Target checkpoint

### CHECKPOINT 1: Error type + kontrak serialisasi
**Goal:** `ApiError` terstruktur dan `Task.toJson/fromJson` mengikuti kontrak.
**Time:** ~25 menit

**Validasi:**
- [ ] `flutter test test/api_error_test.dart`, hijau.
- [ ] Diskusi: kenapa `sealed` + `switch` lebih aman daripada `if-else` string.
- [ ] Cek `API-CONTRACT.md`: nama field JSON (`due_date`, `priority`, `is_completed`) cocok dengan mapper.

### CHECKPOINT 2: Mock/fixture fallback
**Goal:** aplikasi jalan tanpa server lewat `MockTaskApiClient`.
**Time:** ~20 menit

**Melanjutkan CP 1:**
- Already have: error type + JSON mapping.
- 🆕 Will add: pahami path data fixture -> UI.

**Validasi:**
- [ ] `flutter test test/mock_task_api_client_test.dart`, hijau.
- [ ] `flutter run` (tanpa `--dart-define`) -> list menampilkan task "Fixture: …" dan badge **MOCK API**.
- [ ] Toggle flag `simulateNetworkError = true` di provider init (demo) -> state error + tombol Retry muncul.

### CHECKPOINT 3: Provider CRUD + state UI lengkap
**Goal:** add/update/delete/toggle memanggil repository; semua state (loading/empty/4xx/5xx/network) terlihat.
**Time:** ~40 menit

**Melanjutkan CP 2:**
- Already have: GET dari mock, error mapping.
- 🆕 Will add: POST/PATCH/DELETE + refresh list + error state per operasi.

**Validasi:**
- [ ] FAB -> form -> save -> task baru muncul (mock menyimpan in-memory).
- [ ] Tap card -> edit -> save -> data berubah.
- [ ] Swipe delete -> task hilang.
- [ ] Toggle complete -> status berubah.
- [ ] Matikan internet / set `simulateNetworkError` -> pull-to-refresh -> **state error dengan Retry**.
- [ ] (Bila endpoint tersedia) run dengan `--dart-define=API_BASE_URL=...` -> badge **LIVE API**, data dari server.

## Yang TIDAK boleh diubah

- `Task` field + enum (hanya boleh memperkaya method, bukan mengganti field).
- `ApiConfig` (membaca `--dart-define`).
- `ApiError` hirarki.
- Kontrak JSON `API-CONTRACT.md` (fix; client mengikuti).
- `main.dart` pemilihan client (kecuali menambah strategy lain yang relevan).

## Petunjuk

- Provider CRUD: `_repo.save/remove` -> simpan error ke `_error` -> `loadTasks()` (atau mutasi `_tasks`) -> `notifyListeners()`.
- Bedakan pesan error berdasarkan subtype `ApiError` (NetworkError -> "cek koneksi", ServerError -> "server sibuk", dst).
- Pull-to-refresh sudah terpasang di list screen (`RefreshIndicator`).
- Mock menyimpan in-memory; data tidak persisten lintas restart (itu domain P04). Itu bukan bug sebagai bug.

## Troubleshooting

- **Badge "MOCK API" padahal mau live?** `API_BASE_URL` belum didefinisikan via `--dart-define`; `ApiConfig.useMock` bernilai true.
- **`ClientException: Failed to parse` saat live?** Bentuk JSON server tidak cocok kontrak; periksa `API-CONTRACT.md` dan `Task.fromJson`.
- **State error tidak muncul?** Operasi CRUD masih TODO; exception belum ditangkap ke `_error`.
- **Test `widget_test` gagal `flutter_test` timeout?** Mock ada delay 150ms; pakai `pumpAndSettle()` sudah cukup.

## Status verifikasi host

Host produksi tidak punya Flutter SDK. `pub get/analyze/test` belum dijalankan di sini; verifikasi runtime ditangguhkan sampai SDK tersedia (lihat `06-Starter-Code/README.md`).
