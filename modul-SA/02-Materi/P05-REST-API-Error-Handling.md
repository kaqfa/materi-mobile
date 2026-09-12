# P05, REST API dan Error Handling

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker
**Durasi sesi:** 150 menit (3 × 50) | **Estimasi belajar mandiri:** 5-7 jam
**Sub-CPMK:** 53.2 (REST, error handling, performa) | **Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`

> **Baca juga:** `../02-Materi/P04-SQLite-Offline-First.md`, `../01-Orientasi/Panduan-Mahasiswa.md`. Pasangan kelas: `../03-Modul-Kelas/Modul-P05-REST-API-Error-Handling.md`. Kontrak data: `../06-Starter-Code/API-CONTRACT.md`. Basis konsep: `../../Tutorial/outline-p09-14-advanced-features.md` (Pertemuan 10 REST), dipersempit ke error type terstruktur + mapper JSON + mock/fixture fallback sesuai starter P05.

> **Kebijakan endpoint:** endpoint nyata **belum ditetapkan** saat produksi materi ini. Seluruh paket tuntas memakai **fixture/mock offline** (`MockTaskApiClient`). Endpoint nyata hanya konfigurasi opsional saat pelaksanaan lewat `--dart-define=API_BASE_URL=...`. **Tidak ada secret, akun, atau URL produksi** di materi ini, semua contoh host pakai placeholder `https://your-server.example.com`.

---

## Tujuan Pembelajaran

Setelah materi ini dikuasai, kamu mampu:

1. **Membaca kontrak REST** (`API-CONTRACT.md`): method, path, kode status, dan bentuk JSON; memetakan HTTP status + kondisi jaringan ke `ApiError` terstruktur lewat `sealed class` + `switch` exhaustif sampai `api_error_test.dart` hijau.
2. **Melakukan marshaling JSON** antara `Task` dan objek JSON lewat `Task.toJson`/`fromJson` (`DateTime`/ISO-8601, `enum`/nama, `bool`/JSON boolean) yang konsisten dengan kontrak, termasuk menangani bentuk list "array langsung" vs "dibungkus `data`".
3. **Menghubungkan remote datasource -> repository -> provider** sehingga CRUD menulis ke API (GET wajib + POST/PATCH/DELETE) dan setiap operasi memunculkan **state UI lengkap**: loading, success, empty, dan error 401/404/500/network yang terlihat dengan **retry manual**, seluruhnya bisa diuji tanpa server lewat `MockTaskApiClient`.

**Outcome sesi (bukti observable):**
- Starter `06-Starter-Code/p05-api/` berjalan **tanpa `--dart-define`** (mode mock): list menampilkan task "Fixture: …" dengan badge **MOCK API** di AppBar.
- `flutter test test/api_error_test.dart`, semua test **hijau** (pemetaan status -> subtype `ApiError`, `sealed` switch exhaustif).
- `flutter test test/mock_task_api_client_test.dart`, semua test **hijau** (fixture fallback GET offline, create/update/delete, duplikat->`ClientError 409`, hilang->`NotFoundError`, `simulateNetworkError`->`NetworkError`).
- CRUD end-to-end di mode mock: FAB -> form -> save -> task muncul; tap -> edit; swipe -> delete; tap centang -> toggle (data tersimpan in-memory mock dalam sesi).
- **Error state terbukti:** aktifkan `simulateNetworkError` (atau putus jaringan saat live) -> pull-to-refresh -> muncul `_ErrorView` (ikon `cloud_off` + pesan + tombol **Retry**) yang memanggil ulang `loadTasks()`.

---

## Prasyarat

- Menyelesaikan `../02-Materi/P04-SQLite-Offline-First.md`: paham abstraksi `TaskRepository`, layer datasource -> repository -> provider, persistensi lintas restart, dan pola "simpan provider sebelum `await` + `mounted` guard". P05 **memakai abstraksi `TaskRepository` yang sama** tapi sumbernya remote, bukan SQLite.
- `../01-Orientasi/Checklist-Environment.md` lulus; `flutter doctor` bersih. Target demo **Android atau web**, `package:http` berjalan di kedua platform (tidak butuh native SQLite seperti P04). Mode mock paling cepat diuji di web.
- Paham Dart 3 dasar: `enum` + `.name`/`.byName`, `sealed`/`switch` pattern, `try`/`catch`/`rethrow`, `Future`/`await`. Fondasi ini dipakai penuh di error mapping.
- Starter P05 sudah di-copy ke workspace kosong (lihat "Setup").

> **Kebijakan AI P05:** AI boleh untuk **debugging dan review error jaringan/data layer** (mis. "kenapa `401` muncul padahal saya sudah kirim token?"). AI **tidak boleh** menulis core `fromJson`/`toJson`, error mapping, atau wiring provider CRUD tanpa analisis sendiri, kamu **wajib memahami perubahan data layer + alur error** (ini kriteria ujian + Assignment 2). Bila memakai AI, isi `../01-Orientasi/Template-AI-Interaction-Log.md` dan pastikan kamu dapat menjelaskan tiap baris dengan kata sendiri, termasuk skenario 401/404/500/network.

---

## Setup

```bash
# 1. Copy folder starter ke workspace kosong, lalu di dalamnya:
flutter create --platforms=android,web. # hasilkan platform runner (http jalan di android & web)
flutter pub get # menambah: http ^1.2.2, provider ^6.1.2
flutter analyze
flutter test # api_error_test.dart + mock_task_api_client_test.dart
 # + widget_test.dart, SEMUA HIJAU sejak starter

# MODE DEFAULT (mock/fixture), cukup untuk seluruh materi + demo:
flutter run
```

**Mode live opsional (hanya bila dosen menyediakan endpoint saat pelaksanaan):**

```bash
flutter run \
 --dart-define=API_BASE_URL=https://your-server.example.com \
 --dart-define=API_TOKEN=*** # opsional; jangan di-commit
```

> Folder `android/`/`web/` dll. sengaja **tidak** disertakan. Jalankan `flutter create` dari dalam folder starter; pulihkan `pubspec.yaml`/`analysis_options.yaml` dari Git bila ditimpa. **Jangan ubah `pubspec.yaml`**, dependency (`http ^1.2.2`, `provider ^6.1.2`) sudah dipasang dan dipin. **Jangan hardcode** base URL/token di source: `ApiConfig` membaca `--dart-define`; tanpa define -> otomatis mode mock.

> **No-secret rule:** contoh `https://your-server.example.com` dan token `***` adalah placeholder dokumentasi, bukan endpoint/akun nyata. Jangan pernah menulis host, IP, username, password, atau token produksi di source maupun `README`. Lihat `../06-Starter-Code/API-CONTRACT.md` §6.

---

## Struktur starter P05

```text
06-Starter-Code/p05-api/
├── pubspec.yaml # http ^1.2.2, provider ^6.1.2 (TANPA sqflite, beda P04)
├── lib/
│ ├── main.dart # pilih client: Mock atau Http by ApiConfig.useMock
│ ├── app.dart # TaskTrackerApp + activeModeLabel() (MOCK/LIVE)
│ ├── core/
│ │ ├── constants/{app_colors,app_strings}.dart # modeMock/modeLive/actionRetry/networkOffline
│ │ ├── errors/api_error.dart # sealed ApiError + mapResponseToError (HIJAU)
│ │ └── theme/app_theme.dart
│ └── features/tasks/
│ ├── domain/task.dart # model + toJson/fromJson sesuai API-CONTRACT (HIJAU)
│ ├── data/
│ │ ├── remote/
│ │ │ ├── api_config.dart # --dart-define: API_BASE_URL, API_TOKEN, timeout
│ │ │ ├── task_api_client.dart # abstract interface (listTasks/create/update/delete)
│ │ │ ├── http_task_api_client.dart # impl via package:http + _send wrapper
│ │ │ ├── mock_task_api_client.dart # fixture fallback (in-memory + simulateNetworkError)
│ │ │ ├── remote_task_datasource.dart# pembungkus tipis atas client
│ │ │ └── fixtures/task_fixtures.dart# 3 task JSON offline (Bentuk A array)
│ │ └── repositories/
│ │ └── task_repository.dart # RemoteTaskRepository (upsert PATCH/POST)
│ └── presentation/
│ ├── providers/task_provider.dart # CRUD wiring = TODO (CP3); loadTasks sudah jalan
│ └── screens/{task_list_screen,task_form_screen}.dart
└── test/
 ├── widget_test.dart # smoke (hijau: mode mock tampil tanpa server)
 ├── api_error_test.dart # hijau: pemetaan status -> ApiError + sealed switch
 └── mock_task_api_client_test.dart # hijau: fixture fallback + error simulation
```

**Aturan batas (penting):**
- Boleh mengubah `task_provider.dart` (isi `addTask`/`updateTask`/`deleteTask`/`toggleComplete` wiring ke repo + error ke `_error`).
- Tidak boleh mengubah `Task` class/enum/field, `ApiConfig`, `ApiError` hirarki, kontrak JSON (`API-CONTRACT.md`), `HttpTaskApiClient`, `MockTaskApiClient`, `RemoteTaskRepository`, `RemoteTaskDatasource`, atau `main.dart` pemilihan client, semua sudah benar.
- Tidak boleh menambah package atau mengubah signature metode yang sudah didefinisikan.

**Role starter:** shell remote layer lengkap. ApiConfig, error type, JSON mapper, interface klien, impl HTTP + impl mock, datasource, repository, UI (list dengan badge + `_ErrorView` + `RefreshIndicator`; form async) **semua sudah tersambung**. Yang sengaja no-op: **wiring CRUD di `TaskProvider`** (CP3), `loadTasks` sudah jalan sehingga GET memperlihatkan data fixture sejak first run. Bukan bug, tugas implementasi yang diverifikasi oleh state UI error.

---

## Mengapa REST, dan Kenapa Sekarang

Di P04, sumber kebenaran adalah **file SQLite lokal**, app bekerja penuh tanpa internet. P05 menambah **sumber remote** (REST/JSON) tanpa membuang fondasi offline-first: ketika remote gagal, operasi lokal tetap layak (bahan Assignment 2). Empat prinsip yang dilatih di sini:

1. **Kontrak eksplisit = sumber kebenaran antara klien dan server.** `API-CONTRACT.md` menetapkan method, path, status, dan bentuk JSON. Klien **mengikuti kontrak**, bukan sebaliknya. Saat server mengubah field (`due_date` -> `dueDate`), mapper pecah, itulah kenapa kontrak tertulis penting dan kenapa mapper JSON wajib eksplisit.
2. **Error terstruktur, bukan string acak.** HTTP hanya memberi `statusCode` (int) + body tak terjamin. P05 memetakan status + kondisi jaringan ke **hirarki `sealed ApiError`** (`NetworkError`/`ServerError`/`ClientError`/`NotFoundError`/`ParseError`). UI lalu `switch` exhaustif: tiap subtype punya pesan + aksi berbeda. Ini jauh lebih aman daripada `if (message.contains('timeout'))`.
3. **Layer terpisah = swap sumber tanpa ubah UI.** Provider hanya kenal `TaskRepository` (sama seperti P04). Saat `TaskApiClient` ditukar Mock/Http lewat `ApiConfig.useMock`, repository/provider/UI **tidak berubah**. Manfaat abstraksi: mock di lab, live di demo, tanpa refactor.
4. **Fallback mock = uji tanpa server.** Endpoint nyata belum ditetapkan saat materi dibuat. `MockTaskApiClient` mengimplementasikan seluruh method `TaskApiClient` terhadap fixture offline, termasuk flag `simulateNetworkError` untuk mendemokan state error. **Setiap checkpoint bisa diselesaikan dan diverifikasi 100% tanpa server eksternal.**

> **Sambungan dengan P04:** `TaskRepository` abstraksi di P05 **sama persis** (`getAll`/`save`/`remove`), beda sumber data: `RemoteTaskDatasource` (HTTP/mock) alih-alih `LocalTaskDatasource` (SQLite). `RemoteTaskRepository.save` tetap upsert (PATCH bila ada, POST bila baru). Pola provider "tulis repo -> reload -> notify" juga sama; yang baru adalah **error bisa datang dari jaringan**, jadi tiap operasi kini butuh `try`/`catch` + state `_error`.

> **Mengapa bukan parsing body error?** Body error tak konsisten lintas server (ada yang `{error: "msg"}`, ada yang plain text, ada yang kosong). Klien andal memetakan dari **HTTP status** + jenis eksepsi jaringan, bukan menebak struktur body. Isi `mapResponseToError`.

---

## CHECKPOINT 1: Error Type Terstruktur + Kontrak Serialisasi

**Goal:** memahami hirarki `ApiError` (sealed) + `mapResponseToError`, dan memverifikasi `Task.toJson`/`fromJson` cocok kontrak; `api_error_test.dart` hijau.
**Time:** ~10 menit

### 1.1 Baca `api_error.dart`, sealed class sebagai kontrak error

```dart
sealed class ApiError implements Exception {
 const ApiError(this.message);
 final String message;

 @override
 String toString() => '$runtimeType: $message';
}

class NetworkError extends ApiError {
 const NetworkError([super.message = 'Network error: tidak ada koneksi.']);
}

class ServerError extends ApiError {
 const ServerError(this.status, [String? message])
 : super(message ?? 'Server error ($status): coba lagi nanti atau pakai fallback.');
 final int status;
}

class ClientError extends ApiError {
 const ClientError(this.status, [String? message])
 : super(message ?? 'Client error ($status): permintaan tidak valid.');
 final int status;
}

class NotFoundError extends ApiError {
 const NotFoundError([super.message = 'Task tidak ditemukan (404).']);
}

class ParseError extends ApiError {
 const ParseError([super.message = 'Response tidak dapat di-parse.']);
}

ApiError mapResponseToError(int status) {
 if (status >= 500) return ServerError(status);
 if (status == 404) return const NotFoundError();
 if (status >= 400) return ClientError(status);
 return ClientError(status, 'Unexpected status $status');
}
```

**Penting:**

1. **`sealed` (Dart 3) = semua subtype diketahui saat compile.** UI/repository bisa `switch` **exhaustif** atas `ApiError`, compiler menolak bila ada subtype tak tertangani. Bandingkan dengan `if-else` string: lupa satu cabang = bug diam-diam. `sealed` memaksa kelengkapan.
2. **Pemetaan dari status, bukan body.** `mapResponseToError(503)` -> `ServerError(503)`; `404` -> `NotFoundError`; `401/403/422` -> `ClientError`. Tidak ada parsing body error, sumber kebenaran adalah `statusCode`. Alasan: body error tak terjamin konsisten lintas server (lihat §"Mengapa REST").
3. **Network/Parse tidak punya status.** `NetworkError` terjadi sebelum response (timeout, socket, DNS); `ParseError` setelah response tapi body rusak. Keduanya tak terkait HTTP status, lahir dari `catch` di `_send`/`_decode` (lihat CP2/CP3).
4. **`implements Exception`.** Semua subtype bisa di-`throw` dan di-`catch` sebagai `ApiError`. Pola: repository/provider `try {... } on ApiError catch (e) { _error = e.message; }`, satu tipe dasar cukup untuk semua error API.
5. **Pesan default bermakna.** Tiap subtype punya teks siap pakai untuk UI (mis. `NetworkError` -> "tidak ada koneksi", `ServerError` -> "server sibuk"). UI boleh meng-override, tapi default sudah cukup untuk demo.

### 1.2 Baca test yang hijau, verifikasi pemetaan

```bash
flutter test test/api_error_test.dart
```

Test menyatakan ekspektasi (semua sudah hijau di starter, kamu **membaca untuk memahami**, bukan mengimplementasi):
- `mapResponseToError(503)` -> `isA<ServerError>()` + `status == 503`.
- `mapResponseToError(404)` -> `isA<NotFoundError>()`.
- `400/401/403/422` -> masing-masing `isA<ClientError>()` + `status` sesuai.
- `NetworkError`/`ParseError` punya `message` non-kosong.
- **Switch exhaustif:** function `describe(ApiError)` `switch` atas semua 5 subtype, semua lulus, membuktikan `sealed` bekerja.

> **Ini gate konsep.** Bila kamu belum bisa menjelaskan "kenapa `sealed` lebih aman dari `if-else` string" atau "kenapa error dipetakan dari status bukan body", tunda CP2. CP2 dan CP3 memakai error type ini; salah paham di sini -> bug susur di provider.

### 1.3 Baca `Task.toJson`/`fromJson`, marshaling JSON sesuai kontrak

Buka `domain/task.dart`. Mapper JSON meniru pola `toRow`/`fromRow` P04, tapi untuk `Map<String, Object?>` JSON (bukan baris SQLite). Perhatikan perbedaan tipe storage:

```dart
factory Task.fromJson(Map<String, Object?> json) {
 return Task(
 id: json['id'] as String,
 title: json['title'] as String,
 description: (json['description'] as String?) ?? '',
 dueDate: DateTime.parse(json['due_date'] as String),
 priority: TaskPriority.values.byName(json['priority'] as String),
 isCompleted: (json['is_completed'] as bool?) ?? false,
 );
}

Map<String, Object?> toJson() => <String, Object?>{
 'id': id,
 'title': title,
 'description': description,
 'due_date': dueDate.toIso8601String(),
 'priority': priority.name,
 'is_completed': isCompleted,
 };
```

**Poin penting (bandingkan dengan P04 SQLite mapper):**

| Field | JSON tipe | SQLite tipe (P04) | Catatan |
|-----------------|-------------------------|-------------------|--------------------------------------------------------|
| `id` | string | TEXT | sama |
| `title` | string | TEXT | sama |
| `description` | string (`""` boleh) | TEXT DEFAULT '' | `fromJson` defensive: `?? ''` bila null |
| `due_date` | string ISO-8601 | TEXT ISO-8601 | **snake_case** di JSON (bukan `dueDate`) |
| `priority` | string nama enum | TEXT nama enum | `"low"`/`"medium"`/`"high"` |
| `is_completed` | **boolean** `true`/`false` | INTEGER 0/1 | **BEDA P04!** JSON punya boolean native, bukan 0/1 |

1. **`is_completed` = boolean di JSON, integer di SQLite.** Ini jebakan silang P04/P05. Di P04 kamu simpan `? 1 : 0`; di JSON kamu kirim `isCompleted` (bool) langsung. `jsonEncode`/`jsonDecode` mengurus boolean native. Jangan pakai `0`/`1` di JSON, kontrak (`API-CONTRACT.md` §3.1) menetapkan boolean.
2. **Nama field snake_case.** Kontrak memakai `due_date`, `is_completed`, bukan camelCase Dart. Mapper `toJson`/`fromJson` **wajib** pakai literal string `'due_date'`/`'is_completed'`. Typo di sini = server menolak (422) atau field `null` saat parse.
3. **`DateTime.toIso8601String()` / `DateTime.parse()`.** Sama seperti P04, representasi ISO-8601 string. Kontrak menetapkan **UTC** (`Z` suffix, mis. `"2026-09-01T00:00:00.000Z"`). `DateTime.parse` menerimanya; untuk konsistensi zona, uji dengan `DateTime.utc(...)`.
4. **`.name` / `.byName`.** Enum/string, sama P04. `TaskPriority.high.name == 'high'`; `.byName('high')` kembalikan enum. **Throw `ArgumentError` bila nama tak ada**, di P05 data bisa datang dari server tak terpercaya, jadi rawan invalid value. Mock starter selalu valid; live server belum tentu.
5. **`fromJson` defensive.** `description`/`is_completed` pakai `?? ''`/`?? false`, toleran bila field null. Ini berbeda dari `id`/`title`/`due_date` yang **wajib** ada (kontrak §3.1: required). Pilihan: field wajib = cast langsung (throw bila hilang = bug kontrak yang harus diperbaiki, bukan ditelan).

### 1.4 Verifikasi kontrak cocok

```bash
flutter test test/api_error_test.dart # All tests passed!
flutter analyze # No issues found!
```

Buka `API-CONTRACT.md` §3.1. Bandingkan tiap field di tabel dengan `toJson`/`fromJson`: nama (`due_date` bukan `dueDate`), tipe (`is_completed` boolean), wajib (id/title/due_date/priority/is_completed). **Kontrak dan mapper harus identik.** Saat demo, dosen bisa tanya "field `due_date` di JSON camelCase atau snake_case? Kenapa?", wajib bisa jawab.

### Checkpoint Validation

- [ ] `flutter test test/api_error_test.dart`, **semua test hijau** (pemetaan status + sealed switch).
- [ ] `flutter analyze` tetap bersih.
- [ ] Kamu bisa menjelaskan **kenapa** `sealed` + `switch` lebih aman daripada `if-else` string.
- [ ] Kamu bisa menjelaskan **kenapa** error dipetakan dari HTTP status, bukan dari body error.
- [ ] Kamu bisa menjelaskan perbedaan marshaling `is_completed` antara JSON (boolean) dan SQLite (0/1), serta **kenapa** berbeda.

**Run & Test:**
```bash
flutter test test/api_error_test.dart # All tests passed!
```

> **Fallback mock path CP1:** error type + mapper diverifikasi lewat test murni (`api_error_test.dart`), **tanpa server, tanpa `--dart-define`, tanpa koneksi**. Fixture/mock mendukung sepenuhnya: `MockTaskApiClient` melempar subtype `ApiError` yang sama (`ClientError 409`, `NotFoundError`, `NetworkError`) saat kondisi terpicu (lihat CP2/CP3).

---

## CHECKPOINT 2: Mock/Fixture Fallback (GET Tanpa Server)

**Goal:** memahami jalur data fixture -> UI; aplikasi jalan **tanpa server** lewat `MockTaskApiClient`; `mock_task_api_client_test.dart` hijau.
**Time:** ~10 menit

**Melanjutkan CP 1:**
- Sudah punya: error type terstruktur + mapper JSON cocok kontrak.
- 🆕 Akan pahami: pemilihan client (Mock vs Http), alur fixture -> klien -> datasource -> repo -> provider -> UI, badge MOCK/LIVE.

### 2.1 Baca `api_config.dart`, konfigurasi compile-time

```dart
class ApiConfig {
 const ApiConfig._();

 static const String baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
 static const String apiToken = String.fromEnvironment('API_TOKEN', defaultValue: '');
 static const Duration timeout = Duration(seconds: 10);

 static bool get useMock => baseUrl.isEmpty;
}
```

**Poin:**

1. **`String.fromEnvironment` = compile-time define.** Nilai dibaca saat `flutter run/build`, bukan saat runtime. `--dart-define=API_BASE_URL=...` menyuntik nilai; tanpa define -> `defaultValue: ''`. **Bukan** baca file `.env` (Flutter tak baca `.env` native, lihat `06-Starter-Code/.env.example`).
2. **`useMock` = `baseUrl.isEmpty`.** Default (tanpa define) -> `useMock == true` -> aplikasi otomatis pakai mock. Ini memenuhi acceptance "bisa diuji tanpa server eksternal".
3. **`timeout` 10 dtk.** Request melebihi ini -> `NetworkError` (lihat `_send` di `HttpTaskApiClient`, CP3 diskusi).
4. **No hardcoded secret.** Tidak ada default host/token nyata. Token `apiToken` kosong default; hanya dipakai saat `baseUrl` tidak kosong (`HttpTaskApiClient` kirim header `Authorization: Bearer...` bila `_token` tak kosong).

### 2.2 Baca `main.dart`, pemilihan client

```dart
void main() {
 final TaskApiClient client = ApiConfig.useMock
 ? MockTaskApiClient()
 : HttpTaskApiClient(baseUrl: ApiConfig.baseUrl, token: ApiConfig.apiToken);

 final repository = RemoteTaskRepository(RemoteTaskDatasource(client));

 runApp(
 ChangeNotifierProvider(
 create: (_) => TaskProvider(repository)..loadTasks(),
 child: const TaskTrackerApp(),
 ),
 );
}
```

**Poin:**

1. **Satu titik pilih sumber data.** `ApiConfig.useMock` menentukan `MockTaskApiClient` (fixture) atau `HttpTaskApiClient` (server). Selepas titik ini, semua lapisan sama.
2. **Rantai dependency identik P04.** `client -> RemoteTaskDatasource -> RemoteTaskRepository -> TaskProvider`. Beda P04: datasource/client adalah `remote`, bukan `local`. Repository/provider/UI tak peduli sumbernya, itu manfaat abstraksi.
3. **`..loadTasks()`** cascade memicu GET saat app start. Mode mock -> `_store` fixture (`f01`/`f02`/`f03`) -> list tampil 3 task "Fixture: …". Mode live -> `GET /tasks` ke server.
4. **Tidak ada `try` di `main`.** Pemilihan client tak bisa gagal. Error (jaringan, 5xx) terjadi di `loadTasks` dan ditangani di provider (`_error`).

### 2.3 Baca `MockTaskApiClient` + fixture, fallback offline lengkap

```dart
class MockTaskApiClient implements TaskApiClient {
 MockTaskApiClient({List<Map<String, Object?>>? seed})
 : _store = {
 for (final t in (seed ?? TaskFixtures.tasks))
 t['id'] as String: Map<String, Object?>.from(t),
 };

 final Map<String, Map<String, Object?>> _store;

 bool simulateNetworkError = false;

 @override
 Future<List<Task>> listTasks() async {
 await _delay();
 _maybeThrowNetwork();
 return _store.values.map(Task.fromJson).toList();
 }
 // create/update/delete serupa: _delay -> _maybeThrowNetwork -> store logic
 // create id duplikat -> ClientError(409); update/delete id hilang -> NotFoundError
}
```

**Penting:**

1. **Mock implement seluruh method `TaskApiClient`.** GET/POST/PATCH/DELETE semua berfungsi terhadap `_store` in-memory. CRUD yang kamu wiring di CP3 **langsung terlihat efeknya** tanpa server.
2. **Fixture = JSON mentah, parse lewat `Task.fromJson`.** `TaskFixtures.tasks` disimpan sebagai `List<Map<String,Object?>>` (bukan `List<Task>`) supaya path parsing JSON tetap teruji. Bentuknya persis `API-CONTRACT.md` Bentuk A (array langsung). Jadi mock menguji mapper yang sama dengan live.
3. **`_delay()` 150ms meniru latensi.** Membuat loading state terlihat (`isLoading` true sebentar). Bukan realistis, tapi cukup untuk demo spinner.
4. **`simulateNetworkError` = saklar demo error.** Set `true` -> `_maybeThrowNetwork()` melempar `NetworkError` di tiap method. Cara **memunculkan state error UI tanpa mematikan internet**, krusial untuk CP3 dan bukti screenshot Assignment 2.
5. **Mock TIDAK persisten lintas restart.** In-memory store hilang saat app dibunuh. **Itu bukan bug**, persistensi adalah domain P04 (SQLite). Mock hanya meniru sumber remote dalam sesi. Itu bukan bug.

### 2.4 Baca test fallback, verifikasi GET offline

```bash
flutter test test/mock_task_api_client_test.dart
```

Test (semua hijau di starter, kamu **membaca**):
- `listTasks` mengembalikan **3 fixture** tanpa server; `tasks.first.title` startsWith `'Fixture:'`.
- `createTask` menambah; muncul di `listTasks` berikutnya.
- `createTask` id duplikat (`f01`) -> `throwsA(isA<ClientError>())` (409).
- `updateTask` id hilang -> `throwsA(isA<NotFoundError>())`.
- `deleteTask` menghapus; `simulateNetworkError = true` -> `throwsA(isA<NetworkError>())`.

> **Ini bukti acceptance "fallback mock".** Seluruh perilaku klien yang tersedia di mock, sukses + 409 + 404 + network error, teruji tanpa endpoint nyata. Pemetaan 401/500 diverifikasi lewat `api_error_test.dart`; tampilan UI untuk status tersebut perlu endpoint live atau test double tambahan, bukan flag mock bawaan.

### 2.5 Verifikasi first run (mode mock)

```bash
flutter run # tanpa --dart-define
```

Amati: spinner singkat (150ms delay) -> list 3 task "Fixture: …" -> badge **MOCK API** di AppBar (dari `activeModeLabel()` -> `AppStrings.modeMock`). Tidak ada crash. Pull-to-refresh (`RefreshIndicator`) memuat ulang fixture. **GET offline terbukti tanpa server.**

### Checkpoint Validation

- [ ] `flutter test test/mock_task_api_client_test.dart`, **semua test hijau**.
- [ ] `flutter run` (tanpa `--dart-define`) -> list tampil task "Fixture: …" + badge **MOCK API**.
- [ ] Pull-to-refresh memuat ulang fixture tanpa error.
- [ ] Kamu bisa menjelaskan **kenapa** mock tidak persisten lintas restart (dan itu bukan bug).
- [ ] Kamu bisa menjelaskan kapan `ApiConfig.useMock` bernilai `true`/`false`.

**Run & Test:**
```bash
flutter test test/mock_task_api_client_test.dart # All tests passed!
flutter run # Expected: 3 fixture task + badge MOCK API
```

> **Fallback mock path CP2:** jalur data penuh `TaskFixtures -> MockTaskApiClient -> RemoteTaskDatasource -> RemoteTaskRepository -> TaskProvider -> TaskListScreen` berjalan **100% offline**. Error simulation (`simulateNetworkError`, duplikat 409, hilang 404) tersedia untuk demo state error di CP3.

---

## CHECKPOINT 3: Provider CRUD + State UI Lengkap (Loading/Success/Empty/401/404/500/Network)

**Goal:** hubungkan `addTask`/`updateTask`/`deleteTask`/`toggleComplete` ke repository; setiap operasi memunculkan state UI lengkap dengan **retry manual**.
**Time:** ~35 menit

**Melanjutkan CP 2:**
- Sudah punya: error type + mapper cocok kontrak; GET dari mock jalan; jalur fallback lengkap.
- 🆕 Akan tambah: POST/PATCH/DELETE wiring + state error per operasi + retry manual + (opsional) mode live.

### 3.1 Baca `TaskProvider`, state + TODO inti

```dart
class TaskProvider extends ChangeNotifier {
 TaskProvider(this._repo);
 final TaskRepository _repo;

 List<Task> _tasks = const [];
 bool _isLoading = false;
 String? _error;

 List<Task> get tasks => List.unmodifiable(_tasks);
 bool get isLoading => _isLoading;
 String? get error => _error;

 Future<void> loadTasks() async {
 _isLoading = true;
 _error = null;
 notifyListeners();
 try {
 _tasks = await _repo.getAll();
 } catch (e) {
 _error = 'Failed to load tasks: $e';
 } finally {
 _isLoading = false;
 notifyListeners();
 }
 }

 // ---- CRUD inti (TODO student) ------------------------------------------
 Future<void> addTask(Task task) async {
 // TODO(student): _repo.save(task) lalu refresh list + notify.
 // Tangani error: simpan ke _error lalu notifyListeners agar UI retry muncul.
 }
 Future<void> updateTask(Task task) async { /* TODO */ }
 Future<void> deleteTask(String id) async { /* TODO */ }
 Future<void> toggleComplete(String id) async { /* TODO */ }
}
```

**Poin penting sebelum ngoding:**

1. **Tiga state UI eksplisit.** `isLoading` (spinner), `error != null` (`_ErrorView` + Retry), `tasks.isEmpty` (empty state). List screen sudah `switch` atas tiga ini (`_body`). Tinggal kamu isi CRUD supaya state berubah benar.
2. **`loadTasks` = pola acuan.** Perhatikan urutan: set `_isLoading=true` + `_error=null` + `notifyListeners` -> `await repo` -> `try`/`catch` isi `_error` -> `finally` set `_isLoading=false` + `notifyListeners`. CRUD memakai pola serupa, tapi state loading boleh lebih granular (lihat 3.2).
3. **CRUD no-op saat ini = bug yang harus kamu perbaiki.** FAB -> form -> save saat ini **tidak mengubah list** karena `addTask` TODO. Begitu kamu wiring ke `_repo.save`, mock menyimpan ke `_store` -> reload memperlihatkan perubahan. Ini gate utama P05.
4. **Error dari repo = `ApiError` subtype.** `save`/`remove` melempar `ClientError`/`NotFoundError`/`ServerError`/`NetworkError`/`ParseError`. Tangkap sebagai `catch (e)`, simpan `e.toString()` (atau `e.message`) ke `_error`. UI sudah siap menampilkannya.

### 3.2 Implementasi CRUD, pola "coba tulis -> tangani error -> reload"

Terapkan pola `try/catch` yang sama di tiap metode. Jangan menambah helper pseudo-code yang tidak dipakai; fokus pada urutan operasi nyata di bawah.

```dart
Future<void> addTask(Task task) async {
 try {
 await _repo.save(task); // POST (mock: simpan ke _store)
 await loadTasks(); // reload agar list segar + state loading/error benar
 } catch (e) {
 _error = 'Failed to add task: $e';
 notifyListeners();
 }
}

Future<void> updateTask(Task task) async {
 try {
 await _repo.save(task); // PATCH (mock: update _store)
 await loadTasks();
 } catch (e) {
 _error = 'Failed to update task: $e';
 notifyListeners();
 }
}

Future<void> deleteTask(String id) async {
 try {
 await _repo.remove(id); // DELETE (mock: hapus dari _store)
 await loadTasks();
 } catch (e) {
 _error = 'Failed to delete task: $e';
 notifyListeners();
 }
}

Future<void> toggleComplete(String id) async {
 final task = findById(id);
 if (task == null) return;
 try {
 await _repo.save(task.copyWith(isCompleted: !task.isCompleted)); // PATCH
 await loadTasks();
 } catch (e) {
 _error = 'Failed to toggle task: $e';
 notifyListeners();
 }
}
```

**Penting:**

1. **`try { repo... } catch (e) { _error =...; notifyListeners(); }`.** Setiap operasi async bisa gagal (jaringan/server). Tanpa `try/catch`, exception tak tertangkap -> crash app + UI beku. Pola ini menangkap kegagalan ke `_error` agar UI tampilkan retry.
2. **`await loadTasks()` di akhir sukses.** Cara termudah menjaga `_tasks` sinkron: tulis lalu reload. Mock in-memory -> langsung terlihat. LoadTasks juga mengatur `_isLoading`/`_error`, jadi state konsisten. (Catatan: loadTasks set `_error=null` di awal, itu membersihkan error lama, yang diinginkan saat operasi sukses.)
3. **`findById` + `copyWith` untuk toggle (sama P04).** Cari task di memori, balik `isCompleted` lewat immutable `copyWith`, simpan ke repo. Bila id tak ada -> return awal (idempotent).
4. **Pesan error membedakan operasi.** "Failed to add/update/delete/toggle" membantu debug. Bila mau tampilan lebih ramah, ubah pesan berdasarkan subtype `ApiError` (lihat 3.4). Tapi untuk lulus gate, teks default `'$runtimeType: $message'` (dari `ApiError.toString()`) sudah cukup, UI tunjukkan `NetworkError:...`, `ServerError (503):...`, dst.
5. **`notifyListeners()` di setiap cabang.** Sukses -> `loadTasks` sudah notify. Gagal -> notify eksplisit setelah set `_error`. Tanpa notify, UI diam walau state berubah.
6. **Async + context misuse (warisan P03/P04).** `task_form_screen._submit` sudah ambil `context.read<TaskProvider>()` sebelum `await`, lalu `if (mounted) Navigator.pop()`. Wiring CRUD kamu jadi async tidak mengubah ini, pola tetap aman.

> **Alternatif (tanpa reload penuh):** bila mau respons lebih cepat, mutasi `_tasks` langsung (insert/update/delete elemen list) lalu `notifyListeners`, tanpa `loadTasks`. Lebih cepat (1 request, tanpa GET ulang) tapi **rawan inkonsistensi** bila server menolak parsial. Reload penuh = sederhana + aman; pilih sesuai konteks. Untuk Assignment 2, reload penuh sudah memenuhi rubrik.

### 3.3 Uji CRUD end-to-end (mode mock)

```bash
flutter analyze
flutter test # semua hijau
flutter run # mode mock (tanpa --dart-define)
```

Uji manual:
1. FAB -> form -> isi title "Belajar REST" -> Save -> **task muncul** di list (mock `_store` menyimpan).
2. Tap card -> edit title "Belajar REST Lanjut" -> Save -> **data berubah**.
3. Tap centang -> status flip (strikethrough + chip `COMPLETED`).
4. Swipe kiri -> dialog -> Delete -> **task hilang**.

> Catatan: mock in-memory, jadi setelah restart app, perubahan **hilang** (kembali ke fixture awal). Itu bukan bug, persistensi lintas restart adalah domain P04/Assignment 2 (SQLite). Yang diuji P05: **CRUD bekerja dalam sesi** + state UI.

### 3.4 Uji state error + retry manual

Ini gate penting P05, skenario error eksplisit (401/404/500/network).

**Skenario A, NetworkError via `simulateNetworkError` (paling cepat, tanpa internet):**

Sementara, di `main.dart` atau via constructor, aktifkan flag mock untuk demo. Pendekatan paling bersih: tambahkan opsi di provider yang di-inject, atau set langsung di init demo. **Cara termudah untuk demo lab:** modifikasi wiring demo sementara, ```dart
// HANYA UNTUK DEMO, jangan commit. Aktifkan network error di mode mock.
final mockClient = MockTaskApiClient();
mockClient.simulateNetworkError = true; // GET berikutnya melempar NetworkError
final repository = RemoteTaskRepository(RemoteTaskDatasource(mockClient));
```

Lalu `flutter run` -> pull-to-refresh -> muncul `_ErrorView`: ikon `cloud_off` + pesan `"Failed to load tasks: NetworkError:..."` + tombol **Retry**. Tap Retry -> memanggil `loadTasks()` lagi.

**Skenario B, 404/ClientError via operasi CRUD (mock):**
- Toggle/delete task yang id-nya tidak ada di `_store` (mis. tiru race: hapus dua kali cepat) -> `NotFoundError` -> pesan error muncul. Atau create id duplikat -> `ClientError(409)`.

**Skenario C, 500/Server (mock):** mock tidak menyimulasikan 5xx langsung. Untuk demo `ServerError`, gunakan live mode (lihat 3.5) atau cukup jelaskan bahwa `mapResponseToError(503)` -> `ServerError` sudah teruji di `api_error_test.dart`. UI memperlakukan `ServerError` sama (pesan + retry).

**Skenario D, NetworkError nyata (mode live):** bila endpoint tersedia, putuskan internet/perubahan host tidak valid -> `GET /tasks` gagal -> `_send` catch -> `NetworkError` -> `_ErrorView` + Retry.

**Yang harus terlihat di UI saat error:**
- Ikon `cloud_off` + pesan terbaca (mengandung jenis error: Network/Server/Client/NotFound).
- Tombol **Retry** (`AppStrings.actionRetry`) yang memanggil ulang `loadTasks()`.
- Setelah kondisi pulih (matikan `simulateNetworkError` / kembalikan koneksi) -> tap Retry -> list kembali.

> **Mengapa retry manual, bukan auto-retry?** Auto-retry (backoff eksponensial) di luar scope wajib (lihat planning §2: "retry manual"). Retry manual = user memicu ulang via tombol/pull-to-refresh. Ini cukup untuk membuktikan state error + pemulihan, dan lebih sederhana untuk dijelaskan saat demo.

### 3.5 Mode live opsional (bila endpoint tersedia saat pelaksanaan)

```bash
flutter run \
 --dart-define=API_BASE_URL=https://your-server.example.com \
 --dart-define=API_TOKEN=***
```

- Badge berubah **LIVE API** (`ApiConfig.useMock == false` -> `activeModeLabel()` -> `AppStrings.modeLive`).
- `GET /tasks` ke server; bila JSON cocok kontrak (`API-CONTRACT.md` §3) -> list tampil data server.
- Bila status non-2xx -> `mapResponseToError` -> subtype `ApiError` -> `_ErrorView` + Retry.
- Bila bentuk JSON server tidak cocok (mis. `dueDate` camelCase, atau `data` wrapper tak terduga) -> `ParseError` atau field null -> perbaiki kontrak/mapper (ini bahan diskusi, bukan TODO inti).

> **Tidak ada server? Tidak masalah.** Seluruh acceptance P05 tercapai di mode mock. Mode live hanya bukti tambahan bila dosen menyediakan endpoint. Jangan hardcode endpoint ke source, selalu via `--dart-define`.

### 3.6 Troubleshooting khusus P05 (status/state/parse)

Bagian ini wajib dipahami, jebakan paling sering di P05:

**Jebakan 1: CRUD "tidak berubah" padahal tidak error.**
- Gejala: FAB -> save -> list tetap sama; tidak ada exception.
- Penyebab: `addTask`/`updateTask`/`deleteTask` masih TODO (no-op). Wiring ke `_repo.save/remove` belum diisi (lihat 3.2).
- Solusi: implementasi CRUD + `await loadTasks()` + `notifyListeners()`. Verifikasi: set save, cek `provider.tasks` bertambah via debugPrint.
- Tes cepat: setelah implementasi, create task -> `findById(newId)` harus tidak null.

**Jebakan 2: State error tidak muncul walau operasi gagal.**
- Gejala: toggle/hapus gagal diam-diam; UI tetap list biasa.
- Penyebab: `try` ada tapi `catch` lupa `notifyListeners()`, atau `catch` menelan exception tanpa set `_error`.
- Solusi: pastikan tiap `catch` menulis `_error = '...'` lalu `notifyListeners()`. UI list screen beralih ke `_ErrorView` hanya bila `provider.error != null`.
- Tes cepat: aktifkan `simulateNetworkError`, pull-to-refresh -> `_ErrorView` harus muncul.

**Jebakan 3: `is_completed` dikirim sebagai 0/1 ke JSON.**
- Gejala: server menolak (422) atau `isCompleted` selalu false setelah round-trip live.
- Penyebab: kebiasaan P04 (`? 1 : 0`) ikut ke mapper JSON. Kontrak P05: **boolean**.
- Solusi: `toJson` kirim `isCompleted` (bool) langsung; `fromJson` baca `as bool?`. Jangan campur 0/1.
- Tes cepat: `jsonEncode(task.toJson())` -> `"is_completed": false`, bukan `0`.

**Jebakan 4: Nama field camelCase vs snake_case.**
- Gejala: server mengembalikan field null / `NoSuchMethodError` saat parse live.
- Penyebab: mapper pakai `'dueDate'`/`'isCompleted'` (camelCase), padahal kontrak `due_date`/`is_completed`.
- Solusi: cocokkan literal string di `toJson`/`fromJson` dengan `API-CONTRACT.md`. Mock selalu valid karena fixture pakai snake_case, bug ini hanya muncul di live.
- Tes cepat: bandingkan key `toJson()` dengan fixture `task_fixtures.dart`, harus identik.

**Jebakan 5: `FormatException` / `ParseError` saat list response.**
- Gejala: `GET` sukses (200) tapi parsing gagal.
- Penyebab: server membungkus list di `{"data": [...]}` (Bentuk B) dan `HttpTaskApiClient._decodeList` harus menanganinya, sudah ditangani di starter. Bila masih gagal, body bukan JSON valid atau struktur lain.
- Solusi: cek `API-CONTRACT.md` §3.2; `_decodeList` mendukung Bentuk A (array) + Bentuk B (`data`). Bila server pakai wrapper lain (mis. `{"items": [...]}`), tambah cabang di `_decodeList`, tapi itu di luar aturan batas (ubah `HttpTaskApiClient`); koordinasi dengan dosen.
- Tes cepat: `curl <endpoint>/tasks` + lihat struktur respons.

**Jebakan 6: `ClientException` / `SocketException` (live) tapi tidak jadi `NetworkError`.**
- Gejala: app crash saat live request gagal jaringan.
- Penyebab: `HttpTaskApiClient._send` seharusnya catch semua non-`ApiError` -> `NetworkError`. Bila kamu mengubah `_send` (di luar aturan batas) dan merusak catch, ini terjadi.
- Solusi: jangan ubah `_send` (sudah benar). Verifikasi: `try {... } catch (_) { throw const NetworkError(); }` ada dan `on ApiError { rethrow; }` di atasnya.

### Checkpoint Validation

- [ ] `flutter test`, **semua test hijau** (api_error + mock_api_client + widget smoke).
- [ ] `flutter analyze` tetap bersih.
- [ ] FAB -> form -> save -> task **muncul** (mock menyimpan in-memory).
- [ ] Edit -> berubah; delete -> hilang; toggle -> status flip.
- [ ] **State error terbukti:** aktifkan `simulateNetworkError` (atau putus jaringan live) -> pull-to-refresh -> `_ErrorView` (cloud_off + pesan + Retry) muncul.
- [ ] Tap **Retry** -> `loadTasks()` ulang; setelah kondisi pulih -> list kembali.
- [ ] Kamu bisa menjelaskan tiga skenario error (NetworkError, NotFoundError 404, ClientError 409/4xx) dan bagaimana mock merekayasa masing-masing.
- [ ] (Opsional) Mode live: badge **LIVE API**, data dari server; non-2xx -> error state.

**Run & Test:**
```bash
flutter test # All tests passed!
flutter analyze # No issues found!
flutter run # CRUD + simulateNetworkError demo
```

> **Fallback mock path CP3:** seluruh CRUD + semua skenario error (Network via flag, 409 duplikat, 404 hilang, 4xx client) teruji **tanpa server** via `MockTaskApiClient`. Mode live hanya opsional. Tidak ada checkpoint yang butuh endpoint nyata untuk lulus.

---

## Summary

**Yang kamu kerjakan:**
- Memahami hirarki `sealed ApiError` + `mapResponseToError`, memverifikasi pemetaan status -> subtype lewat `api_error_test.dart`.
- Mengonfirmasi `Task.toJson`/`fromJson` cocok `API-CONTRACT.md` (snake_case, `is_completed` boolean, ISO date, enum `.name`/`.byName`).
- Menelusuri jalur fallback offline: `TaskFixtures -> MockTaskApiClient -> RemoteTaskDatasource -> RemoteTaskRepository -> TaskProvider -> TaskListScreen`, diverifikasi `mock_task_api_client_test.dart`.
- Menghubungkan `addTask`/`updateTask`/`deleteTask`/`toggleComplete` ke repository dengan `try/catch` -> state `_error`, sehingga **semua state UI (loading/success/empty/401/404/500/network) terlihat + retry manual**.
- Membuktikan seluruh paket tuntas **tanpa server** (mode mock); endpoint nyata opsional via `--dart-define`.

**Konsep kunci:**
- **Kontrak eksplisit**, `API-CONTRACT.md` sumber kebenaran; klien mengikuti, mapper JSON wajib cocok nama/tipe field.
- **Error terstruktur**, `sealed ApiError` + `switch` exhaustif; dipetakan dari HTTP status, bukan body error.
- **Layer terpisah + swap sumber**, provider tak peduli Mock vs Http; ganti lewat `ApiConfig.useMock`.
- **Fallback mock**, `MockTaskApiClient` menguji seluruh path (sukses + error) tanpa server; `simulateNetworkError` mendemokan state error.
- **State UI lengkap + retry manual**, loading/success/empty/error(401/404/500/network); user memicu ulang via tombol/pull-to-refresh (auto-retry di luar scope).
- **Perbedaan marshaling P04/P05**, `is_completed`: SQLite 0/1 vs JSON boolean; tetap ISO date + enum name.

**Preview sesi berikutnya (P06):**
- Device fitur (image picker/camera + permission handling, fallback gallery).
- Testing QA: unit test (model/mapper/filter) + widget test (form/empty/error/list).
- `flutter test` + `flutter analyze` sebagai gate rilis; fondasi error/mock P05 dipakai untuk test error state UI.
- Assignment 2 ditenggat **sebelum P06**, selesaikan persistence (SQLite dari P04) + API error handling (P05) sebelum lanjut device/testing.

---

## Troubleshooting

**App jalan tapi list kosong / tidak muncul task.**
Default mode mock -> harus tampil 3 fixture. Cek: (1) `ApiConfig.useMock` true (tidak ada `--dart-define`)? (2) Badge AppBar "MOCK API"? (3) `TaskProvider.loadTasks` berjalan (`..loadTasks()` di `main.dart`)? Bila `loadTasks` throw (seharusnya tidak di mock), `_error` terisi -> UI tampil `_ErrorView`, bukan empty. Jalankan `flutter test test/mock_task_api_client_test.dart`, harus hijau.

**Badge "LIVE API" padahal mau mock.**
`--dart-define=API_BASE_URL` masih terpasang dari run sebelumnya, atau ter-hardcode. Hapus define, `flutter run` ulang. `ApiConfig.useMock` = `baseUrl.isEmpty`. Jangan hardcode `baseUrl` di source.

**`ClientException: Failed to parse` saat live.**
Body JSON server tidak cocok kontrak. Periksa `API-CONTRACT.md` vs respons nyata: nama field (snake_case), bentuk list (array vs `data` wrapper), tipe `is_completed` (boolean). `HttpTaskApiClient._decodeList` mendukung Bentuk A + B; bila wrapper lain, koordinasi dosen (di luar aturan batas).

**CRUD tidak mengubah list walau tidak error.**
`addTask`/`updateTask`/`deleteTask` masih TODO (no-op). Implementasi wiring ke `_repo.save/remove` + `await loadTasks()` + `notifyListeners()` (CP3 §3.2).

**State error tidak muncul walau operasi gagal.**
`catch` lupa `notifyListeners()`, atau exception ditelan tanpa set `_error`. Pastikan tiap `catch` menulis `_error` + notify. Aktifkan `simulateNetworkError`, pull-to-refresh -> `_ErrorView` harus muncul.

**`FormatException` / `ParseError` saat parsing.**
Body bukan JSON valid, atau struktur tak dikenal. Mock selalu valid (fixture Bentuk A). Live: `curl` endpoint, cocokkan dengan `API-CONTRACT.md`. Untuk wrapper `data` sudah ditangani `_decodeList`.

**`is_completed` selalu false setelah round-trip live.**
Mapper kirim `0`/`1` (kebiasaan P04) bukan boolean. Kontrak P05: boolean. `toJson` kirim `isCompleted` langsung.

**Test `widget_test` gagal timeout.**
Mock ada delay 150ms; pakai `pumpAndSettle()` (starter sudah benar). Jangan hapus delay, itu yang membuat loading state terlihat di demo.

**`A ValueNotifier/ChangeNotifier used after dispose` / `Looking up deactivated widget`.**
Pola dari P03/P04: simpan provider sebelum `await`, cek `mounted` setelahnya. `task_form_screen._submit` sudah benar. Bila kamu menambah async di provider tanpa guard, error muncul saat user cepat menutup form sebelum request selesai (latensi jaringan memperbesar risiko vs P04).

**Mode live: 401 Unauthorized padahal token sudah dikirim.**
Header `Authorization: Bearer <token>` hanya dikirim bila `_token` tak kosong (`HttpTaskApiClient._headers`). Cek: `--dart-define=API_TOKEN` terisi? Token kedaluwarsa? Di luar scope wajib (tidak ada token refresh, lihat planning §2); lapor dosen.

**Mock data hilang setelah restart.**
Bukan bug. Mock in-memory (`_store` Map); persistensi lintas restart domain P04/Assignment 2 (SQLite). Yang diuji P05: CRUD bekerja **dalam sesi** + state UI.

---

## Self-Assessment (sebelum & sesudah)

**Skor kepercayaan 1-5, sebelum & sesudah P05:**
- Membaca kontrak REST (method/status/JSON shape): -> 
- Error terstruktur (`sealed ApiError` + `switch` exhaustif): -> 
- Marshaling JSON (`toJson`/`fromJson`, snake_case, boolean vs int): -> 
- Remote datasource/repo/provider wiring (GET + CRUD async): -> 
- State UI lengkap + retry manual (loading/success/empty/401/404/500/network): -> 
- Fallback mock/fixture + `simulateNetworkError`: -> 

**Verifikasi praktik:**
- Tambah satu test di `mock_task_api_client_test.dart`: create lalu update task, verifikasi field berubah di `listTasks` berikutnya. Hijau.
- Jelaskan dengan kata sendiri **kenapa** error dipetakan dari HTTP status, bukan dari body error, dan kapan `ParseError` (bukan `ServerError`) muncul.
- Lakukan demo state error di depan teman/dosen: aktifkan `simulateNetworkError` -> `_ErrorView` + Retry -> matikan flag -> tap Retry -> list kembali. Jelaskan **alur exception** dari `MockTaskApiClient._maybeThrowNetwork` -> provider `catch` -> `_error` -> UI.

---

## Challenge Bertingkat (kerja sendiri, siapkan bukti)

Pilih satu level. Semua boleh pakai AI untuk **penjelasan/debugging**, bukan menulis core mapper/error-mapping/provider wiring tanpa analisis.

**Level 1 (Basic):** Tambah unit test di `mock_task_api_client_test.dart`: `deleteTask` id yang tidak ada -> `throwsA(isA<NotFoundError>())`. Kriteria: test lulus, `analyze` bersih. Membuktikan 404 path mock.

**Level 2 (Medium):** Perkaya pesan error UI berdasarkan subtype `ApiError`. Di provider, ganti teks generik dengan `switch` atas `ApiError`: `NetworkError` -> "Tidak ada koneksi. Cek internet lalu coba lagi." / `ServerError` -> "Server sibuk, coba lagi nanti." / `ClientError(401)` -> "Sesi habis (401)." / `NotFoundError` -> "Task tidak ditemukan." / `ParseError` -> "Data server rusak." Tampilkan pesan ini di `_ErrorView`. Kriteria: tiap subtype menampilkan teks berbeda; `analyze` bersih; tidak mengubah hirarki `ApiError`. Relevan untuk UX Assignment 2.

**Level 3 (Advanced):** Tambah policy retry sederhana di provider: bila `loadTasks` gagal dengan `NetworkError`/`ServerError`, simpan juga timestamp error; di UI, tampilkan "Terakhir gagal: HH:MM" + tombol Retry. (Bukan auto-backoff, itu di luar scope.) Atau: dukung bentuk list wrapper `{"items": [...]}` di `HttpTaskApiClient._decodeList` (koordinasi dosen, dokumentasikan asumsi). Kriteria: demo state + metadata; jelaskan trade-off retry manual vs auto.

**Submit:** screenshot + paste kode + 2-3 kalimat penjelasan pendekatan.

> Challenge Level 2 langsung relevan untuk **Assignment 2** (UX error state yang ramah pengguna). Level 3 melatih mindset robustness untuk proyek nyata.

---

## AI-Enhanced Learning (P05)

**Penggunaan AI produktif di P05:**
- "Kenapa `sealed` lebih aman dari `if-else` string untuk error handling?" (konsep exhaustiveness)
- "Jelaskan perbedaan marshaling `is_completed` di SQLite (0/1) vs JSON (boolean)."
- "Kapan `ParseError` muncul, dan bedanya dengan `ServerError`?" (status vs body rusak)
- "Bagaimana cara mendemokan state network error tanpa mematikan internet?" (`simulateNetworkError`)
- "Bandingkan retry manual vs auto-retry backoff, pro/kontra di mobile." (di luar scope, tapi konsep)
- "Kenapa error dipetakan dari HTTP status, bukan dari body error?" (konsistensi lintas server)

**Hindari:**
- "Tulis `toJson`/`fromJson` untuk skema ini." (core mapper, analisis sendiri; wajib pahami + cocok kontrak)
- "Implementasikan `addTask`/`toggleComplete` provider saya." (core wiring, analisis sendiri)
- "Buatkan pemetaan status HTTP ke error type." (core error mapping, analisis sendiri; sudah ada kontrak)

**Wajib bila memakai AI:** isi `../01-Orientasi/Template-AI-Interaction-Log.md`, tujuan, prompt, ringkasan respons, perubahan dipilih/ditolak, dan **verifikasi pemahaman** (jelaskan ulang dengan kata sendiri + bukti `flutter test` hijau + demo state error). Saat demo, dosen bisa tanya "kenapa `is_completed` boolean di JSON tapi 0/1 di SQLite?" / "subtype mana yang muncul saat timeout?", kamu harus bisa jawab.

---

## Resources

- **Resmi:** [pub.dev/packages/http](https://pub.dev/packages/http), [dart.dev/guides/language/language-tour#sealed](https://dart.dev/language/class-modifiers#sealed) (sealed class), [dart.dev/libraries/dart-convert](https://dart.dev/libraries/dart-convert) (`jsonEncode`/`jsonDecode`), [developer.mozilla.org/en-US/docs/Web/HTTP/Status](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status) (kode status).
- **Dalam paket:** `../06-Starter-Code/API-CONTRACT.md` (kontrak data), `../06-Starter-Code/.env.example` (placeholder config), `../02-Materi/P04-SQLite-Offline-First.md` (fondasi repository/abstraksi), `../01-Orientasi/Panduan-Mahasiswa.md`, `../05-Assessment/Lembar-Observasi.md`.
- **Konsep dasar:** `../../Tutorial/outline-p09-14-advanced-features.md` Pertemuan 10 (REST API Integration, dipersempit ke error type + mock fallback; **tanpa** Supabase/JWT refresh/sync queue yang dikecualikan di planning §2).
- **Starter:** `../06-Starter-Code/p05-api/` (README + struktur di atas).

**Persiapan P06:** baca ulang state UI error di `task_list_screen.dart` (`_ErrorView` + `RefreshIndicator`), P06 akan menambah **widget test** untuk state error/empty/list. Fondasi mock P05 dipakai: test tidak butuh server. Mulai pikirkan **Assignment 2** (persistence SQLite P04 + API error P05) yang ditenggat sebelum P06.

---

**Estimasi belajar mandiri:** 5-7 jam | **Kesulitan:** menengah-tinggi | **Updated:** 2026-08-08
