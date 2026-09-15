import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'probe.dart';

/// Bab 12: kamera dan galeri.
///
/// Probe ini sengaja TIDAK membuka kamera. Membuka kamera menuntut interaksi
/// manusia, dan pemeriksaan lingkungan harus bisa berjalan tanpa siapa pun
/// menekan apa pun. Yang diperiksa adalah bahwa plugin ter-register dan
/// channel-nya hidup, yaitu hal yang benar-benar bisa gagal saat build.
class ImagePickerProbe extends Probe {
  const ImagePickerProbe();

  @override
  String get id => 'image-picker';

  @override
  String get label => 'image_picker: plugin ter-register';

  @override
  int get chapter => 12;

  @override
  Future<String> probe() async {
    final picker = ImagePicker();

    if (kIsWeb) {
      throw const UnsupportedOnThisPlatform(
        'pemulihan berkas hilang hanya ada di Android',
      );
    }

    try {
      // Android-only: mengembalikan berkas yang tertinggal saat proses mati.
      // Di iOS memanggil ini melempar MissingPluginException/UnimplementedError,
      // dan itu tetap membuktikan plugin terpasang, bukan channel yang putus.
      final response = await picker.retrieveLost();
      final lost = response.isEmpty ? 'tidak ada berkas tertinggal' : 'ada berkas tertinggal';
      return 'channel hidup, $lost';
    } on UnimplementedError {
      return 'channel hidup (retrieveLost khusus Android)';
    } catch (e) {
      // MissingPluginException berarti plugin benar-benar tidak terpasang.
      if (e.toString().contains('MissingPlugin')) {
        throw StateError('plugin image_picker tidak ter-register: $e');
      }
      return 'channel hidup (platform menolak retrieveLost: $e)';
    }
  }
}

/// Bab 12: lokasi.
///
/// Sama seperti kamera, izin lokasi tidak diminta di sini: meminta izin
/// memunculkan dialog dan menggantung pemeriksaan otomatis. Yang diperiksa
/// adalah bahwa layanan bisa ditanya statusnya sama sekali.
class GeolocatorProbe extends Probe {
  const GeolocatorProbe();

  @override
  String get id => 'geolocator';

  @override
  String get label => 'geolocator: status layanan & izin terbaca';

  @override
  int get chapter => 12;

  @override
  Future<String> probe() async {
    final enabled = await Geolocator.isLocationServiceEnabled()
        .timeout(const Duration(seconds: 10));
    final permission = await Geolocator.checkPermission()
        .timeout(const Duration(seconds: 10));

    // Keempat keadaan bab 12 bisa dibedakan: itulah yang dibuktikan di sini.
    final layanan = enabled ? 'layanan aktif' : 'layanan mati';
    return '$layanan, izin: ${permission.name}';
  }
}
