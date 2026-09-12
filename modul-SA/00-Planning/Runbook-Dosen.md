# Runbook Dosen, PPB Remidi 7 Pertemuan

> **Status:** v1.0, 2026-08-08
> **Aplikasi jangkar:Remedial Task Tracker**
> **Sumber:** `Rencana-Modul-PPB-Remedial-7-Pertemuan.md`, `Peta-Capaian-dan-Assessment.md`, `Rubrik-Remedial.md`
> **Tujuan:** panduan operasional dosen/asisten untuk menjalankan paket remidi dari sebelum P01 hingga final P07.

## 1. Prinsip operasional

- **Klinik praktik terukur**, bukan kuliah ringkasan. Rasio praktik minimal 65%.
- **Satu aplikasi jangkar** (Remedial Task Tracker) untuk seluruh sesi; starter dirancang seragam.
- **Nilai aplikasi tidak cukup.** Setiap tugas divalidasi dengan penjelasan dan live modification.
- **Tegakkan kebijakan AI bertingkat** (P1-P3, P4-P5, P6-P7) dan wajib AI Interaction Log.
- **Jangan distribusi starter bila quality gate gagal** (lihat bagian 6).

## 2. Sebelum P01 (persiapan)

| # | Tindakan | Bukti selesai |
|---|---|---|
| 1 | Validasi environment pada mesin target via `../01-Orientasi/Checklist-Environment.md` | `flutter doctor`, `pub get`, `analyze`, `test` bersih |
| 2 | Pastikan perangkat/emulator tersedia dan kamera/gallery dapat dipakai | `flutter devices` aktif; opsi fallback gallery disiapkan |
| 2b | Tetapkan **Flutter/Dart version kelas**, pin dependency | `pubspec.yaml` terkunci; catat di compatibility matrix |
| 3 | Siapkan starter P01 yang dapat `pub get`/`analyze`/`test` | starter lolos tiga perintah |
| 4 | Siapkan diagnosis konsep + praktik dengan kunci/rubrik (task kanban terpisah) | soal + kunci Merah/Kuning/Hijau tersedia |
| 5 | Tentukan jalur submission (ZIP + repo URL + screenshot + APK bila ada; **tanpa video**) | instruksi submission dirilis ke mahasiswa |
| 6 | Tentukan backend P5: endpoint asli **atau** mock/fixture fallback | config `API_BASE_URL`/fixture teruji |

## 3. Format sesi tetap (150 menit)

| Blok | Menit | Aktivitas |
|---|---:|---|
| Retrieval/review bug sebelumnya | 10 | quiz singkat / bahas bug pertemuan lalu |
| Konsep minimum + demo | 20 | teori padat + live demo |
| Guided lab + checkpoint | 55 | praktik terbimbing, 2-3 checkpoint, kode jalan tiap checkpoint |
| Praktik individual + observasi | 40 | kerja sendiri; dosen observasi via `05-Assessment/Lembar-Observasi.md` |
| Demo singkat + exit ticket + PR | 15 | siswa presentasi singkat; kumpulkan exit ticket; instruksi PR |

Setiap materi/modul mengikuti **Progressive Checkpoint Pattern** (`../Standar Tutorial Koding PPB.md`): 2-3 checkpoint, validasi testable, troubleshooting, preview sesi berikutnya.

## 4. Rundown per sesi

| Sesi | Fokus | Checkpoint inti | Catatan dosen |
| ---- | -------------------------- | ----------------------------------------------------------- | --------------------------------------------------------------------- |
| P01 | Diagnosis, Dart, debugging | cek environment; model `Task`; perbaiki filter/search rusak | pakai starter bugged; diagnosis memetakan merah/kuning/hijau |
| P02 | Widget, layout, navigation | task list; `TaskCard` reusable; list-detail/add nav | tekan responsive portrait+landscape |
| P03 | Form, CRUD, Provider | validator; `TaskProvider`; CRUD + state | **buka Assignment 1** di akhir sesi |
| P04 | SQLite, offline-first | schema; repository lokal; persistence restart | validasi: restart app -> data tetap. **Tegaskan: SQLite opsional di tugas (jalur bonus), bukan gate** |
| P05 | REST API, robustness | HTTP/JSON; repository remote; network/error state; retry | **buka Assignment 2**; siapkan mock bila tanpa server; **tenggat Assignment 1** |
| P06 | Device, testing, QA | permission + image picker; unit + widget test | **tenggat Assignment 2**; cek `flutter test` semua lulus; **buka Proyek Akhir** |
| P07 | Release, live coding, demo | analyze bersih; APK; live modification; wawancara | **final Proyek Akhir**; tarik soal live mod dari bank; demo **tatap muka**, bukan rekaman |

## 5. Kadens tugas dan tenggat

| Tugas | Batas lingkup | Dibuka | Tenggat | Bukti |
|---|---|---|---|---|
| Assignment 1, Task Tracker Core | sampai testing | setelah P03 | sebelum P04 | source, **narasi AI 800-1200 kata**, screenshot (portrait+landscape+flow), README, AI log |
| Assignment 2, Serialization dan API | sampai testing | setelah P05 | sebelum P06 | source, **narasi AI 800-1200 kata**, screenshot (list/loading/empty/error+retry/4xx/offline), config tanpa secret, README, AI log |
| Proyek Akhir, QA, Release, Demo | release + demo | setelah P06 | final P07 | source, APK rilis, **narasi AI 1000-1500 kata**, screenshot, README final, AI log, demo tatap muka 7-10' + live mod 20-25' |

> **Tanpa video.** Paket ini tidak memakai video presentasi. Bukti visual = screenshot; penjelasan kode = narasi tertulis (+ demo tatap muka di P07). Jangan meminta mahasiswa merekam video.

> **SQLite opsional.** Mahasiswa boleh memilih jalur A (in-memory) atau jalur B (SQLite) di Assignment 2 dan melanjutkannya di Proyek Akhir. **Menurunkan nilai jalur A karena tidak memakai SQLite adalah kesalahan penilaian.** Jalur B hanya membuka skor 4 pada indikator bertanda (bonus B).

### Cara menilai narasi (ringkas)

Narasi **kuat**: menyebut nama file/class/variabel milik mahasiswa, memuat minimal satu saran AI yang **ditolak** dengan alasan teknis masuk akal, dan penjelasan alurnya cocok dengan source yang dikumpulkan.

Narasi **lemah**: kalimat umum tanpa detail proyek ("AI membantu saya memahami widget"), tidak ada penolakan, atau menjelaskan arsitektur yang tidak ada di kodenya.

Bila ragu, ajukan **satu pertanyaan lisan singkat** berdasarkan isi narasinya. Mahasiswa yang menulis sendiri akan menjawab lancar. Ketidakcocokan narasi dengan jawaban lisan ditangani sebagai temuan integritas, bukan sekadar skor rendah.

## 6. Quality gate

### Per checkpoint
- Aplikasi build/run.
- Acceptance checklist checkpoint tercapai.
- Broken/error state tidak diteruskan ke checkpoint berikutnya.
- Exit ticket terkumpul (screenshot/log + satu konsep belum jelas).

### Sebelum distribusi paket
- Semua snippet menjalankan lint/test.
- Setiap materi 2-3 checkpoint + troubleshooting.
- Modul kelas punya rundown 150 menit + demo + latihan mandiri + challenge bertingkat + notes dosen.
- Tugas tepat 2 assignment + 1 proyek akhir, rubrik eksplisit (`Rubrik-Remedial.md`), template submission konsisten.
- API/mock fallback dibuktikan.
- Bank live coding punya rubrik/kunci + variasi setara (`05-Assessment/Bank-Live-Coding.md`).

## 7. Kebijakan AI (penegakan)

| Sesi | Boleh | Tindakan dosen bila melanggar |
|---|---|---|
| P1-P3 | penjelasan syntax, diagnosis | tolak PR bila core logic tempel AI tanpa analisis; minta kerja ulang |
| P4-P5 | debugging, review error | minta mahasiswa menjelaskan perubahan data layer; cek log |
| P6-P7 | ide test/optimasi | log wajib; bila tidak ada -> anggap pelanggaran |

**Wajib di tiap tugas:** **Narasi Pemanfaatan AI** (selalu, bahkan bila tidak memakai AI) + AI Interaction Log bila AI dipakai (`../01-Orientasi/Template-AI-Interaction-Log.md`). Narasi adalah gate: narasi generik atau tidak cocok dengan source dapat membatalkan poin dimensi fungsional (lihat `Rubrik-Remedial.md` bagian 5-6). Di P07, cocokkan isi narasi dengan jawaban lisan saat Q&A.

## 8. Backend P5, endpoint atau mock fallback

**Default bila tidak ada server stabil:** pakai mock server/fixture yang dikontrol dosen.

- Config base URL via `--dart-define=API_BASE_URL=...` atau `.env.example`; jangan hardcode secret.
- Endpoint minimum: `GET /tasks`, `POST /tasks`, `PATCH /tasks/:id`, `DELETE /tasks/:id`.
- Sediakan fixture JSON tunggal + fixture offline agar capaian dapat diuji tanpa jaringan.
- Base URL, kredensial, dan kebijakan auth = input dosen.

## 9. Live modification (P07)

Tarik satu soal dari bank live coding. Contoh variasi setara:
- Tambah/ubah sorting daftar task.
- Filter baru (mis. filter prioritas + status bersamaan).
- Validasi tanggal (due date tidak di masa lalu).
- Empty state khusus untuk hasil filter tertentu.
- Perubahan mapper JSON (field baru/ubah tipe).

Kriteria penilaian: ketepatan hasil, kemampuan debug hidup, penjelasan "mengapa". Bank wajib punya kunci/rubrik dan variasi setara. Live modification **tidak dapat digantikan source code**.

## 10. Keputusan yang masih perlu dari dosen

| Keputusan | Dampak | Default plan |
|---|---|---|
| Flutter/Dart version kelas | dependency lock + test starter | tulis compatibility matrix, pin setelah diverifikasi |
| Backend P5 | API URL, account, auth, demo | mock server/fixture lokal sebagai fallback wajib |
| Bentuk submission | GitHub/GitLab/E-learning | source ZIP + repo URL bila ada + screenshot + APK (**tanpa video**) |
| Kebijakan nilai remidi maksimum | rubrik akhir | rubrik skor 100; konversi final ikut prodi/dosen |
| Device fisik | kamera vs gallery fallback | gallery picker + permission handling tetap wajib |

## 11. Lintas paket, QA final

Sebelum paket dianggap DoD (`Rencana-Modul-PPB-Remedial-7-Pertemuan.md` bagian 12):
- [ ] 7 materi + 7 modul kelas tersedia dan lolos gate.
- [ ] 2 assignment + 1 proyek akhir + rubrik eksplisit + template submission konsisten.
- [ ] Starter P01-P07 semua `pub get`/`analyze`/`test` bersih.
- [ ] Diagnosis + kunci + lembar observasi tersedia.
- [ ] AI log template + policy tersebar di panduan.
- [ ] Bank live coding + rubrik demo tersedia.
- [ ] Semua artefak merujuk nama aplikasi, 7 sesi, serta 2 assignment + 1 proyek akhir yang sama.
- [ ] Tidak ada artefak yang masih menuntut video presentasi.
- [ ] Tidak ada artefak yang menjadikan SQLite sebagai gate wajib.
