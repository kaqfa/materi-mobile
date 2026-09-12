# Solution Reference, p01-diagnosis

> **KHUSUS DOSEN. Jangan dibagikan ke mahasiswa sebelum sesi P01 selesai.**

## Lokasi solusi lengkap

Repo/tag privat (dosen): lihat konfigurasi internal PPB. File ini hanya ringkasan
pendekatan; solusi lengkap (komentar pengajaran + versi hijau dari test) disimpan
di tag `solution/p01` pada repo privat dosen.

## Perbaikan yang diharapkan

`lib/features/tasks/domain/task_filter.dart`:

```dart
List<Task> filterByStatus(List<Task> tasks, TaskStatus? status) {
 if (status == null) return List<Task>.unmodifiable(tasks);
 return tasks.where((t) => t.status == status).toList(growable: false);
}

List<Task> searchByTitle(List<Task> tasks, String query) {
 final q = query.trim().toLowerCase();
 if (q.isEmpty) return List<Task>.unmodifiable(tasks);
 return tasks.where((t) => t.title.toLowerCase().contains(q)).toList(growable: false);
}
```

## Titik diagnostik utama

1. `!=` -> `==` pada `filterByStatus` (logika terbalik).
2. `startsWith` + tidak lower-case -> `toLowerCase().contains()` (case-insensitive substring).

## Checklist rubrik singkat

- Filter status benar untuk pending/overdue/completed.
- Search case-insensitive + substring + real-time.
- Empty state untuk "no match" informatif.
- `flutter analyze` bersih.
- Mahasiswa bisa menjelaskan kenapa bug lama salah.
