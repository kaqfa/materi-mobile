# P11 — Advanced State Management

> Pertemuan 11 • Sub-CPMK53.2 • Modul: [State Management — bagian Provider](https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/07-state-management-shared-preferences)

Starter: refactor dari setState (P03) ke state terpusat — `TaskProvider` + `AuthProvider` di MultiProvider, `Consumer` vs `Selector` vs `context.read`.

## Cara mulai

```bash
flutter create --platforms=android,ios,web .
flutter pub get
flutter run
```

Login apa pun yang valid (email mengandung `@`, password ≥ 6 karakter).

## Checkpoints

| # | Tugas | Validasi |
|---|---|---|
| 1 | Implement `undo()` (TODO P11-2) + dorong juga toggle ke `_undoStack` (TODO P11-1) | Hapus tugas → tombol undo aktif → item kembali |
| 2 | Ganti satu `Consumer` menjadi `Selector<int>` (hanya `tasks.length`) — ukur rebuild dengan debugPrint di builder | Print tidak muncul saat perubahan tak relevan |
| 3 | Tambah `SyncProvider` (status: idle/syncing/error) dengan tombol yang menyalakan status 2 detik | Status tampil di AppBar tanpa membangun ulang list |

## Catatan

- `context.watch`/`Consumer` = listen (rebuild); `context.read` = aksi sekali (tidak rebuild). Salah pilih = rebuild berlebihan.
- BLoC/Riverpod = pembanding berkode di modul (bab 7, "Arah Setelah Provider") — ide efeknya sama: state keluar dari widget.
- Pain points P03 yang diselesaikan di sini: duplicate state antar screen & prop drilling — rasakan saat AuthGate berganti screen tanpa satu pun Navigator manual.
