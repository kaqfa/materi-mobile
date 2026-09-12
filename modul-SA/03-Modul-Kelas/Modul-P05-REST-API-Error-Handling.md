# Modul Kelas P05, REST API dan Error Handling

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker
**Durasi:** 150 menit (3 × 50) | **Rasio praktik minimal:** 65%
**Pasangan:** `../02-Materi/P05-REST-API-Error-Handling.md` (materi)
**Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`, `../00-Planning/Runbook-Dosen.md`, `../05-Assessment/Lembar-Observasi.md`, `../06-Starter-Code/API-CONTRACT.md`

> **Untuk dosen/asisten.** Modul ini panduan menjalankan kelas, bukan handout mahasiswa. `solution-reference/` **jangan dibagikan** sebelum sesi selesai. **Assignment 2 dibuka hari ini (P05)** dan ditenggat **sebelum P06**, blok 1 membuka/brief, blok praktik mulai dikerjakan, blok 6 mengunci tenggat + alokasi kerja/submit. **Endpoint nyata belum ditetapkan** saat produksi; seluruh kelas tuntas di mode mock/fixture. Mode live hanya demonstrasi opsional bila dosen menyediakan endpoint.

---

## BAGIAN 1: Overview

### Tujuan Hari Ini

Mahasiswa mampu:
1. Membaca kontrak REST (`API-CONTRACT.md`) dan memetakan HTTP status + kondisi jaringan ke `sealed ApiError` (`NetworkError`/`ServerError`/`ClientError`/`NotFoundError`/`ParseError`) lewat `mapResponseToError`; menjelaskan **kenapa** `sealed` + `switch` exhaustif lebih aman dari `if-else` string.
2. Menelusuri jalur fallback offline `TaskFixtures -> MockTaskApiClient -> RemoteTaskDatasource -> RemoteTaskRepository -> TaskProvider -> UI`, memverifikasi `Task.toJson`/`fromJson` cocok kontrak (snake_case, `is_completed` boolean).
3. Menghubungkan `addTask`/`updateTask`/`deleteTask`/`toggleComplete` ke repository dengan `try/catch`, sehingga **semua state UI (loading/success/empty/401/404/500/network) terlihat + retry manual**.
4. Membuktikan seluruh capaian **tanpa server** (mode mock); endpoint nyata opsional via `--dart-define`.

### Rundown Kelas (150 menit)

```
00-10 Retrieval quiz P04 (repository/SQLite) + BUKA/BRIEF Assignment 2 (10 menit)
10-30 Konsep REST + error terstruktur (sealed) + live demo (20 menit)
30-85 Guided lab: CP1 (error/mapper) + CP2 (mock path) + CP3 (provider CRUD) (55 menit)
85-125 Praktik individual + observasi dosen (selesaikan state error + mulai Assignment 2) (40 menit)
125-140 Demo state error + challenge reveal + detail Assignment 2 (15 menit)
140-150 Exit ticket + PR + KIRIM/kerja Assignment 2 (tenggat sebelum P06) (10 menit)
```

> Alokasi mengikuti format tetap (`Runbook-Dosen.md` bagian 3). **Dua sisipan khusus P05:** (1) blok 1 **membuka Assignment 2** ( Persistence + API), bukan kumpul (tenggat sebelum P06); (2) blok 6 mengunci alokasi kerja/submit. Bila banyak mahasiswa belum solid P04 (abstraksi `TaskRepository`/async), **tahan** mereka review P04 dulu, P05 memakai abstraksi yang sama dengan sumber remote. Jangan kurangi blok observasi (40').

### Yang Harus Sudah Ready (sebelum kelas)

- [ ] Starter `06-Starter-Code/p05-api/` lolos `pub get`/`analyze`; `api_error_test.dart` + `mock_task_api_client_test.dart` + `widget_test.dart` **semua hijau** (baseline; TODO terkonfirmasi hanya di `TaskProvider` CRUD).
- [ ] `flutter doctor` bersih; versi kelas dipin; dependency `http ^1.2.2`, `provider ^6.1.2` terkunci. Target demo **Android atau web** (http jalan di keduanya; berbeda P04 yang butuh native SQLite).
- [ ] **Kontrak data:** `06-Starter-Code/API-CONTRACT.md` sudah dibaca dosen; bentuk JSON, status, konfigurasi `--dart-define` dipahami. `.env.example` hanya placeholder (tidak diisi rahasia).
- [ ] Assignment 2: `04-Penugasan/Assignment-02-Serialization-dan-API.md` + `Rubrik-Assignment-02.md` siap untuk **dibuka** di blok 1. (Bila belum ada artefaknya, gunakan spesifikasi di `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md` §6 sebagai brief.)
- [ ] `Lembar-Observasi.md` (satu per mahasiswa) siap diisi.
- [ ] Mahasiswa pita merah di P04 (async/repository) sudah dipasangkan anchor hijau; siap dengan **demo state error** (perangkat/emulator, atau cukup mode mock + `simulateNetworkError`).
- [ ] `solution-reference/` di kanal privat, tidak terlihat mahasiswa.
- [ ] (Opsional) Endpoint live + token untuk demo `--dart-define`; bila tidak ada, **mode mock sudah cukup** untuk seluruh capaian P05.

---

## BAGIAN 2: Live Coding (Konsep + Demo)

### Demo 1: Kontrak REST + error terstruktur (10 menit)

_Ikuti dosen, jangan maju sendiri._

Tampilkan `API-CONTRACT.md` + `api_error.dart`. Tunjukkan:

1. `API-CONTRACT.md` §2 (endpoint `GET/POST/PATCH/DELETE`) + §3 (bentuk objek `task`: `due_date` snake_case, `is_completed` **boolean**) + §4 (status -> subtype).
2. `api_error.dart` -> `sealed class ApiError` + 5 subtype + `mapResponseToError`.
3. `flutter test test/api_error_test.dart` -> semua hijau; tunjukkan test "sealed switch exhaustif".

**Penting:**
- **Kontrak = sumber kebenaran antara klien dan server.** Klien mengikuti; mapper JSON wajib cocok nama/tipe field. Server ubah field -> mapper pecah.
- **Error dipetakan dari HTTP status, bukan body error.** Body tak konsisten lintas server; status (int) andal. `mapResponseToError(503)` -> `ServerError`; `404` -> `NotFoundError`; `401/403/422` -> `ClientError`.
- **`sealed` = exhaustiveness.** `switch` atas `ApiError` wajib tangani semua subtype atau compiler menolak. Lebih aman dari `if (msg.contains('timeout'))`.
- **Network/Parse tak punya status.** `NetworkError` lahir sebelum response (timeout/socket/DNS); `ParseError` setelah body rusak. Keduanya dari `catch` di klien, bukan dari `mapResponseToError`.

**Test live (diskusi):**
- "Kalau server kirim `{error: 'gone'}` dengan status 410, subtype apa yang muncul?" (jawaban: `ClientError(410)`, dari status, abaikan body).
- "Kenapa `is_completed` boolean di JSON tapi 0/1 di SQLite?" (jawaban: JSON punya boolean native; SQLite tak punya BOOLEAN, konvensi 0/1).

### Demo 2: Mock path + pola provider persisten (10 menit)

Tampilkan `main.dart` (pemilihan client) + `mock_task_api_client.dart` (fixture fallback) + `task_provider.dart` (TODO). Tunjukkan pola, **bukan** implementasi CRUD penuh:

```dart
// main.dart: pilih sumber via ApiConfig.useMock (tanpa --dart-define => mock)
final client = ApiConfig.useMock
 ? MockTaskApiClient()
 : HttpTaskApiClient(baseUrl: ApiConfig.baseUrl, token: ApiConfig.apiToken);

// MockTaskApiClient: fixture in-memory + saklar demo error
bool simulateNetworkError = false; // set true => NetworkError di tiap method

// TaskProvider: pola CRUD dengan error state (TODO inti)
Future<void> addTask(Task task) async {
 try {
 await _repo.save(task); // POST (mock: simpan _store)
 await loadTasks(); // reload => list segar + state konsisten
 } catch (e) {
 _error = 'Failed to add task: $e';
 notifyListeners(); // UI beralih ke _ErrorView bila ada error
 }
}
```

**Penting:**
- **CRUD kini async + bisa gagal (jaringan).** Pola anti context misuse dari P03/P04 tetap berlaku: simpan provider sebelum `await`, cek `mounted` setelahnya. Latensi jaringan > SQLite -> risiko context misuse lebih besar.
- **Tiga state UI eksplisit:** `isLoading` (spinner), `error != null` (`_ErrorView` + Retry), `tasks.isEmpty` (empty). List screen sudah `switch` atas tiga ini; tinggal isi CRUD.
- **Mock tidak persisten lintas restart**, itu domain P04/Assignment 2. Yang diuji P05: CRUD bekerja **dalam sesi** + state UI.
- **`simulateNetworkError` = demo error tanpa internet.** Krusial untuk membuktikan state error di kelas tanpa ketergantungan koneksi.

**Common errors (antisipasi):**
```
'CRUD tidak mengubah list' -> provider CRUD masih TODO (no-op).
'State error tidak muncul walau gagal' -> catch lupa notifyListeners / _error tak diisi.
'is_completed selalu false setelah round-trip' -> mapper kirim 0/1 (P04), padahal JSON boolean.
'ParseError saat list' -> bentuk JSON server tak cocok kontrak/wrapper.
'Badge LIVE padahal mau mock' -> API_BASE_URL ter-define; hapus --dart-define.
```

> **Jangan** tunjukkan implementasi `addTask`/`updateTask`/`deleteTask`/`toggleComplete` lengkap di demo. Beri pola (snippet di atas); biarkan mahasiswa menerjemahkan ke starter P05.

---

## BAGIAN 3: Guided Lab, 3 Checkpoint (55 menit)

Ikuti materi `../02-Materi/P05-REST-API-Error-Handling.md`. Tiap checkpoint harus jalan sebelum lanjut (no broken state).

### CHECKPOINT 1: Error Type + Kontrak Serialisasi (≈10' di kelas)
- Mahasiswa baca `api_error.dart` + `task.dart` (toJson/fromJson); jalankan `flutter test test/api_error_test.dart` -> hijau.
- Bandingkan `toJson`/`fromJson` dengan `API-CONTRACT.md` §3 (nama field snake_case, `is_completed` boolean, ISO date, enum `.name`/`.byName`).
- **Gate dosen:** pemetaan status -> subtype dipahami; mahasiswa bisa jelaskan **kenapa** `sealed` lebih aman dari `if-else` string + **kenapa** error dari status bukan body. Bila ragu, tunda CP2.

### CHECKPOINT 2: Mock/Fixture Fallback (≈10' di kelas)
- Mahasiswa telusuri `api_config.dart` -> `main.dart` -> `MockTaskApiClient` -> `TaskFixtures`; jalankan `flutter test test/mock_task_api_client_test.dart` -> hijau.
- `flutter run` (tanpa `--dart-define`) -> list 3 fixture + badge **MOCK API**.
- **Gate dosen:** jalur fallback offline dipahami; mahasiswa bisa jelaskan kapan `useMock` true/false + **kenapa** mock tidak persisten (bukan bug). Demonstrasi flag `simulateNetworkError` (siap untuk CP3).

### CHECKPOINT 3: Provider CRUD + State UI Lengkap (≈35' di kelas, inti implementasi)
- Mahasiswa isi `addTask`/`updateTask`/`deleteTask`/`toggleComplete` di `task_provider.dart`: `_repo.save/remove` -> `try/catch` isi `_error` -> `await loadTasks()` + `notifyListeners()`. Ini **TODO utama** P05.
- Uji CRUD end-to-end (mock): FAB -> save -> muncul; edit -> berubah; swipe -> hilang; toggle -> flip.
- Uji **state error + retry**: aktifkan `simulateNetworkError` (atau putus jaringan live) -> pull-to-refresh -> `_ErrorView` (cloud_off + pesan + Retry) -> tap Retry -> list kembali.
- **Gate dosen:** CRUD mengubah list **dan** state error mock terbukti (404 via id hilang, 409 via duplikat, network via flag). Pemetaan 401/500 dibuktikan lewat `api_error_test.dart` atau endpoint live opsional. Ini gate utama P05, tahan mahasiswa sampai retry manual terlihat. Cek enam jebakan: CRUD no-op, error tak notify, `is_completed` 0/1 vs boolean, camelCase vs snake_case, `ParseError` wrapper, `_send` NetworkError.

> Bila ada mahasiswa buntu > 10 menit di CP3, beri pertanyaan pengarah (bukan jawaban): "Setelah save, apa yang kamu lupa muat ulang?" / "Catch-mu ada `notifyListeners`?" / "`is_completed` di JSON boolean atau int, cek kontrak?" Catat bantuan di `Lembar-Observasi.md`.

---

## BAGIAN 4: Praktik Individual + Observasi (40 menit)

**Tujuan:** mengukur kemampuan individu mengimplementasikan CRUD + state error, **tanpa AI untuk core mapper/error-mapping/provider wiring**. Sekaligus **mulai mengerjakan Assignment 2**.

### Praktik Mandiri (30')

Kerjakan di luar checkpoint wajib: perkaya **state error UI** dan **mulai Assignment 2**.

**Task:**
1. Perkaya pesan error berdasarkan subtype `ApiError`: `switch` di provider, `NetworkError` -> "Tidak ada koneksi…", `ServerError` -> "Server sibuk…", `ClientError(401)` -> "Sesi habis…", `NotFoundError` -> "Task tidak ditemukan.", `ParseError` -> "Data server rusak." Tampilkan di `_ErrorView`. **Tanpa mengubah hirarki `ApiError`.**
2. Tambah unit test di `mock_task_api_client_test.dart`: `deleteTask` id hilang -> `throwsA(isA<NotFoundError>())`; create lalu update -> field berubah di `listTasks`.
3. Pastikan `flutter analyze` + `flutter test` tetap hijau. Lakukan **demo state error** sendiri: flag on -> error -> flag off -> Retry -> pulih.
4. **Mulai Assignment 2:** baca `04-Penugasan/Assignment-02-Serialization-dan-API.md` + `Rubrik-Assignment-02.md`; rencanakan API error (P05) dan **putuskan jalur lokal: A (in-memory) atau B (SQLite, opsional/bonus)**. Catat satu blocker untuk diskusi.

**Checklist progres:**
- [ ] Pesan error berbeda per subtype; `analyze` bersih.
- [ ] 2 test baru lulus (404 path + update field).
- [ ] Demo state error terbukti (screenshot before/after Retry).
- [ ] `is_completed` boolean di JSON (bukan 0/1); field snake_case.
- [ ] Assignment 2 dibaca; rencana integrasi + satu blocker tercatat.

**Expected output (uji manual):**
```
simulateNetworkError=true -> pull refresh -> _ErrorView "Tidak ada koneksi…"
simulateNetworkError=false -> tap Retry -> list fixture kembali.
delete id hilang -> NotFoundError -> pesan "Task tidak ditemukan."
create id duplikat -> ClientError(409) -> pesan sesuai.
```

**Bantuan:**
- Subtype switch: gunakan `switch (e) { case NetworkError():...; case ServerError():...;... }` (exhaustif). Tidak boleh ubah `api_error.dart`.
- `deleteTask` id hilang: mock melempar `NotFoundError` bila `!_store.containsKey(id)`. Test: `await expectLater(client.deleteTask('missing'), throwsA(isA<NotFoundError>()));`.
- Assignment 2: fokus mapper SQLite (P04) + JSON (P05), perhatikan `is_completed` 0/1 (SQLite) vs boolean (JSON); jangan tertukar.

### Challenge Individual (10')

Pilih satu level, kerjakan sendiri, siapkan bukti. Dinilai via `Lembar-Observasi.md`.

**Level 1 (Basic):** Unit test `deleteTask` id hilang -> `NotFoundError`. Membuktikan 404 path mock.

**Level 2 (Medium):** Pesan error UX per subtype (lihat Task 1) + satu test verifikasi. Relevan untuk **Assignment 2** (UX error state).

**Level 3 (Advanced):** Tambah metadata retry, timestamp error terakhir di provider, tampilkan "Terakhir gagal: HH:MM" di `_ErrorView`. Atau dukung wrapper `{"items":[...]}` di `_decodeList` (koordinasi dosen). Jelaskan trade-off retry manual vs auto.

**Submit:** screenshot + paste kode + 2-3 kalimat penjelasan.

> Challenge Level 2/3 langsung relevan untuk **Assignment 2** (UX error + robustness). Mahasiswa yang selesaikan = semakin siap submit sebelum P06.

---

## BAGIAN 5: Demo State Error + Challenge Reveal + Detail Assignment 2 (15 menit)

**Pada menit 125, hentikan praktik individual.** Jalankan demo gabungan:

1. **Pilih 1-2 mahasiswa** (rotasi, catat di observasi) untuk **demo state error di depan kelas** (mode mock):
 - Aktifkan `simulateNetworkError` -> pull-to-refresh -> `_ErrorView` (cloud_off + pesan + Retry).
 - Matikan flag -> tap **Retry** -> list fixture kembali.
 - Jelaskan **alur exception**: `MockTaskApiClient._maybeThrowNetwork` -> provider `catch` -> `_error` -> UI `_ErrorView` -> Retry memanggil `loadTasks()`.
 - (Bonus) Tunjukkan 404: hapus id hilang -> `NotFoundError` -> pesan.
2. **Reveal challenge:** siapa yang selesaikan Level 2/3 tunjukkan singkat (1-2 menit). Catat di observasi untuk pita Hijau.
3. **Detail Assignment 2 (bukan kumpul, dibuka hari ini):**
 - Spesifikasi wajib: CRUD lokal konsisten (jalur A in-memory **atau** jalur B SQLite, **SQLite opsional/bonus**) + serialization JSON eksplisit + REST GET + min satu POST/PATCH memakai endpoint/mock + state loading/success/empty/4xx/5xx/network + mode offline operasi lokal.
 - Bukti: source, **Narasi Pemanfaatan AI 800-1200 kata** (alur data + alur exception), screenshot (list, loading, empty, error+retry, 4xx, indikator offline), API contract/endpoint config **tanpa secret**, README. Lingkup berhenti di testing.
 - **Tenggat: sebelum P06.** Alokasi kerja: mulai hari ini (mapper + integrasi), lanjut mandiri, submit sebelum sesi P06.
 - Default: gunakan mock/fixture bila endpoint belum tersedia (acceptance tetap teruji).

> **Bila waktu mepet:** pangkas demo ke 1 mahasiswa; challenge reveal cukup yang Level 2; detail Assignment 2 diringkas ke handout + rubrik. **Jangan** pangkas exit ticket (blok 6), feedback loop + kunci tenggat Assignment 2 wajib.

---

## BAGIAN 6: Take-Home / PR + Exit Ticket + Assignment 2 (10 menit terakhir)

**PR + Assignment 2 (menuju P06):**
1. **Selesaikan CP3** bila state error/retry belum terbukti (CRUD no-op atau error tak muncul = belum lulus P05).
2. `flutter analyze` + `flutter test` semua hijau; kumpulkan diff + screenshot demo state error (network + 404 + retry).
3. **Kerja Assignment 2:** integrasikan sumber lokal dengan API error (P05). **SQLite opsional:** bila memilih jalur B, pakai mapper ganda (`toRow`/`fromRow` SQLite + `toJson`/`fromJson` API) dan hati-hati `is_completed` 0/1 vs boolean; bila jalur A, cukup `toJson`/`fromJson`. Buka `Assignment-02-Serialization-dan-API.md` + `Rubrik-Assignment-02.md`.
4. **Submit Assignment 2 sebelum P06** (source + screenshot restart + error sim + config tanpa secret + README). Default mock/fixture bila tanpa endpoint.
5. Catat **satu konsep REST/error yang belum jelas** untuk retrieval P06.

**Persiapan P06:**
- Device: image picker/camera + permission + fallback gallery.
- Testing QA: unit test (model/mapper/filter) + widget test (form/empty/error/list). Fondasi mock P05 dipakai, test tanpa server.
- `flutter test` + `flutter analyze` sebagai gate rilis.

**Exit ticket:** satu konsep belum jelas + satu hal sudah jelas + screenshot demo state error + pernyataan pemakaian AI (lampirkan log bila ya) + **komitmen tenggat Assignment 2**.

Dosen mengisi pita praktik di `Lembar-Observasi.md` (Merah/Kuning/Hijau) + satu rekomendasi per mahasiswa. Mahasiswa yang state error belum terbukti wajib selesai sebelum submit Assignment 2 (action dosen).

---

## BAGIAN 7: References

- Materi: `../02-Materi/P05-REST-API-Error-Handling.md`.
- Kontrak data: `../06-Starter-Code/API-CONTRACT.md`, `../06-Starter-Code/.env.example`.
- Diagnosis: `../01-Orientasi/Tes-Diagnostik-Konsep.md`, `../05-Assessment/Lembar-Observasi.md`.
- Tugas: `../04-Penugasan/Assignment-02-Serialization-dan-API.md`, `../04-Penugasan/Rubrik-Assignment-02.md` (dibuka hari ini; tenggat sebelum P06).
- Starter: `../06-Starter-Code/p05-api/` (+ `solution-reference/`, dosen).
- Standar: `../../Standar Tutorial Koding PPB.md`, `../../Standar Pengembangan Materi PPB.md`.
- Konsep dasar: `../../Tutorial/outline-p09-14-advanced-features.md` Pertemuan 10 (REST, dipersempit; **tanpa** Supabase/JWT/sync queue yang dikecualikan di planning §2).

---

## Catatan Dosen (Notes)

- **Assignment 2 dibuka hari ini (bukan kumpul).** Blok 1 brief, blok praktik mulai dikerjakan, blok 6 kunci tenggat **sebelum P06**. Ini memenuhi alokasi "waktu mengerjakan/submit Assignment 2". Spesifikasi wajib lihat `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md` §6 bila artefak `Assignment-02-*` belum lengkap. **Default mock/fixture** bila endpoint belum tersedia, acceptance tetap teruji.
- **Endpoint belum ditetapkan = bukan hambatan.** Seluruh capaian P05 tercapai di mode mock. Mode live hanya demo opsional bila dosen menyediakan endpoint + token via `--dart-define`. **Jangan** suruh mahasiswa hardcode host/token. Tidak ada secret/akun/URL produksi di materi.
- **Penegakan AI (P4-P5):** AI boleh debugging/review error jaringan/data layer, **tidak** menulis core `toJson`/`fromJson`/error-mapping/provider wiring tanpa analisis. Tolak tempelan AI tanpa penjelasan; minta kerja ulang + jelaskan tiap baris (terutama alur exception + subtype). Catat di `Lembar-Observasi.md` D7. Saat demo, tanya "subtype mana yang muncul saat timeout?" / "kenapa `is_completed` boolean di JSON?"
- **Broken state = jangan lanjut.** CP1 (error mapping) belum dipahami = belum boleh CP2. CP3 CRUD no-op atau state error tak muncul = belum lulus P05. Mahasiswa broken wajib selesai sebelum Assignment 2.
- **Enam jebakan utama, tekankan:**
 1. **CRUD no-op** (provider TODO belum diisi -> list diam).
 2. **Error tak notify** (catch lupa `notifyListeners`/`_error`).
 3. **`is_completed` 0/1 vs boolean** (silang P04/P05; JSON wajib boolean).
 4. **camelCase vs snake_case** (kontrak `due_date`/`is_completed`; typo = 422/null live).
 5. **`ParseError` wrapper** (server `data`/`items`; `_decodeList` mendukung Bentuk A+B).
 6. **`_send` NetworkError** (timeout/socket -> `NetworkError`; jangan ubah `_send`).
- **State error = gate utama.** "CRUD mengubah list" saja belum cukup, buktikan **retry manual**: error (network/404/409) -> `_ErrorView` -> Retry -> pulih. `simulateNetworkError` = cara tercepat demo tanpa internet.
- **Async + context misuse.** Latensi jaringan > SQLite; pola "simpan provider sebelum `await` + `mounted` guard" kritis. `task_form_screen._submit` sudah benar; waspadai mahasiswa yang tambah async tanpa guard.
- **Target platform.** Demo di Android atau web (http jalan di keduanya). Beda P04 (native SQLite, bukan web). Test headless tidak butuh ffi (beda P04).
- **Kontrak = bahan ujian.** Mahasiswa wajib baca `API-CONTRACT.md`. Saat demo, tanya "field `due_date` camelCase atau snake_case?", wajib bisa jawab. Ini dipakai juga di Assignment 2.
- **Anchor pairing.** Mahasiswa pita merah di async/repository dari P04 dipasangkan anchor hijau; P05 memperberat beban async (jaringan tak terduga). Yang masih merah setelah P05, tunda eksplorasi challenge Level 2/3 sampai fondasi aman.
- **Jangan bagikan solution-reference.** Peta pita + rekomendasi saja yang dikembalikan.
- **Pacing.** Observasi 40' tidak boleh dipangkas. Bila mepet, pangkas challenge Level 3 / demo ke 1 mahasiswa, bukan observasi maupun exit ticket. Brief + kunci tenggat Assignment 2 wajib tersampaikan.
- **Versi toolchain.** Catat versi kelas; starter memakai `sdk: ^3.4.0`, `flutter: ">=3.22.0"`, `http: ^1.2.2`, `provider: ^6.1.2`. Sesuaikan bila berubah.

---

**Kepatuhan produksi:**
- Rundown 150 menit, rasio praktik ≥ 65%, **Assignment 2 dibuka + dialokasikan kerja/submit** (blok 1 brief, praktik mulai, blok 6 kunci tenggat sebelum P06).
- 3 checkpoint + validasi testable + troubleshooting (enam jebakan: no-op, notify, boolean, snake_case, parse wrapper, network).
- Live demo (kontrak REST + error sealed + mock path), praktik mandiri (subtype UX + test + mulai Assignment 2), challenge 3 level, demo state error, exit ticket.
- **Seluruh checkpoint punya fallback mock path** (api_error test, mock_api_client test, `simulateNetworkError`), tuntas tanpa server.
- **Tidak ada secret/akun/URL produksi** (placeholder `your-server.example.com` saja).
- Notes dosen + penegakan AI (P4-P5: debugging boleh, core logic analisis sendiri) + rujuk rubrik/observasi/tugas/kontrak.
- Semua path merujuk starter P05 (`06-Starter-Code/p05-api/`), materi `02-Materi/P05-REST-API-Error-Handling.md`, kontrak `06-Starter-Code/API-CONTRACT.md`, dan Assignment 2 (`04-Penugasan/`).

**Updated:** 2026-08-08
