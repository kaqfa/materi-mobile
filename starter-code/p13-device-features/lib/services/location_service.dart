import 'package:geolocator/geolocator.dart';

/// Mengambil lokasi — dengan penanganan izin bertingkat.
///
/// Alur wajib (Android/iOS menolak kalau dicegat):
/// 1. cek GPS/service aktif  2. cek izin  3. minta izin bila belum
/// 4. baru ambil posisi.
class LocationService {
  Future<Position> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException('GPS dimatikan — nyalakan lokasi dulu');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationException('Izin lokasi ditolak');
    }

    // TODO(student) P13-2: tangani deniedForever — bedakan pesannya
    // (arahkan user ke pengaturan, lihat modul bab 12) dan tetap
    // lempar LocationException.

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      throw const LocationException('Izin lokasi tidak tersedia');
    }

    return Geolocator.getCurrentPosition();
  }
}

class LocationException implements Exception {
  const LocationException(this.message);
  final String message;

  @override
  String toString() => message;
}
