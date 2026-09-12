import 'package:flutter/foundation.dart';

/// Hasil memilih lampiran. Sealed agar UI `switch` exhaustif menangani
/// semua cabang: sukses, perangkat tidak tersedia, izin ditolak.
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

/// Kontrak layanan lampiran. Abstract supaya bisa di-mock di unit test
/// dan di-swap antara real device (image_picker) dan lokal (test).
abstract class AttachmentService {
  Future<AttachmentResult> pickFromGallery();
  Future<AttachmentResult> pickFromCamera();
}

/// Mode rekayasa skenario attachment untuk test/fallback.
enum AttachmentScenario { success, unavailable, denied }

/// Implementasi lokal untuk unit test. Dikonfigurasi untuk merekayasa
/// skenario device-unavailable / permission-denied. **Hijau di CI tanpa
/// perangkat.**
class LocalAttachmentService implements AttachmentService {
  LocalAttachmentService({
    this.galleryBehavior = AttachmentScenario.success,
    this.cameraBehavior = AttachmentScenario.success,
    int counterStart = 0,
  }) : _counter = counterStart;

  final AttachmentScenario galleryBehavior;
  final AttachmentScenario cameraBehavior;
  int _counter;

  @override
  Future<AttachmentResult> pickFromGallery() async =>
      _resolve(galleryBehavior);

  @override
  Future<AttachmentResult> pickFromCamera() async => _resolve(cameraBehavior);

  AttachmentResult _resolve(AttachmentScenario s) {
    switch (s) {
      case AttachmentScenario.success:
        _counter += 1;
        return AttachmentSuccess('local://attachment-$_counter.png');
      case AttachmentScenario.unavailable:
        return const AttachmentUnavailable();
      case AttachmentScenario.denied:
        return const AttachmentDenied();
    }
  }
}

/// Implementasi nyata memakai `image_picker`. Bila plugin melempar
/// `PlatformException` (izin ditolak / tidak ada aplikasi galeri / kamera
/// absen di emulator) atau mengembalikan null (user batal), hasilnya
/// dipetakan ke [AttachmentDenied]/[AttachmentUnavailable] — bukan throw.
/// Inilah inti "device unavailable / permission denied fallback".
///
/// Catatan: bagian image_picker diimpor lazy agar tetap dapat dianalisis
/// tanpa perangkat. Lihat README untuk catatan izin Android.
class ImagePickerAttachmentService implements AttachmentService {
  const ImagePickerAttachmentService();

  @override
  Future<AttachmentResult> pickFromGallery() => _pick(AttachmentSource.gallery);

  @override
  Future<AttachmentResult> pickFromCamera() => _pick(AttachmentSource.camera);

  Future<AttachmentResult> _pick(AttachmentSource source) async {
    try {
      // Lazy import: plugin native hanya relevan saat runtime di perangkat.
      // ignore: implementation_imports
      final picker = _obtainPicker();
      final picked = await picker(source);
      if (picked == null) {
        // User batal atau tidak ada sumber tersedia -> unavailable, bukan error.
        return const AttachmentUnavailable('No source returned.');
      }
      return AttachmentSuccess(picked);
    } catch (e) {
      // PlatformException paling umum: permission denied / aktivitas kamera
      // absen. Kita tidak menebak string; anggap denial bila pesan menyebut
      // permission, lainnya unavailable.
      final msg = e.toString().toLowerCase();
      if (msg.contains('permission') || msg.contains('denied')) {
        return AttachmentDenied(e.toString());
      }
      return AttachmentUnavailable(e.toString());
    }
  }
}

enum AttachmentSource { gallery, camera }

/// Indirection tipis agar `ImagePickerAttachmentService` tetap bisa
/// di-instantiate di mesin tanpa plugin (test unit hanya menguji
/// `LocalAttachmentService`; kelas ini tak diuji langsung di unit test).
typedef _PickerFn = Future<String?> Function(AttachmentSource source);

_PickerFn _obtainPicker() {
  // Implementasi sebenarnya memanggil package:image_picker. Disederhanakan
  // di starter: detail wiring native ada di README + materi P06 CP3.
  // TODO(student): ganti body ini dengan panggilan image_picker sesuai CP3.
  throw UnimplementedError('image_picker wiring = TODO CP3 (device feature).');
}

/// Ekspos marker agar analyzer tidak menganggap import `foundation` unused.
@visibleForTesting
const int attachmentServiceVersion = 1;
