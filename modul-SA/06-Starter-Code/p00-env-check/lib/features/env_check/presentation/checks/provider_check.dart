import 'package:flutter/foundation.dart';

import '../../domain/check_result.dart';

/// Membuktikan `provider` ter-import dan ChangeNotifier + notifyListeners
/// jalan di level logika. `context.watch`/`context.read` divalidasi secara
/// struktur oleh [EnvCheckScreen] yang memakai provider.
class _Counter extends ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }
}

/// Probe: buat ChangeNotifier, panggil notifier, verifikasi state berubah
/// dan listener ter-detect. Fungsi async agar cocok dengan signature
/// [CheckRunner]; tidak ada operasi await di dalamnya.
Future<CheckResult> runProviderCheck() async {
  try {
    final counter = _Counter();
    var notifications = 0;
    counter.addListener(() => notifications += 1);
    counter.increment();
    counter.increment();
    if (counter.value != 2) {
      return CheckFail('Counter value=${counter.value}, expected 2.');
    }
    if (notifications != 2) {
      return CheckFail('notifyListeners fired=$notifications, expected 2.');
    }
    counter.dispose();
    return const CheckOk(
      'ChangeNotifier + notifyListeners OK; watch/read aktif via EnvCheckScreen.',
    );
  } catch (e) {
    return CheckFail(e.toString());
  }
}
