import 'check_definition.dart';
import 'geolocator_check.dart';
import 'http_check.dart';
import 'image_picker_check.dart';
import 'path_check.dart';
import 'provider_check.dart';
import 'sqlite_check.dart';

/// Daftar seluruh smoke test yang dijalankan [EnvCheckProvider].
/// Urutan = urutan tampil di layar.
final List<CheckDefinition> allChecks = <CheckDefinition>[
  const CheckDefinition(
    id: 'provider',
    title: 'provider',
    description: 'ChangeNotifier + notifyListeners; watch/read via UI.',
    run: runProviderCheck,
  ),
  const CheckDefinition(
    id: 'sqflite',
    title: 'sqflite + sqflite_common_ffi',
    description: 'Open DB, create table, insert, query (in-memory).',
    run: runSqliteCheck,
  ),
  const CheckDefinition(
    id: 'http',
    title: 'http',
    description: 'GET 200 ke jsonplaceholder.typicode.com.',
    run: runHttpCheck,
  ),
  const CheckDefinition(
    id: 'image_picker',
    title: 'image_picker',
    description: 'Registrasi plugin; ambil foto nyata dikerjakan di P06.',
    run: runImagePickerCheck,
  ),
  const CheckDefinition(
    id: 'geolocator',
    title: 'geolocator',
    description: 'Location service + status permission (non-interaktif).',
    run: runGeolocatorCheck,
  ),
  const CheckDefinition(
    id: 'path',
    title: 'path + path_provider',
    description: 'p.join + getTemporaryDirectory/getApplicationDocumentsDirectory.',
    run: runPathCheck,
  ),
];
