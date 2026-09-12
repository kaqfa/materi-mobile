import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/check_result.dart';

/// Probe dua sekaligus karena tugas memakai istilah `path` untuk fungsi
/// `getTemporaryPath`/`getApplicationDocumentsPath` (sebenarnya di
/// `path_provider`). `path` (manipulasi string) juga diuji agar keduanya
/// terbukti ter-import.
Future<CheckResult> runPathCheck() async {
  try {
    final joined = p.join('a', 'b', 'c.dart');
    if (joined != 'a/b/c.dart' || p.basename(joined) != 'c.dart') {
      return CheckFail('path.join/basename salah: $joined.');
    }
    final tmp = await getTemporaryDirectory();
    final docs = await getApplicationDocumentsDirectory();
    return CheckOk(
      'path.join OK; tmp=${tmp.path}; docs=${docs.path}',
    );
  } catch (e) {
    return CheckFail('path/path_provider error: $e');
  }
}
