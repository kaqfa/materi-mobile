# PPB Remedial 7 Pertemuan, Rencana Produksi Modul

> **Status:** Planning v1.0, 2026-08-08 
> **Root artefak:** `Handout-SA/` 
> **Board eksekusi:** `.agents/kanban/` 
> **Sumber utama:** `../RPS PPB - 20251.md`, `../Handout/`, `../Tutorial/`, `../UTS/`, `../Standar Tutorial Koding PPB.md`, `../Standar Pengembangan Materi PPB.md`

## 1. Tujuan

Membuat paket ajar remidi PPB yang memulihkan kompetensi inti Flutter dalam **7 pertemuan**. Paket bukan ringkasan 14 pertemuan reguler. Paket berbentuk klinik praktik terukur dengan satu aplikasi jangkar: **Remedial Task Tracker**.

Mahasiswa peserta sudah pernah mengikuti PPB, tetapi nilainya belum memenuhi standar. Mereka harus membuktikan kemampuan individual untuk membaca, memperbaiki, membuat, menguji, dan menjelaskan kode Flutter.

## 2. Batas Kompetensi

### Kompetensi wajib

1. Dart: model, constructor, enum, null safety, collection, `async`/`await`, `try`/`catch`, JSON.
2. Flutter: widget tree, `StatelessWidget`, `StatefulWidget`, layout, navigasi, form validation, responsive dasar.
3. State: `ChangeNotifier` + Provider; loading, error, empty state; CRUD reaktif.
4. Data: SQLite sebagai local source of truth; repository/data source; REST CRUD dan penanganan error.
5. Kualitas: unit test, widget test, permission dan satu fitur device, `flutter analyze`, release APK, penjelasan kode.

### Di luar scope wajib

- BLoC, Riverpod, WebSocket, WorkManager, token refresh otomatis, conflict resolution kompleks, push notification, iOS build, Play Store upload, rich-text editor, analytics/chart kompleks.
- Mahasiswa boleh menambah fitur setelah semua gate wajib lulus. Fitur tambahan tidak mengganti fitur wajib.

## 3. Alignment RPS dan asesmen

| Area RPS | Bukti remidi | Bobot |
|---|---|---:|
| Sub-CPMK53.1, Dart, widget, state | Assignment 1 + live modification | 30% |
| Sub-CPMK92.1, UI interaktif dan responsive | Assignment 1 + review UI | 25% |
| Sub-CPMK53.2, serialization, REST, performa, release | Assignment 2 + APK (Proyek Akhir) | 20% |
| Sub-CPMK92.2, device, testing, dokumentasi | Proyek Akhir + demo individual | 25% |
| **Total** | | **100%** |

Nilai aplikasi tidak cukup. Mahasiswa wajib menjelaskan kode dan menyelesaikan perubahan kecil individual saat final.

## 4. Arsitektur paket ajar

```text
Handout-SA/
├── 00-Planning/
│ ├── Rencana-Modul-PPB-Remedial-7-Pertemuan.md
│ ├── Peta-Capaian-dan-Assessment.md
│ ├── Rubrik-Remedial.md
│ └── Runbook-Dosen.md
├── 01-Orientasi/
│ ├── Panduan-Mahasiswa.md
│ ├── Checklist-Environment.md
│ ├── Tes-Diagnostik-Konsep.md
│ ├── Tes-Diagnostik-Praktik.md
│ └── Template-AI-Interaction-Log.md
├── 02-Materi/
│ ├── P01-Diagnosis-Dart-Debugging.md
│ ├── P02-Widget-Layout-Navigation.md
│ ├── P03-Form-CRUD-Provider.md
│ ├── P04-SQLite-Offline-First.md
│ ├── P05-REST-API-Error-Handling.md
│ ├── P06-Device-Testing-QA.md
│ └── P07-Release-Live-Coding-Demo.md
├── 03-Modul-Kelas/
│ └── Modul-P01...Modul-P07.md
├── 04-Penugasan/
│ ├── Assignment-01-Task-Tracker-Core.md
│ ├── Assignment-02-Serialization-dan-API.md
│ ├── Proyek-Akhir-QA-Release-dan-Demo.md
│ ├── Rubrik-Assignment-01.md
│ ├── Rubrik-Assignment-02.md
│ ├── Rubrik-Proyek-Akhir.md
│ └── Template-Submission-README.md
├── 05-Assessment/
│ ├── Bank-Live-Coding.md
│ ├── Rubrik-Demo-dan-Wawancara.md
│ ├── Lembar-Observasi.md
│ └── Kunci-Diagnostik.md
├── 06-Starter-Code/
│ ├── README.md
│ ├── p01-diagnosis/
│ ├── p02-ui-navigation/
│ ├── p03-provider-crud/
│ ├── p04-sqlite/
│ ├── p05-api/
│ ├── p06-testing-device/
│ └── p07-release/
└──.agents/kanban/
```

## 5. Desain tujuh pertemuan

Setiap sesi 3 × 50 menit. Rasio praktik minimal 65%. Format tetap:

- 10 menit: retrieval quiz / review bug sebelumnya.
- 20 menit: konsep minimum dan demo.
- 55 menit: guided lab dengan checkpoint.
- 40 menit: praktik individual dan observasi dosen.
- 15 menit: demo singkat, exit ticket, instruksi kerja rumah.

Setiap materi dan modul kelas mengikuti **Progressive Checkpoint Pattern**: 2-3 checkpoint, kode jalan pada tiap checkpoint, checklist validasi, estimasi waktu, troubleshooting, dan preview sesi berikutnya.

| P | Fokus dan outcome | Checkpoint inti | Bukti sesi | Artefak utama |
|---|---|---|---|---|
| 1 | Diagnosis, Dart, debugging | cek environment; model `Task`; perbaiki filter/search rusak | tes konsep + patch fitur kecil | materi, modul, tes diagnosis, starter bugged code |
| 2 | Widget, layout, navigation | task list; reusable `TaskCard`; list-detail/add navigation | dua screen dan responsive dasar | materi, modul, starter UI |
| 3 | Form, CRUD, Provider | validator; `TaskProvider`; CRUD, loading/error/empty state | Assignment 1 dimulai | materi, modul, starter provider |
| 4 | SQLite dan offline-first | schema; local datasource/repository; restart persistence | data bertahan setelah restart | materi, modul, starter SQLite |
| 5 | REST API dan robustness | HTTP/JSON; repository remote; network/error state dan retry manual | Assignment 2 dimulai | materi, modul, API contract/mock fallback |
| 6 | Device, testing, QA | permission + image picker; unit test; widget test | test pass dan device fallback | materi, modul, test/device starter |
| 7 | Release, live coding, demo | static quality/performance; APK; modifikasi requirement; technical interview | Proyek Akhir dan demo final | materi, modul, bank soal, rubrik demo |

## 6. Rancangan dua assignment + satu proyek akhir

> **Aturan lintas tugas (v2.0):**
> - **Tanpa video presentasi.** Bukti pemahaman = **Narasi Pemanfaatan AI** (karangan tertulis) + screenshot. Demo P07 dilakukan tatap muka, bukan direkam.
> - **Assignment berhenti di testing** (`analyze` bersih + `test` hijau). Release APK, demo, dan live modification hanya di Proyek Akhir.
> - **SQLite opsional** di seluruh tugas. Diajarkan di P04, bernilai bonus, bukan gate. Mahasiswa memilih jalur A (in-memory) atau jalur B (SQLite).

### Assignment 1, Task Tracker Core (30%, rilis setelah P3; tenggat sebelum P4)

**Tujuan:** membuktikan Dart, widget, responsive UI, form validation, navigation, dan Provider CRUD.

**Wajib:**
- `Task` model dengan enum category/priority/status atau equivalent yang konsisten.
- daftar task, detail/add-edit screen, delete confirmation, toggle completion.
- search title **dan** filter status/category.
- `ChangeNotifier`/Provider; loading/error/empty state.
- Material 3 dengan layout tidak overflow pada phone portrait dan landscape.
- `flutter analyze` bersih atau warning dijelaskan.

**Bukti:** repository/ZIP source, **Narasi Pemanfaatan AI 800-1200 kata**, screenshot dua orientasi + flow utama, `README`, AI log bila memakai AI. Lingkup berhenti di testing.

### Assignment 2, Serialization dan API (30%, rilis setelah P5; tenggat sebelum P6)

**Tujuan:** membuktikan arsitektur data dan error handling.

**Wajib:**
- CRUD lokal konsisten; sumber lokal boleh in-memory (jalur A) **atau** SQLite (jalur B, bonus, data bertahan setelah restart).
- model serialization yang eksplisit (`toJson/fromJson`; mapper baris bila jalur B).
- REST GET dan minimal POST/PUT/PATCH memakai endpoint yang disediakan dosen atau mock server.
- loading, success, empty, 4xx/5xx/network-error state yang terlihat.
- mode offline: operasi lokal tetap bisa dilakukan; UI menunjukkan status lokal/sync sederhana.

**Bukti:** source, **Narasi Pemanfaatan AI 800-1200 kata** (alur data + alur exception), screenshot (list, loading, empty, error+retry, 4xx, indikator offline; + restart bila jalur B), API contract/endpoint config tanpa secret, README update. Lingkup berhenti di testing.

**Prasyarat operasional:** dosen menyediakan endpoint/test credentials. Jika belum tersedia, starter code harus menyertakan mock repository/API fixture agar capaian tetap bisa diuji.

### Proyek Akhir, QA, Release, dan Demo Individual (40%, rilis setelah P6; final P7)

**Tujuan:** membuktikan kualitas, integrasi platform, dan pemahaman individual.

**Wajib:**
- satu fitur device: pilih image picker/camera; bila device/emulator tidak mendukung kamera, gallery picker + permission/error branch sah.
- minimal 3 unit test: model/mapper/filter-validator.
- minimal 2 widget test: form validation dan empty/error/list interaction.
- `flutter test`, `flutter analyze`, release APK berhasil.
- README final: cara run, arsitektur singkat, jalur lokal (A/B), fitur, known limitation, bukti test.
- **Narasi Pemanfaatan AI 1000-1500 kata** (evolusi strategi, ≥3 kasus termasuk penolakan, verifikasi, jalur end-to-end + dua `sealed` + alasan `const`, refleksi kejujuran).
- demo individual **tatap muka** 7-10 menit: app walkthrough, code walkthrough, live modification 20-25 menit, Q&A.

**Live modification:** dosen menarik satu soal dari bank, misalnya sorting, filter baru, validasi tanggal, empty state khusus, atau perubahan mapper JSON. Nilai live modification dan penjelasan tidak dapat digantikan dengan source code.

## 7. Starter code dan delivery model

### Prinsip

- **Satu repo template**, cabang/tag atau folder checkpoint `p01`-`p07`.
- Mahasiswa **fork/copy** starter terbaru, bukan menyambung proyek lama yang tidak seragam.
- Setiap starter code harus build dan punya README checkpoint.
- Starter code tidak menyelesaikan inti tugas; ia memberi struktur, data dummy, constants, dan TODO terarah.
- Tiap starter memiliki `before/` (kode awal) dan `solution-reference/` (khusus dosen, tidak dibagikan sebelum sesi selesai) atau tag Git privat.

### Kontrak struktur aplikasi

```text
lib/
├── app.dart
├── main.dart
├── core/
│ ├── constants/
│ ├── errors/
│ ├── theme/
│ └── utils/
├── features/tasks/
│ ├── data/
│ │ ├── local/
│ │ ├── remote/
│ │ └── repositories/
│ ├── domain/
│ │ └── task.dart
│ └── presentation/
│ ├── providers/
│ ├── screens/
│ └── widgets/
└── test/
```

Dependency minimum: `provider`, `sqflite`, `path`, `http`, `image_picker`; `mocktail` atau `mockito` hanya bila test starter memerlukannya. Pin versi setelah `flutter --version` target kelas ditetapkan.

### API contract minimum

- Config base URL melalui `--dart-define=API_BASE_URL=...` atau `.env.example`; jangan hardcode secret.
- `GET /tasks`, `POST /tasks`, `PATCH /tasks/:id`, `DELETE /tasks/:id`.
- Response JSON tunggal dan fixture offline disediakan.
- Base URL, kredensial, dan kebijakan auth menjadi input dosen. Jika tidak ada server stabil, gunakan mock server/fixture yang dikontrol dosen.

## 8. AI policy

- P1-P3: AI boleh untuk penjelasan syntax dan diagnosis, bukan menulis core logic tanpa analisis.
- P4-P5: AI boleh untuk debugging dan review error; mahasiswa wajib memahami perubahan data layer.
- P6-P7: AI boleh untuk ide test/optimasi, wajib dicatat.
- Semua tugas menyertakan AI Interaction Log: tujuan, prompt, ringkasan respons, perubahan yang dipilih/ditolak, dan cara mahasiswa memverifikasi.
- Saat demo, mahasiswa harus mampu menjelaskan kode yang dibantu AI.

## 9. Instrumentasi dan quality gate

### Sebelum P1

- `flutter doctor` dan perangkat/emulator tervalidasi.
- starter P01 dapat `flutter pub get`, `flutter analyze`, dan `flutter test` pada environment target.
- diagnosis konsep + diagnosis praktik disiapkan dengan kunci/rubrik.

### Per checkpoint

- aplikasi build/run;
- acceptance checklist tercapai;
- error/broken state tidak diteruskan ke checkpoint berikutnya;
- mahasiswa mengumpulkan exit ticket: screenshot/log + satu konsep yang belum jelas.

### Sebelum distribusi paket

- semua snippets menjalankan lint/test;
- material punya 2-3 checkpoint dan troubleshooting;
- modul kelas punya rundown 150 menit, demo, latihan mandiri, challenge bertingkat, dan notes dosen;
- tugas hanya 3, rubrik eksplisit, submission template konsisten;
- API/mock fallback dibuktikan;
- bank live coding punya rubrik/kunci dan variasi setara.

## 10. Urutan produksi

1. Bangun pedoman, rubrik, diagnosis, policy, dan kontrak aplikasi.
2. Scaffold starter P01-P03 dan validasi toolchain.
3. Produksi materi+modul P01-P03 serta Assignment 1.
4. Scaffold data layer P04-P05; tentukan endpoint atau mock fallback.
5. Produksi materi+modul P04-P05 serta Assignment 2.
6. Scaffold P06-P07; test/device/release checklist.
7. Produksi materi+modul P06-P07, Proyek Akhir, bank live coding, dan dosen runbook.
8. QA lint/build/test sumber starter; review pedagogi, rubrik, seluruh tautan/path.

## 11. Keputusan yang masih perlu dari dosen

| Keputusan | Dampak | Default plan |
|---|---|---|
| Flutter/Dart version kelas | dependency lock dan test starter | tulis compatibility matrix, pin setelah diverifikasi di mesin target |
| Backend P5 | API URL, account, auth, demo | mock server/fixture lokal sebagai fallback wajib |
| Bentuk submission | GitHub/GitLab/E-learning | source ZIP + repo URL bila tersedia + screenshot + APK (**tanpa video**) |
| Kebijakan remidi nilai maksimum | rubrik akhir | rubrik memberi skor 100; konversi final mengikuti aturan prodi/dosen |
| Device fisik | camera vs gallery fallback | gallery picker + permission handling tetap wajib |

## 12. Definition of Done paket

Paket lengkap bila 7 materi, 7 modul kelas, 2 assignment + 1 proyek akhir, starter code P01-P07, diagnosis, rubrik, AI log, bank live coding, template submission, serta runbook dosen tersedia pada root ini; seluruh starter check berhasil dan setiap artefak merujuk kompetensi/rubrik yang sama.
