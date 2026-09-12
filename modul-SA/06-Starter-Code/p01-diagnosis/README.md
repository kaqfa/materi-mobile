# p01-diagnosis, Diagnosis Dart & Debugging

> **Pertemuan 1**, fokus: cek environment, model `Task`, perbaiki filter/search rusak.
> **Role starter:** baseline bugged. Mahasiswa mendiagnosis, bukan menulis dari nol.

## Prasyarat

- Flutter SDK terpasang, `flutter doctor` bersih.
- IDE (VS Code / Android Studio) dengan plugin Dart aktif.
- Handout P01 dan Tes Diagnostik Praktik sudah dikerjakan.

## Instruksi run

```bash
# 1. Copy folder ini ke workspace kosong, lalu di dalamnya:
flutter create --platforms=android,web. # hasilkan platform runner
flutter pub get
flutter analyze
flutter test

flutter run
```

Folder `android/`, `web/`, dll. sengaja tidak disertakan; dibuat oleh `flutter create`.

## Struktur penting

```text
lib/
├── main.dart
├── app.dart
├── core/{constants,theme}/
└── features/tasks/
 ├── domain/
 │ ├── task.dart # model + enum + getDummyTasks()
 │ └── task_filter.dart # LAYANAN SENGAJA RUSAK (diagnosis target)
 └── presentation/screens/task_list_screen.dart
test/
├── task_filter_test.dart # beberapa test sengaja MERAH
└── widget_test.dart # smoke (hijau)
```

## Target checkpoint

### CHECKPOINT 1: Environment & model
**Goal:** aplikasi build dan run, data dummy tampil.
**Time:** ~15 menit

**Validasi:**
- [ ] `flutter pub get` sukses.
- [ ] `flutter analyze` bersih (atau warning dijelaskan).
- [ ] `flutter run` menampilkan daftar 20 task dummy.
- [ ] `test/widget_test.dart` lulus.

### CHECKPOINT 2: Diagnosis filter & search (inti)
**Goal:** temukan dan perbaiki bug di `task_filter.dart` sampai semua test hijau.
**Time:** ~40 menit

**Gejala yang terlihat saat run:**
- Memilih filter "Pending" justru menampilkan task **bukan** pending.
- Mengetik "math" di search tidak menemukan "Complete Math Assignment".

**Validasi:**
- [ ] `flutter test test/task_filter_test.dart`, semua test **hijau**.
- [ ] Filter "Pending/Overdue/Completed" menampilkan task yang tepat.
- [ ] Search "math" menemukan "Complete Math Assignment" (case-insensitive).
- [ ] Search kosong mengembalikan semua task.
- [ ] `flutter analyze` tetap bersih.

## Petunjuk diagnosis

1. Jalankan `flutter test test/task_filter_test.dart`. Baca pesan kegagalan; nama test menyebut ekspektasi benar.
2. Buka `lib/features/tasks/domain/task_filter.dart`. Dua metode ditandai `// TODO(student) BUG`.
3. Jangan ubah model `Task` atau enum. Hanya perbaiki logika filter/search.
4. AI boleh untuk **penjelasan** dan diagnosis, bukan menulis jawaban langsung. Catat di AI Interaction Log.

## Yang TIDAK boleh diubah

- `Task` class, `TaskStatus`, `TaskPriority`.
- Struktur data `List<Task>` di screen.
- Menambah package baru.

## Troubleshooting

- **`flutter create` menimpa pubspec?** Jalankan dari dalam folder; jika menimpa, pulihkan `pubspec.yaml` dari git.
- **Test tetap merah padahal filter sudah diperbaiki?** Pastikan `status` getter di model benar (completed > overdue > prioritas waktu).
- **`Color.withValues` tidak dikenal?** Flutter < 3.27 pakai `.withOpacity()`. Lihat constraint versi di `pubspec.yaml`.

## Status verifikasi host

Host produksi tidak punya Flutter SDK. `pub get/analyze/test` belum dijalankan di sini; verifikasi runtime ditangguhkan sampai SDK tersedia (lihat `06-Starter-Code/README.md`).
