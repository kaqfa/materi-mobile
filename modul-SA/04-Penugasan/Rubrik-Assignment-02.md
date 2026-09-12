# Rubrik Assignment 2, Serialization dan API

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker | **Beban tugas:** 30%
**Mengukur brief:** `Assignment-02-Serialization-dan-API.md`
**Sumber kebenaran asesmen:** `../00-Planning/Peta-Capaian-dan-Assessment.md`, `../00-Planning/Rubrik-Remedial.md`

> **Aturan:** rubrik menilai **indikator observable** (yang terlihat dan bisa diverifikasi), bukan niat. Aplikasi saja tidak cukup; **Narasi Pemanfaatan AI** + bukti visual wajib. Indikator bertanda **(gate)** yang gagal membatalkan poin indikator turunan yang bergantung padanya. Seluruh gate dapat dinilai di **mode mock** (tanpa server pribadi/akun berbayar).

> **Bukti visual = screenshot**; bukti pemahaman = **narasi tertulis** (brief §5.1).

> **SQLite opsional.** Mahasiswa memilih **jalur A (in-memory)** atau **jalur B (SQLite)** (brief §3.1). Keduanya dapat mencapai **skor 3 ("Baik") pada seluruh indikator**. Jalur B hanya membuka akses ke **skor 4 ("Sangat Baik")** pada indikator bertanda **(bonus B)**. **Menurunkan nilai submission jalur A karena tidak memakai SQLite adalah kesalahan penilaian.**

---

## 1. Cara pakai rubrik

1. Tiap indikator dinilai skala **0-4** (tabel §2).
2. Skor dikonversi ke poin per dimensi: `poin dimensi = (rata-rata skor indikator dimensi / 4) × bobot dimensi`.
3. Jumlah total = **100 poin**.
4. Indikator **gate** yang dapat skor 0 -> semua indikator turunan di dimensi itu dipaksa 0.
5. Penilaian final memperhitungkan **narasi/penjelasan tertulis** (dimensi D), source tanpa narasi yang meyakinkan dapat dibatalkan sesuai `Rubrik-Remedial.md` §3 (gate "AI log + penjelasan") dan §6.

### Skala 0-4

| Skor | Label | Definisi |
|---:|---|---|
| 4 | Sangat Baik | Semua kriteria tercapai, konsisten, plus bukti tambahan (edge case, test tambahan, dokumentasi tajam, 5xx eksplisit, **atau jalur B/SQLite terbukti** pada indikator bertanda (bonus B)). |
| 3 | Baik | Seluruh kriteria inti tercapai; catatan minor saja. |
| 2 | Cukup | Sebagian kriteria inti tercapai; ada kekurangan yang dapat diperbaiki dalam sesi. |
| 1 | Kurang | Hanya sebagian kecil tercapai; banyak kerentanan/broken state. |
| 0 | Tidak ada / tidak jujur | Indikator tidak ada, atau ditemukan plagiarisme/penjelasan tidak menguasai kode sendiri. |

---

## 2. Dimensi dan indikator (total 100 poin)

### Dimensi A, Serialization & API (35 poin)
*Mengukur: CRUD lokal, JSON round-trip, REST GET + write, dua jalur submission. Area RPS 53.2 (utama) + 53.1 (serialization).*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| A1 | CRUD lokal end-to-end | Add/edit/delete/toggle bekerja pada sumber lokal (in-memory **atau** SQLite); data konsisten dalam sesi | gate |
| A2 | `GET /tasks` bekerja | List tampil data (mock fixture default / server via `--dart-define`) | gate |
| A3 | Minimal satu write (POST/PATCH/DELETE) | Operasi write terhubung client; mode mock -> perubahan terlihat dalam sesi | gate |
| A4 | `toJson`/`fromJson` cocok kontrak | Snake_case (`due_date`/`is_completed`/`priority`), boolean JSON native, ISO date; cocok `API-CONTRACT.md` §3.1 | |
| A5 | Round-trip JSON lossless | `Task -> toJson -> fromJson -> Task'` menjaga field; enum `.name`/`.byName` konsisten | |
| A6 | Dua jalur submission terdokumentasi | README menjelaskan (A) endpoint dosen via `--dart-define` **dan** (B) fixture/mock fallback default; keduanya menghasilkan behavior sama | |
| A7 | **(bonus B)** Persistensi SQLite terbukti | *Jalur A: nilai 3 bila CRUD lokal in-memory konsisten + limitasi dicatat di README.* Jalur B untuk skor 4: data bertahan lintas restart (screenshot sebelum/sesudah), `TaskMapper` benar (ISO date, enum name, bool 0/1), mapper SQLite vs JSON tidak tertukar, `task_mapper_test` + `local_task_datasource_test` hijau. | |

**Konversi:** `poin A = (rata2 A1-A7 / 4) × 35`.

> **A7 dan keadilan antar-jalur:** mahasiswa jalur A yang memenuhi seluruh kriteria mendapat **3** di A7, bukan 0 dan bukan N/A. Skor 4 disediakan bagi yang membuktikan jalur B. Selisih satu poin skala pada satu indikator dari tujuh ini adalah **bentuk bonus yang dimaksud**, bukan penalti bagi jalur A.

### Dimensi B, Error UX & Mode Offline (30 poin)
*Mengukur: loading/empty/4xx/5xx/network terlihat + retry + mode offline. Area RPS 92.1 (error/empty state) + 53.2 (offline).*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| B1 | Loading & empty state terlihat | Spinner saat async; empty state saat tabel/hasil kosong (bukan layar blank) | |
| B2 | Network error + retry | `simulateNetworkError`/putus jaringan -> `cloud_off` + pesan + tombol Retry yang memanggil ulang operasi | gate |
| B3 | Client error (4xx/404) dibedakan | Create duplikat -> `ClientError 409`; id hilang -> `NotFoundError`; pesan membedakan dari network | |
| B4 | Server error (5xx) terbukti | 5xx terlihat di UI **atau** dibuktikan via `api_error_test.dart` (`mapResponseToError(503)` -> `ServerError`); flag demo-only diterima | |
| B5 | Mode offline: lokal tetap jalan | Remote gagal -> operasi lokal tetap berhasil (data tersimpan di sumber lokal apa pun jalurnya, tidak hilang/crash) | gate |
| B6 | Indikator lokal/sync sederhana | Chip/badge/teks membedakan "online/sync" vs "offline/lokal-only"; pulih setelah retry | |

**Konversi:** `poin B = (rata2 B1-B6 / 4) × 30`.

> **Syarat bukti B2/B3:** wajib ada **screenshot** state error + tombol Retry, dan screenshot `ClientError 409`/`NotFoundError` (lihat brief §5). Tanpa bukti visual, B2/B3 maksimal skor 2.

### Dimensi C, Architecture & Code Quality (20 poin)
*Mengukur: layer separation, abstraksi `TaskRepository`, no-secret, tooling. Area RPS 53.2 (indikator pendukung).*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| C1 | Layer terpisah | datasource (lokal+remote) -> repository -> provider; UI hanya kenal abstraksi `TaskRepository`, bukan `http` (atau `sqflite`) langsung | |
| C2 | Abstraksi `TaskRepository` dimanfaatkan | Repository koordinator (mis. `OfflineFirstTaskRepository`) mendelegasi lokal + remote via interface yang sama. **(bonus B)** skor 4 bila datasource lokalnya SQLite dan pergantian sumber tidak mengubah UI. | |
| C3 | `flutter analyze` bersih/dijelaskan | Output bersih, **atau** setiap warning/info dijelaskan di README + alasan | gate |
| C4 | `flutter test` lulus | `api_error_test` + `mock_task_api_client_test` + round-trip JSON hijau; jalur B menambah `task_mapper_test` + `local_task_datasource_test`. Menulis test sendiri = bonus, bukan gate. | gate |
| C5 | Immutability + `copyWith` | `Task` diubah lewat `copyWith`; `List.unmodifiable` di getter; tidak mutasi field final | |
| C6 | Tidak ada secret/credential | Base URL/token hanya via `--dart-define`; `.env.example` placeholder; tidak ada hardcode host/token/IP di source/README | |

**Konversi:** `poin C = (rata2 C1-C6 / 4) × 20`.

### Dimensi D, Narasi AI & Dokumentasi (15 poin)
*Mengukur: narasi tertulis alur data + exception, README, AI log. Area RPS 92.2 (dokumentasi) + 53.1 (penjelasan).*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| D1 | Narasi memuat strategi & keputusan AI | Narasi 800-1200 kata memuat strategi + contoh prompt konkret, dan **minimal dua kasus**: satu saran diterima + alasan, satu **ditolak** + alasan teknis (mis. menolak auto-retry, menolak `catch` yang menelan error). | gate |
| D2 | Narasi menjelaskan alur data **dan** alur exception | Alur UI -> provider -> repository koordinator -> lokal/remote, **dan** alur HTTP status -> `mapResponseToError` -> `sealed ApiError` -> `_error` -> UI, termasuk **kenapa jenis error ditentukan dari status code bukan body**. Penjelasan **cocok dengan source**. | gate |
| D3 | Narasi menyebut jalur lokal + verifikasi | Menyatakan jalur A/B yang dipilih beserta alasannya, dan cara memverifikasi kebenaran data layer (`flutter test`, uji `simulateNetworkError`) + bukti terlampir. | |
| D4 | AI log lengkap bila pakai AI | Bila memakai AI: tiap interaksi mencatat tujuan, prompt, ringkasan, dipilih/ditolak, verifikasi. Bila **tidak** memakai AI dan narasi 500-800 kata terisi konsisten: skor penuh (N/A, bukan nol). | |
| D5 | README rapi & lengkap | Pakai `Template-Submission-README.md`; run dua jalur (mock + live), arsitektur, jalur lokal, limitation, bukti analyze+test | |

**Konversi:** `poin D = (rata2 D1-D5 / 4) × 15`.

> **Gate D1/D2:** gagal (skor 0) karena narasi generik tanpa detail spesifik proyek, narasi **tidak cocok dengan source**, atau plagiarisme -> poin dimensi **A dan B juga dipaksa 0** (aturan `Rubrik-Remedial.md` §6: nilai aplikasi saja tidak cukup).

---

## 3. Lembar skor (contoh)

**Jalur lokal mahasiswa:** `[ ] A (in-memory)` `[ ] B (SQLite)` — dicatat dari README.

| Dimensi | Bobot | Indikator (skor 0-4) | Rata-rata | Poin |
|---|---:|---|---:|---:|
| A, Serialization & API | 35 | A1 A2 A3 A4 A5 A6 A7 = _ _ _ _ _ _ _ | __ | __ / 35 |
| B, Error UX & offline | 30 | B1 B2 B3 B4 B5 B6 = _ _ _ _ _ _ | __ | __ / 30 |
| C, Architecture & code quality | 20 | C1 C2 C3 C4 C5 C6 = _ _ _ _ _ _ | __ | __ / 20 |
| D, Narasi AI & dokumentasi | 15 | D1 D2 D3 D4 D5 = _ _ _ _ _ | __ | __ / 15 |
| **Total** | **100** | | | **__ / 100** |

---

## 4. Bukti wajib (otomatis memengaruhi penilaian)

- **Source/ZIP** + repo URL bila ada, dapat di-build di mesin bersih (`flutter create` -> `flutter pub get`).
- **Narasi Pemanfaatan AI 800-1200 kata** (brief §5.1).
- **Screenshot**, list tampil (mock/fixture), loading, empty state, state error (`cloud_off` + Retry), 4xx (`ClientError 409`/`NotFoundError`), indikator offline/lokal. **Jalur B:** tambahan screenshot sebelum/sesudah restart.
- **Bukti test**, output `flutter test`, termasuk `api_error_test.dart` yang menunjukkan `503 -> ServerError` sebagai bukti 5xx.
- **README** memakai `Template-Submission-README.md` + dua jalur run (mock + live) + jalur lokal yang dipilih.
- **API config** (`.env.example`/`--dart-define` docs), tanpa secret nyata.
- **AI Interaction Log**, wajib bila memakai AI (`../01-Orientasi/Template-AI-Interaction-Log.md`).

> **Tidak mewajibkan server pribadi/akun berbayar:** seluruh gate dapat dinilai di mode mock default (`MockTaskApiClient`). Endpoint dosen via `--dart-define` adalah jalur tambahan, bukan syarat.

---

## 5. Quick reference: red flags (skor rendah otomatis)

- CRUD lokal tidak konsisten dalam sesi (add/edit hilang tanpa sebab) -> A1 = 0 (gate) -> dimensi A turun.
- `is_completed` 0/1 di JSON (bukan boolean) -> A4 ≤ 1; jalur B yang mencampur mapper SQLite dan JSON -> A7 ≤ 2.
- Nama field JSON camelCase (`dueDate`) -> A4 ≤ 1 (kontrak dilanggar).
- GET saja, tidak ada write terhubung -> A3 = 0 (gate) -> dimensi A turun.
- Operasi gagal diam-diam tanpa `_error` / tanpa retry -> B2 ≤ 1.
- Saat remote gagal, lokal juga gagal/crash -> B5 ≤ 1 (mode offline gagal).
- UI langsung import `http`/`sqflite` (bypass repository) -> C1 ≤ 1.
- Secret/token di-hardcode di source/README -> C6 = 0.
- `flutter analyze` merah dan tidak dijelaskan -> C3 = 0 (gate) -> dimensi C turun.
- Narasi generik tanpa detail spesifik proyek -> D1 ≤ 1; tanpa satu pun saran AI yang ditolak -> D1 ≤ 2.
- Narasi tidak menjelaskan alur exception, atau tidak cocok dengan source -> D2 = 0 (gate) -> dimensi A & B juga 0.

> **Bukan red flag:** memilih jalur A (tanpa SQLite) dan data hilang setelah restart. Itu konsekuensi jalur yang sah selama dicatat di README, **bukan pengurang nilai**.

---

## 6. Konversi nilai akhir

1. Skor mentah rubrik = 0-100.
2. Assignment 2 berkontribusi ke **area RPS 53.2 (serialization/REST) sebagai bukti utama**, plus indikator pendukung 53.1 (serialization) dan 92.1 (error/empty state UI) serta 92.2 (narasi AI). Pemetaan di `../00-Planning/Peta-Capaian-dan-Assessment.md` §6.
3. Konversi nilai remidi final (termasuk pembatasan maksimum) mengikuti aturan prodi/dosen (`Rubrik-Remedial.md` §6).

---

**Status rubrik:** v2.0, 2026-08-10 | **Konsistensi:** jika ada pertentangan angka dengan `Peta-Capaian-dan-Assessment.md`, dokumen tersebut yang menang.

**Perubahan v2.0:** Rubrik Tugas 2 -> Rubrik Assignment 2; dimensi "Local Persistence (SQLite)" **dihapus** sebagai dimensi mandiri, SQLite jadi bonus di A7/C2; bobot direalokasi (Serialization & API 25->35, Error UX 20->30, Architecture 15->20, Narasi 15); bukti pemahaman berupa screenshot + narasi tertulis; 5 dimensi -> 4 dimensi; beban 35% -> 30%.
