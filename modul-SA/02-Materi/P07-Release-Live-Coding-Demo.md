# P07, Release, Quality Gate & Live Coding Demo

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker
**Durasi sesi:** 150 menit (3 × 50) | **Estimasi belajar mandiri:** 5-7 jam
**Sub-CPMK:** 53.2 (SQLite, REST, performa, release) + 92.2 (device, testing, dokumentasi) | **Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`

> **Baca juga:** `../02-Materi/P05-REST-API-Error-Handling.md` (`sealed ApiError`), `../02-Materi/P06-Device-Testing-QA.md` (`sealed AttachmentResult` + gate testing), keduanya jadi bahan code walkthrough demo. Pasangan kelas: `../03-Modul-Kelas/Modul-P07-Release-Live-Coding-Demo.md`. Starter: `../06-Starter-Code/p07-release/` (README + `RELEASE-CHECKLIST.md`). Basis konsep: `../../Tutorial/outline-p09-14-advanced-features.md` (dipersempit ke release + const/rebuild + demo).

> **P07 adalah pertemuan penutup.** Ia **tidak menambah fitur**, ia **membuktikan kualitas** seluruh capaian P01-P06 lalu **merilis APK** dan **menjelaskan kode** lewat demo individual. Fokus tiga pilar: (1) quality gate `flutter analyze` + `flutter test` + `flutter build apk --release`; (2) `const`/rebuild basics; (3) demo + live modification rehearsal. Proyek Akhir (QA + release + demo) **final hari ini**.

---

## Tujuan Pembelajaran

Setelah materi ini dikuasai, kamu mampu:

1. **Menjalankan quality gate rilis secara mandiri:** `flutter analyze` (strict `const` + `avoid_print` -> **No issues found!**), `flutter test` (unit smoke P07 + gate P06 -> **All tests passed!**), dan `flutter build apk --release` (APK terbentuk di `build/app/outputs/flutter-apk/app-release.apk` tanpa error), serta menjelaskan kenapa gate ini prasyarat penilaian, bukan formalitas.
2. **Menerapkan `const` & dasar rebuild secara sadar:** menandai subtree immutable sebagai `const` agar Flutter **skip rebuild**, memisahkan state lokal ke `StatefulWidget` kecil, dan memverifikasi via Flutter Inspector bahwa hanya widget yang membaca state yang rebuild, diuji hijau lewat `PerfDemoScreen`.
3. **Mempersiapkan & merehearsal demo individual + live modification:** app walkthrough (CRUD P03, persistensi P04, API/error P05, device P06) + code walkthrough satu jalur end-to-end + `sealed ApiError`/`AttachmentResult` + menyelesaikan **satu soal live modification** (sorting/filter baru, validasi tanggal, empty state khusus, mapper JSON) dari `../05-Assessment/Bank-Live-Coding.md` dengan `const`/lint tetap bersih.
4. **Menjaga hygiene & keamanan repo rilis:** tidak menyimpan signing key/keystore/`key.properties`/token/`.env` rahasia, me-rute base URL lewat `--dart-define`, dan mendokumentasikan known limitation + AI log di README final.

**Outcome sesi (bukti observable):**
- `flutter analyze` -> **No issues found!** (linter P07: `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `avoid_print`, `strict-casts`).
- `flutter test` -> **All tests passed!** (`test/domain/task_model_test.dart` 3 kasus + `test/widget/smoke_test.dart` 2 kasus; plus gate P06 bila disertakan).
- `flutter build apk --release` -> APK terbentuk; terinstall di perangkat/emulator tanpa `INSTALL_FAILED_*`.
- `PerfDemoScreen`: tekan "Bump" -> counter naik; subtree `const _StaticCard` & `const _TipList` **tidak rebuild** (terverifikasi via Inspector / `debugPrint` rebuild).
- Live modification rehearsal: kamu menyelesaikan satu soal bank, `analyze` + `test` tetap hijau, lalu menjelaskan perubahan dengan kata sendiri.

---

## Prasyarat

- Menyelesaikan `../02-Materi/P06-Device-Testing-QA.md`: gate testing hijau (3 unit + 2 widget), paham `sealed AttachmentResult` + fallback device. P07 **memakai ulang** gate itu sebagai prasyarat APK.
- Menyelesaikan P05 (`sealed ApiError`, `--dart-define=API_BASE_URL`, state error/retry), bahan code walkthrough demo.
- Menyelesaikan P03-P04 (Provider CRUD + persistensi SQLite), bahan app walkthrough.
- `../01-Orientasi/Checklist-Environment.md` lulus; `flutter doctor` bersih; perangkat/emulator Android untuk uji APK.
- Starter P07 sudah di-copy ke workspace kosong (lihat "Setup").

> **Kebijakan AI P07:** AI boleh untuk **ide optimasi `const`/rebuild, debugging build/gradle, dan brainstorming strategi live modification**. AI **tidak boleh** menyelesaikan soal live modification tanpa analisis sendiri, juga tidak boleh menonaktifkan `flutter analyze`/skip test agar "hijau". Saat demo, dosen bisa menanyakan "kenapa subtree ini `const`?", "kenapa `sealed` aman?", "kenapa error HTTP dari status bukan body?", kamu wajib jawab dengan kata sendiri. Bila memakai AI, isi `../01-Orientasi/Template-AI-Interaction-Log.md`.

---

## Setup

```bash
# 1. Copy folder starter ke workspace kosong, lalu di dalamnya:
flutter create --platforms=android. # hasilkan platform runner (build APK butuh native)
flutter pub get # provider ^6.1.2
flutter analyze # strict const -> No issues found!
flutter test # unit + widget smoke -> All tests passed!
flutter build apk --release # build/app/outputs/flutter-apk/app-release.apk
```

> Folder `android/` sengaja **tidak** disertakan. Jalankan `flutter create` dari dalam folder starter; pulihkan `pubspec.yaml`/`analysis_options.yaml` dari Git bila ditimpa. **Jangan ubah `pubspec.yaml`**, dependency sudah dipin. Lihat `RELEASE-CHECKLIST.md` untuk langkah rilis lengkap (obfuscation, ukuran APK, uji install).

> **No-secret rule:** P07 **tidak menyimpan signing key atau release secret apa pun** (acceptance criteria). `.gitignore` mengecualikan `*.jks`, `*.keystore`, `key.properties`, `google-services.json`, `GoogleService-Info.plist`, `*.p12`, `*.pem`, `.env`, `secrets.json`. Signing APK di luar scope wajib (planning §2 kecualikan Play Store upload); demo cukup `flutter build apk --release` (debug-sign/unsigned) + install manual.

---

## Struktur starter P07

```text
06-Starter-Code/p07-release/
├── pubspec.yaml # provider ^6.1.2 (rilis; tanpa image_picker/http di shell ini)
├── analysis_options.yaml # strict const + avoid_print + strict-casts
├──.gitignore # exclude signing material + secrets
├── RELEASE-CHECKLIST.md # 6 bagian: gate, const, APK, uji fungsional, keamanan, demo
├── lib/
│ ├── main.dart # runApp(TaskTrackerApp())
│ ├── app.dart # MaterialApp + home (TaskListScreen) + FAB -> PerfDemoScreen
│ ├── core/{constants,theme}/
│ └── features/
│ ├── perf/perf_demo_screen.dart # const/rebuild demo (CP2)
│ └── tasks/
│ ├── domain/task.dart # immutable, const-friendly, copyWith, status turunan
│ └── presentation/screens/task_list_screen.dart # const-heavy, switch expression
└── test/
 ├── domain/task_model_test.dart # UNIT smoke (3 kasus), gate
 └── widget/smoke_test.dart # WIDGET smoke (2 kasus), gate
```

**Role starter:** shell release-ready minimal. Strict `const` lint aktif; smoke test (3 unit + 2 widget) hijau sejak starter; **tidak menyimpan signing key/secret apa pun**. P07 **tidak menambah fitur**, semua kode siap di-`analyze`/`test`/`build`. Tugas utama kamu: menjalankan gate, memahami `const`/rebuild, lalu **menjelaskan** dan **merehearsal demo**. Proyek Akhir (app utuh P01-P06) adalah yang dirilis + didemokan; starter ini menyediakan shell ringan untuk melatih gate + `PerfDemoScreen` tanpa dependensi berat.

**Aturan batas (penting):**
- Boleh menambah kasus test gate (mis. `const` assertion, `copyWith` edge case).
- Boleh memperkaya `PerfDemoScreen` (mis. `RepaintBoundary` demo) selama `analyze` tetap bersih.
- Boleh mengganti isi `releaseDummyTasks()` bila ingin demo data sendiri.
- Tidak boleh menonaktifkan linter / skip test / `// ignore:` tanpa alasan tertulis.
- Tidak boleh menyimpan signing key/keystore/token/`.env` rahasia di repo.
- Tidak boleh mengganti source reguler di parent folder.

---

## Mengapa Release & Demo, dan Kenapa Sekarang

P01-P06 membangun dan menguji aplikasi. P07 **menutup paket**: membuktikan bahwa aplikasi bisa **dirilis** (bukan hanya jalan di laptop) dan bahwa kamu **memahami** kode yang kamu tulis/bantu-AI. Tiga prinsip yang dilatih:

1. **Gate rilis adalah kontrak, bukan formalitas.** `flutter analyze` + `flutter test` + `flutter build apk --release` bukan tiga perintah yang dilewati. Masing-masing menjawab pertanyaan berbeda: *apakah kode bersih?* (analyze), *apakah perilaku benar?* (test), *apakah bisa dikemas & dipasang?* (build). Gate hijau adalah **prasyarat penilaian Proyek Akhir** (planning §9). Bila satu pun gagal, demo ditunda.
2. **`const` bukan gaya, ia menghemat kerja.** Flutter membangun ulang (*rebuild*) widget saat state berubah. Widget yang ditandai `const` dipakai ulang sebagai instance yang sama; Flutter **skip** pembangunannya. Di app dengan list panjang atau animasi, ini beda nyata. P07 melatih kebiasaan menandai subtree immutable `const` dan memisahkan state lokal ke widget kecil, diverifikasi lewat `PerfDemoScreen` + Inspector.
3. **Kode yang tidak bisa dijelaskan bukan kode kamu.** Demo individual + live modification ada **karena AI bisa menulis kode, tapi tidak bisa menulis pemahaman**. Dosen menarik satu soal dari bank; kamu selesaikan live dan jelaskan. Nilai live modification + penjelasan **tidak dapat digantikan source code** (planning §6 Proyek Akhir).

> **Sambungan dengan P05-P06:** code walkthrough demo memakai dua `sealed`: `ApiError` (P05, sumber HTTP status) dan `AttachmentResult` (P06, sumber plugin/permission). Kenapa keduanya `sealed`? Karena `switch` exhaustif menolak cabang terlupakan, error handling jadi aman secara compile-time. Pertanyaan demo klasik: "kenapa error HTTP diturunkan dari **status code**, bukan body?" Jawaban: body bisa berubah/berbahasa asing; status code adalah kontrak HTTP.

> **Kenapa `--dart-define`, bukan hardcode?** Base URL API adalah input dosen, bukan rahasia yang di-hardcode. P05 menunjukkan `--dart-define=API_BASE_URL=...` + `.env.example`. P07 mengonfirmasi tidak ada endpoint/akun produksi yang hardcode di repo rilis (lihat `RELEASE-CHECKLIST.md` bagian 5).

---

## CHECKPOINT 1: Quality Gate, Analyze, Test, Build

**Goal:** menjalankan tiga gate rilis hingga hijau dan menjelaskan kenapa masing-masing prasyarat penilaian.
**Time:** ~15 menit

### 1.1 Gate 1, `flutter analyze` (analisis statis)

```yaml
# analysis_options.yaml (ringkas)
analyzer:
 language:
 strict-casts: true
linter:
 rules:
 prefer_const_constructors: true
 prefer_const_literals_to_create_immutables: true
 prefer_const_declarations: true
 avoid_print: true
 unnecessary_const: true
```

```bash
flutter analyze
# Expected: No issues found! (issued 0)
```

**Penting:**

1. **`prefer_const_constructors`** menuntut widget immutable tanpa argumen dinamis ditandai `const`. Contoh di starter: `const _StaticCard(...)`, `const _TipList()`, `const SizedBox(height: 12)`.
2. **`avoid_print`** melarang `print()` di production, sisa debug yang tertinggal memenuhi log dan memperlambat release build.
3. **`strict-casts: true`** menolak cast implisit berbahaya; memaksa eksplisit `as`/type-safe.
4. **Warning wajib diperbaiki *atau* dijelaskan** di README (planning §6 Assignment 1). Jangan ditelan diam-diam, jangan di-`// ignore:` tanpa alasan.

> Bila muncul warning: baca pesannya. Linter P07 umumnya menuntun ke `const`. Tandai widget immutable sebagai `const`; pisahkan state dinamis ke `StatefulWidget` kecil.

### 1.2 Gate 2, `flutter test` (perilaku)

```bash
flutter test
# Expected: All tests passed! (3 unit + 2 widget)
```

Test yang harus hijau (sudah hijau sejak starter, kamu **membaca untuk memahami**):

**`test/domain/task_model_test.dart` (UNIT, 3 kasus):**
```dart
test('releaseDummyTasks mengembalikan 3 task', () {... }); // data dummy valid
test('Task.status: overdue untuk due date lampau', () {... }); // status turunan
test('Task immutability: copyWith tidak mengubah asli', () {... }); // immutable + copyWith
```

**`test/widget/smoke_test.dart` (WIDGET, 2 kasus):**
```dart
testWidgets('app render home dengan list task', (tester) async {... }); // home + FAB + tile
testWidgets('perf demo: tombol bump memperbarui counter', (tester) async {... }); // CP2 hook
```

**Penting:**
- **Smoke test bukan tes fungsional penuh**, ia membuktikan app render tanpa crash + kontrak minimum (counter naik, tile muncul). Gate P06 (3 unit + 2 widget) adalah tes perilaku yang lebih dalam; P07 menambah smoke release.
- **`copyWith` menjaga immutability.** `final b = a.copyWith(title: 'B');` -> `a.title` tetap `'A'`. Ini idiom yang dipakai live modification (mis. "toggle status task tertentu tanpa mutasi asli").
- **Test pakai tanggal relatif** (`DateTime.now().subtract(...)`), non-deterministik `now()` tidak boleh membuat status bergantung tanggal hardcode.

### 1.3 Gate 3, `flutter build apk --release` (kemas + pasang)

```bash
flutter build apk --release
# Expected: Built build/app/outputs/flutter-apk/app-release.apk.
```

Lalu pasang di perangkat/emulator:

```bash
# (opsional) install manual via adb
adb install build/app/outputs/flutter-apk/app-release.apk
```

Catat ukuran APK di README (`du -h app-release.apk`). Pastikan tidak ada `INSTALL_FAILED_*`.

> **(Opsional) Obfuscation**, bila ingin simbol tidak terbaca:
> ```bash
> flutter build apk --release --obfuscate --split-debug-info=build/symbols
> ```
> Simpan folder `build/symbols` di **luar repo** bila perlu deobfuscate crash nanti.

### Checkpoint Validation

- [ ] `flutter analyze` -> **No issues found!**
- [ ] `flutter test` -> **All tests passed!** (3 unit + 2 widget)
- [ ] `flutter build apk --release` sukses; APK ada di `build/app/outputs/flutter-apk/app-release.apk`.
- [ ] APK terinstall tanpa `INSTALL_FAILED_*`.
- [ ] Kamu bisa menjelaskan apa yang dijawab tiap gate (bersih? benar? terkemas?).

**Run & Test:**
```bash
flutter analyze && flutter test && flutter build apk --release
```

> **Ini gate rilis.** Bila salah satu gagal, **tunda demo**. Gate hijau adalah prasyarat penilaian Proyek Akhir (planning §9). Jangan "paksakan hijau" dengan menonaktifkan linter/skip test.

---

## CHECKPOINT 2: `const` & Rebuild Basics

**Goal:** memahami kenapa subtree `const` tidak rebuild, memverifikasinya di `PerfDemoScreen`, dan mempraktikkan pemisahan state lokal.
**Time:** ~15 menit

**Melanjutkan CP 1:**
- Already have: gate hijau; paham `analyze` menuntut `const`.
- 🆕 Will add: pemahaman **mengapa** `const` menghemat rebuild (bukan sekadar lulus lint).

### 2.1 Baca `PerfDemoScreen`, kontras const vs stateful

```dart
class _PerfDemoScreenState extends State<PerfDemoScreen> {
 int _counter = 0;
 void _bump() => setState(() => _counter += 1);

 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: AppBar(title: const Text('Const & Rebuild Demo')),
 body: ListView(
 children: [
 // Subtree ini TIDAK bergantung _counter -> seharusnya const.
 const _StaticCard(
 title: 'I am const',
 note: 'Tidak rebuild saat tombol ditekan.',
 ),
 Text('Counter: $_counter'...), // <- hanya ini bergantung state
 FilledButton(onPressed: _bump, child: const Text('Bump (rebuild stateful)')),
 const _TipList(),
 ],
 ),
 );
 }
}
```

**Penting:**

1. **`setState` memicu `build` parent.** Saat tekan "Bump", `_PerfDemoScreenState.build` dipanggil ulang.
2. **Subtree `const` dipakai ulang.** `const _StaticCard(...)` adalah instance yang sama lintas rebuild, Flutter **tidak membangun ulang** isinya. Bandingkan dengan `Text('Counter: $_counter')` yang *harus* rebuild karena argumennya berubah.
3. **Pemisahan state = rebuild terbatas.** Hanya widget yang **membaca** `_counter` yang rebuild. Bila seluruh screen menyimpan state global, semua tile ikut rebuild. Pisahkan state lokal ke `StatefulWidget` kecil.
4. **`const` transmisional.** Anak dari `const` parent otomatis `const` (mis. `const _TipList()` punya `const Column` berisi `Text` `const`).

### 2.2 Verifikasi via Flutter Inspector

1. Buka `PerfDemoScreen` di perangkat/emulator (atau `flutter run`).
2. Buka **Flutter Inspector** (VS Code / Android Studio).
3. Aktifkan **"Highlight rebuilds"** / **"Track widget builds"**.
4. Tekan "Bump" berkali-kali.
5. Amati: hanya `Text('Counter: …')` (dan parent yang bergantung state) yang **ter-highlight rebuild**. `const _StaticCard` & `const _TipList` **tidak** berkedip.

> Tanpa Inspector, kamu bisa verifikasi konsep dengan menambah `debugPrint` di `_StaticCard.build` (sementara, untuk belajar, **hapus sebelum release** karena `avoid_print` tidak melarang `debugPrint`, tapi jangan tinggalkan jejak debug). Setiap tekan "Bump" -> cetakan `_StaticCard.build` **tidak bertambah**.

### 2.3 Latihan: pisahkan state lokal

Tantangan kecil (bukan submission, latihan konsep): bayangkan daftar 50 task + satu tombol "refresh counter" di AppBar. Jika counter disimpan di root `Scaffold`, seluruh 50 tile ikut rebuild tiap tekan. Solusi: bungkus counter ke `StatefulWidget` kecil terpisah; root tetap `StatelessWidget`. Prinsip: **state sedekat mungkin ke widget yang membutuhkannya.**

### Checkpoint Validation

- [ ] `flutter analyze` tetap **No issues found!** setelah membaca/memahami `PerfDemoScreen`.
- [ ] `flutter test` tetap hijau (smoke "bump counter" lulus).
- [ ] Kamu bisa menjelaskan dengan kata sendiri: subtree mana yang rebuild dan mana yang tidak saat "Bump" ditekan, dan **kenapa**.
- [ ] (Opsional) Flutter Inspector menunjukkan `const _StaticCard` tidak rebuild.

**Run & Test:**
```bash
flutter run # buka PerfDemoScreen via FAB, amati Inspector
flutter analyze && flutter test
```

---

## CHECKPOINT 3: Release APK + Live Modification Rehearsal

**Goal:** merilis APK bersih + merehearsal satu soal live modification dari bank hingga gate tetap hijau.
**Time:** ~25 menit

**Melanjutkan CP 2:**
- Already have: gate hijau; paham `const`/rebuild.
- 🆕 Will add: rilis final + rehearsal demo individual.

### 3.1 Finalisasi README rilis

README final (lihat `../04-Penugasan/Template-Submission-README.md`) wajib memuat:
- **Cara run** (`flutter create`, `pub get`, `analyze`, `test`, `build apk`).
- **Arsitektur singkat** (jalur `TaskProvider -> TaskRepository -> datasource`; `sealed ApiError`; `sealed AttachmentResult`).
- **Fitur** (CRUD P03, persistensi P04, API/error P05, device P06).
- **Known limitation** (mis. "API base URL via `--dart-define`; bila tak ada server, mock fixture").
- **Bukti test** (`flutter analyze` + `flutter test` output; jumlah kasus).
- **AI log** (bila memakai AI, `../01-Orientasi/Template-AI-Interaction-Log.md`).

### 3.2 Build APK release final

Ikuti `RELEASE-CHECKLIST.md` (6 bagian). Minimum wajib:

```bash
flutter analyze # 1. No issues found!
flutter test # 2. All tests passed!
flutter build apk --release # 3. APK terbentuk
du -h build/app/outputs/flutter-apk/app-release.apk # catat ukuran
```

Uji fungsional pada APK rilis (checklist bagian 4):
- App launch tanpa crash.
- CRUD task (P03) bekerja pada build release.
- Persistensi SQLite (P04) bertahan setelah kill + relaunch.
- API/mock + state error (P05): `simulateNetworkError` -> error view + Retry.
- Device attachment (P06): pick gallery -> tampil; tolak izin -> banner denied (bukan crash).
- `PerfDemoScreen` bump counter bekerja.

### 3.3 Rehearsal demo (struktur 7-10 menit + live mod 20-25 menit)

**App walkthrough (2-3 menit):** jalankan APK rilis; tunjukkan CRUD, persistensi pasca-restart, API/error state, device attachment.

**Code walkthrough (3-4 menit):** jelaskan **satu jalur end-to-end** (mis. `TaskProvider -> TaskRepository -> datasource`), lalu dua `sealed`: `ApiError` (P05) + `AttachmentResult` (P06), dan `TaskFilterService` (P06). Siapkan jawaban: "kenapa `sealed` aman?" (switch exhaustif), "kenapa error dari status bukan body?".

**Live modification (20-25 menit), REHEARSAL:** dosen menarik satu soal dari `../05-Assessment/Bank-Live-Coding.md`. Sebelum sesi nyata, **latih sendiri** minimal dua kategori:

| Kategori soal | Contoh perubahan | Konsep yang diuji |
|---|---|---|
| **Sorting/filter baru** | tambah sort by `priority` desc; atau filter `overdue` saja | `TaskFilterService` (P06), comparator, `const` |
| **Validasi tanggal** | due date tidak boleh lampau saat create | form validation (P03), `DateTime` |
| **Empty state khusus** | pesan berbeda untuk "semua completed" vs "belum ada task" | widget test (P06), conditional UI |
| **Mapper JSON** | tambah field `tags` ke `toJson`/`fromJson` | serialization (P04/P05), `copyWith` |

**Alur kerja rehearsal (wajib latih):**
1. Baca soal; tanyakan klarifikasi bila ambigu (jangan asumsi).
2. Identifikasi file yang diubah; rencanakan sebelum ngetik.
3. Implementasi; jaga `const` + lint.
4. Jalankan `flutter analyze` + `flutter test` -> harus tetap hijau (atau tambah test baru sesuai perubahan).
5. Jelaskan perubahan dengan kata sendiri: kenapa pendekatan ini, apa trade-off-nya.

> **Inti acceptance criteria P07:** quality gate **dan** live modification rehearsal. Gate hijau tanpa bisa menjelaskan = tidak lulus. Live modification + penjelasan **tidak dapat digantikan source code** (planning §6).

### Checkpoint Validation

- [ ] APK rilis terinstall; seluruh uji fungsional (checklist bagian 4) lulus.
- [ ] README final lengkap (run, arsitektur, fitur, limitation, bukti test, AI log).
- [ ] `.gitignore` mengecualikan signing material + secrets; `git status` bersih.
- [ ] Kamu merehearsal minimal 2 kategori soal bank; `analyze` + `test` tetap hijau setelah modifikasi.
- [ ] Kamu bisa menjelaskan dua `sealed` + satu jalur end-to-end dengan kata sendiri.

**Run & Test:**
```bash
flutter analyze && flutter test && flutter build apk --release
git status # bersih, tanpa signing material
```

> **Rehearsal path CP3:** seluruh gate release teruji **tanpa Play Store** (di-scope-out planning §2). Demo cukup `flutter build apk --release` + install manual. Live modification diuji lewat bank soal + gate hijau pasca-modifikasi.

---

## Summary

**Yang kamu kerjakan:**
- Menjalankan tiga gate rilis hingga hijau: `flutter analyze` (No issues found!), `flutter test` (All tests passed!), `flutter build apk --release` (APK terbentuk + terinstall).
- Memahami `const`/rebuild basics lewat `PerfDemoScreen` + Flutter Inspector; subtree `const` tidak rebuild saat `setState`.
- Merilis APK final + menulis README final (run, arsitektur, fitur, limitation, bukti test, AI log).
- Merehearsal demo individual: app walkthrough + code walkthrough + live modification (≥2 kategori soal bank) dengan gate tetap hijau.

**Konsep kunci:**
- **Gate rilis = kontrak**, bukan formalitas, analyze (bersih), test (benar), build (terkemas); prasyarat penilaian Proyek Akhir.
- **`const` menghemat rebuild**, instance dipakai ulang, Flutter skip build; pisahkan state lokal ke widget kecil.
- **Kode yang tidak bisa dijelaskan bukan kode kamu**, live modification + penjelasan tidak tergantikan source/Al.
- **Dua `sealed` jadi bahan code walkthrough**, `ApiError` (P05) + `AttachmentResult` (P06); switch exhaustif = error handling aman compile-time.
- **No-secret rule**, signing key/keystore/token/`.env` tidak di repo; base URL via `--dart-define`.

**Penutup paket remidi:**
P07 menutup 7 pertemuan. Kamu sudah membuktikan kemampuan **membaca, memperbaiki, membuat, menguji, dan menjelaskan** kode Flutter, kompetensi inti yang dipulihkan paket ini. Selamat demo.

---

## Troubleshooting

**`flutter analyze` melaporkan `prefer_const_constructors`.**
Widget immutable tanpa argumen dinamis wajib `const`. Tandai `const MyWidget(...)`. Linter menuntun; jangan `// ignore:` tanpa alasan tertulis.

**`flutter build apk --release` gagal `Keystore file not found`.**
Ini muncul bila Gradle mencari signing release. Untuk demo di luar Play Store (di-scope-out planning §2), build debug-sign/unsigned cukup. **Jangan** membuat/commit keystore nyata ke repo. Cek `android/app/build.gradle` signing config; pastikan tidak mereferensi `key.properties` yang tidak ada.

**`INSTALL_FAILED_OLDER_SDK` / `INSTALL_FAILED_VERIFICATION_FAILURE`.**
minSdkVersion tidak cocok perangkat. Cek `android/app/build.gradle`; pastikan perangkat/emulator memenuhi minSdk. `flutter clean` + rebuild.

**APK terlalu besar.**
Catat ukuran (`du -h`). Bila ingin kecil: `flutter build apk --release --split-per-abi` (per arsitektur) atau `--obfuscate --split-debug-info`. Tapi bukan syarat wajib; catat known limitation di README.

**`PerfDemoScreen` counter tidak naik.**
Cek `onPressed: _bump` terpasang; `_bump` memanggil `setState`. Smoke test "bump counter" akan menangkap ini, bila hijau, binding benar.

**Inspector tidak menunjukkan rebuild highlight.**
Aktifkan "Highlight rebuilds" / "Track widget builds" di Inspector. Pastikan `flutter run` (bukan release build, Inspector butuh debug/profile mode).

**Live modification: `analyze`/`test` jadi merah setelah ubah.**
Jangan "paksakan hijau" dengan ignore/skip. Perbaiki `const`, tambah/update test sesuai perubahan. Gate hijau pasca-modifikasi adalah bagian dari penilaian.

**`debugPrint` tertinggal setelah belajar rebuild.**
`avoid_print` tidak melarang `debugPrint`, tapi jejak debug memenuhi log release. Hapus sebelum build final.

**`A RenderFlex overflowed` saat demo landscape.**
Ini capaian P02/P03 (responsive). Bila muncul di APK rilis, perbaiki (mis. `SingleChildScrollView`, `Expanded`) atau catat known limitation.

---

## Self-Assessment (sebelum & sesudah)

**Skor kepercayaan 1-5, sebelum & sesudah P07:**
- Menjalankan `flutter analyze` + memperbaiki warning: -> 
- Menjalankan `flutter test` sebagai gate perilaku: -> 
- `flutter build apk --release` + install manual: -> 
- Menjelaskan kenapa `const` menghemat rebuild (bukan sekadar lulus lint): -> 
- Menjaga repo bebas signing key/secret: -> 
- App walkthrough + code walkthrough end-to-end: -> 
- Live modification dari bank soal dengan gate tetap hijau: -> 

**Verifikasi praktik:**
- Demo ke teman/dosen: app walkthrough 2-3 menit + code walkthrough jalur end-to-end + jawab "kenapa `sealed` aman?".
- Rehearsal 2 soal bank berbeda kategori; `analyze` + `test` hijau setelah masing-masing.
- Periksa `git status` bersih; konfirmasi tidak ada `*.jks`/`key.properties`/`.env` di repo.

---

## Challenge Bertingkat (kerja sendiri, siapkan bukti)

Pilih satu level. Semua boleh pakai AI untuk **penjelasan/debugging/strategi**, bukan menyelesaikan live modification tanpa analisis.

**Level 1 (Basic):** Tambah unit test gate `const` assertion: verifikasi `const Task(...)` kompilasi + `copyWith` menjaga immutability untuk field `priority` & `isCompleted`. Kriteria: test lulus, `analyze` bersih.

**Level 2 (Medium):** Tambah demo `RepaintBoundary` di `PerfDemoScreen` (mis. isolasi kartu beranimasi dari list), atau tambah widget test yang memverifikasi `const _TipList` merender tepat 4 poin. Kriteria: `analyze` + `test` hijau; jelaskan kapan `RepaintBoundary` berguna (dan kapan jadi overhead).

**Level 3 (Advanced):** Selesaikan satu soal live modification penuh dari kategori **mapper JSON** atau **sorting baru**; tambah unit test untuk perilaku baru; pastikan `const` tetap bersih. Rehearsal penjelasan 2 menit. Kriteria: gate hijau; penjelasan jelas. Relevan langsung untuk demo Proyek Akhir.

**Submit:** screenshot gate hijau + paste kode + 2-3 kalimat penjelasan pendekatan.

> Challenge Level 3 = rehearsal demo nyata. Lakukan minimal satu sebelum sesi final.

---

## AI-Enhanced Learning (P07)

**Penggunaan AI produktif di P07:**
- "Kenapa menandai widget `const` menghemat rebuild? Jelaskan mekanisme instance reuse."
- "Kapan `RepaintBoundary` berguna, dan kapan jadi overhead?"
- "Apa beda debug/profile/release build Flutter? Kenapa Inspector butuh debug/profile?"
- "Bagaimana strategi aman men-debug `flutter build apk --release` gagal gradle?"
- "Beri saya ide soal live modification kategori sorting + validasi, lalu bantu saya *mengevaluasi* solusi saya (bukan menulisnya)."

**Hindari:**
- "Selesaikan soal live modification ini untuk saya." (core, analisis sendiri; ini yang dinilai)
- "Buat `analyze`/`test` hijau dengan mengabaikan warning." (menonaktifkan gate = melanggar prinsip)
- "Tulis README final saya." ( dokumentasi = pemahaman kamu)

**Wajib bila memakai AI:** isi `../01-Orientasi/Template-AI-Interaction-Log.md`, tujuan, prompt, ringkasan respons, perubahan dipilih/ditolak, dan **verifikasi pemahaman** (jelaskan ulang + bukti gate hijau + demo). Saat demo, dosen bisa tanya "kenapa subtree ini `const`?" / "apa yang dijawab tiap gate?" / "kenapa error dari status bukan body?", kamu harus bisa jawab.

---

## Resources

- **Resmi:** [docs.flutter.dev/deployment/android](https://docs.flutter.dev/deployment/android) (build & sign APK), [docs.flutter.dev/perf/best-practices](https://docs.flutter.dev/perf/best-practices) (const/rebuild), [docs.flutter.dev/testing/overview](https://docs.flutter.dev/testing/overview) (gate testing), [docs.flutter.dev/ui/inspector](https://docs.flutter.dev/tools/devtools/inspector) (rebuild highlight).
- **Dalam paket:** `../06-Starter-Code/p07-release/README.md` + `RELEASE-CHECKLIST.md`, `../02-Materi/P05-REST-API-Error-Handling.md` (`sealed ApiError`, `--dart-define`), `../02-Materi/P06-Device-Testing-QA.md` (`sealed AttachmentResult` + gate testing), `../05-Assessment/Bank-Live-Coding.md` (soal live modification), `../01-Orientasi/Template-AI-Interaction-Log.md`.
- **Konsep dasar:** `../../Tutorial/outline-p09-14-advanced-features.md` (dipersempit ke release + const/rebuild; **tanpa** maps/analytics/notification/Play Store yang dikecualikan planning §2).
- **Starter:** `../06-Starter-Code/p07-release/` (README + `RELEASE-CHECKLIST.md` + struktur di atas).

**Penutup:** P07 menutup paket remidi. Bila seluruh gate hijau + demo + live modification selesai, kompetensi inti Flutter (membaca, memperbaiki, membuat, menguji, menjelaskan kode) terbukti pulih. Lihat `../00-Planning/Rubrik-Remedial.md` untuk konversi nilai akhir.

---
