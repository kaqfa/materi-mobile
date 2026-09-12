# Rubrik Assignment 1, Task Tracker Core

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker | **Beban tugas:** 30%
**Mengukur brief:** `Assignment-01-Task-Tracker-Core.md`
**Sumber kebenaran asesmen:** `../00-Planning/Peta-Capaian-dan-Assessment.md`, `../00-Planning/Rubrik-Remedial.md`

> **Aturan:** rubrik menilai **indikator observable** (yang terlihat dan bisa diverifikasi), bukan niat. Aplikasi saja tidak cukup; **Narasi Pemanfaatan AI** wajib. Indikator bertanda **(gate)** yang gagal membatalkan poin indikator turunan yang bergantung padanya.

> **Bukti visual = screenshot**; bukti pemahaman = **narasi tertulis** (brief §5.1).

---

## 1. Cara pakai rubrik

1. Tiap indikator dinilai skala **0-4** (tabel §2).
2. Skor dikonversi ke poin per dimensi: `poin dimensi = (rata-rata skor indikator dimensi / 4) × bobot dimensi`.
3. Jumlah total = **100 poin**.
4. Indikator **gate** yang dapat skor 0 -> semua indikator turunan di dimensi itu dipaksa 0.
5. Penilaian final memperhitungkan **narasi/penjelasan tertulis** (dimensi E), source tanpa narasi yang meyakinkan dapat dibatalkan sesuai `Rubrik-Remedial.md` §6.

### Skala 0-4

| Skor | Label | Definisi |
|---:|---|---|
| 4 | Sangat Baik | Semua kriteria tercapai, konsisten, plus bukti tambahan (edge case, test tambahan, dokumentasi tajam). |
| 3 | Baik | Seluruh kriteria inti tercapai; catatan minor saja. |
| 2 | Cukup | Sebagian kriteria inti tercapai; ada kekurangan yang dapat diperbaiki dalam sesi. |
| 1 | Kurang | Hanya sebagian kecil tercapai; banyak kerentanan/broken state. |
| 0 | Tidak ada / tidak jujur | Indikator tidak ada, atau ditemukan plagiarisme/penjelasan tidak menguasai kode sendiri. |

---

## 2. Dimensi dan indikator (total 100 poin)

### Dimensi A, Fungsionalitas (25 poin)
*Mengukur: model, CRUD lengkap, search+filter, toggle. Area RPS 53.1.*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| A1 | Model `Task` dipakai apa adanya | Field `id`/`title`/`description`/`dueDate`/`priority`/`isCompleted` + getter `status` benar; enum konsisten | |
| A2 | Daftar + detail + add/edit + delete | Navigasi bekerja; delete meminta **konfirmasi dialog**; toggle completion jalan | |
| A3 | Search title reaktif | Case-insensitive, update saat mengetik, benar pada data nyata | |
| A4 | Filter status **dan** priority reaktif | Keduanya bekerja; hasil benar pada dataset dengan overdue + completed | |
| A5 | Kombinasi search + filter (AND) | Hasil = cocok query **dan** status **dan** priority terpilih | |
| A6 | Toggle completion idempotent | Dua kali tap kembali semula; status chip/update real-time | |

**Konversi:** `poin A = (rata2 A1-A6 / 4) × 25`.

### Dimensi B, State & Data Flow (25 poin)
*Mengukur: Provider reaktif, watch/read, konsistensi lintas layar. Area RPS 53.1.*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| B1 | Provider CRUD | `ChangeNotifier`/Provider; mutasi lewat `addTask`/`updateTask`/`deleteTask`/`toggleComplete` | |
| B2 | `notifyListeners()` konsisten | Setiap mutasi memanggilnya; UI update **tanpa `setState` manual** di list/detail | |
| B3 | `watch` vs `read` benar | `watch` di `build` (rebuild), `read` di handler (sekali pakai); tidak tertukar | |
| B4 | State UX terlihat | loading, error, empty state muncul pada kondisi sesuai (termasuk hasil filter/search kosong) | |
| B5 | Konsistensi lintas layar | Edit/toggle di satu layar -> list dan detail ikut update otomatis | |

**Konversi:** `poin B = (rata2 B1-B5 / 4) × 25`.

### Dimensi C, UI & Responsive (20 poin)
*Mengukur: Material 3, tidak overflow dua orientasi, validasi form. Area RPS 92.1.*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| C1 | Material 3 konsisten | Tema `AppTheme`/`useMaterial3`; komponen sesuai | |
| C2 | Tidak overflow portrait | Screenshot portrait ponsel; tidak ada overflow horizontal/vertikal | |
| C3 | Tidak overflow landscape | Screenshot landscape ponsel; layout menyesuaikan (mis. 2 kolom saat ≥ 600) | |
| C4 | Rotasi tidak rusak state | Rotasi cepat portrait/landscape tidak menghilangkan data/merusak state | |
| C5 | Form validation title | Menolak kosong/whitespace (`errTitleRequired`) dan < 3 char (`errTitleTooShort`); pesan jelas | |
| C6 | Validasi due date tidak lampau (add) | Menolak tanggal lampau saat add; pesan jelas (`errDueDateInPast`/setara) | |

**Konversi:** `poin C = (rata2 C1-C6 / 4) × 20`.

> **Syarat bukti C2/C3:** wajib ada **screenshot portrait + landscape** (lihat brief §5). Tanpa bukti visual, C2/C3 maksimal skor 2.

### Dimensi D, Kualitas Kode & Tooling (15 poin)
*Mengukur: `flutter analyze`, struktur, immutability. Area RPS 53.2 (indikator pendukung).*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| D1 | `flutter analyze` bersih atau dijelaskan | Output bersih, **atau** setiap warning/info dijelaskan di README + alasan | |
| D2 | `flutter test` lulus | Minimal test bawaan starter hijau; tambahan = bonus | |
| D3 | Struktur & naming rapi | Folder `core/`/`features/` konsisten; nama variabel/ fungsi self-explanatory | |
| D4 | Immutability + `copyWith` | `Task` diubah lewat `copyWith`; tidak mutasi field final; `List.unmodifiable` dijaga | |
| D5 | Tidak menambah package tanpa izin | Hanya `provider` + `flutter_lints` (atau seizin dosen) | |

**Konversi:** `poin D = (rata2 D1-D5 / 4) × 15`.

### Dimensi E, Narasi AI & Dokumentasi (15 poin)
*Mengukur: narasi tertulis, penguasaan kode, AI log, README. Area RPS 92.2.*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| E1 | Narasi memuat strategi & keputusan AI | Narasi 800-1200 kata memuat strategi pemanfaatan AI (+ contoh prompt konkret) dan **minimal dua kasus**: satu saran diterima + alasan, satu saran **ditolak** + alasan teknis. Kasus penolakan yang spesifik = indikator penguasaan terkuat. | gate |
| E2 | Narasi menjelaskan satu alur end-to-end | Menjelaskan dengan kata sendiri alur search+filter AND **atau** add task: `watch`/`read`, mutasi provider, `notifyListeners()`, rebuild. Penjelasan **cocok dengan source** yang dikumpulkan. | gate |
| E3 | Narasi menunjukkan cara verifikasi | Menyebut cara membuktikan kode benar (`flutter analyze`/`flutter test`/uji manual) + bukti terlampir; bukan klaim kosong. | |
| E4 | AI log lengkap bila pakai AI | Bila memakai AI: tiap interaksi mencatat tujuan, prompt, ringkasan, perubahan dipilih/ditolak, verifikasi. Bila **tidak** memakai AI dan narasi versi 500-800 kata terisi konsisten: skor penuh (N/A, bukan nol). | |
| E5 | README rapi & lengkap | Pakai `Template-Submission-README.md`; run, fitur, arsitektur, limitation, bukti analyze + test | |

**Konversi:** `poin E = (rata2 E1-E5 / 4) × 15`.

> **Gate E1/E2:** gagal (skor 0) karena narasi generik/normatif tanpa detail spesifik proyek, narasi **tidak cocok dengan source** yang dikumpulkan, atau plagiarisme -> poin dimensi **A dan B juga dipaksa 0** (aturan `Rubrik-Remedial.md` §6: nilai aplikasi saja tidak cukup).

> **Cara menilai narasi (panduan dosen):** narasi kuat menyebut nama file/class/variabel milik mahasiswa sendiri, alasan teknis yang bisa salah (bukan aman-normatif), dan kasus penolakan saran AI yang masuk akal. Narasi lemah berisi kalimat umum seperti "AI sangat membantu saya memahami Flutter" tanpa satu pun detail yang hanya bisa ditulis orang yang mengerjakan proyek itu. Bila ragu, tandai sebagai temuan integritas dan periksa kecocokan narasi dengan source (nama file/class yang disebut benar-benar ada dan berperilaku seperti yang ditulis).

---

## 3. Lembar skor (contoh)

| Dimensi | Bobot | Indikator (skor 0-4) | Rata-rata | Poin |
|---|---:|---|---:|---:|
| A, Fungsionalitas | 25 | A1 A2 A3 A4 A5 A6 = _ _ _ _ _ _ | __ | __ / 25 |
| B, State & data flow | 25 | B1 B2 B3 B4 B5 = _ _ _ _ _ | __ | __ / 25 |
| C, UI & responsive | 20 | C1 C2 C3 C4 C5 C6 = _ _ _ _ _ _ | __ | __ / 20 |
| D, Kualitas kode & tooling | 15 | D1 D2 D3 D4 D5 = _ _ _ _ _ | __ | __ / 15 |
| E, Narasi AI & dokumentasi | 15 | E1 E2 E3 E4 E5 = _ _ _ _ _ | __ | __ / 15 |
| **Total** | **100** | | | **__ / 100** |

---

## 4. Bukti wajib (otomatis memengaruhi penilaian)

- **Source/ZIP** + repo URL bila ada, dapat di-build di mesin bersih.
- **Narasi Pemanfaatan AI 800-1200 kata** (brief §5.1).
- **Screenshot portrait + landscape**, bukti tidak overflow (wajib untuk C2/C3).
- **Screenshot flow utama**, CRUD, toggle, search+filter aktif bersamaan, pesan validasi.
- **README** memakai `Template-Submission-README.md`.
- **AI Interaction Log**, wajib bila memakai AI (`../01-Orientasi/Template-AI-Interaction-Log.md`).

---

## 5. Quick reference: red flags (skor rendah otomatis)

- Search atau filter hanya bekerja sendiri, tidak AND -> A5 ≤ 1.
- Mutasi data tanpa `notifyListeners` -> B2 ≤ 1 (UI diam).
- `context.read` di `build` atau `context.watch` di handler -> B3 ≤ 1.
- Tidak ada screenshot landscape -> C3 maksimal 2.
- `flutter analyze` merah dan tidak dijelaskan -> D1 = 0 (gate) -> dimensi D turun.
- Narasi generik tanpa detail spesifik proyek (tidak menyebut file/class/keputusan sendiri) -> E1 ≤ 1.
- Narasi tidak memuat satu pun saran AI yang **ditolak** beserta alasannya -> E1 ≤ 2.
- Penjelasan alur di narasi tidak cocok dengan source yang dikumpulkan -> E2 = 0 (gate) -> dimensi A & B juga 0.

---

## 6. Konversi nilai akhir

1. Skor mentah rubrik = 0-100.
2. Assignment 1 berkontribusi ke **area RPS 53.1 (Dart, widget, state) dan 92.1 (UI interaktif responsive)** sebagai bukti utama, plus indikator pendukung 92.2 (narasi AI) dan 53.2 (tooling). Pemetaan di `../00-Planning/Peta-Capaian-dan-Assessment.md` §6.
3. Konversi nilai remidi final (termasuk pembatasan maksimum) mengikuti aturan prodi/dosen (`Rubrik-Remedial.md` §6).

---

**Status rubrik:** v2.0, 2026-08-10 | **Konsistensi:** jika ada pertentangan angka dengan `Peta-Capaian-dan-Assessment.md`, dokumen tersebut yang menang.

**Perubahan v2.0:** Rubrik Tugas 1 -> Rubrik Assignment 1; bukti pemahaman berupa screenshot + narasi tertulis; dimensi E dirombak jadi "Narasi AI & Dokumentasi" (E1-E5); beban 35% -> 30%.
