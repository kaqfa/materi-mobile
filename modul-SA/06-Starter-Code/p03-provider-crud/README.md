# p03-provider-crud, Form, CRUD & Provider

> **Pertemuan 3**, fokus: validator, `TaskProvider` (ChangeNotifier), CRUD reaktif, loading/error/empty state.
> **Role starter:** shell lengkap (Provider + form + state UI), inti CRUD sengaja no-op TODO. Assignment 1 dimulai setelah checkpoint ini.

## Prasyarat

- Selesai P02 (list, `TaskCard`, navigasi).
- `flutter doctor` bersih.

## Instruksi run

```bash
flutter create --platforms=android,web. # di dalam folder ini
flutter pub get
flutter analyze
flutter test
flutter run
```

## Struktur penting

```text
lib/
├── main.dart # MultiProvider + ChangeNotifierProvider
├── app.dart
├── core/{constants,theme}/
└── features/tasks/
 ├── domain/task.dart
 └── presentation/
 ├── providers/task_provider.dart # CRUD inti = TODO
 ├── screens/
 │ ├── task_list_screen.dart # Consumer: loading/error/empty/list
 │ └── task_form_screen.dart # form + validator TODO
 └── widgets/task_card.dart
test/
├── task_provider_test.dart # beberapa test sengaja MERAH
└── widget_test.dart # smoke (hijau)
```

## Target checkpoint

### CHECKPOINT 1: Provider + state UI
**Goal:** `TaskProvider` terhubung; list memakai `Consumer`; loading/error/empty state tampil.
**Time:** ~20 menit

**Validasi:**
- [ ] `flutter run` menampilkan loading singkat lalu daftar task.
- [ ] Tap ikon centang -> panggilan `toggleComplete` (belum mengubah = TODO, oke untuk cek alur).
- [ ] `test/widget_test.dart` lulus.

### CHECKPOINT 2: Implementasi CRUD inti
**Goal:** add/update/delete/toggle bekerja dan reaktif.
**Time:** ~40 menit

**Validasi:**
- [ ] `flutter test test/task_provider_test.dart`, semua **hijau**.
- [ ] FAB -> form -> save -> task baru muncul di list.
- [ ] Tap card -> form edit -> save -> data berubah.
- [ ] Swipe kanan-ke-kiri -> konfirmasi -> task hilang.
- [ ] Tap ikon centang -> status berubah (completed/pending) + UI update.

### CHECKPOINT 3: Validasi form
**Goal:** form menolak input tidak valid.
**Time:** ~15 menit

**Validasi:**
- [ ] Title kosong -> pesan `AppStrings.errTitleRequired`.
- [ ] Title < 3 karakter -> `AppStrings.errTitleTooShort`.
- [ ] Form valid -> save berhasil.

## Yang TIDAK boleh diubah

- `Task` class dan enum.
- Menambah package baru.
- `main.dart` wiring Provider (kecuali menambah provider lain yang relevan).

## Petunjuk

- Pakai `copyWith` untuk immutability saat toggle/update.
- Panggil `notifyListeners()` di setiap mutasi agar UI reaktif.
- `findById` sudah disediakan untuk lookup by id.

## Troubleshooting

- **CRUD tidak mengubah list?** Pastikan method memodifikasi `_tasks` **dan** memanggil `notifyListeners()`.
- **Toggle lalu status chip tidak berubah?** `status` dihitung ulang otomatis dari `isCompleted`; cukup toggle flag-nya.
- **Form save diam?** Validator TODO masih `return null`; implementasi dulu sebelum test validasi.

## Status verifikasi host

Host produksi tidak punya Flutter SDK. `pub get/analyze/test` belum dijalankan di sini; verifikasi runtime ditangguhkan sampai SDK tersedia (lihat `06-Starter-Code/README.md`).
