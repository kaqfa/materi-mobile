# Peta Capaian dan Asesmen, PPB Remidi 7 Pertemuan

> **Status:** v1.0, 2026-08-08
> **Root artefak:** `Handout-SA/`
> **Sumber:** `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md`, `../RPS PPB - 20251.md`
> **Terkait:** `Rubrik-Remedial.md`, `Runbook-Dosen.md`, `../01-Orientasi/Panduan-Mahasiswa.md`

## 1. Tujuan dokumen

Dokumen ini adalah **sumber kebenaran capaian dan asesmen** paket remidi. Semua materi, modul kelas, tugas, rubrik, diagnosis, dan runbook dosen **wajib merujuk kembali** ke tabel dan bobot di sini. Jika ada pertentangan angka antar-artefak, dokumen ini menang, kecuali `Rencana-Modul-PPB-Remedial-7-Pertemuan.md`.

## 2. Kontrak konstan (wajib sama di semua artefak)

| Item | Nilai |
|---|---|
| Nama aplikasi jangkar | **Remedial Task Tracker** |
| Jumlah sesi | **7 pertemuan** (P01-P07), masing-masing 3 × 50 menit = 150 menit |
| Jumlah tugas | **2 assignment + 1 proyek akhir** (Assignment 1, Assignment 2, Proyek Akhir) |
| State management | `ChangeNotifier` + `provider` |
| Local persistence | SQLite (`sqflite`, `path`), **opsional** di seluruh tugas (diajarkan, bernilai bonus, bukan gate) |
| Remote | REST via `http`; mock/fixture fallback bila tidak ada server stabil |
| Device feature | `image_picker` (camera atau gallery + permission/error) |
| Rasio praktik minimal | 65% waktu sesi |

Kontrak struktur aplikasi dan dependency minimum mengikuti `Rencana-Modul-PPB-Remedial-7-Pertemuan.md` bagian 7.

## 3. Alignment RPS dan bobot capaian

Bobot final nilai remidi mengikuti **empat area Sub-CPMK** di bawah. Total 100%.

| Area RPS | Sub-CPMK | Bukti remidi | Bobot |
|---|---|---|---:|
| Dart, widget, state | Sub-CPMK53.1 | Assignment 1 + live modification P07 | **30%** |
| UI interaktif dan responsive | Sub-CPMK92.1 | Assignment 1 + review UI | **25%** |
| Serialization, REST, performa, release | Sub-CPMK53.2 | Assignment 2 + APK rilis (Proyek Akhir) | **20%** |
| Device, testing, dokumentasi | Sub-CPMK92.2 | Proyek Akhir + demo individual | **25%** |
| **Total** | | | **100%** |

**Aturan nol:** nilai aplikasi saja tidak cukup. Mahasiswa wajib menjelaskan kode lewat **Narasi Pemanfaatan AI** di setiap tugas dan menyelesaikan modifikasi kecil individual di final. Kegagalan narasi/penjelasan/live modification dapat membatalkan poin tugas terkait (lihat `Rubrik-Remedial.md`).

**Catatan bukti:** paket ini **tidak memakai video presentasi**. Bukti pemahaman berupa **narasi tertulis** (Narasi Pemanfaatan AI + AI Interaction Log) ditambah **screenshot** sebagai bukti visual fungsional.

## 4. Peta tujuh sesi

Setiap sesi menargetkan capaian observable. Bukti sesi = keluaran yang dapat diverifikasi pada akhir 150 menit.

| Sesi | Fokus | Capaian observable | Bukti sesi | Rilis tugas |
|---|---|---|---|---|
| P01 | Diagnosis, Dart, debugging | Environment valid; model `Task`; patch filter/search rusak | tes konsep + patch fitur kecil |, |
| P02 | Widget, layout, navigation | Dua screen; `TaskCard` reusable; list-detail/add; responsive dasar | dua screen tampil di portrait+landscape |, |
| P03 | Form, CRUD, Provider | Validator; `TaskProvider`; CRUD; loading/error/empty state | provider reaktif berjalan | Assignment 1 dibuka |
| P04 | SQLite, offline-first (opsional) | Schema; local datasource/repository; data bertahan setelah restart | restart app, data tetap ada |, |
| P05 | REST API, robustness | HTTP/JSON; repository remote; network/error state; retry manual | GET + POST/PUT/PATCH tampil + error state | Assignment 2 dibuka |
| P06 | Device, testing, QA | Permission + image picker; ≥3 unit test; ≥2 widget test | `flutter test` lulus; device fallback jalan |, |
| P07 | Release, live coding, demo | `flutter analyze` bersih; APK rilis; live modification; wawancara | APK + demo individual 7-10 menit + live mod 20-25 menit | Proyek Akhir final |

Kadens tugas: Assignment 1 dibuka setelah P03 (tenggat sebelum P04); Assignment 2 dibuka setelah P05 (tenggat sebelum P06); Proyek Akhir final di P07.

**Batas lingkup assignment:** Assignment 1 dan Assignment 2 berhenti di **testing** (`flutter analyze` bersih + `flutter test` hijau). Build release APK, demo individual, dan live modification hanya ada di **Proyek Akhir**.

## 5. Peta dua assignment + proyek akhir

Tugas dirancang sebagai bukti individu. Label persentase di bawah adalah **beban/luas lingkup tugas** (sebaran usaha dan timeline rilis), bukan langsung bobot final. Konversi ke nilai final mengikuti matriks area RPS di bagian 6.

| Tugas | Judul | Lingkup utama | Batas akhir lingkup | Beban tugas | Dibuka | Tenggat |
| ------------ | --------------------- | ------------------------------------------------------------------------- | ------------------- | ----------: | ----------- | ----------- |
| Assignment 1 | Task Tracker Core | model, UI responsive, form validation, navigation, Provider CRUD, state | testing | 30% | setelah P03 | sebelum P04 |
| Assignment 2 | Serialization dan API | serialization, REST, error/network state, mode offline, SQLite (opsional) | testing | 30% | setelah P05 | sebelum P06 |
| Proyek Akhir | QA, Release, dan Demo | fitur device, unit+widget test, analyze/test/APK, README, demo+live mod | release + demo | 40% | setelah P06 | final P07 |

**Bukti per tugas:** source/ZIP, **Narasi Pemanfaatan AI**, screenshot, `README`, dan **AI Interaction Log** bila memakai AI (template: `../01-Orientasi/Template-AI-Interaction-Log.md`). **Tidak ada video presentasi** di tugas mana pun.

**SQLite opsional:** persistence lokal diajarkan di P04 dan boleh dipakai di assignment maupun proyek akhir, tetapi **bukan gate**. Yang mengerjakannya mendapat nilai bonus (kolom "Sangat Baik" rubrik); yang tidak, memakai penyimpanan in-memory tanpa penalti.

## 6. Rekonsiliasi bobot tugas -> area RPS

Setiap tugas dikontribusikan ke area RPS. Rubrik menilai indikator per area, lalu skor diakumulasikan ke bobot area di bagian 3.

| Area RPS (bobot) | Dari Assignment 1 | Dari Assignment 2 | Dari Proyek Akhir | Dari Demo P07 |
|---|:---:|:---:|:---:|:---:|
| Sub-CPMK53.1, Dart, widget, state (30%) | utama (model, Provider) | ◐ mapper/serialization |, | live modification |
| Sub-CPMK92.1, UI interaktif responsive (25%) | utama (UI, form, nav) | ◐ error/empty state UI |, | ◐ review UI |
| Sub-CPMK53.2, serialization/REST/release (20%) |, | utama (serialization, REST) | ◐ APK rilis | ◐ |
| Sub-CPMK92.2, device/testing/dokumentasi (25%) | ◐ narasi AI + analyze | ◐ narasi AI | utama (device, test, README) | demo + wawancara |

Legenda: utama (indikator pokok area), ◐ pendukung (indikator turunan).

**Rumus nilai final (ilustratif):**
`Nilai = 0,30·A53.1 + 0,25·A92.1 + 0,20·A53.2 + 0,25·A92.2`, masing-masing `A` adalah rata-rata tertimbang indikator pada area itu (0-100). Rubrik memberi skor per indikator; konversi remidi-maksimum mengikuti aturan prodi/dosen (`Rubrik-Remedial.md` bagian 6).

## 7. Quality gate

### Sebelum P1
- `flutter doctor` bersih pada environment target (lihat `../01-Orientasi/Checklist-Environment.md`).
- Perangkat/emulator tervalidasi.
- Starter P01 lulus `flutter pub get`, `flutter analyze`, `flutter test`.
- Diagnosis konsep + praktik siap dengan kunci/rubrik (tugas produksi diagnosis = task kanban terpisah).

### Per checkpoint (lintas sesi)
- Aplikasi build dan run.
- Acceptance checklist checkpoint tercapai.
- Broken/error state tidak diteruskan ke checkpoint berikutnya.
- Exit ticket terkumpul: screenshot/log + satu konsep yang belum jelas.

### Lintas paket (sebelum distribusi)
- Semua snippet menjalankan lint/test.
- Setiap materi punya 2-3 checkpoint dan troubleshooting (Progressive Checkpoint Pattern, `../Standar Tutorial Koding PPB.md`).
- Modul kelas punya rundown 150 menit, demo, latihan mandiri, challenge bertingkat, notes dosen.
- Tugas tepat 2 assignment + 1 proyek akhir, rubrik eksplisit, template submission konsisten.
- API/mock fallback dibuktikan.
- Bank live coding punya rubrik/kunci dan variasi setara.

## 8. Verifikasi pemahaman (anti "nilai aplikasi saja")

Setiap tugas wajib disertai **verifikasi pemahaman**:

- **Narasi Pemanfaatan AI** (800-1200 kata), wajib di setiap tugas. Menjelaskan strategi prompting, keputusan menerima/menolak saran AI, dan cara memverifikasi pemahaman. Inilah pengganti video presentasi.
- **AI Interaction Log**, bila AI dipakai, tiap interaksi mencatat tujuan, prompt, ringkasan respons, perubahan yang dipilih/ditolak, dan cara verifikasi.
- **Demo + wawancara P07**, mahasiswa menjelaskan kode yang dibantu AI dan menyelesaikan live modification dari bank soal. Hanya di Proyek Akhir.
- **Live modification**, tidak dapat digantikan source code. Nilainya masuk ke Sub-CPMK53.1 dan Sub-CPMK92.2.

Kebijakan AI bertingkat (P1-P3, P4-P5, P6-P7) dirinci di `../01-Orientasi/Panduan-Mahasiswa.md` dan `Runbook-Dosen.md`.
