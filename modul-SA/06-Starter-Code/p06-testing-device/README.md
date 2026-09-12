# p06-testing-device, Device Feature (Image Picker) & Testing QA

> **Pertemuan 6**, fokus: satu fitur device (image picker/camera + gallery fallback), permission handling, unit test (model/filter-validator), widget test (form/empty/error/list).
> **Role starter:** shell testing + device feature lengkap (filter service, attachment service sealed result, provider state, list+form screens). Wiring `attachPhoto` ke `AttachmentService` sengaja no-op TODO (CP2); fallback device-unavailable/permission-denied **sudah hijau** di unit test via `LocalAttachmentService`.

## Prasyarat

- Selesai P05 (error terstruktur, mock fallback). P06 memakai pola `sealed` + `switch` exhaustif yang sama untuk `AttachmentResult`.
- `flutter doctor` bersih; `image_picker` membutuhkan perangkat/emulator Android (tidak jalan di headless test, itulah sebabnya unit test memakai `LocalAttachmentService`).
- Assignment 2 (persistence + API) sudah ditenggat **sebelum P06**.

## Instruksi run

```bash
flutter create --platforms=android. # di dalam folder ini (image_picker butuh native)
flutter pub get # menambah: image_picker ^1.1.2, provider ^6.1.2
flutter analyze
flutter test # 3 unit + 2 widget -> SEMUA HIJAU sejak starter
flutter run
```

> Folder `android/` sengaja tidak disertakan (di-`.gitignore`); `flutter create` membuatnya. **Jangan ubah `pubspec.yaml`**, dependency sudah dipasang dan dipin. Headless test tidak menyentuh plugin native; semua hijau tanpa perangkat.

## Struktur penting

```text
lib/
├── main.dart # TaskProvider (tanpa attachment service by default)
├── app.dart
├── core/{constants,theme}/ # AppColors, AppStrings, AppTheme
└── features/
 ├── attachments/
 │ └── attachment_service.dart # sealed AttachmentResult + Local/Impl (fallback hijau)
 └── tasks/
 ├── domain/task.dart # +attachmentPath, status (unit target)
 ├── services/task_filter_service.dart # pure-Dart filter (unit target)
 └── presentation/
 ├── providers/task_provider.dart # attachPhoto = TODO (CP2); loadTasks jalan
 └── screens/{task_list_screen,task_form_screen}.dart
test/
├── domain/task_status_test.dart # unit #1: status completed/overdue/pending
├── services/task_filter_service_test.dart # unit #2: filter status/search/combined
├── services/attachment_service_test.dart # unit #3: device fallback (sealed)
└── widget/
 ├── task_form_widget_test.dart # widget #1: validation
 └── task_list_widget_test.dart # widget #2: empty/error/list states
```

## Target checkpoint

### CHECKPOINT 1: Filter service + 3 unit test (gate model)
**Goal:** `TaskFilterService` (status + search + kombinasi) dan `Task.status` diverifikasi hijau.
**Time:** ~25 menit

**Validasi:**
- [ ] `flutter test test/domain/task_status_test.dart`, hijau (completed/overdue/pending).
- [ ] `flutter test test/services/task_filter_service_test.dart`, hijau (status, search case-insensitive, AND, defensive empty).
- [ ] Diskusi: kenapa `TaskFilterService` pure-Dart (tanpa Flutter) lebih mudah & cepat diuji.

### CHECKPOINT 2: Attachment service + fallback device/permission
**Goal:** `attachPhoto` dihubungkan ke `AttachmentService`; semua cabang `AttachmentResult` (success/unavailable/denied) terlihat di UI.
**Time:** ~30 menit

**Melanjutkan CP 1:**
- Already have: filter + 3 unit test hijau.
- 🆕 Will add: wiring `LocalAttachmentService` (demo) -> tukar `ImagePickerAttachmentService` (device).

**Validasi:**
- [ ] `flutter test test/services/attachment_service_test.dart`, hijau (success/unavailable/denied + switch exhaustif).
- [ ] Suntik `LocalAttachmentService(galleryBehavior: denied)` ke provider -> tekan "Pick photo" -> `AttachmentStatusBanner` tampil pesan permission-denied.
- [ ] Ganti ke `ImagePickerAttachmentService()` di `main.dart` -> jalankan di perangkat/emulator; tolak izin -> banner denied (bukan crash). Bila emulator tanpa kamera -> banner unavailable.

### CHECKPOINT 3: 2 widget test + integrasi state UI
**Goal:** widget test form (validasi) + list (empty/error/list) hijau; UI menampilkan ketiga state.
**Time:** ~30 menit

**Melanjutkan CP 2:**
- Already have: device fallback + attachment wiring.
- 🆕 Will add: verifikasi state UI lewat widget test (tanpa perangkat).

**Validasi:**
- [ ] `flutter test test/widget/task_form_widget_test.dart`, hijau (empty/short/valid).
- [ ] `flutter test test/widget/task_list_widget_test.dart`, hijau (empty, error+retry, list).
- [ ] `flutter analyze` bersih; seluruh `flutter test` hijau sebelum lanjut P07.

## Yang TIDAK boleh diubah

- `Task` field + enum (boleh memperkaya method, bukan mengganti field).
- `TaskFilterService` kontrak (signature `apply`/`byStatus`/`bySearch`).
- `AttachmentResult` sealed + 3 subtype.
- `LocalAttachmentService` (hijau; sumber kebenaran unit test fallback).
- `Task` status derivation.

## Petunjuk

- `attachPhoto` wiring: panggil service -> `switch` atas `AttachmentResult` -> simpan ke `lastAttachment`/`attachmentError` -> `notifyListeners()`.
- Jangan throw dari `attachPhoto`; semua error device sudah dipetakan service ke `AttachmentUnavailable`/`AttachmentDenied`.
- Untuk demo tanpa perangkat, suntik `LocalAttachmentService`; untuk device, `ImagePickerAttachmentService` + lengkapi `_obtainPicker` (CP3 di materi).
- `seedTasks`/`seedError` adalah helper `@visibleForTesting`, jangan dipakai di kode produksi.

## Troubleshooting

- **Test gagal `image_picker not found`?** Plugin native dimuat saat `flutter create`. Headless test (`flutter test`) tidak menyentuh plugin; bila gagal, cek `pub get` + nama package `p06_testing_device`.
- **Banner tidak muncul setelah attach?** `attachPhoto` masih TODO (no-op). Implementasikan CP2.
- **Crash saat tekan Pick di emulator tanpa kamera?** Seharusnya tidak, service menangkap eksepsi -> `AttachmentUnavailable`. Bila masih crash, `catch` di `ImagePickerAttachmentService._pick` ditimpa/dihapus (jangan).
- **`PlatformException` permission?** Normal bila izin ditolak; dipetakan ke `AttachmentDenied`. Aktifkan izin di pengaturan perangkat.

## Catatan keamanan

- Tidak ada secret/key. `attachmentPath` hanya path file lokal (gallery/camera), bukan URL/token.
- Tidak menyimpan signing key apa pun di starter ini.

## Status verifikasi host

Host produksi tidak punya Flutter SDK. `pub get/analyze/test` belum dijalankan di sini; verifikasi runtime ditangguhkan sampai SDK tersedia (lihat `../README.md`).
