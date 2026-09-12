import 'package:geolocator/geolocator.dart';

import '../../domain/check_result.dart';

/// Probe non-interaktif ketersediaan GPS: cek location service on/off +
/// status permission saat ini. Tidak meminta dialog permission dan tidak
/// wajib GPS fix nyata (dikerjakan di P06 bila perlu).
Future<CheckResult> runGeolocatorCheck() async {
  try {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();
    return CheckOk(
      'LocationService=$serviceEnabled; permission=$permission.',
    );
  } catch (e) {
    return CheckFail(
      'geolocator error: $e. Cek permission manifest/info.plist.',
    );
  }
}
