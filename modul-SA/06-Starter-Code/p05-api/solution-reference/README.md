# Solution Reference, p05-api

> **KHUSUS DOSEN. Jangan dibagikan ke mahasiswa sebelum sesi P05 selesai.**

## Lokasi solusi lengkap

Repo/tag privat dosen: `solution/p05`. File ini ringkasan pendekatan.

## Provider CRUD yang diharapkan

`lib/features/tasks/presentation/providers/task_provider.dart`:

```dart
Future<void> addTask(Task task) async {
 try {
 await _repo.save(task);
 _error = null;
 _tasks = await _repo.getAll();
 } catch (e) {
 _error = _describe(e);
 }
 notifyListeners();
}

Future<void> updateTask(Task task) async {
 try {
 await _repo.save(task);
 _error = null;
 _tasks = await _repo.getAll();
 } catch (e) {
 _error = _describe(e);
 }
 notifyListeners();
}

Future<void> deleteTask(String id) async {
 try {
 await _repo.remove(id);
 _error = null;
 _tasks = await _repo.getAll();
 } catch (e) {
 _error = _describe(e);
 }
 notifyListeners();
}

Future<void> toggleComplete(String id) async {
 final task = findById(id);
 if (task == null) return;
 await updateTask(task.copyWith(isCompleted: !task.isCompleted));
}

String _describe(Object e) => switch (e) {
 NetworkError() => 'Tidak ada koneksi. Periksa internet lalu coba lagi.',
 ServerError() => 'Server sedang bermasalah. Coba lagi nanti.',
 ClientError() => 'Permintaan ditolak server.',
 NotFoundError() => 'Task tidak ditemukan.',
 ParseError() => 'Data server tidak terbaca.',
 _ => 'Terjadi kesalahan: $e',
 };
```

## Titik pengajaran

- Antarmuka `TaskApiClient` memungkinkan tukar Mock/Http tanpa sentuh UI/provider/repository.
- `sealed class` + `switch` = penanganan error exhaustif; compiler menolak kalau ada kasus terlewat.
- Serialisasi eksplisit (`toJson/fromJson`) -> bukti pemahaman mapper, bukan black-box codegen.
- `--dart-define` = inject config compile-time, bukan hardcode; secret tidak masuk repo.
- Fixture fallback membuktikan capaian dapat diuji meski server dosen belum stabil.

## Koneksi ke tugas

Ini baseline Assignment 2, bagian API + error handling. Gabung dengan P04 (persistence) untuk mode offline: operasi lokal tetap bisa, status sync sederhana.

## Catatan mocktail

Starter sengaja **tidak** memakai `mocktail`. `MockTaskApiClient` sendiri yang berperan sebagai test double + fixture fallback sekaligus, sehingga capaian teruji tanpa dependensi mocking tambahan. Tambah `mocktail` hanya bila ingin meniru `package:http` secara mendalam (di luar scope wajib).
