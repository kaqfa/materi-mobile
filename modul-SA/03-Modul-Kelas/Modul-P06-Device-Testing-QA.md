# Modul Kelas P06, Device Feature, Testing & QA

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker
**Durasi:** 150 menit (3 × 50) | **Rasio praktik minimal:** 65%
**Pasangan:** `../02-Materi/P06-Device-Testing-QA.md` (materi)
**Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`, `../00-Planning/Runbook-Dosen.md`, `../05-Assessment/Lembar-Observasi.md`, `../05-Assessment/Bank-Live-Coding.md`

> **Untuk dosen/asisten.** Modul ini panduan menjalankan kelas, bukan handout mahasiswa. `solution-reference/` **jangan dibagikan** sebelum sesi selesai. **Proyek Akhir dibuka hari ini (P06)** dan final di P07, blok 1 membuka/brief, blok praktik mulai dikerjakan, blok 6 mengunci submisi + jadwal demo. Seluruh gate testing dapat diverifikasi **tanpa perangkat** (unit + widget test hijau); jalur device nyata opsional via `ImagePickerAttachmentService`.

---

## BAGIAN 1: Overview

### Tujuan Hari Ini

Mahasiswa mampu:
1. Menulis/membaca unit test untuk logika pure-Dart (`Task.status`, `TaskFilterService`), status + search case-insensitive + kombinasi AND + defensive empty, sampai hijau.
2. Mengintegrasikan satu fitur device (image picker, gallery fallback) dengan `sealed AttachmentResult` sehingga **device-unavailable & permission-denied tidak crash**; diverifikasi hijau via `LocalAttachmentService`.
3. Menulis/membaca widget test (validasi form + state list empty/error/retry) sebagai **gate rilis** menuju P07 (`flutter build apk --release` + demo).
4. Membuktikan seluruh gate **tanpa perangkat**; jalur `ImagePickerAttachmentService` opsional saat demo di perangkat.

### Rundown Kelas (150 menit)

```
00-10 Retrieval quiz P05 (sealed/fallback) + BUKA/BRIEF Proyek Akhir (10 menit)
10-30 Konsep testing pyramid + device fallback (sealed) + live demo (20 menit)
30-85 Guided lab: CP1 (unit filter/status) + CP2 (attach fallback) + CP3 (widget test) (55 menit)
85-125 Praktik individual + observasi dosen (lengkapi wiring + Proyek Akhir) (40 menit)
125-140 Demo fallback device/permission + challenge reveal + detail Proyek Akhir (15 menit)
140-150 Exit ticket + PR + KIRIM Proyek Akhir + jadwal demo P07 (10 menit)
```

> Alokasi mengikuti format tetap (`Runbook-Dosen.md` bagian 3). **Dua sisipan khusus P06:** (1) blok 1 **membuka Proyek Akhir** (QA + release + demo), final P07; (2) blok 6 mengunci jadwal demo individual. Bila banyak mahasiswa belum solid P05 (`sealed`), **tahan** mereka review dulu, P06 memakai idiom yang sama. Jangan kurangi blok observasi (40').

### Yang Harus Sudah Ready (sebelum kelas)

- [ ] Starter `06-Starter-Code/p06-testing-device/` lolos `pub get`/`analyze`; **3 unit + 2 widget test semua hijau** (baseline; TODO terkonfirmasi hanya di `TaskProvider.attachPhoto` + `_obtainPicker`).
- [ ] `flutter doctor` bersih; versi kelas dipin; dependency `image_picker ^1.1.2`, `provider ^6.1.2` terkunci. Target demo **Android** (image_picker butuh native); headless test tetap hijau lewat `LocalAttachmentService`.
- [ ] Proyek Akhir: `04-Penugasan/Proyek-Akhir-QA-Release-dan-Demo.md` + `Rubrik-Proyek-Akhir.md` siap **dibuka** di blok 1. `05-Assessment/Bank-Live-Coding.md` + `Rubrik-Demo-dan-Wawancara.md` siap untuk preview demo P07.
- [ ] `Lembar-Observasi.md` (satu per mahasiswa) siap diisi.
- [ ] `PERMISSIONS.md` dibaca; izin `READ_MEDIA_IMAGES` dipahami (Android 13+). **Bukan secret**, hanya deklarasi OS.
- [ ] `solution-reference/` di kanal privat, tidak terlihat mahasiswa.
- [ ] (Opsional) Perangkat/emulator dengan kamera untuk demo `ImagePickerAttachmentService`; bila tidak ada, **`LocalAttachmentService` sudah cukup** untuk seluruh gate P06.

---

## BAGIAN 2: Live Coding (Konsep + Demo)

### Demo 1: Testing pyramid + logika pure-Dart (10 menit)

_Ikuti dosen, jangan maju sendiri._

Tampilkan `task_filter_service.dart` + `task_status_test.dart`. Tunjukkan:

1. `TaskFilterService.apply`, tidak ada `import 'package:flutter'`. Filter: status AND search, case-insensitive, defensive empty.
2. `Task.status`, urutan `completed` sebelum `overdue`; komputasi, bukan field.
3. `flutter test test/domain/ test/services/task_filter_service_test.dart` -> semua hijau.

**Penting:**
- **Piramida testing:** banyak unit (murah/cepat), sedikit widget (sedang), sangat sedikit integration (maham). P06 fokus unit + widget.
- **Logika tanpa dependency = paling mudah diuji.** Pisahkan filter dari UI.
- **Test pakai tanggal relatif** (`add`/`subtract` dari `DateTime.now()`), non-deterministik `now()` tidak boleh mengganggu status.

**Test live (diskusi):**
- "Kenapa `completed` dicek sebelum `overdue`?" (task selesai yang lewat jatuh tempo tetap `completed`).
- "Kenapa `bySearch('MATH')` cocok walau kapital?" (`toLowerCase()` di kedua sisi).

### Demo 2: Sealed AttachmentResult + fallback tanpa perangkat (10 menit)

Tampilkan `attachment_service.dart` + `attachment_service_test.dart` + `task_provider.dart` (TODO). Tunjukkan pola, **bukan** implementasi wiring penuh:

```dart
sealed class AttachmentResult { const AttachmentResult(); }
class AttachmentSuccess extends AttachmentResult { final String path;... }
class AttachmentUnavailable extends AttachmentResult { final String reason;... }
class AttachmentDenied extends AttachmentResult { final String reason;... }

// LocalAttachmentService: rekayasa skenario tanpa plugin
// success / unavailable / denied -> unit test hijau di CI headless

// TaskProvider.attachPhoto (TODO CP2): switch atas result, NO throw
```

**Penting:**
- **Device wajib punya cabang gagal aman.** Izin ditolak / emulator tanpa kamera / galeri kosong -> `AttachmentResult`, bukan crash.
- **`Denied` vs `Unavailable` = aksi pengguna berbeda.** Denied -> "aktifkan di pengaturan"; unavailable -> "pakai device lain/gallery".
- **Pola dipinjam dari P05 `ApiError`.** Beda sumber (plugin vs HTTP), sama idiomnya (sealed + switch exhaustif).
- **`LocalAttachmentService` = rekayasa tanpa perangkat.** Unit test fallback hijau di CI.

**Common Errors:**
```
PlatformException permission -> pastikan bukan throw ke UI; service catch -> AttachmentDenied
image_picker not found -> flutter create belum dijalankan (plugin native)
banner tidak update -> attachPhoto belum notifyListeners / masih TODO
```

**Interactive Questions:**
- "Kalau user batal memilih (null return), subtype apa yang muncul?" (`AttachmentUnavailable`).
- "Kenapa unit test tidak langsung menguji `ImagePickerAttachmentService`?" (butuh plugin native; pakai `LocalAttachmentService`).

---

## BAGIAN 3: Practice Mandiri (40 menit observasi)

### Task: Selesaikan CP2 + CP3 (gate hijau)

**Time: 40 menitYang Harus Dibuat:**

1. **CP2, `attachPhoto` wiring.** Hubungkan `TaskProvider.attachPhoto` ke `_attachmentService`: panggil `pickFromGallery`/`pickFromCamera`, simpan ke `lastAttachment` via `switch` exhaustif, `notifyListeners()`. Tidak boleh `throw`.
2. **CP3, widget test gate.** Pastikan `flutter test` (3 unit + 2 widget) hijau. Lalu suntik `LocalAttachmentService` di `main.dart` dengan tiga skenario -> verifikasi banner berubah.
3. **(Opsional device)** Lengkapi `_obtainPicker` dengan `image_picker`; ganti ke `ImagePickerAttachmentService`; uji di perangkat (tolak izin -> banner denied).

**Starter Code:** sudah ada di `lib/` + `test/`; kerjakan TODO bertanda `// TODO(student)`.

**Checklist Progress:**
- [ ] `attachPhoto` terhubung; tiga skenario `LocalAttachmentService` -> banner berbeda.
- [ ] `flutter test` semua hijau (3 unit + 2 widget).
- [ ] `flutter analyze` bersih.
- [ ] (Opsional) `ImagePickerAttachmentService` di perangkat -> 3 skenario nyata.
- [ ] Tidak ada `throw` dari `attachPhoto` ke UI.

**Expected Output:**
```
$ flutter test
All tests passed! (3 unit + 2 widget)
$ flutter analyze
No issues found!
```

**Bantuan:**
- **Banner tidak muncul?** `attachPhoto` belum notify / masih TODO.
- **Test `task_list_widget` gagal Retry?** `seedError` belum dipanggil pada provider yang sama.
- **Crash di emulator tanpa kamera?** catch di `_pick` ditimpa (jangan).

**Advanced Challenge (Bonus):** widget test untuk `AttachmentStatusBanner` (denied -> teks permission).

---

## BAGIAN 4: Challenge Individual (15 menit)

### Individual Challenge (rehearsal demo)

**Level 1 (Basic):** Tambah kasus `attachment_service_test.dart`: default `success` -> `pickFromCamera()` path unik (counter naik). Kriteria: hijau, `analyze` bersih.

**Level 2 (Medium):** Tambah widget test `attachment_banner_test.dart`: pump `AttachmentStatusBanner` dengan `lastAttachment = AttachmentDenied(...)` -> teks permission muncul. Kriteria: dua kasus hijau; sealed tidak diubah.

**Level 3 (Advanced):** Persistensikan `attachmentPath` ke `Task` (in-memory) + tampilkan ikon `attach_file` di tile. Atau dukung `pickMultiImage`. Kriteria: demo lampiran lintas navigasi; jelaskan trade-off path vs bytes.

**Submit:** screenshot + paste kode + 2-3 kalimat penjelasan.

**Evaluation Criteria:**
- **Level 1:** test tambahan hijau.
- **Level 2:** widget test kontrak banner.
- **Level 3:** fitur device diperkaya untuk demo Proyek Akhir.

---

## BAGIAN 5: Take-Home Assignment (Proyek Akhir)

### Proyek Akhir, QA, Release, dan Demo Individual

**Final: P07** (dibuka hari ini). Lihat `04-Penugasan/Proyek-Akhir-QA-Release-dan-Demo.md` + `Rubrik-Proyek-Akhir.md`.

**Requirements (ringkas):**
1. **Satu fitur device:** image picker + gallery fallback + cabang device-unavailable/permission-denied (hari ini).
2. **Min 3 unit test:** model/filter-validator (hari ini). + **min 2 widget test:** form/empty/error/list (hari ini).
3. **`flutter test` + `flutter analyze` + release APK** (P07).
4. **README final + AI log** + **demo individual 7-10 menit** + **live modification 20-25 menit** dari `Bank-Live-Coding.md`.

**AI Usage Rules:**
- **Boleh:** ide test/optimasi, debugging plugin/permission, konsep `sealed`/testing pyramid.
- **Boleh:** review test yang sudah kamu tulis.
- **Jangan:** minta AI menulis core test / `attachPhoto` wiring tanpa analisis.
- **Wajib:** `Template-AI-Interaction-Log.md` + verifikasi pemahaman (jelaskan tiap cabang + bukti test hijau).

**Submission Format:** lihat `Rubrik-Proyek-Akhir.md` + `Template-Submission-README.md`.

**Grading:** Functionality / Code Quality / QA (test+analyze) / Demo & Live Modification, bobot di `Rubrik-Proyek-Akhir.md`. **Live modification + penjelasan tidak dapat digantikan source code.**

> **Demo P07 (preview):** app walkthrough + code walkthrough + **live modification** (dosen tarik soal dari bank) + Q&A. Mulai siapkan sekarang: pahami satu jalur end-to-end (provider->repository->datasource) + sealed `ApiError` (P05) + sealed `AttachmentResult` (hari ini).

---

## BAGIAN 6: References

### For Self-Study:

- **`../02-Materi/P06-Device-Testing-QA.md`**, materi lengkap (3 checkpoint + troubleshooting + challenge).
- **`../06-Starter-Code/p06-testing-device/README.md` + `PERMISSIONS.md`**, struktur + izin.
- **`../02-Materi/P05-REST-API-Error-Handling.md`**, pola `sealed` yang dipakai ulang.
- **Resmi:** [docs.flutter.dev/testing/overview](https://docs.flutter.dev/testing/overview), [pub.dev/packages/image_picker](https://pub.dev/packages/image_picker).

### Next Week Preview:

**P07, Release, Live Coding, Demo.Preparation:**
- Pastikan `flutter analyze` + `flutter test` hijau (gate rilis).
- Baca `../05-Assessment/Bank-Live-Coding.md` + `Rubrik-Demo-dan-Wawancara.md`.
- Siapkan perangkat untuk `flutter build apk --release` + demo.

**Connection Points:**
- P07 **tidak menambah fitur**, ia **membuktikan kualitas** P01-P06 + rilis APK + demo.
- Gate testing hari ini = prasyarat build APK P07.
- Sealed `AttachmentResult`/`ApiError` = bahan code walkthrough demo.

---

**Production Guidelines Compliance:**
- **Time-boxed:** 150 menit, semua aktivitas berdurasi jelas.
- **Action-oriented:** gate testing + fallback device sebagai deliverable.
- **Self-contained:** starter + test hijau; gate tanpa perangkat.
- **Progressive difficulty:** unit -> fallback -> widget test -> (opsional device).
