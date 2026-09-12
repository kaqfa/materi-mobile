# Rubrik Demo dan Wawancara, P07 Final (Dosen)

> **Status:** v2.0, 2026-08-10
> **Aplikasi jangkar:Remedial Task Tracker**
> **Untuk:** dosen/asisten menilai **demo individual + live modification + Q&A** di sesi final P07.
> **Sumber:** `../00-Planning/Rubrik-Remedial.md` §5, `../00-Planning/Peta-Capaian-dan-Assessment.md` §3, `../02-Materi/P07-Release-Live-Coding-Demo.md`.
> **Soal live mod:** `Bank-Live-Coding.md`. **Rubrik Proyek Akhir:** `../04-Penugasan/Rubrik-Proyek-Akhir.md`.

## 0. Format sesi final (per mahasiswa)

| Blok | Durasi | Aktivitas |
|---|---:|---|
| App walkthrough | 2-3 menit | Demo alur utama pada APK rilis (CRUD, API/error, device; + persistensi pasca-restart bila mahasiswa memilih jalur B/SQLite) |
| Code walkthrough | 3-4 menit | Jelaskan satu jalur end-to-end + dua `sealed` (`ApiError`, `AttachmentResult`) |
| Live modification | 20-25 menit | Dosen tarik satu soal dari `Bank-Live-Coding.md`; mahasiswa selesaikan + `analyze`/`test` hijau |
| Q&A | 5 menit | Tanya "mengapa", `sealed`/const/status-vs-body/alur exception |
| **Total** | **±35 menit** | |

> **Demo ini dilakukan tatap muka.** Walkthrough disampaikan langsung di sesi final.

> **Baca narasi lebih dulu.** Sebelum sesi, baca **Narasi Pemanfaatan AI** mahasiswa (README §7). Susun pertanyaan Q&A dari isi narasinya, khususnya bagian yang ia klaim dikerjakan sendiri dan saran AI yang ia klaim ditolak. **Ketidakcocokan narasi dengan jawaban lisan adalah temuan integritas**, bukan sekadar skor rendah, tangani sesuai `../00-Planning/Rubrik-Remedial.md` §5-§6.

> **SQLite opsional.** Jangan menuntut bukti persistensi pasca-restart dari mahasiswa jalur A (in-memory). Itu pilihan yang sah dan tidak mengurangi nilai.

> **Prasyarat gate:** demo hanya berjalan bila `flutter analyze` + `flutter test` + `flutter build apk --release` **hijau pada submission** (Proyek Akhir gate C). Gate merah -> demo ditunda (planning §9).

## 1. Skala penilaian

Skala 0-4 per indikator (sama dengan `Rubrik-Remedial.md` §1).

| Skor | Label | Definisi |
|---:|---|---|
| 4 | Sangat Baik | Semua kriteria tercapai, konsisten, plus bukti tambahan (debug hidup sukses, penjelasan tajam, edge case). |
| 3 | Baik | Seluruh kriteria inti tercapai; catatan minor saja. |
| 2 | Cukup | Sebagian kriteria inti tercapai; ada kebingungan yang dapat diluruskan. |
| 1 | Kurang | Hanya sebagian kecil tercapai; banyak kebingungan/terbata-bata. |
| 0 | Tidak ada / tidak jujur | Indikator tidak tercapai, atau ditemukan plagiarisme/tidak menguasai kode sendiri. |

> Skor 0 pada indikator **(gate)** membatalkan poin tugas terkait meski source baik (`Rubrik-Remedial.md` §4-§5: nilai aplikasi saja tidak cukup).

## 2. Dimensi dan indikator (total 100 poin)

### Dimensi A, App Walkthrough (15 poin)
*Mengukur: mendemonstrasikan alur utama tanpa kebingungan. Area RPS 92.1.*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| A1 | Launch tanpa crash pada APK rilis | App terbuka, home tampil, navigasi dasar jalan | |
| A2 | Demo CRUD task | Add -> list reaktif; edit -> berubah; delete -> konfirmasi + hilang; toggle | |
| A3 | Demo persistensi pasca-restart | Kill app -> buka lagi -> data tetap (SQLite) | |
| A4 | Demo API/error + retry | `simulateNetworkError`/putus jaringan -> error view + Retry; 4xx dibedakan | |
| A5 | Demo device attachment | Gallery pick -> tampil; tolak izin -> banner denied (bukan crash) | |

**Konversi:** `poin A = (rata2 A1-A5 / 4) × 15`.

### Dimensi B, Code Walkthrough (20 poin)
*Mengukur: menjelaskan widget tree, Provider, data flow, dua `sealed`. Area RPS 53.1.*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| B1 | Jelaskan satu jalur end-to-end | UI -> `TaskProvider` -> `TaskRepository` -> datasource (lokal/remote); tahu letak logika | |
| B2 | Jelaskan `sealed ApiError` | Menyebut exhaustive switch; **error HTTP dari status code bukan body** | |
| B3 | Jelaskan `sealed AttachmentResult` | success/denied/permission-error; switch exhaustif menolak cabang terlupakan | |
| B4 | Jelaskan `notifyListeners`/watch vs read | Menjelaskan kapan rebuild; bukan `setState` brutal | |
| B5 | Tahu letak logika filter/search | Menunjuk `TaskFilterService`; menjelaskan AND | |

**Konversi:** `poin B = (rata2 B1-B5 / 4) × 20`.

> **Gate B1/B2:** gagal (tidak bisa menjelaskan jalur end-to-end / alasan error-dari-status) -> indikator turunan B turun; flag untuk membatalkan poin Proyek Akhir (lihat §4).

### Dimensi C, Live Modification (35 poin)
*Mengukur: menyelesaikan soal bank sesuai kriteria + jaga gate + jelaskan. Area RPS 53.1 (utama).*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| C1 | Baca soal + tanya klarifikasi | Tidak asumsi; identifikasi file target sebelum ngetik | |
| C2 | Implementasi sesuai kriteria soal | Kriteria sukses soal (`Bank-Live-Coding.md`) tercapai | |
| C3 | `const`/lint tetap bersih | Tidak `// ignore:` tanpa alasan; subtree immutable `const` | |
| C4 | `flutter analyze` + `flutter test` hijau pasca-mod | Jalankan keduanya; hijau (atau test baru sesuai perubahan) | |
| C5 | Debug hidup bila gagal | Bila error, baca pesan & koreksi arah (bukan menyerah/force-hijau) | |
| C6 | Jelaskan perubahan + trade-off | Menjelaskan kenapa pendekatan ini, apa trade-off-nya | |

**Konversi:** `poin C = (rata2 C1-C6 / 4) × 35`.

> **Gate C2/C4/C6:** gagal (tidak mencapai kriteria soal / gate merah tanpa perbaikan / tidak bisa menjelaskan) -> **live modification = 0**; poin tugas terkait dapat dibatalkan (`Rubrik-Remedial.md` §4). Live modification **tidak dapat digantikan source code**.

### Dimensi D, Penjelasan Kode Berbantuan AI (15 poin)
*Mengukur: penguasaan atas bagian AI; bukti pemahaman, bukan tempel. Area RPS 92.2.*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| D1 | Transparansi bantuan AI | Bila memakai AI: akurat menyebut mapper/wiring/repository/dll yang dibantu. Bila tidak memakai AI dan konsisten saat demo: skor penuh (N/A, bukan nol). | |
| D2 | Jelaskan ulang dengan kata sendiri | Mampu menjelaskan logika bagian AI bila ada, atau seluruh kode sendiri bila tidak memakai AI; bukan hafalan | |
| D3 | AI log lengkap & konsisten | Bila memakai AI: `Template-AI-Interaction-Log.md` terisi tujuan, prompt, ringkasan, perubahan dipilih/ditolak, verifikasi. Bila tidak memakai AI: N/A, bukan nol. | |
| D4 | Konsisten saat demo | Tidak ada bagian kode yang tidak dapat dijelaskan; klaim pemakaian AI konsisten dengan log/bukti | |

**Konversi:** `poin D = (rata2 D1-D4 / 4) × 15`.

> **Gate D1/D2:** gagal (plagiarisme / tidak menguasai kode sendiri) -> poin tugas terkait dapat dibatalkan (`Rubrik-Proyek-Akhir.md` gate E, `Rubrik-Remedial.md` §4).

### Dimensi E, Q&A "Mengapa" (15 poin)
*Mengukur: alasan teknis masuk akal. Area RPS 92.2 + 53.1.*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| E1 | "Kenapa `sealed` aman?" | Exhaustive switch; compiler tolak cabang terlupakan | |
| E2 | "Kenapa error HTTP dari status bukan body?" | Body bisa berubah/berbahasa asing; status = kontrak HTTP | |
| E3 | "Kenapa subtree ini `const`?" | Instance reuse; Flutter skip rebuild | |
| E4 | "Kenapa lokal source of truth?" | Offline tetap jalan; remote best-effort | |
| E5 | "Kenapa `--dart-define` bukan hardcode?" | Base URL = input dosen; hindari secret di repo | |

**Konversi:** `poin E = (rata2 E1-E5 / 4) × 15`. Dosen pilih ≥3 dari E1-E5 sesuai konteks.

## 3. Lembar skor (contoh)

| Dimensi | Bobot | Indikator (skor 0-4) | Rata-rata | Poin |
|---|---:|---|---:|---:|
| A, App walkthrough | 15 | A1 A2 A3 A4 A5 = _ _ _ _ _ | __ | __ / 15 |
| B, Code walkthrough | 20 | B1 B2 B3 B4 B5 = _ _ _ _ _ | __ | __ / 20 |
| C, Live modification | 35 | C1 C2 C3 C4 C5 C6 = _ _ _ _ _ _ | __ | __ / 35 |
| D, Penjelasan kode berbantuan AI | 15 | D1 D2 D3 D4 = _ _ _ _ | __ | __ / 15 |
| E, Q&A "mengapa" | 15 | E1 E2 E3 E4 E5 = _ _ _ _ _ (pilih ≥3) | __ | __ / 15 |
| **Total** | **100** | | | **__ / 100** |

## 4. Kontribusi ke area RPS & aturan gate

- **Demo + live modification** berkontribusi ke **Sub-CPMK 53.1** (live modification = Dart/widget/state) dan **Sub-CPMK 92.2** (demo/wawancara/dokumentasi), bobot di `Peta-Capaian-dan-Assessment.md` §3 (30% + 25%).
- **Gate yang dapat membatalkan poin tugas:**
 - C2/C4/C6 gagal -> **live modification = 0**; poin Proyek Akhir (dan area 53.1) dapat dibatalkan.
 - B1/B2 gagal (tidak bisa menjelaskan jalur end-to-end / error-dari-status) -> flag; bila disertai D1/D2 gagal (plagiarisme) -> poin Proyek Akhir dipaksa 0 sesuai `Rubrik-Proyek-Akhir.md` gate E.
 - A1 gagal (crash pada APK rilis) -> demo ditunda (gate Proyek Akhir C1/C2 belum hijau).
- **Tidak mewajibkan Play Store/signing:** demo pada APK `flutter build apk --release` (debug-sign/unsigned) + install manual sudah memadai (planning §2).

## 5. Quick reference: red flags (skor rendah otomatis)

- App crash saat launch -> A1 = 0 (gate) -> demo ditunda.
- Tidak bisa menunjuk file/logika filter/search -> B5 ≤ 1.
- Error HTTP dibaca dari body, bukan status -> B2 ≤ 1.
- Live mod: gate merah & "dipaksa hijau" via ignore/skip -> C4 = 0 (gate) -> C = 0.
- Live mod tidak mencapai kriteria soal -> C2 = 0 (gate) -> C = 0.
- Tidak bisa menjelaskan bagian AI -> D1/D2 = 0 (gate) -> flag pembatalan poin Proyek Akhir.
- "Kenapa const?" dijawab "biar bersih" tanpa mekanisme rebuild -> E3 ≤ 2.

## 6. Variasi & catatan dosen

- Soal live mod ditarik acak dari `Bank-Live-Coding.md` (12 variasi setara). Jangan ulang soal pada dua mahasiswa berurutan.
- Untuk semester berikutnya, buat variasi setara (ganti field/konstanta/ar.sort) tanpa mengubah struktur kriteria & rubrik ini.
- Catat hasil di `Lembar-Observasi.md` bagian kompetensi sesi (P07) + rekomendasi tindak lanjut bila ada gate yang gagal.
- Hormati kejujuran: indikator plagiarisme/tempel-AI-tanpa-pemahaman dicatat; konsekuensi mengikuti `Kunci-Diagnostik.md` §6 "Pelanggaran kebijakan" & aturan prodi.

---

**Status rubrik:** v1.0, 2026-08-08 | **Konsistensi:** rujuk `Peta-Capaian-dan-Assessment.md` bila ada pertentangan angka.
