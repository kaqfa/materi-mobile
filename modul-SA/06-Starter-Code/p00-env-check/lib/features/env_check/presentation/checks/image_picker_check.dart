import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/check_result.dart';

/// Probe non-interaktif: membuktikan plugin `image_picker` ter-import,
/// ter-construct, dan handler platform terdaftar. **Tidak** memanggil
/// `pickImage` (butuh interaksi user + device fisik): uji ambil foto
/// nyata dikerjakan di P06.
///
/// Pada platform tanpa plugin native, akses `ImagePicker.platform` atau
/// `defaultTargetPlatform` tidak melempar; namun pemanggilan nyata akan
/// gagal di runtime. Oleh sebab itu hasil check ini adalah [CheckSkip]
/// bila hanya bisa membuktikan registrasi, bukan interaksi nyata.
Future<CheckResult> runImagePickerCheck() async {
  try {
    ImagePicker();
    final platform = defaultTargetPlatform;
    return CheckSkip(
      'image_picker terdaftar (target=$platform).'
      ' Uji ambil foto nyata: P06.',
    );
  } catch (e) {
    return CheckFail('image_picker gagal registrasi: $e');
  }
}
