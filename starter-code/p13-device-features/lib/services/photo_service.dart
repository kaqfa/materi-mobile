import 'dart:io';

import 'package:image_picker/image_picker.dart';

/// Dokumentasi progres tugas lewat foto.
///
/// `maxWidth` + `imageQuality` = kompresi sederhana tanpa package tambahan:
/// foto 12 MP tidak perlu disimpan utuh untuk thumbnail.
class PhotoService {
  final _picker = ImagePicker();

  /// Ambil dari kamera.
  Future<File?> capture() => _pick(ImageSource.camera);

  /// Ambil dari galeri.
  Future<File?> pickFromGallery() => _pick(ImageSource.gallery);

  Future<File?> _pick(ImageSource source) async {
    final xfile = await _picker.pickImage(
      source: source,
      maxWidth: 1080,
      imageQuality: 70,
    );
    if (xfile == null) return null; // user membatalkan — bukan error
    return File(xfile.path);
  }
}
