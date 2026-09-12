# P06, Device Feature, Testing & QA

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker
**Durasi sesi:** 150 menit (3 × 50) | **Estimasi belajar mandiri:** 5-7 jam
**Sub-CPMK:** 92.2 (device, testing, dokumentasi) | **Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`

> **Baca juga:** `../02-Materi/P05-REST-API-Error-Handling.md` (fondasi `sealed` + fallback yang dipakai ulang), `../01-Orientasi/Panduan-Mahasiswa.md`. Pasangan kelas: `../03-Modul-Kelas/Modul-P06-Device-Testing-QA.md`. Starter: `../06-Starter-Code/p06-testing-device/` (README + `PERMISSIONS.md`). Basis konsep: `../../Tutorial/outline-p09-14-advanced-features.md` (dipersempit ke image picker + permission + testing).

> **Pilihan fitur device:** sesuai planning §6 Proyek Akhir, P06 memilih **image picker** dengan **gallery fallback**. Bila perangkat/emulator tidak mendukung kamera, gallery picker + cabang permission/error tetap sah. Seluruh capaian device + testing dapat diverifikasi **tanpa perangkat** lewat `LocalAttachmentService` + unit/widget test hijau.

---

## Tujuan Pembelajaran

Setelah materi ini dikuasai, kamu mampu:

1. **Menguji pure-Dart logic tanpa Flutter:** menulis/membaca unit test untuk `Task.status` (completed/overdue/pending) dan `TaskFilterService` (filter status + search case-insensitive + kombinasi AND), sampai `task_status_test.dart` + `task_filter_service_test.dart` **hijau**, dan menjelaskan kenapa logika tanpa dependency lebih cepat & andal diuji.
2. **Mengintegrasikan satu fitur device dengan fallback aman:** menghubungkan `ImagePickerAttachmentService` (gallery + camera) ke provider; setiap hasil dipetakan ke `sealed AttachmentResult` (`AttachmentSuccess`/`AttachmentUnavailable`/`AttachmentDenied`) sehingga **device unavailable dan permission denied tidak pernah crash**, diverifikasi hijau via `LocalAttachmentService` di `attachment_service_test.dart`.
3. **Menguji widget & state UI tanpa perangkat:** menulis/membaca widget test untuk validasi form (`task_form_widget_test.dart`: kosong -> error, <3 char -> error, valid -> callback) dan state UI list (`task_list_widget_test.dart`: empty, error+retry, list), sehingga `flutter test` hijau sebagai **gate rilis** menuju P07.

**Outcome sesi (bukti observable):**
- `flutter test` di `06-Starter-Code/p06-testing-device/` -> **3 unit + 2 widget test hijau sejak starter** (status, filter, attachment fallback; form validasi, list states).
- `flutter analyze` -> bersih (const lints aktif).
- Demo fallback device/permission tanpa perangkat: suntik `LocalAttachmentService(galleryBehavior: denied)` -> banner `AttachmentDenied`; `unavailable` -> banner unavailable; `success` -> banner path. Tidak ada `throw` ke UI.
- (Di perangkat) `ImagePickerAttachmentService()` + tolak izin kamera/galeri -> banner denied; emulator tanpa kamera -> banner unavailable.

---

## Prasyarat

- Menyelesaikan `../02-Materi/P05-REST-API-Error-Handling.md`: paham `sealed` + `switch` exhaustif, pola provider "simpan state sebelum await + notifyListeners", dan fallback mock. P06 **memakai pola yang sama** untuk `AttachmentResult`.
- Menyelesaikan P03 (`ChangeNotifier`/Provider) dan P04 (pola async provider). P06 menyuntik service ke provider + UI membaca `lastAttachment`.
- `../01-Orientasi/Checklist-Environment.md` lulus; `flutter doctor` bersih. Target demo **Android** (image_picker butuh native; headless test tetap hijau lewat `LocalAttachmentService`).
- Starter P06 sudah di-copy ke workspace kosong (lihat "Setup").

> **Kebijakan AI P06:** AI boleh untuk **ide test/optimasi dan debugging plugin/permission** (mis. "kenapa `PlatformException` muncul saat izin ditolak?"). AI **tidak boleh** menulis core `attachPhoto` wiring atau unit/widget test inti tanpa analisis sendiri, kamu wajib memahami tiap cabang `AttachmentResult` dan tiap assertion test (ini kriteria ujian + Proyek Akhir). Bila memakai AI, isi `../01-Orientasi/Template-AI-Interaction-Log.md` dan siap menjelaskannya saat demo Proyek Akhir.

---

## Setup

```bash
# 1. Copy folder starter ke workspace kosong, lalu di dalamnya:
flutter create --platforms=android. # hasilkan platform runner (image_picker butuh native)
flutter pub get # menambah: image_picker ^1.1.2, provider ^6.1.2
flutter analyze
flutter test # 3 unit + 2 widget -> SEMUA HIJAU sejak starter
```

> Folder `android/` sengaja **tidak** disertakan. Jalankan `flutter create` dari dalam folder starter; pulihkan `pubspec.yaml`/`analysis_options.yaml` dari Git bila ditimpa. **Jangan ubah `pubspec.yaml`**, dependency sudah dipasang dan dipin. Untuk izin Android, tambahkan deklarasi di `AndroidManifest.xml` sesuai `PERMISSIONS.md` (bukan secret, hanya deklarasi OS).

> **No-secret rule:** P06 tidak menyimpan token/URL/key. `attachmentPath` hanya path file lokal (gallery/camera). Tidak ada signing key di starter ini.

---

## Struktur starter P06

```text
06-Starter-Code/p06-testing-device/
├── pubspec.yaml # image_picker ^1.1.2, provider ^6.1.2
├── analysis_options.yaml # const lints aktif
├── PERMISSIONS.md # deklarasi izin Android/iOS (bukan secret)
├── lib/
│ ├── main.dart # TaskProvider()..loadTasks() (default: tanpa attachment svc)
│ ├── app.dart
│ ├── core/{constants,theme}/
│ └── features/
│ ├── attachments/attachment_service.dart # sealed AttachmentResult + Local/Impl (fallback hijau)
│ └── tasks/
│ ├── domain/task.dart # +attachmentPath, status (UNIT TARGET)
│ ├── services/task_filter_service.dart # pure-Dart (UNIT TARGET)
│ └── presentation/
│ ├── providers/task_provider.dart # attachPhoto = TODO (CP2); loadTasks jalan
│ └── screens/{task_list_screen,task_form_screen}.dart
└── test/
 ├── domain/task_status_test.dart # UNIT #1
 ├── services/task_filter_service_test.dart # UNIT #2
 ├── services/attachment_service_test.dart # UNIT #3 (device fallback)
 └── widget/
 ├── task_form_widget_test.dart # WIDGET #1 (validasi)
 └── task_list_widget_test.dart # WIDGET #2 (empty/error/list)
```

**Aturan batas (penting):**
- Boleh mengubah `task_provider.dart` (isi `attachPhoto` wiring ke service + `switch` atas `AttachmentResult` + notify).
- Boleh melengkapi `_obtainPicker` di `attachment_service.dart` dengan panggilan `image_picker` (CP3 device).
- Tidak boleh mengubah `Task` field/enum, `TaskFilterService` kontrak, `AttachmentResult` sealed + 3 subtype, `LocalAttachmentService` (sumber kebenaran unit test fallback), atau status derivation.
- Tidak boleh menambah package atau mengubah signature metode yang sudah didefinisikan.

**Role starter:** shell testing + device lengkap. `TaskFilterService`, `AttachmentService` (abstract + Local + Impl), `AttachmentResult` sealed, provider state, list+form screens, dan **semua 5 test** sudah tersedia. Yang sengaja no-op: **wiring `attachPhoto` di `TaskProvider`** (CP2) + **pemanggilan `image_picker` di `_obtainPicker`** (CP3). Bukan bug, tugas implementasi yang diverifikasi oleh hijau-nya test + UI fallback.

---

## Mengapa Testing, dan Kenapa Sekarang

P01-P05 membangun aplikasi; P06 **membuktikan** bahwa aplikasi itu bekerja dan tidak rapuh. Tiga prinsip yang dilatih:

1. **Logika pure-Dart adalah aset paling murah diuji.** `TaskFilterService.apply` tidak mengimpor Flutter. Test-nya berjalan dalam milidetik, tanpa emulator, tanpa plugin native. Setiap bug filter yang lolos ke produksi mahal; di unit test ia tertangkap gratis. Kenapa kita memisahkan logika dari UI.
2. **Device feature harus punya cabang gagal yang aman, bukan crash.** `image_picker` melempar `PlatformException` saat izin ditolak, atau mengembalikan `null` saat tidak ada kamera/galeri. Aplikasi andal **memetakan** kedua kasus ke hasil yang ditangani UI, bukan membiarkan exception naik. Pola `sealed AttachmentResult` + `switch` exhaustif (dipinjam dari P05 `ApiError`) memaksa tiap cabang ditangani.
3. **Widget test menjaga kontrak UI tanpa perangkat.** "Form kosong -> error", "list error -> Retry", "list kosong -> empty message" adalah kontrak. Widget test menguncinya; refactor tidak akan diam-diam merusaknya. `flutter test` hijau adalah **gate rilis** menuju P07.

> **Sambungan dengan P05:** `AttachmentResult` meminjam pola `sealed ApiError`. Bedanya: sumber error bukan HTTP status, melainkan eksepsi plugin + `null` return. Tapi idiomnya sama, `switch` exhaustif, pesan bermakna per subtype, UI tidak `throw`.

> **Mengapa `LocalAttachmentService`?** Plugin native tidak bisa dijalankan di CI headless. Untuk menguji cabang device-unavailable/permission-denied **tanpa perangkat**, kita butuh implementasi lokal yang bisa direkayasa. `LocalAttachmentService` menyediakan tiga skenario (`success`/`unavailable`/`denied`), unit test `attachment_service_test.dart` hijau tanpa pernah menyentuh `image_picker`.

---

## CHECKPOINT 1: Unit Test, Model & Filter Service

**Goal:** memahami + memverifikasi `Task.status` dan `TaskFilterService`; dua file unit test hijau.
**Time:** ~15 menit

### 1.1 Baca `task_filter_service.dart`, logika pure-Dart

```dart
class TaskFilter {
 final TaskStatus? status;
 final String search;
 const TaskFilter({this.status, this.search = ''});
}

class TaskFilterService {
 const TaskFilterService();

 List<Task> apply(List<Task> tasks, TaskFilter filter) {
 if (tasks.isEmpty) return const [];
 final q = filter.search.trim().toLowerCase();
 return tasks.where((t) {
 final statusOk = filter.status == null || t.status == filter.status;
 final searchOk = q.isEmpty ||
 t.title.toLowerCase().contains(q) ||
 t.description.toLowerCase().contains(q);
 return statusOk && searchOk;
 }).toList(growable: false);
 }
}
```

**Penting:**

1. **Tidak ada `import 'package:flutter'`.** Kelas ini hanya logika. Karena itu bisa diuji murni (`flutter test` tanpa binding).
2. **Defensive empty.** Input list kosong -> kembalikan list kosong, bukan error. Mencegah edge case merambat.
3. **AND semantics.** `status != null` DAN `search` non-kosong -> keduanya harus cocok. Bukan OR.
4. **Case-insensitive + trim.** Pencarian tidak peduli kapital/spasi awal-akhir. `" MATH "` cocok `"Complete Math Assignment"`.
5. **`growable: false`.** Hasil immutable secara struktural; jejak kecil performa + kejelasan intent.

### 1.2 Baca `Task.status`, turunan konsisten

```dart
TaskStatus get status {
 if (isCompleted) return TaskStatus.completed;
 if (dueDate.isBefore(DateTime.now())) return TaskStatus.overdue;
 return TaskStatus.pending;
}
```

**Penting:**

1. **Urutan penting.** `completed` dicek sebelum `overdue`. Task selesai yang jatuh tempo tetap `completed`, bukan `overdue`.
2. **Komputasi, bukan field.** Status bukan disimpan; ia diturunkan dari `isCompleted` + `dueDate`. Filter service memakainya langsung lewat `t.status`.
3. **`DateTime.now()` non-deterministik.** Alasan test memakai tanggal relatif (`add`/`subtract`) dari `DateTime.now()` di dalam test, bukan tanggal hardcode, agar status tetap stabil lintas waktu.

### 1.3 Verifikasi unit test hijau

```bash
flutter test test/domain/task_status_test.dart # completed/overdue/pending
flutter test test/services/task_filter_service_test.dart # status + search + kombinasi + defensive
```

Test menyatakan ekspektasi (semua sudah hijau di starter, kamu **membaca untuk memahami**):
- `Task` `isCompleted: true` -> `TaskStatus.completed`.
- `dueDate` lampau, `isCompleted: false` -> `TaskStatus.overdue`.
- `dueDate` depan -> `TaskStatus.pending`.
- `byStatus(sample, overdue)` -> hanya id `b`.
- `bySearch(sample, 'MATH')` (kapital) -> tetap cocok `a`.
- Kombinasi `pending + 'read'` -> kosong (karena 'Read History' overdue); `overdue + 'read'` -> `[b]`.
- Input `[]` + `TaskFilter.empty` -> `[]` (defensive).

> **Ini gate konsep.** Bila kamu belum bisa menjelaskan "kenapa `completed` dicek sebelum `overdue`" atau "kenapa test pakai tanggal relatif", tunda CP2. CP2 memakai pola `sealed` yang sama; salah paham di sini -> bug susur di attachment.

### Checkpoint Validation

- [ ] `flutter test test/domain/task_status_test.dart`, hijau.
- [ ] `flutter test test/services/task_filter_service_test.dart`, hijau.
- [ ] `flutter analyze` bersih.
- [ ] Kamu bisa menjelaskan AND semantics + case-insensitive search + defensive empty.

**Run & Test:**
```bash
flutter test test/domain/ test/services/task_filter_service_test.dart
flutter analyze
```

---

## CHECKPOINT 2: Device Feature, Attachment Service + Fallback

**Goal:** memahami `sealed AttachmentResult` + menghubungkan `attachPhoto` ke `AttachmentService`; semua cabang (success/unavailable/denied) terlihat di UI tanpa crash.
**Time:** ~20 menit

**Melanjutkan CP 1:**
- Already have: filter + 3 unit test hijau; paham `sealed` + `switch`.
- 🆕 Will add: device feature + fallback aman, diverifikasi `attachment_service_test.dart`.

### 2.1 Baca `AttachmentResult`, sealed untuk fallback

```dart
sealed class AttachmentResult {
 const AttachmentResult();
}
class AttachmentSuccess extends AttachmentResult {
 final String path;
 const AttachmentSuccess(this.path);
}
class AttachmentUnavailable extends AttachmentResult {
 final String reason;
 const AttachmentUnavailable([this.reason = 'Device feature unavailable.']);
}
class AttachmentDenied extends AttachmentResult {
 final String reason;
 const AttachmentDenied([this.reason = 'Permission denied.']);
}
```

**Penting:**

1. **Tiga cabang lengkap.** Sukses (path), perangkat tak tersedia (emulator tanpa kamera / galeri kosong), izin ditolak. Tidak ada `throw` ke UI.
2. **`sealed` = exhaustif.** Saat UI `switch` atas `AttachmentResult`, compiler menolak bila satu subtype tak ditangani. Tidak ada banner "lupa kasus".
3. **`Denied` vs `Unavailable`.** Dibedakan karena aksi pengguna berbeda: denied -> "aktifkan izin di pengaturan"; unavailable -> "pakai perangkat lain / gallery fallback". Pesan berbeda = UX berbeda.
4. **Bukan exception.** Cabang gagal adalah **nilai kembalian**, bukan throw. Provider `attachPhoto` cukup `switch`, tidak perlu `try/catch` (service sudah menangkap internal).

### 2.2 Baca `LocalAttachmentService`, rekayasa skenario tanpa perangkat

```dart
class LocalAttachmentService implements AttachmentService {
 LocalAttachmentService({
 this.galleryBehavior = AttachmentScenario.success,
 this.cameraBehavior = AttachmentScenario.success,
 this.counterStart = 0,
 });
 enum AttachmentScenario { success, unavailable, denied }
 //...pickFromGallery/pickFromCamera -> _resolve(behavior)
}
```

Unit test `attachment_service_test.dart` hijau membuktikan tiga cabang:
- `galleryBehavior: success` -> `AttachmentSuccess(path)` (path mulai `local://`).
- `cameraBehavior: unavailable` -> `AttachmentUnavailable()`.
- `galleryBehavior: denied` -> `AttachmentDenied()`.

> Inti acceptance criteria P06: **device unavailable / permission denied fallback** dapat diverifikasi **tanpa perangkat**.

### 2.3 Hubungkan `attachPhoto` di `TaskProvider` (TODO student)

Kerangka yang harus kamu lengkapi (lihat komentar di `task_provider.dart`):

```dart
Future<void> attachPhoto({bool fromCamera = false}) async {
 final svc = _attachmentService;
 if (svc == null) {
 attachmentError = 'No attachment service configured.';
 notifyListeners();
 return;
 }
 lastAttachment =
 fromCamera ? await svc.pickFromCamera() : await svc.pickFromGallery();
 attachmentError = null;
 notifyListeners();
}
```

**Aturan:**
- Jangan `throw`. Service sudah mengembalikan `AttachmentResult`; kamu hanya menyimpan + notify.
- Setelah wiring, UI `AttachmentStatusBanner` `switch` atas `lastAttachment` untuk menampilkan pesan per cabang.

### 2.4 Verifikasi fallback di UI (tanpa perangkat)

Di `main.dart`, suntik `LocalAttachmentService` dengan skenario berbeda, lalu `flutter run`:

```dart
ChangeNotifierProvider(
 create: (_) => TaskProvider(
 attachmentService: LocalAttachmentService(
 galleryBehavior: AttachmentScenario.denied,
 ),
 )..loadTasks(),
 child: const TaskTrackerApp(),
)
```

Tekan "Pick photo" -> `AttachmentStatusBanner` tampil: "Izin kamera/galeri ditolak…". Ganti ke `unavailable` -> banner "tidak tersedia…". Ganti ke `success` -> banner "Attached: local://…".

### Checkpoint Validation

- [ ] `flutter test test/services/attachment_service_test.dart`, hijau (3 skenario + switch exhaustif).
- [ ] `flutter analyze` bersih.
- [ ] `attachPhoto` terhubung; tiga skenario `LocalAttachmentService` memunculkan banner berbeda.
- [ ] Tidak ada `throw` dari `attachPhoto` ke UI (semua jadi `AttachmentResult`).

**Run & Test:**
```bash
flutter test test/services/attachment_service_test.dart
flutter analyze
flutter run # ganti behavior LocalAttachmentService -> banner berubah
```

---

## CHECKPOINT 3: Image Picker Nyata + Widget Test Gate

**Goal:** lengkapi `_obtainPicker` dengan `image_picker` asli; pastikan widget test (form + list) tetap hijau sebagai gate rilis.
**Time:** ~20 menit

**Melanjutkan CP 2:**
- Already have: `attachPhoto` wiring + fallback hijau.
- 🆕 Will add: device path nyata + verifikasi state UI via widget test.

### 3.1 Lengkapi `ImagePickerAttachmentService._obtainPicker`

Berkas `attachment_service.dart` punya `TODO(student)` di `_obtainPicker`. Implementasi nyata (setelah baca `PERMISSIONS.md` + tambah izin `AndroidManifest.xml`):

```dart
import 'package:image_picker/image_picker.dart';

_PickerFn _obtainPicker() {
 final picker = ImagePicker();
 return (source) async {
 final x = await picker.pickImage(
 source: source == AttachmentSource.camera
 ? ImageSource.camera
 : ImageSource.gallery,
 maxWidth: 1280,
 );
 return x?.path;
 };
}
```

Di `main.dart`, ganti `LocalAttachmentService` -> `const ImagePickerAttachmentService()`.

### 3.2 Skenario device & fallback

| Kondisi | Hasil `pickImage` | `AttachmentResult` | Banner |
|----------------------------------------|------------------------|--------------------------|-------------------|
| Izin disetujui, ada galeri/kamera | `XFile(path)` | `AttachmentSuccess` | "Attached: …" |
| User batal / galeri kosong | `null` | `AttachmentUnavailable` | "tidak tersedia" |
| Izin ditolak (`PlatformException`) | throw -> catch | `AttachmentDenied` | "izin ditolak" |
| Emulator tanpa kamera (camera source) | throw/null | `AttachmentUnavailable`/`Denied` | sesuai pesan |

> `ImagePickerAttachmentService._pick` sudah menangkap `catch (e)` dan memetakan ke `Denied` bila pesan mengandung `permission`/`denied`, selain itu `Unavailable`. **Jangan hapus** blok catch, itu jantung fallback.

### 3.3 Widget test sebagai gate rilis

```bash
flutter test test/widget/task_form_widget_test.dart # empty/short/valid
flutter test test/widget/task_list_widget_test.dart # empty/error+retry/list
```

- **Form:** tekan Save dengan title kosong -> `AppStrings.errTitleRequired`; title `"ab"` -> `errTitleTooShort`; title valid -> `onSubmit` dipanggil dengan `Task`.
- **List:** provider seeded empty -> empty message; `seedError('Network down.')` -> ikon `cloud_off` + teks error + tombol Retry; seeded 2 task -> dua `ListTile`.

`seedTasks`/`seedError` adalah helper `@visibleForTesting` di `TaskProvider`, untuk menyuntik state tanpa repo nyata. Tidak dipakai di produksi.

### Checkpoint Validation

- [ ] `flutter test`, **semua test hijau** (3 unit + 2 widget).
- [ ] `flutter analyze` bersih.
- [ ] (Di perangkat) `ImagePickerAttachmentService()` -> gallery pick -> banner sukses; tolak izin -> banner denied (bukan crash); emulator tanpa kamera -> unavailable.
- [ ] Kamu bisa menjelaskan tiga skenario attachment + kenapa tidak boleh `throw` ke UI.

**Run & Test:**
```bash
flutter test # All tests passed!
flutter analyze # No issues found!
flutter run # ganti Local <-> ImagePicker, uji 3 skenario
```

> **Fallback path CP3:** seluruh skenario device + fallback teruji **tanpa perangkat** via `LocalAttachmentService`; `ImagePickerAttachmentService` adalah swap di runtime. Tidak ada checkpoint yang butuh perangkat untuk lulus gate `flutter test`.

---

## Summary

**Yang kamu kerjakan:**
- Membaca & memverifikasi unit test pure-Dart: `Task.status` (3 kasus) + `TaskFilterService` (status/search/kombinasi/defensive), hijau.
- Memahami `sealed AttachmentResult` + menghubungkan `attachPhoto` ke `AttachmentService`, sehingga **device-unavailable & permission-denied tidak pernah crash**, hijau via `LocalAttachmentService`.
- Melengkapi `ImagePickerAttachmentService._obtainPicker` untuk jalur device nyata; menukar Local/ImagePicker tanpa ubah UI.
- Memverifikasi state UI via widget test (form validasi + list empty/error/retry) sebagai gate rilis menuju P07.

**Konsep kunci:**
- **Logika pure-Dart = aset murah diuji**, pisahkan dari Flutter; unit test cepat, andal, tanpa emulator.
- **Device feature wajib punya cabang gagal aman**, `sealed AttachmentResult` (success/unavailable/denied) + `switch` exhaustif; tidak ada `throw` ke UI.
- **Rekayasa skenario tanpa perangkat**, `LocalAttachmentService` menguji ketiga cabang di CI headless.
- **Widget test = kontrak UI**, form kosong -> error, list error -> Retry, list kosong -> empty; refactor tidak diam-diam merusak.
- **Gate rilis**, `flutter test` + `flutter analyze` hijau adalah prasyarat P07 (build APK + demo).
- **Pola `sealed` dipinjam dari P05**, `AttachmentResult` seperti `ApiError`; beda sumber, sama idiomnya.

**Preview sesi berikutnya (P07):**
- Quality gate: `flutter analyze` + `flutter test` + `flutter build apk --release`.
- `const` & rebuild basics (hemat rebuild, bukan sekadar gaya).
- Release checklist tanpa signing secret; demo individual (app walkthrough + code walkthrough + live modification).
- Proyek Akhir final: APK + demo + live modification dari `05-Assessment/Bank-Live-Coding.md`.

---

## Troubleshooting

**`flutter test` gagal `image_picker not found`.**
Plugin native dimuat saat `flutter create`. Headless test (`flutter test`) tidak menyentuh plugin; bila gagal, cek `flutter pub get` + nama package `p06_testing_device`. Unit test `LocalAttachmentService` tidak mengimpor `image_picker`.

**Banner attachment tidak muncul setelah "Pick photo".**
`attachPhoto` masih TODO (no-op). Implementasikan CP2: panggil service -> simpan `lastAttachment` -> `notifyListeners()`.

**Crash saat tekan Pick di emulator tanpa kamera.**
Seharusnya tidak, `_pick` menangkap eksepsi -> `AttachmentUnavailable`. Bila crash, blok `catch` di `ImagePickerAttachmentService._pick` dihapus/ditimpa (jangan).

**`PlatformException: Permission denied` walau sudah setujui.**
Izin belum ditambahkan di `AndroidManifest.xml` (lihat `PERMISSIONS.md`). Android 13+ pakai `READ_MEDIA_IMAGES`. Cek `flutter clean` + reinstall.

**Test `task_list_widget_test` gagal: Retry tidak ditemukan.**
`seedError` belum dipanggil, atau provider tidak dipasang via `ChangeNotifierProvider.value`. Pastikan harness memakai provider yang sama dengan yang di-seed.

**`prefer_const_constructors` warning di `analyze`.**
Tandai widget immutable tanpa argumen dinamis sebagai `const`. Linter akan menuntun; jangan `// ignore:` tanpa alasan.

**`A ChangeNotifier used after dispose`.**
Pola dari P04: simpan provider sebelum `await`. `attachPhoto` async; bila user cepat menutup screen, pastikan tidak notify setelah dispose (guard `mounted` di UI bila perlu).

---

## Self-Assessment (sebelum & sesudah)

**Skor kepercayaan 1-5, sebelum & sesudah P06:**
- Menulis unit test untuk logika pure-Dart (status/filter): -> 
- Menulis widget test (validasi + state UI): -> 
- Mengintegrasikan fitur device (image picker) tanpa crash: -> 
- Menerapkan fallback device-unavailable/permission-denied: -> 
- Memakai `sealed` result + `switch` exhaustif (reuse dari P05): -> 
- Menyuntik service/mock ke provider untuk uji tanpa perangkat: -> 

**Verifikasi praktik:**
- Tambah satu kasus di `task_filter_service_test.dart`: `bySearch` terhadap `description` (bukan title) -> hijau.
- Jelaskan dengan kata sendiri **kenapa** `LocalAttachmentService` eksis, dan kenapa `ImagePickerAttachmentService` tidak bisa diuji langsung di unit test.
- Demo fallback di depan teman/dosen: suntik `denied` -> banner; `unavailable` -> banner; `success` -> banner path. Jelaskan alur: service -> provider `attachPhoto` -> `lastAttachment` -> banner `switch`.

---

## Challenge Bertingkat (kerja sendiri, siapkan bukti)

Pilih satu level. Semua boleh pakai AI untuk **penjelasan/debugging**, bukan menulis core test/wiring tanpa analisis.

**Level 1 (Basic):** Tambah kasus di `attachment_service_test.dart`: `LocalAttachmentService` default (success) -> `pickFromCamera()` mengembalikan `AttachmentSuccess` dengan path unik (counter naik). Kriteria: test lulus, `analyze` bersih.

**Level 2 (Medium):** Tambah widget test `attachment_banner_test.dart`: pump `AttachmentStatusBanner` dengan provider berisi `lastAttachment = AttachmentDenied(...)` -> teks permission muncul. Lalu `AttachmentUnavailable` -> teks unavailable. Kriteria: dua kasus hijau; tidak mengubah sealed.

**Level 3 (Advanced):** Persistensikan `attachmentPath` ke `Task` (lewat provider lokal in-memory) dan tampilkan ikon `attach_file` di `_TaskTile` bila ada. Atau: dukung `pickMultiImage` (galeri banyak) dengan `List<String>` path + fallback yang sama. Kriteria: demo lampiran tersimpan lintas navigasi screen; jelaskan trade-off menyimpan path file (bukan bytes) untuk memori. Relevan untuk Proyek Akhir.

**Submit:** screenshot + paste kode + 2-3 kalimat penjelasan pendekatan.

> Challenge Level 2 langsung relevan untuk **Proyek Akhir** (widget test sebagai bukti QA). Level 3 memperkaya fitur device untuk demo individual.

---

## AI-Enhanced Learning (P06)

**Penggunaan AI produktif di P06:**
- "Kenapa memisahkan logika filter ke kelas pure-Dart (tanpa Flutter)?"
- "Apa itu `sealed` class dan kenapa `switch`-nya exhaustif? Contoh AttachmentResult."
- "Bagaimana mendemokan permission-denied tanpa perangkat?" (`LocalAttachmentService`)
- "Kenapa widget test pakai `Key` pada TextField/FilledButton?" (deterministik `find.byKey`)
- "Apa beda `pump()` dan `pumpAndSettle()` di flutter_test?"
- "Kenapa `image_picker` tidak bisa diuji di CI headless, dan apa solusinya?"

**Hindari:**
- "Tulis 3 unit test + 2 widget test untuk app saya." (core test, analisis sendiri)
- "Implementasikan `attachPhoto` saya." (core wiring, analisis sendiri)
- "Buatkan mapping `PlatformException` ke error type." (core fallback, analisis sendiri; pola sudah ada)

**Wajib bila memakai AI:** isi `../01-Orientasi/Template-AI-Interaction-Log.md`, tujuan, prompt, ringkasan respons, perubahan dipilih/ditolak, dan **verifikasi pemahaman** (jelaskan ulang + bukti `flutter test` hijau + demo fallback). Saat demo, dosen bisa tanya "kenapa `completed` sebelum `overdue`?" / "cabang mana yang muncul saat izin ditolak?", kamu harus bisa jawab.

---

## Resources

- **Resmi:** [docs.flutter.dev/testing/overview](https://docs.flutter.dev/testing/overview) (testing overview), [docs.flutter.dev/cookbook/testing/unit](https://docs.flutter.dev/cookbook/testing/unit/introduction) (unit), [docs.flutter.dev/cookbook/testing/widget](https://docs.flutter.dev/cookbook/testing/widget/introduction) (widget), [pub.dev/packages/image_picker](https://pub.dev/packages/image_picker) (device feature), [docs.flutter.dev/perf/best-practices](https://docs.flutter.dev/perf/best-practices) (const/rebuild, fondasi P07).
- **Dalam paket:** `../06-Starter-Code/p06-testing-device/README.md` + `PERMISSIONS.md`, `../02-Materi/P05-REST-API-Error-Handling.md` (pola `sealed`), `../05-Assessment/Bank-Live-Coding.md` (persiapan P07), `../01-Orientasi/Template-AI-Interaction-Log.md`.
- **Konsep dasar:** `../../Tutorial/outline-p09-14-advanced-features.md` (dipersempit ke image picker + permission + testing; **tanpa** maps/analytics/notification yang dikecualikan planning §2).
- **Starter:** `../06-Starter-Code/p06-testing-device/` (README + struktur di atas).

**Persiapan P07:** baca ulang `flutter analyze`/`flutter test` sebagai gate; P07 akan menambah `flutter build apk --release`, `const`/rebuild basics, dan demo individual. Proyek Akhir dibuka setelah P06, mulai kumpulkan bukti test (3 unit + 2 widget) sebagai syarat QA.

---
