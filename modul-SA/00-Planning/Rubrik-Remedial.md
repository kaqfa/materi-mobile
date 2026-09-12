# Rubrik Remedi, PPB Remidi 7 Pertemuan

> **Status:** v2.0, 2026-08-10
> **Root artefak:** `Handout-SA/`
> **Sumber:** `Peta-Capaian-dan-Assessment.md`, `Rencana-Modul-PPB-Remedial-7-Pertemuan.md`
> **Aplikasi jangkar:Remedial Task Tracker** (7 sesi, 2 assignment + 1 proyek akhir)
> **Aturan:** rubrik menilai **indikator observable**, bukan niat. Aplikasi saja tidak cukup; **narasi tertulis** dan live modification wajib.
> **Tanpa video:** bukti visual = screenshot; penjelasan kode = Narasi Pemanfaatan AI + demo tatap muka di P07.
> **SQLite opsional:** persistence lokal bernilai bonus, bukan gate, di seluruh tugas.

## 1. Skala penilaian

Skala 0-4 per indikator. Konversi: `(skor / 4) × 100`.

| Skor | Label | Definisi |
|---:|---|---|
| 4 | Sangat Baik | Memenuhi semua kriteria, konsisten, dan ada bukti tambahan (test, edge case, dokumentasi tajam). |
| 3 | Baik | Memenuhi seluruh kriteria inti; sedikit catatan minor. |
| 2 | Cukup | Memenuhi sebagian kriteria inti; ada kekurangan yang dapat diperbaiki dalam sesi. |
| 1 | Kurang | Hanya sebagian kecil tercapai; banyak kerentanan/broken state. |
| 0 | Tidak ada / tidak jujur | Indikator tidak ada, atau ditemukan plagiarisme/penjelasan tidak menguasai kode sendiri. |

Skor 0 pada indikator bertanda **(gate)** membatalkan poin indikator turunan yang bergantung padanya.

## 2. Assignment 1, Task Tracker Core

Bukti: source/ZIP, **Narasi Pemanfaatan AI 800-1200 kata**, screenshot portrait+landscape + flow utama, `README`, AI log bila ada. Lingkup berhenti di testing.

| Indikator (observable) | Bukti yang dilihat | Area RPS | Gate |
|---|---|---|:---:|
| Model `Task` | Enum category/priority/status (atau setara konsisten); constructor + null safety benar | 53.1 | |
| Daftar + detail + add/edit + delete | Navigasi bekerja; delete meminta konfirmasi; toggle completion jalan | 92.1 | |
| Search + filter | Search title **dan** filter status/category; hasil benar pada data nyata | 53.1 | |
| Provider CRUD | `ChangeNotifier`/Provider; operasi reaktif memperbarui UI tanpa rebuild brutal | 53.1 | |
| State UX | loading, error, empty state terlihat dan masuk akal | 92.1 | |
| Responsive UI | Material 3; tidak overflow pada portrait **dan** landscape ponsel | 92.1 | |
| Form validation | Validasi mencegah input invalid; pesan error jelas | 92.1 | |
| Tooling | `flutter analyze` bersih **atau** setiap warning dijelaskan di README | 53.2 | |
| Narasi AI + penjelasan | Narasi memuat strategi, saran AI yang diterima **dan ditolak**, cara verifikasi, serta satu alur end-to-end; cocok dengan source. AI log lengkap bila AI dipakai | 92.2 | gate |

## 3. Assignment 2, Serialization dan API

Bukti: source, **Narasi Pemanfaatan AI 800-1200 kata**, screenshot (list, loading, empty, error+retry, 4xx, indikator offline), config endpoint tanpa secret, README update, AI log bila ada. Lingkup berhenti di testing.

| Indikator (observable) | Bukti yang dilihat | Area RPS | Gate |
|---|---|---|:---:|
| CRUD lokal | Operasi Create/Read/Update/Delete pada sumber lokal (in-memory **atau** SQLite) konsisten dalam sesi | 53.2 | gate |
| *(Bonus)* Persistence restart | **Hanya jalur B (SQLite).** Tutup aplikasi, buka lagi -> data tetap ada. Jalur A tidak dipenalti | 53.2 | |
| Serialization eksplisit | `toJson`/`fromJson` atau mapper setara; round-trip benar | 53.1 | |
| REST GET + write | `GET /tasks` + minimal satu dari POST/PUT/PATCH pada endpoint/mock dosen | 53.2 | |
| Error/network state | 4xx, 5xx, network-error terlihat berbeda; tidak crash | 92.1 | |
| Mode offline | Operasi lokal tetap jalan saat remote gagal; status lokal/sync sederhana terlihat | 53.2 | gate |
| Config tanpa secret | Base URL via `--dart-define`/`.env.example`; tidak ada hardcode secret | 53.2 | |
| Narasi AI + penjelasan | Narasi memuat alur data layer **dan** alur exception (status code -> `ApiError` -> `_error` -> UI), jalur lokal yang dipilih, serta saran AI yang ditolak; cocok dengan source | 92.2 | gate |

## 4. Proyek Akhir, QA, Release, dan Demo

Bukti: source, APK rilis, **Narasi Pemanfaatan AI 1000-1500 kata**, screenshot, README final (run, arsitektur, jalur lokal, fitur, limitation, bukti test), demo individual **tatap muka**. Satu-satunya tugas yang sampai release + demo.

| Indikator (observable) | Bukti yang dilihat | Area RPS | Gate |
|---|---|---|:---:|
| Fitur device | image picker/camera; bila tidak didukung -> gallery + permission/error branch | 92.2 | |
| Unit test ≥3 | Model/mapper/filter-validator; `flutter test` lulus | 92.2 | |
| Widget test ≥2 | Form validation + empty/error/list interaction; `flutter test` lulus | 92.2 | |
| Release APK | Build `flutter build apk --release` berhasil; APK terpasang dan jalan | 53.2 | |
| Tooling bersih | `flutter test` + `flutter analyze` bersih atau warning dijelaskan | 92.2 | |
| README final | Lengkap: run, arsitektur, jalur lokal (A/B), fitur, known limitation, bukti test | 92.2 | |
| Narasi AI final | Narasi memuat evolusi strategi AI, ≥3 kasus (≥1 penolakan), verifikasi, jalur end-to-end + dua `sealed` + alasan `const`, refleksi kejujuran; cocok dengan source **dan** jawaban lisan saat Q&A | 92.2 | gate |

## 5. Rubrik demo dan wawancara (P07)

Demo 7-10 menit + live modification 20-25 menit + Q&A.

| Indikator (observable) | Bukti yang dilihat | Area RPS | Gate |
|---|---|---|:---:|
| App walkthrough | Mendemonstrasikan alur utama tanpa kebingungan | 92.1 | |
| Code walkthrough | Menjelaskan widget tree, Provider, data flow, state; tahu letak logika | 53.1 | |
| Live modification | Menarik soal dari bank; menyelesaikan perubahan kecil sesuai kriteria | 53.1 | |
| Penjelasan kode berbantuan AI | Menjelaskan bagian yang dibantu AI; bukti penguasaan, bukan tempel | 92.2 | |
| Q&A | Menjawab pertanyaan "mengapa" dengan alasan teknis masuk akal | 92.2 | |
| Debugging hidup | Bila gagal di live mod, mampu membaca error dan mengoreksi arah | 53.1 | |

Soal live modification berasal dari bank soal (`05-Assessment/Bank-Live-Coding.md`, artefak tugas kanban terpisah): sorting, filter baru, validasi tanggal, empty state khusus, perubahan mapper JSON, dsb. Bank wajib punya kunci/rubrik dan variasi setara.

## 6. Konversi nilai dan aturan remidi

1. Skor tiap indikator -> 0-4 -> 0-100.
2. Akumulasi per area RPS (bobot di `Peta-Capaian-dan-Assessment.md` bagian 3): `Nilai = 0,30·A53.1 + 0,25·A92.1 + 0,20·A53.2 + 0,25·A92.2`.
3. Rubrik memberi skor mentah 0-100. **Konversi final** mengikuti aturan prodi/dosen untuk nilai maksimum remidi (misal pembatasan nilai remidi). Kebijakan default paket: rubrik skor 100; konversi ditangani dosen/prodi.
4. Indikator gate yang gagal pada demo P07 (code walkthrough, live modification, penjelasan AI) dapat membatalkan poin tugas terkait meski source baik.
5. **Narasi tertulis adalah gate di seluruh tugas.** Narasi generik tanpa detail spesifik proyek, atau yang tidak cocok dengan source/jawaban lisan, membatalkan poin dimensi fungsional tugas terkait.
6. **SQLite tidak boleh dijadikan syarat.** Menurunkan nilai submission jalur A (in-memory) karena tidak memakai SQLite adalah kesalahan penilaian.

---

**Perubahan v2.0 (2026-08-10):** penamaan Tugas 1/2/3 -> Assignment 1/2 + Proyek Akhir; bukti video dihapus (narasi tertulis + screenshot); SQLite jadi opsional/bonus; assignment berhenti di testing, release + demo hanya di Proyek Akhir.
