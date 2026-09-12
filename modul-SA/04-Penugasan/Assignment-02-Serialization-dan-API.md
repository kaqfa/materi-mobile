# Assignment 2, Serialization dan API

## 1. Tujuan tugas

Membuktikan secara individu bahwa kamu menguasai **arsitektur data dan ketahanan terhadap kegagalan**: serialization eksplisit (JSON, dan mapper baris bila memakai SQLite), integrasi REST, serta error/network state yang terlihat. Tugas ini **membangun di atas Assignment 1** dan menggabungkan fondasi P04 (persistensi, opsional) dengan P05 (REST + error handling).

Assignment 2 adalah area utama bukti **Sub-CPMK 53.2 (serialization/REST)** plus indikator pendukung 53.1 (serialization) dan 92.1 (error/empty state UI). Nilai aplikasi saja tidak cukup; kamu wajib menjelaskan alur data layer lewat **narasi tertulis**.

> **Assignment ini dinilai sepenuhnya dari artefak yang kamu kumpulkan** (source + narasi + screenshot + README). Tidak ada sesi presentasi atau demo.

Assignment 2 dirancang agar **dapat dinilai penuh tanpa server pribadi atau akun berbayar**: seluruh perilaku REST dapat ditunjukkan lewat **mock/fixture fallback** bawaan starter P05 (`MockTaskApiClient`). Endpoint dosen hanyalah jalur tambahan, bukan syarat.

> **SQLite opsional.** Persistence lokal diajarkan di P04 dan boleh kamu pakai, tapi **bukan syarat kelulusan tugas ini**. Yang menjadi inti Assignment 2 adalah **serialization + REST + error/network state**. Detail jalur di §3.1.

---

## 2. Starting point

Titik mulai wajib: hasil kerja **Assignment 1** (starter `p03-provider-crud` yang sudah kamu kembangkan) **ditambah** starter data layer:

- `../06-Starter-Code/p04-sqlite/` **(opsional)**, skema `tasks`, `TaskDatabase`, `TaskMapper`, `LocalTaskDatasource`, `LocalTaskRepository`. Kau sudah isi mapper + datasource + wiring CRUD saat P04. Pakai starter ini hanya bila kamu memilih jalur SQLite (§3.1 Jalur B).
- `../06-Starter-Code/p05-api/`, `ApiConfig`, `sealed ApiError`, `TaskApiClient` (interface), `HttpTaskApiClient`, `MockTaskApiClient` (fixture offline), `RemoteTaskDatasource`, `RemoteTaskRepository`. Kau sudah isi wiring CRUD provider saat P05.

Yang sudah kamu miliki dari kedua starter:
- Model `Task` + `toJson`/`fromJson` (P05) konsisten dengan `API-CONTRACT.md` (snake_case `due_date`/`is_completed`, boolean JSON, ISO date, enum `.name`).
- `TaskSchema` + `TaskDatabase` (lazy open, `onCreate`) + `TaskMapper.fromRow`/`toRow` (ISO date, enum name, **bool/int 0/1**) yang sudah hijau.
- `LocalTaskDatasource` CRUD (query/insert/update/delete) yang bertahan lintas restart.
- `RemoteTaskDatasource` + `MockTaskApiClient` (fixture 3 task, `simulateNetworkError`, 409 duplikat, 404 hilang) + `HttpTaskApiClient` (via `package:http`).
- Abstraksi `TaskRepository` (`getAll`/`save`/`remove`) yang sama untuk kedua sumber, inilah yang kau manfaatkan untuk menggabung keduanya.

Yang **baru** di Assignment 2: kamu membangun satu app yang punya **sumber remote** (REST mock/live) di atas **sumber lokal**, dengan **lokal sebagai source of truth**. Saat remote gagal, operasi lokal tetap berjalan (mode offline sederhana). Sumber lokal boleh SQLite (jalur B) atau in-memory di provider (jalur A), keduanya sah, lihat §3.1.

> **Aturan batas starter:** jangan mengubah `Task` class/enum/field, `TaskSchema`, kontrak JSON (`API-CONTRACT.md`), `ApiError` hirarki, `mapResponseToError`, `ApiConfig`, atau menambah package di luar `provider`, `sqflite`, `path`, `http`, `flutter_lints` tanpa seizin dosen. Bila ragu, tanya dosen lebih dulu. Kau **boleh** menulis repository koordinator baru, provider baru, dan widget indikator sync, itulah inti tugas.

---

## 3. Requirement (wajib)

Semua butir di bawah **wajib**. Rubrik menilai indikator observable, yang terlihat dan bisa diverifikasi, bukan niat. Seluruh gate dapat diuji di **mode mock** (default, tanpa server) atau **mode live** (`--dart-define=API_BASE_URL=...` bila dosen menyediakan endpoint).

### 3.1 Sumber data lokal, pilih satu jalur

Kamu **wajib** punya sumber kebenaran lokal agar mode offline (§3.5) bisa dibuktikan, tetapi **bebas memilih teknologinya**. Kedua jalur dinilai setara pada gate wajib.

**Jalur A, in-memory (cukup untuk nilai penuh).**
- [ ] Task disimpan di dalam `TaskProvider`/repository lokal sebagai `List<Task>` di memori.
- [ ] CRUD lokal bekerja end-to-end: add -> form -> save -> tersimpan; edit -> berubah; delete -> hilang; toggle -> status flip.
- [ ] Data **boleh hilang saat app di-restart**. Itu bukan kekurangan pada jalur ini; catat saja di README bagian known limitation.

**Jalur B, SQLite (opsional, bernilai bonus).**
- [ ] Semua butir jalur A, tetapi ditopang `LocalTaskDatasource` + `TaskDatabase` dari starter `p04-sqlite`.
- [ ] **Data bertahan setelah restart app** (kill -> `flutter run` lagi -> task tetap ada, termasuk perubahan edit/delete/toggle).
- [ ] `TaskMapper` benar: `DateTime`/ISO-8601, `enum`/nama, `bool`/integer 0/1 (bukan string `"true"`). `task_mapper_test.dart` + `local_task_datasource_test.dart` hijau.

> **Cara SQLite dinilai:** jalur B **tidak** menaikkan bobot dimensi mana pun dan **tidak** wajib. Yang mengerjakannya dapat mengakses kolom **"Sangat Baik" (skor 4)** pada indikator arsitektur dan serialization sebagai bukti tambahan, sementara jalur A tetap dapat mencapai skor 3 ("Baik") tanpa penalti. Pilih jalur B bila kamu ingin memperdalam P04; pilih jalur A bila ingin fokus penuh ke REST + error handling. **Jangan mengerjakan SQLite setengah jadi** yang membuat CRUD lokal rusak, itu lebih merugikan daripada memilih jalur A.

### 3.2 Serialization eksplisit (JSON, + mapper baris bila jalur B)
- [ ] `Task.toJson`/`fromJson` bekerja benar (boolean native untuk `is_completed`).
- [ ] Nama field JSON snake_case sesuai `API-CONTRACT.md` (`due_date`, `is_completed`, `priority`), bukan camelCase.
- [ ] Round-trip JSON benar: `Task -> toJson -> fromJson -> Task'` menjaga seluruh field; enum `.name`/`.byName` konsisten.
- [ ] **(Jalur B saja)** Dua jalur marshaling bekerja dan **tidak tertukar**: `TaskMapper.toRow`/`fromRow` untuk SQLite (bool = 0/1) dan `toJson`/`fromJson` untuk JSON (boolean native). Round-trip `Task -> toRow -> fromRow -> Task'` juga lossless.

### 3.3 REST API (GET + write)
- [ ] `GET /tasks` menampilkan data (mock fixture secara default; server bila `--dart-define`).
- [ ] Minimal satu operasi write (POST/PATCH/DELETE) terhubung ke client. Saat mode mock, perubahan terlihat dalam sesi (mock in-memory menyimpan). Saat live, perubahan tercatat di server.
- [ ] **Dua jalur submission** dijelaskan di README: (A) endpoint dosen via `--dart-define`, (B) fixture/mock fallback default. Keduanya harus menghasilkan behavior yang sama terhadap rubrik.

### 3.4 Error/network state UX
- [ ] **Loading** state terlihat saat operasi async (spinner/skeleton, bukan layar beku).
- [ ] **Empty** state terlihat saat tidak ada task (tabel kosong / hasil kosong), bukan layar blank.
- [ ] **Network error** terlihat: aktifkan `simulateNetworkError` (atau putus jaringan live) -> muncul ikon `cloud_off` + pesan + tombol **Retry** yang memanggil ulang operasi.
- [ ] **Client error (4xx/404)** terlihat dan dibedakan dari network error (mis. create duplikat -> `ClientError 409`; update/hapus id hilang -> `NotFoundError`). Pesan mengandung jenis error.
- [ ] **Server error (5xx)** terlihat **atau** dibuktikan via `api_error_test.dart` (`mapResponseToError(503)` -> `ServerError`) bila mock tidak menyimulasikan 5xx. Untuk demo penuh via mock, kau **boleh** menambah flag demo-only (mis. `simulateServerError`) yang diaktifkan hanya saat demo dan didokumentasikan di README sebagai kode demo.
- [ ] Tiap error dapat dipulihkan lewat **retry manual** (tombol/pull-to-refresh), bukan auto-backoff.

### 3.5 Mode offline (lokal tetap jalan)
- [ ] Saat remote gagal (network/5xx), operasi **lokal tetap berhasil**, data tetap tersimpan di sumber lokalmu (in-memory atau SQLite), tidak hilang dalam sesi, tidak crash.
- [ ] UI menampilkan **status lokal/sync sederhana**: minimal sebuah indikator (chip/badge/teks) yang membedakan "online/sync" vs "offline/lokal-only", cukup boolean, tidak perlu antrian sync penuh.
- [ ] Saat kondisi pulih (matikan `simulateNetworkError` / kembalikan koneksi), refresh manual menyinkronkan ulang remote tanpa kehilangan data lokal.

### 3.6 Architecture & code quality
- [ ] Layer terpisah: datasource (lokal + remote `RemoteTaskDatasource`) -> repository -> provider. UI hanya kenal abstraksi `TaskRepository`, bukan `package:http` (atau `sqflite` bila jalur B) langsung.
- [ ] Kau memanfaatkan abstraksi `TaskRepository` yang sama untuk kedua sumber, boleh lewat repository koordinator (mis. `SyncedTaskRepository`/`OfflineFirstRepository`) yang mendelegasi lokal + remote.
- [ ] Immutability dijaga: mutasi `Task` lewat `copyWith`; tidak ada field final yang dimutasi langsung; `List.unmodifiable` di getter publik.
- [ ] Tidak ada **secret/credential** di-hardcode di source atau README. Base URL/token hanya via `--dart-define` (lihat `API-CONTRACT.md` §1, `.env.example`).
- [ ] `flutter analyze` **bersih**, **atau** setiap warning/info tersisa dijelaskan di README beserta alasannya.
- [ ] `flutter test` lulus. Wajib hijau: `api_error_test`, `mock_task_api_client_test`, dan test JSON round-trip. Bila memilih **jalur B**, tambahkan `task_mapper_test` + `local_task_datasource_test` yang juga harus hijau. Menambah test sendiri = bonus, bukan gate (gate ≥3 unit + ≥2 widget ada di Proyek Akhir).

---

## 4. Non-goal (di luar scope Assignment 2)

Hal-hal berikut **dikecualikan**. Mencantumkannya sebagai requirement wajib akan didiskualifikasi dari rubrik Assignment 2 (sebagian jadi topik Proyek Akhir):

- **SQLite sebagai syarat wajib**, persistence lokal opsional (§3.1); menolak submission jalur A adalah kesalahan penilaian.
- Auth kompleks / token refresh otomatis / OAuth (topik di luar paket remidi).
- Sync conflict resolution (merge strategy, last-write-wins kompleks), mode offline cukup "lokal menang saat remote gagal", tanpa resolusi konflik.
- Background job / WorkManager / antrian sync persisten (push saat online kembali otomatis), di luar scope; cukup **retry manual**.
- Fitur device (camera/image picker), topik P06/Proyek Akhir.
- Release APK / signing / demo individual, topik P07/Proyek Akhir.
- Menulis unit/widget test sendiri sebagai gate (test starter tetap wajib hijau; gate ≥3 unit + ≥2 widget ada di Proyek Akhir).
- Pagination, filter server-side, soft delete, WebSocket, di luar `API-CONTRACT.md` scope wajib (§7).

> Kamu **boleh** menambah fitur ekstra setelah semua gate wajib tercapai (mis. antrian sync sederhana), tapi fitur ekstra tidak menggantikan gate wajib dan tidak menambah poin di luar kolom "Sangat Baik" rubrik.

---

## 5. Deliverable (yang dikumpulkan)

| # | Artefak | Wajib | Catatan |
|---|---|:---:|---|
| 1 | Source code (ZIP) + repo URL bila ada | wajib | Bisa di-build di mesin bersih setelah `flutter create`. |
| 2 | **Narasi Pemanfaatan AI** (800-1200 kata) | wajib | Bagian §7 `Template-Submission-README.md`, lihat §5.1. |
| 3 | Screenshot | wajib | Buktikan: list tampil (mock/fixture), loading, empty state, state error (`cloud_off` + Retry), `ClientError 409`/`NotFoundError`, indikator offline/lokal. **Jalur B:** tambahkan screenshot sebelum/sesudah restart sebagai bukti persistence. |
| 4 | Bukti test (output `flutter test`) | wajib | Termasuk `api_error_test` untuk `mapResponseToError(503) -> ServerError` sebagai bukti 5xx bila mock tidak menyimulasikannya. |
| 5 | `README.md` (pakai `Template-Submission-README.md`) | wajib | Run instruction dua jalur (mock + live), **jalur lokal yang dipilih (A/B) + alasannya**, API config tanpa secret, arsitektur singkat, known limitation, bukti `flutter analyze` + `flutter test`. |
| 6 | API config (`.env.example`/`--dart-define` docs) | wajib | Tanpa secret nyata; placeholder saja. |
| 7 | AI Interaction Log | bila pakai AI | Template: `../01-Orientasi/Template-AI-Interaction-Log.md`. **Tidak melampirkan padahal memakai AI = pelanggaran kebijakan.** |

Format submission mengikuti keputusan dosen. Default paket: source ZIP + README (berisi narasi) + screenshot + API config.

### 5.1 Narasi Pemanfaatan AI

Tulis **800-1200 kata** dalam bahasa Indonesia, di bagian §7 README (atau file `NARASI-AI.md` terpisah). Aturan umum sama dengan Assignment 1, tetapi **fokus penjelasan berbeda**, sesuaikan dengan materi Assignment 2:

1. **Strategi pemanfaatan AI.** Di bagian mana kamu memakai AI dan di bagian mana sengaja tidak. Bagaimana kamu menyusun prompt untuk masalah data layer (konteks apa yang kamu sertakan: potongan JSON, pesan error, kontrak API). Sertakan minimal satu contoh prompt konkret milikmu.
2. **Keputusan menerima/menolak saran AI.** Minimal **dua kasus konkret**, satu diterima dan satu **ditolak** beserta alasan teknisnya. Contoh kasus khas di sini: AI menyarankan menyimpan `is_completed` sebagai string, menyarankan `try`/`catch` yang menelan error tanpa memunculkannya ke UI, atau menyarankan auto-retry padahal brief meminta retry manual.
3. **Cara verifikasi pemahaman.** Bagaimana kamu membuktikan data layer benar: `flutter test` (round-trip JSON, `api_error_test`), uji manual `simulateNetworkError`, atau pemeriksaan payload. Sertakan bukti.
4. **Penjelasan alur data end-to-end + alur exception dengan kata sendiri.** Wajib dua-duanya:
 - **Alur data:** UI -> `TaskProvider` -> `TaskRepository` (koordinator) -> lokal/remote, dan bagaimana lokal tetap jadi source of truth saat remote gagal.
 - **Alur exception:** dari HTTP status di client -> `mapResponseToError` -> `sealed ApiError` -> `_error` di provider -> tampilan error + tombol Retry di UI. Jelaskan juga **kenapa jenis error ditentukan dari status code, bukan dari isi body**.
 - **Jalur lokal yang kamu pilih (A/B) dan alasannya.** Bila memilih jalur B, jelaskan kenapa `is_completed` disimpan 0/1 di SQLite tetapi boolean di JSON.

> **Bila tidak memakai AI sama sekali:** narasi tetap wajib (500-800 kata). Tulis alasannya, sumber belajar yang dipakai, lalu kerjakan poin 3 dan 4 seperti biasa. Tidak ada penalti.

---

## 6. Aturan AI (Assignment 2)

Assignment 2 dibuka setelah P05, jadi berlaku kebijakan AI **P4-P5**:

| Aspek | Boleh | Tidak boleh |
|---|---|---|
| Debugging error jaringan / data layer (mis. "kenapa toggle tidak bertahan?") | |, |
| Penjelasan konsep offline-first, repository koordinator, `sealed ApiError` | |, |
| Menulis **core** `toRow`/`fromRow`/`toJson`/`fromJson`, error mapping, query datasource, atau wiring provider tanpa analisis sendiri |, | |

**Wajib bila memakai AI:**
1. Isi `../01-Orientasi/Template-AI-Interaction-Log.md` untuk **setiap** interaksi: tujuan, prompt, ringkasan respons, perubahan yang dipilih/ditolak, dan **verifikasi pemahaman** (jelaskan ulang dengan kata sendiri + bukti `flutter test`/`flutter analyze`/screenshot state error).
2. Tulis **Narasi Pemanfaatan AI** (§5.1), khususnya alur UI -> provider -> repository koordinator -> lokal/remote dan alur exception dari client -> `_error` -> UI. Narasi dangkal atau tidak cocok dengan source -> poin indikator terkait dapat dibatalkan meski source benar (lihat `Rubrik-Assignment-02.md` gate dimensi E).

**Peringatan akademik:** menyalin solusi teman atau menempel hasil AI tanpa pemahaman termasuk pelanggaran. Rubrik punya indikator khusus untuk mendeteksi ini lewat kualitas narasi dan kecocokannya dengan source.

---

## 7. Command verifikasi (jalankan sebelum kumpul)

```bash
# 1. Dari folder proyekmu (hasil Assignment 1 + starter P05, + P04 bila jalur B):
flutter create --platforms=android. # jalur B memakai sqflite native; jangan target web
flutter pub get
flutter analyze # bersih, atau catat warning di README
flutter test # test starter P05 hijau (+ P04 bila jalur B)

# 2. Jalankan dan uji manual (default = mode mock, tanpa server):
flutter run
# Uji: loading -> list (fixture); FAB add; edit; delete+confirm; toggle;
# (JALUR B saja) KILL app, flutter run lagi -> data TETAP ADA (persistence);
# aktifkan simulateNetworkError -> pull-to-refresh -> _ErrorView + Retry;
# create duplikat -> ClientError 409; update/hapus id hilang -> NotFoundError;
# toggle saat "offline" -> lokal tetap jalan, indikator offline muncul;
# matikan flag -> refresh -> sync kembali.

# 3. (Opsional) Mode live bila dosen menyediakan endpoint:
flutter run \
 --dart-define=API_BASE_URL=https://your-server.example.com \
 --dart-define=API_TOKEN=*** # jangan di-commit

# 4. Verifikasi file deliverable ada:
test -f README.md
test -f../01-Orientasi/Template-AI-Interaction-Log.md # referensi template AI log
```

**Checklist sebelum submit** (centang semua):
- [ ] Semua requirement §3 tercapai dan teruji manual (mode mock cukup).
- [ ] Jalur lokal (A atau B) dipilih sadar dan **ditulis di README** beserta alasannya.
- [ ] **(Jalur B saja)** Restart app -> data bertahan, terbukti lewat screenshot sebelum/sesudah.
- [ ] `flutter analyze` bersih / warning dijelaskan.
- [ ] `flutter test` lulus.
- [ ] **Narasi Pemanfaatan AI 800-1200 kata** ditulis, memuat keempat poin §5.1 (termasuk alur data **dan** alur exception).
- [ ] Screenshot: list, loading, empty, network error + Retry, 4xx, indikator offline.
- [ ] Bukti 5xx lewat `api_error_test.dart` (`503 -> ServerError`) atau screenshot bila memakai flag demo.
- [ ] Tidak ada secret di repo (`.env.example` hanya placeholder).
- [ ] README pakai template submission + dua jalur run (mock + live).
- [ ] AI log dilampirkan bila memakai AI.

---

## 8. Rubrik dan bobot

Penilaian memakai `Rubrik-Assignment-02.md` (4 dimensi, total 100 poin). Dimensi SQLite yang dulu berdiri sendiri **dihapus**; bobotnya dialihkan ke serialization/API dan error UX:

| Dimensi | Bobot | Inti penilaian |
|---|---:|---|
| Serialization & API | 35 | JSON round-trip, GET + write, dua jalur submission, kontrak field |
| Error UX & offline | 30 | loading/empty/4xx/5xx/network terlihat + retry + mode offline |
| Architecture & code quality | 20 | layer separation, abstraksi `TaskRepository`, no-secret, tooling |
| Narasi AI & dokumentasi | 15 | narasi alur data + alur exception, README, AI log |

**SQLite (jalur B)** dinilai sebagai **bonus di dalam** dimensi Serialization & API dan Architecture, yaitu sebagai bukti tambahan yang membuka skor 4 ("Sangat Baik"), bukan sebagai dimensi terpisah. Jalur A tetap dapat mencapai nilai sangat baik secara keseluruhan.

Skala 0-4 per indikator, dikonversi ke poin per dimensi. Indikator **gate** (bertanda ) yang gagal dapat membatalkan poin turunan. Detail di `Rubrik-Assignment-02.md`.

---

## 9. Deadline (placeholder, diisi dosen)

| Item | Tanggal |
|---|---|
| Assignment 2 dibuka | `[diisi dosen, default: akhir sesi P05]` |
| Assignment 2 dikumpulkan | `[diisi dosen, default: sebelum sesi P06]` |

> Tenggat final mengikuti `../00-Planning/Runbook-Dosen.md` bagian 5 dan pengumuman dosen. Keterlambatan mengikuti aturan prodi.

---

## 10. Tips pendekatan (saran, bukan syarat)

1. **Putuskan jalur lokal (A atau B) di awal, jangan di tengah jalan.** Jalur A (in-memory) lebih cepat selesai dan cukup untuk nilai penuh; jalur B (SQLite) menambah bukti bonus tapi menambah permukaan bug. Pilih jalur B hanya bila P04-mu sudah hijau dan waktumu cukup.
2. **Mulai dari hasil Assignment 1 yang sudah hijau**, lalu datangkan lapisan remote dari starter P05 (dan starter P04 bila jalur B). Jangan dari awal.
3. **Repository koordinator adalah jantung Assignment 2.** Buat satu class (mis. `OfflineFirstTaskRepository implements TaskRepository`) yang punya datasource lokal + `RemoteTaskDatasource`. Strategi sederhana: `getAll` baca lokal dulu (cepat + pasti ada), lalu coba remote (best-effort); `save`/`remove` tulis lokal dulu (sumber kebenaran), lalu coba remote. Remote gagal -> swallow ke `_error`, data lokal tetap utuh. Pola ini sama persis untuk jalur A maupun B, yang berbeda hanya implementasi datasource lokalnya.
4. **Indikator offline = boolean sederhana.** Tambah flag `isOnline`/`lastSyncFailed` di provider; UI tampilkan chip "OFFLINE/lokal-only" saat `true`. Tidak perlu antrian.
5. **(Jalur B) Jangan tertukar mapper.** `is_completed`: SQLite 0/1 (`? 1 : 0` / `as int) != 0`), JSON boolean (`isCompleted` langsung). Ini jebakan silang paling umum, punya dua jalur marshaling justru jadi ujian, dan menjelaskannya di narasi adalah bukti bonus yang kuat.
6. **5xx tanpa server:** mock P05 tidak menyimulasikan 5xx native. Untuk bukti penuh, tambah flag demo-only `simulateServerError` di mock instance kau sendiri (didokumentasikan README), **atau** andalkan `api_error_test.dart` sebagai bukti mapping 5xx -> `ServerError`. Keduanya diterima rubrik.
7. **(Jalur B) Verifikasi persistence lebih dulu.** Restart adalah yang paling sering gagal diam-diam (datasource CRUD no-op, atau path DB salah). Lakukan add -> kill -> run SEBELUM mengintegrasi remote. Bila persistence tak kunjung jalan mendekati tenggat, **turun ke jalur A** dan catat di README, itu jauh lebih baik daripada mengumpulkan CRUD lokal yang rusak.
8. **Tulis narasi sambil kerja.** Catat alur data layer + alur exception di AI log sambil mengerjakan, terutama saran AI yang kamu tolak. Narasi §5.1 tinggal merangkai, dan hasilnya jauh lebih spesifik daripada ditulis dari ingatan.

