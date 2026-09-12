# Solution Reference, p06-testing-device (Khusus Dosen)

> **JANGAN dibagikan ke mahasiswa sebelum sesi P06 selesai.** Berisi kerangka
> jawaban + lokasi repo/tag privat lengkap. Sinkron dengan
> `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md` §7.

## Kerangka jawaban

### CP1, filter + 3 unit test
Selesai di starter. Mahasiswa membaca + menjelaskan, bukan menulis ulang.
Validasi: ketiga file test hijau + diskusi "kenapa pure-Dart".

### CP2, `attachPhoto` wiring
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
- `main.dart`: suntik `LocalAttachmentService(...)` untuk demo, lalu ganti
 `ImagePickerAttachmentService()` saat di perangkat (lengkapi `_obtainPicker`
 dengan `ImagePicker().pickImage(...)` dan petakan `XFile.path`).

### CP3, widget test
Selesai di starter. Tambah challenge: widget test untuk
`AttachmentStatusBanner` (denied -> teks permission muncul).

## Lokasi solusi lengkap

Repo/tag privat: lihat `.agents/kanban/` atau channel dosen internal.
Versi: `solution-reference/p06-testing-device@v1.0` (hubungi koordinator).

## Jebakan umum yang diamati

- Mahasiswa lupa `notifyListeners()` di `attachPhoto` -> banner tidak update.
- Mahasiswa `throw` dari service alih-alih mengembalikan `AttachmentDenied`
 (merusak kontrak sealed).
- Mahasiswa menulis image_picker call tanpa `try/catch` -> crash di emulator
 tanpa kamera (gagal acceptance fallback).
