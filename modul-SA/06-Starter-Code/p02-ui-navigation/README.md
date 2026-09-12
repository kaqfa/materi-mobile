# p02-ui-navigation, Widget, Layout & Navigation

> **Pertemuan 2**, fokus: task list, reusable `TaskCard`, navigasi list-detail/add, responsive dasar.
> **Role starter:** bersih (tidak bugged). Navigasi sengaja ditinggalkan sebagai TODO.

## Prasyarat

- Selesai P01 (environment + model `Task` sudah dipahami).
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
├── main.dart
├── app.dart
├── core/{constants,theme}/
└── features/tasks/
 ├── domain/task.dart
 └── presentation/
 ├── widgets/task_card.dart # reusable
 └── screens/
 ├── task_list_screen.dart # list + responsive + TODO navigasi
 ├── task_detail_screen.dart # stub (lengkapi konten)
 └── add_task_screen.dart # stub (ganti dengan form)
test/
├── task_card_test.dart
└── widget_test.dart
```

## Target checkpoint

### CHECKPOINT 1: TaskCard + task list
**Goal:** daftar 20 task tampil memakai `TaskCard` reusable.
**Time:** ~20 menit

**Validasi:**
- [ ] `flutter run` menampilkan daftar task.
- [ ] `TaskCard` menampilkan title, deskripsi, due date, priority, status.
- [ ] Task completed menampilkan title strikethrough + ikson check.
- [ ] `test/task_card_test.dart` lulus.

### CHECKPOINT 2: Navigasi list-detail/add
**Goal:** tap card membuka detail; FAB membuka add; task baru muncul di list.
**Time:** ~35 menit

**Validasi:**
- [ ] Tap `TaskCard` -> `Navigator.push` ke `TaskDetailScreen`.
- [ ] FAB -> push `AddTaskScreen`; task hasil ditambahkan ke daftar.
- [ ] Back button kembali ke list tanpa error.

### CHECKPOINT 3: Responsive dasar
**Goal:** layout adaptif portrait/landscape tanpa overflow.
**Time:** ~15 menit

**Validasi:**
- [ ] Portrait (lebar < 600) -> 1 kolom list.
- [ ] Landscape / layar lebar (≥ 600) -> grid 2 kolom.
- [ ] Tidak ada overflow atau teks terpotong saat rotate.

## Yang TIDAK boleh diubah

- `Task` class dan enum.
- Menambah package baru.
- `core/` (kecuali menyelaraskan tema saat perlu).

## Troubleshooting

- **Tap card tidak responsif?** Pastikan `InkWell`/`onTap` terhubung; `TaskCard` sudah terima `onTap`.
- **Grid overflow?** Atur `mainAxisExtent`/`maxCrossAxisExtent` sesuai tinggi `TaskCard`.
- **Task baru tidak muncul?** `AddTaskScreen` harus `pop<Task>(task)` dan list memakai `setState`.

## Status verifikasi host

Host produksi tidak punya Flutter SDK. `pub get/analyze/test` belum dijalankan di sini; verifikasi runtime ditangguhkan sampai SDK tersedia (lihat `06-Starter-Code/README.md`).
