import 'package:flutter/foundation.dart';

import '../../domain/check_result.dart';
import '../checks/all_checks.dart';
import '../checks/check_definition.dart';

/// Status satu item smoke test di provider.
enum CheckStatus { pending, running, done }

/// State item check yang dimutasi provider lalu di-broadcast.
class CheckItem {
  CheckItem({required this.definition});

  final CheckDefinition definition;
  CheckStatus status = CheckStatus.pending;
  CheckResult? result;
}

/// State seluruh environment check. Memakai [ChangeNotifier] agar UI bisa
/// `context.watch` dan re-render tiap kemajuan, serta `context.read` untuk
/// memicu [runAll].
class EnvCheckProvider extends ChangeNotifier {
  EnvCheckProvider()
      : _items = allChecks
            .map((definition) => CheckItem(definition: definition))
            .toList();

  final List<CheckItem> _items;
  bool _running = false;

  List<CheckItem> get items => List<CheckItem>.unmodifiable(_items);
  bool get running => _running;

  int get okCount =>
      _items.where((item) => item.result is CheckOk).length;
  int get failCount =>
      _items.where((item) => item.result is CheckFail).length;
  int get skipCount =>
      _items.where((item) => item.result is CheckSkip).length;

  /// Jalankan semua check berurutan; tiap item di-broadcast saat mulai dan
  /// selesai agar UI update progresif. Idempoten terhadap re-entry.
  Future<void> runAll() async {
    if (_running) return;
    _running = true;
    notifyListeners();

    for (final item in _items) {
      item.status = CheckStatus.running;
      item.result = null;
      notifyListeners();

      item.result = await item.definition.run();
      item.status = CheckStatus.done;
      notifyListeners();
    }

    _running = false;
    notifyListeners();
  }
}
