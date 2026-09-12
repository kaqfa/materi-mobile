# Modul Kelas P07, Release, Quality Gate & Live Coding Demo

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker
**Durasi:** 150 menit (3 × 50) | **Rasio praktik minimal:** 65%
**Pasangan:** `../02-Materi/P07-Release-Live-Coding-Demo.md` (materi)
**Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`, `../00-Planning/Runbook-Dosen.md`, `../05-Assessment/Lembar-Observasi.md`, `../05-Assessment/Bank-Live-Coding.md`, `../05-Assessment/Rubrik-Demo-dan-Wawancara.md`

> **Untuk dosen/asisten.** Modul ini panduan menjalankan kelas **penutup** paket remidi, bukan handout mahasiswa. `solution-reference/` **jangan dibagikan**. **Proyek Akhir final hari ini (P07)**, blok 1 mengunci submisi, blok 6 menjalankan/menjadwalkan demo individual. P07 **tidak menambah fitur**; ia **membuktikan kualitas** P01-P06 + merilis APK + demo + live modification. Seluruh gate release dapat diverifikasi **tanpa Play Store** (di-scope-out planning §2).

---

## BAGIAN 1: Overview

### Tujuan Hari Ini

Mahasiswa mampu:
1. Menjalankan **quality gate rilis** secara mandiri: `flutter analyze` (No issues found!), `flutter test` (All tests passed!), `flutter build apk --release` (APK terbentuk + terinstall), dan menjelaskan apa yang dijawab tiap gate.
2. Menerapkan **`const` & dasar rebuild** secara sadar: subtree `const` tidak rebuild saat `setState`; diverifikasi lewat `PerfDemoScreen` + Flutter Inspector.
3. **Merehearsal demo individual + live modification** (≥1 kategori soal bank) dengan gate tetap hijau; app walkthrough + code walkthrough end-to-end + dua `sealed` (`ApiError`, `AttachmentResult`).
4. Menjaga **hygiene & keamanan repo rilis**: tanpa signing key/keystore/token/`.env` rahasia; base URL via `--dart-define`.

### Rundown Kelas (150 menit)

```
00-10 Retrieval quiz P06 (sealed/gate testing) + KUNCI submisi Proyek Akhir (10 menit)
10-30 Konsep release gate + const/rebuild + live demo PerfDemoScreen (20 menit)
30-85 Guided lab: CP1 (analyze+test+build) + CP2 (const/Inspector) + CP3 (rehearsal) (55 menit)
85-125 Praktik individual + observasi dosen (finalisasi APK + README + rehearsal) (40 menit)
125-140 Demo/rehearsal sample + reveal strategi live modification + QA (15 menit)
140-150 Exit ticket + jadwal demo individual + penutup paket remidi (10 menit)
```

> Alokasi mengikuti format tetap (`Runbook-Dosen.md` bagian 3). **Dua sisipan khusus P07:** (1) blok 1 **mengunci submisi Proyek Akhir** (tidak terima tambahan setelah ini); (2) blok 6 **menjadwalkan demo individual** (app walkthrough + code walkthrough + live modification 20-25 menit + Q&A). Jangan kurangi blok observasi (40'), di sinilah dosen menilai kesiapan demo + menjaring miskonsepsi `const`/rebuild. Bila banyak mahasiswa gate P06 belum hijau, **tahan** mereka selesaikan dulu, gate P06 adalah prasyarat build APK P07.

### Yang Harus Sudah Ready (sebelum kelas)

- [ ] Starter `06-Starter-Code/p07-release/` lolos `pub get`/`analyze`; **smoke test (3 unit + 2 widget) hijau** sejak starter.
- [ ] `flutter doctor` bersih; versi kelas dipin; dependency `provider ^6.1.2` terkunci. Target demo **Android**; perangkat/emulator untuk uji APK rilis.
- [ ] Proyek Akhir: `04-Penugasan/Proyek-Akhir-QA-Release-dan-Demo.md` + `Rubrik-Proyek-Akhir.md` siap **difinalkan** di blok 1. `05-Assessment/Bank-Live-Coding.md` + `Rubrik-Demo-dan-Wawancara.md` siap untuk demo individual.
- [ ] `Lembar-Observasi.md` (satu per mahasiswa) siap diisi; jadwal demo individual (7-10 menit + live mod 20-25 menit) sudah dirancang.
- [ ] `RELEASE-CHECKLIST.md` dibaca; aturan no-secret (`.gitignore` signing material) dipahami. **Signing key/keystore tidak ada di starter** (acceptance criteria P07).
- [ ] `solution-reference/` di kanal privat, tidak terlihat mahasiswa.
- [ ] (Opsional) Proyektor untuk demo Flutter Inspector (highlight rebuild).

---

## BAGIAN 2: Live Coding (Konsep + Demo)

### Demo 1: Tiga gate rilis + kenapa masing-masing prasyarat (10 menit)

_Ikuti dosen, jangan maju sendiri._

Tampilkan starter `p07-release/`. Jalankan berurutan:

```bash
flutter analyze # No issues found!
flutter test # All tests passed! (3 unit + 2 widget)
flutter build apk --release # APK terbentuk
```

**Penting:**
- **Tiga pertanyaan berbeda.** analyze = *bersih?*; test = *benar?*; build = *terkemas & terpasang?*. Bukan formalitas.
- **Gate hijau = prasyarat penilaian Proyek Akhir** (planning §9). Satu pun gagal -> tunda demo.
- **`avoid_print` + `prefer_const_constructors`** bukan hiasan -前者 cegah log debug bocor ke release; latter paksa `const`.
- **Smoke test bukan tes fungsional penuh**, ia bukti render tanpa crash + kontrak minimum. Gate P06 (3 unit + 2 widget) adalah tes perilaku lebih dalam.

**Test live (diskusi):**
- "Kenapa `copyWith` wajib ada sebelum test `Task immutability` hijau?" (test memanggil `a.copyWith(title: 'B')`; tanpa metode itu gate gagal kompilasi).
- "Warning `analyze` boleh di-ignore?" (tidak, perbaiki atau jelaskan di README; jangan `// ignore:` tanpa alasan tertulis).

### Demo 2: `const`/rebuild basics via `PerfDemoScreen` (10 menit)

Tampilkan `perf_demo_screen.dart` + jalankan `flutter run` + buka **Flutter Inspector -> Highlight rebuilds**. Tekan "Bump" berkali-kali.

Tunjukkan:
1. `const _StaticCard(...)` & `const _TipList()` **tidak berkedip** (instance dipakai ulang, Flutter skip rebuild).
2. `Text('Counter: $_counter')` **berkedip** (argumen berubah -> harus rebuild).
3. `setState` di parent memicu `build` parent; tapi anak `const` kebal.

**Penting:**
- **`const` transmisional & menghemat rebuild**, bukan gaya penulisan. Di list 50 item + animasi, beda nyata.
- **Pemisahan state = rebuild terbatas.** Hanya widget yang membaca state yang rebuild. State sedekat mungkin ke pemakai.
- **`const` dituntut linter** (`prefer_const_constructors`), jadi mahasiswa tak perlu hafal; lint menuntun.

**Common Errors:**
```
analyze prefer_const_constructors -> tandai const; jangan // ignore: tanpa alasan
build gagal "Keystore file not found" -> signing release; untuk demo cukup debug-sign/unsigned; JANGAN commit keystore
INSTALL_FAILED_OLDER_SDK -> minSdkVersion vs perangkat; flutter clean + rebuild
Inspector tak highlight rebuild -> pakai debug/profile build (bukan release)
```

**Interactive Questions:**
- "Kalau 50 task + tombol refresh counter di root, apa yang rebuild?" (semua tile, solusi: pisahkan counter ke widget kecil).
- "Kenapa `const _TipList()` punya `const Column` berisi `const Text`?" (const transmisional dari parent).

---

## BAGIAN 3: Practice Mandiri (40 menit observasi)

### Task: Selesaikan CP1-CP3 (gate hijau + rehearsal)

**Time: 40 menitYang Harus Dibuat:**

1. **CP1, Gate rilis.** `flutter analyze` (No issues found!) + `flutter test` (All tests passed!) + `flutter build apk --release` (APK terbentuk + terinstall tanpa `INSTALL_FAILED_*`). Catat ukuran APK.
2. **CP2, `const`/Inspector.** Buka `PerfDemoScreen` via FAB; amati Inspector; konfirmasi `const _StaticCard` & `const _TipList` tidak rebuild saat "Bump". Jelaskan dengan kata sendiri.
3. **CP3, Rehearsal live modification.** Pilih minimal **satu kategori** soal `05-Assessment/Bank-Live-Coding.md` (sorting/filter baru, validasi tanggal, empty state khusus, mapper JSON). Implementasi; `analyze` + `test` tetap hijau (atau tambah test). Latih penjelasan 2 menit.
4. **Finalisasi README + hygiene.** README final (run, arsitektur, fitur, limitation, bukti test, AI log); `git status` bersih; `.gitignore` signing material.

**Starter Code:** sudah ada di `lib/` + `test/`; smoke test hijau sejak starter.

**Checklist Progress:**
- [ ] Tiga gate hijau; APK terinstall; uji fungsional (checklist bagian 4) lulus.
- [ ] Inspector: konfirmasi `const` subtree tidak rebuild; bisa menjelaskan.
- [ ] Rehearsal ≥1 kategori soal bank; gate hijau pasca-modifikasi.
- [ ] README final lengkap; `git status` bersih; tanpa signing key/secret.

**Expected Output:**
```
$ flutter analyze
No issues found!
$ flutter test
All tests passed!
$ flutter build apk --release
Built build/app/outputs/flutter-apk/app-release.apk.
$ git status
nothing to commit, working tree clean
```

**Bantuan:**
- **Build gagal gradle signing?** Untuk demo di luar Play Store, debug-sign/unsigned cukup; jangan buat/commit keystore nyata.
- **APK tidak terinstall?** Cek minSdkVersion vs perangkat; `flutter clean` + rebuild; `adb install` manual.
- **Inspector tak highlight?** Pakai `flutter run` (debug/profile), bukan release build.
- **`analyze` jadi merah setelah live mod?** Perbaiki `const`, tambah test, jangan ignore/skip.

**Advanced Challenge (Bonus):** selesaikan **dua kategori** soal bank + tambah unit test untuk perilaku baru; latih penjelasan end-to-end (provider->repository->datasource + dua `sealed`).

---

## BAGIAN 4: Challenge Individual (15 menit)

### Individual Challenge (rehearsal demo nyata)

**Level 1 (Basic):** Tambah unit test gate: verifikasi `const Task(...)` kompilasi + `copyWith` menjaga immutability untuk `priority` & `isCompleted`. Kriteria: hijau, `analyze` bersih.

**Level 2 (Medium):** Tambah demo `RepaintBoundary` di `PerfDemoScreen` (kartu beranimasi terisolasi dari list), atau widget test yang verifikasi `const _TipList` merender 4 poin. Kriteria: `analyze` + `test` hijau; jelaskan kapan `RepaintBoundary` berguna vs overhead.

**Level 3 (Advanced):** Selesaikan satu soal live modification penuh dari kategori **mapper JSON** atau **sorting baru**; tambah unit test; `const` tetap bersih. Rehearsal penjelasan 2 menit. Kriteria: gate hijau; penjelasan jelas. **Level 3 = rehearsal demo Proyek Akhir.Submit:** screenshot gate hijau + paste kode + 2-3 kalimat penjelasan.

**Evaluation Criteria:**
- **Level 1:** test tambahan hijau (immutability).
- **Level 2:** konsep rebuild/`RepaintBoundary` benar.
- **Level 3:** live modification penuh + penjelasan (kandidat nilai demo tinggi).

---

## BAGIAN 5: Take-Home Assignment (Proyek Akhir, FINAL P07)

### Proyek Akhir, QA, Release, dan Demo Individual

**Final & jadwal demo: hari ini (P07).** Lihat `04-Penugasan/Proyek-Akhir-QA-Release-dan-Demo.md` + `Rubrik-Proyek-Akhir.md`.

**Requirements (ringkas):**
1. **Satu fitur device** (P06) + cabang device-unavailable/permission-denied.
2. **Min 3 unit test + min 2 widget test** (P06) + smoke gate P07.
3. **`flutter analyze` + `flutter test` + release APK** (hari ini).
4. **README final + AI log** + **demo individual 7-10 menit** + **live modification 20-25 menit** dari `05-Assessment/Bank-Live-Coding.md`.
5. **No-secret rule:** tanpa signing key/keystore/token/`.env` rahasia di repo.

**AI Usage Rules:**
- **Boleh:** ide optimasi `const`/rebuild, debugging gradle/build, brainstorming strategi live modification.
- **Boleh:** evaluasi solusi yang sudah kamu tulis.
- **Jangan:** minta AI menyelesaikan soal live modification tanpa analisis.
- **Jangan:** menonaktifkan `analyze`/skip test agar "hijau".
- **Wajib:** `Template-AI-Interaction-Log.md` + verifikasi pemahaman (jelaskan tiap gate + demo + live mod).

**Submission Format:** lihat `Rubrik-Proyek-Akhir.md` + `Template-Submission-README.md`.

**Grading:** Functionality / Code Quality / QA (test+analyze+APK) / Demo & Live Modification, bobot di `Rubrik-Proyek-Akhir.md`. **Live modification + penjelasan tidak dapat digantikan source code.**

> **Demo individual (format):** app walkthrough (2-3 menit) + code walkthrough end-to-end (3-4 menit, termasuk dua `sealed`) + **live modification** (dosen tarik soal bank, 20-25 menit) + Q&A. Nilai berdasarkan `Rubrik-Demo-dan-Wawancara.md`. Jadwal di blok 6.

---

## BAGIAN 6: References & Penutup Paket

### For Self-Study:

- **`../02-Materi/P07-Release-Live-Coding-Demo.md`**, materi lengkap (3 checkpoint + troubleshooting + challenge).
- **`../06-Starter-Code/p07-release/README.md` + `RELEASE-CHECKLIST.md`**, gate + langkah rilis.
- **`../02-Materi/P05-REST-API-Error-Handling.md`** (`sealed ApiError`, `--dart-define`) + **`../02-Materi/P06-Device-Testing-QA.md`** (`sealed AttachmentResult`, gate testing), bahan code walkthrough demo.
- **Resmi:** [docs.flutter.dev/deployment/android](https://docs.flutter.dev/deployment/android), [docs.flutter.dev/perf/best-practices](https://docs.flutter.dev/perf/best-practices), [docs.flutter.dev/tools/devtools/inspector](https://docs.flutter.dev/tools/devtools/inspector).

### Penutup Paket Remidi:

P07 menutup 7 pertemuan. Mahasiswa membuktikan kemampuan **membaca, memperbaiki, membuat, menguji, dan menjelaskan** kode Flutter, kompetensi inti yang dipulihkan. Konversi nilai akhir di `../00-Planning/Rubrik-Remedial.md`.

**Connection Points:**
- P07 **tidak menambah fitur**, ia **membuktikan kualitas** P01-P06 + rilis APK + demo.
- Gate testing P06 (3 unit + 2 widget) = prasyarat build APK P07.
- Dua `sealed` (`ApiError` P05 + `AttachmentResult` P06) = bahan code walkthrough demo.
- `const`/rebuild basics = fondasi performa untuk app nyata pasca-remidi.

---

**Production Guidelines Compliance:**
- **Time-boxed:** 150 menit, semua aktivitas berdurasi jelas.
- **Action-oriented:** gate release + rehearsal live modification sebagai deliverable.
- **Self-contained:** starter + smoke hijau; gate tanpa Play Store.
- **Progressive difficulty:** analyze/test/build -> const/Inspector -> rehearsal demo.

---
