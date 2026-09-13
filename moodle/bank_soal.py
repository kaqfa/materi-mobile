#!/usr/bin/env python3
"""Bank soal quiz unlock PPB 20251 — SUMBER KEBENARAN teks soal.

Konvensi:
- Tiap pertemuan 10 soal, 4 opsi, SATU kunci (selalu ditulis duluan).
- Moodle mengacak urutan opsi (shuffleanswers), jadi urutan di sini bebas;
  namun validator menjaga panjang teks kunci <= semua distraktor agar
  jawaban benar tidak bisa ditebak dari panjangnya.
- Potongan kode ditulis dalam blok ```dart ...``` pada teks soal;
  generator mengubahnya menjadi <pre><code> saat build XML.
- Edit file ini (bukan XML hasil build), lalu: python3 build_moodle_xml.py
"""

JUDUL = {
    "P01": "Introduction to Mobile Development & Dart Fundamentals",
    "P02": "Dart Programming Deep Dive",
    "P03": "Flutter Fundamentals & Widget System",
    "P04": "Build System & Project Structure",
    "P05": "UI Design & Material Design Implementation",
    "P06": "Advanced UI & Custom Widgets",
    "P07": "Responsive Design & Adaptive Layouts",
    "P09": "API Integration & HTTP Operations",
    "P10": "Real-time Features & Advanced API Integration",
    "P11": "Advanced State Management",
    "P12": "Testing & Quality Assurance",
    "P13": "Platform Features & Device Integration",
    "P14": "Performance Optimization & Production Prep",
    "P15": "Deployment & Distribution Strategies",
}

# (pertanyaan, (kunci, distraktor1, distraktor2, distraktor3), umpan balik)
BANK = {
"P01": [
("""Apa output program berikut?
```dart
void main() {
  final nama = 'StudyTracker';
  print('App: $nama');
}
```""",
 ("App: StudyTracker", "App: $nama tercetak mentah", "Error: final tidak boleh begini", "null karena final belum diisi"),
 "Interpolasi `$nama` menyisipkan nilai variabel ke string."),

("Apa peran `runApp(const MyApp());` di `main()`?",
 ("Memasang widget root", "Mengunduh dependensi pub", "Membuka emulator Android", "Menjalankan build release"),
 "`runApp` menempelkan widget paling atas ke layar sebagai akhir widget tree."),

("""Untuk menambah dependensi `http` ke project, file yang diedit adalah?
```yaml
# file ini?
dependencies:
  flutter:
    sdk: flutter
```""",
 ("pubspec.yaml", "pubspec.lock hasil resolver", "package_config.json di tool", "analysis_options.yaml bawaan"),
 "pubspec.yaml adalah manifest dependensi; lock hanya hasil resolve."),

("""Counter `StatefulWidget` sedang berjalan, nilai sudah 7. Teks diubah lalu di-hot-reload.
Apa yang terjadi pada nilai counter?""",
 ("UI baru, state utuh", "UI baru, state direset", "UI lama, build di-skip", "Error karena widget berubah"),
 "Hot reload mempertahankan state bila struktur tree tidak berubah; hot restart yang meresetnya."),

("Di mana file `main.dart` bawaan sebuah project Flutter berada?",
 ("lib/main.dart", "android/app/main.dart", "root/main.dart project", "ios/Runner/main.dart file"),
 "`lib/` adalah tempat seluruh kode Dart; folder platform hanya runner."),

("Apa manfaat `const` pada widget seperti `const Text('Halo Dart')`?",
 ("Objek dipakai ulang", "Teks jadi tidak bisa scroll", "Widget jadi otomatis center", "Build jadi berjalan dua kali"),
 "Instance const dibuat sekali dan dipakai ulang — rebuild jadi murah."),

("`flutter doctor` menandai merah pada baris *Android toolchain*. Apa artinya?",
 ("Toolchain bermasalah", "Flutter SDK sudah terbaru", "Emulator sedang berjalan", "Project punya dependensi rusak"),
 "doctor memeriksa kesehatan toolchain; merah berarti ada komponen yang perlu diperbaiki."),

("Setelah mengubah bagian `dependencies`, perintah yang wajib dijalankan adalah?",
 ("flutter pub get", "flutter pub upgrade --major", "flutter clean && flutter run", "flutter create --refresh project"),
 "`pub get` me-resolve dan mengunduh dependensi baru."),

("""Null safety aktif. Apa hasil kompilasi kode berikut?
```dart
String judul = 'PPB';
judul = null;
```""",
 ("Error: null tak bisa", "Kompilasi lolos, judul jadi null", "Warning saja, nilai tetap string", "Otomatis dikonversi String?"),
 "`String` non-nullable menolak null; harus dideklarasikan `String?`."),

("Apa peran `Scaffold` pada sebuah screen?",
 ("Kerangka halaman Material", "Konfigurasi tema aplikasi", "Pusat routing named routes", "Penyimpanan state global app"),
 "Scaffold menyediakan struktur halaman: AppBar, body, FAB, drawer, dll."),
],

"P02": [
("""Class berikut dibuat. Manakah cara membuat instance yang benar?
```dart
class Task {
  final String title;
  const Task({required this.title});
}
```""",
 ("Task(title: 'Belajar')", "Task('Belajar', title: null)", "new Task(required: 'Belajar')", "Task.create(title: 'Belajar')"),
 "Parameter named wajib diisi dengan label `title:`."),

("""Apa output kode berikut?
```dart
String? catatan;
print(catatan?.length);
```""",
 ("null", "0 karena default kosong", "Error: catatan masih null", "undefined saat kompilasi gagal"),
 "`?.` menghentikan akses saat penerima null — hasilnya null, bukan error."),

("""Mixin dipasang dengan kata kunci apa?
```dart
class Task extends Object ___ Taggable {}
```""",
 ("with", "extends Taggable saja", "implements Taggable juga", "uses Taggable keyword"),
 "Sintaks Dart: `class X extends Y with M`."),

("""Urutan output program?
```dart
Future<void> main() async {
  print('A');
  await Future<void>.delayed(const Duration(seconds: 1));
  print('B');
}
```""",
 ("A lalu B", "B lalu A oleh scheduler", "A saja, B di-skip await", "B saja, A tertelan future"),
 "`await` menunda continuation sampai Future selesai — urutan tetap A dulu."),

("""Output program?
```dart
try {
  throw Exception('gagal');
} catch (e) {
  print('tangkap');
} finally {
  print('akhir');
}
```""",
 ("tangkap lalu akhir", "akhir lalu tangkap juga", "hanya akhir yang tercetak", "error lolos, app berhenti"),
 "`finally` selalu berjalan setelah blok try/catch selesai."),

("""Apa yang tercetak?
```dart
String? nama;
final tampil = nama ?? 'Tamu';
print(tampil);
```""",
 ("Tamu", "null tetap tercetak juga", "nama karena bukan null", "Error karena nama belum diisi"),
 "`??` memberi nilai cadangan saat sisi kiri null."),

("""Apa kegunaan `Priority.values.byName('high')` pada model JSON?""",
 ("String → enum", "Enum → String nama field", "Membuat enum baru runtime", "Validasi urutan nilai enum"),
 "byName mencari anggota enum dari string — jembatan JSON ke enum."),

("""Pola berikut menjamin hal apa?
```dart
final baru = lama.copyWith(completed: true);
```""",
 ("Objek lama tetap", "Objek lama ikut berubah", "Objek lama dihapus otomatis", "Hanya id yang digantinya"),
 "copyWith membuat salinan baru — model immutable tidak dimutasi."),

("""Return type `Future<List<Task>>` pada fungsi async; `return tasks;` di dalamnya otomatis?""",
 ("Dibungkus Future", "Dibungkus Stream events", "Di-cast jadi List<dynamic>", "Error karena bukan Future"),
 "Fungsi async membungkus nilai kembalian ke Future."),

("""Mengapa default parameter list harus `const []`?
```dart
const Task({this.tags = const []});
```""",
 ("Default harus konstanta", "List default tidak boleh ada", "const membuat list jadi global", "Agar tags bisa diubah nanti"),
 "Nilai default parameter harus compile-time constant."),
],

"P03": [
("""Apa efek utama pemanggilan berikut?
```dart
setState(() {
  _tasks.add(task);
});
```""",
 ("Build ulang dijadwalkan", "initState dijalankan lagi", "Seluruh app ikut rebuild", "State langsung dihapus dulu"),
 "setState menandai State ini kotor sehingga build() dijadwalkan ulang."),

("""Nilai `hasil` berasal dari mana?
```dart
final hasil = await Navigator.of(context).push<bool>(
  MaterialPageRoute(builder: (_) => DetailScreen(task: task)),
);
```""",
 ("pop() di detail", "Return value builder detail", "Constructor Task yang dikirim", "BuildContext screen asalnya"),
 "Future dari push selesai saat route di-pop dengan nilai."),

("Kelebihan `ListView.builder` dibanding `ListView(children: [...])` untuk data banyak?",
 ("Item dibuat saat perlu", "Semua item pasti ter-cache", "Scroll dua arah otomatis", "Tidak butuh context widget"),
 "builder membuat item secara lazy ketika mendekati viewport."),

("Saat parent melakukan rebuild, `build()` child StatelessWidget akan?",
 ("Ikut dibangun ulang", "Tidak pernah dibangun ulang", "Hanya bila punya Key unik", "Hanya bila bertipe const"),
 "Stateless tidak punya state sendiri — selalu dibangun ulang oleh parent."),

("""Apa fungsi `Expanded` pada potongan ini?
```dart
Row(
  children: [
    const Icon(Icons.info),
    Expanded(child: Text(title)),
  ],
)
```""",
 ("Text pakai sisa ruang", "Text selalu di tengah Row", "Icon ikut menyusut sebagian", "Row berubah jadi Column"),
 "Expanded memberi anak sisa ruang sumbu utama — mencegah overflow."),

("Method `initState()` dipanggil berapa kali dalam satu lifecycle State?",
 ("Sekali seumur State", "Setiap kali setState jalan", "Setiap frame baru dirender", "Dua kali saat create widget"),
 "initState hanya sekali; perubahan berikutnya lewat build."),

("Di starter P03, data `Task` dikirim ke screen detail lewat apa?",
 ("Lewat constructor", "Lewat variabel global statis", "Lewat query string route string", "Lewat setState pada parent"),
 "DetailScreen(task: task) — data eksplisit lewat parameter constructor."),

("""Efek `Navigator.of(context).pop(true)` di screen detail terhadap list screen?""",
 ("Hasil push jadi true", "List ikut ter-rebuild total", "Route detail tetap tertahan", "True dikirim lewat callback"),
 "Nilai pop menjadi hasil Future dari push yang di-await."),

("""Syarat widget bisa dipanggil dengan `const`?
```dart
const TaskCard({super.key, required this.task});
```""",
 ("Semua field final", "Widget bertipe StatefulWidget", "Mempunyai Key wajib unik", "Build tanpa memakai context"),
 "Constructor const butuh semua field final dan argumen const-able."),

("""Cabang ini menangani kondisi apa?
```dart
if (snapshot.connectionState != ConnectionState.done) {
  return const CircularProgressIndicator();
}
```""",
 ("Masih menunggu data", "Data sudah siap dipakai", "Terjadi error jaringan", "List hasil berisi kosong"),
 "connectionState belum done berarti Future masih berjalan — tampilkan loading."),
],

"P04": [
("""Apa makna constraint berikut?
```yaml
provider: ^6.1.2
```""",
 (">=6.1.2 <7.0.0", "Tepat 6.1.2 tanpa versi lain", ">=6.1.2 <6.2.0 saja patch", "6.1.2 atau versi 7 beta pun"),
 "Caret mengizinkan upgrade minor/patch dalam major yang sama."),

("Untuk project aplikasi (bukan package publik), `pubspec.lock` sebaiknya?",
 ("Di-commit agar stabil", "Di-commit hanya untuk package", "Tidak pernah masuk repositori", "Di-commit saat dependensi kosong"),
 "Lock yang di-commit menjamin semua anggota tim dapat versi sama persis."),

("Apa efek `flutter pub add http`?",
 ("Isi pubspec + resolve", "Menginstal HTTP server lokal", "Menyalin source ke folder lib/", "Menjalankan build android sekali"),
 "pub add menulis dependensi ke pubspec.yaml lalu me-resolve-nya."),

("Prinsip utama struktur `models/ services/ screens/ widgets/ utils/`?",
 ("Pemisahan tanggung jawab", "Semua logika di dalam main.dart", "Folder mengikuti urutan abjad file", "Satu file besar per satu layar app"),
 "Tiap lapisan punya satu tanggung jawab — separation of concerns."),

("""Keuntungan pola berikut dibanding string tersebar manual?
```dart
class AppRoutes {
  static const taskList = '/tasks';
}
```""",
 ("Referensi terpusat", "Navigasi tanpa BuildContext", "Route otomatis jadi deep link", "Tidak perlu MaterialPageRoute"),
 "Konstanta terpusat: anti typo, mudah rename, mudah dicari."),

("""Kapan `onGenerateRoute` dipanggil?
```dart
MaterialApp(
  routes: {AppRoutes.home: (_) => const HomeScreen()},
  onGenerateRoute: (settings) { ... },
)
```""",
 ("Route tak ada di map", "Setiap app pertama dijalankan", "Ketika Navigator.pop dipanggil", "Saat MaterialApp kehilangan theme"),
 "Route yang tidak terdaftar di `routes` jatuh ke onGenerateRoute."),

("""Import `package:study_tracker/models/task.dart` lebih baik daripada `../models/task.dart` karena?""",
 ("Stabil, absolut dari lib/", "Ringan karena di-cache server", "Khusus file di folder utils saja", "Wajib untuk semua file pub.dev"),
 "Import package absolut dari `lib/` tidak rusak saat file dipindah."),

("""Deklarasi aset folder `images/` yang benar ada di bagian?
```yaml
flutter:
  ___
```""",
 ("assets: - images/", "dependency_assets: images", "android: resources: images", "tool: asset_bundle: images"),
 "Aset didaftarkan di `flutter: assets:` di pubspec.yaml."),

("Apa fungsi `analysis_options.yaml`?",
 ("Aturan lint analyzer", "Konfigurasi emulator target", "Daftar dependensi pub tambahan", "Mengunci versi SDK Flutter"),
 "File ini mengatur aturan analisis statis (termasuk flutter_lints)."),

("Setelah menjalankan `flutter create .` di dalam starter, apa yang dihasilkan?",
 ("Folder platform runner", "File pubspec.yaml diganti baru", "Semua TODO starter hilang total", "Folder lib ditimpa isinya semua"),
 "`flutter create .` menghasilkan folder android/ios/web dst tanpa menimpa lib dan test."),
],

"P05": [
("""Pemakaian berikut menghasilkan apa?
```dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF00695C)),
)
```""",
 ("Palet turun satu warna", "Warna acak tiap dijalankan", "Semua widget jadi Cupertino", "Tema tersimpan SharedPreferences"),
 "fromSeed menurunkan seluruh palet Material 3 dari satu warna benih."),

("""Kapan validator dianggap lolos?
```dart
validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
```""",
 ("Saat return null", "Saat field kosong terdeteksi", "Saat form langsung terkirim", "Saat validator belum diisi"),
 "Validator mengembalikan null = tidak ada error; string = pesan error."),

("""Pemanggilan berikut menjalankan apa?
```dart
if (_formKey.currentState?.validate() != true) return;
```""",
 ("Semua validator field", "Hanya validator pertama saja", "Simpan form ke database lokal", "Reset semua field ke kosong"),
 "`validate()` memicu seluruh validator form dan true hanya bila semua lolos."),

("Apa tipe kembalian `showDatePicker(...)`?",
 ("Future<DateTime?>", "DateTime non-nullable langsung", "Stream pilihan tanggal user", "void plus callback terpisah"),
 "Future selesai saat dialog ditutup; null bila user membatalkan."),

("`DropdownButtonFormField` wajib memuat di `items`?",
 ("Semua opsi termasuk nilai", "Hanya nilai terpilih aktif", "Label tanpa nilai value sama", "Key global tiap pilihan item"),
 "items mendefinisikan seluruh opsi; `initialValue` harus termasuk di dalamnya."),

("Bagaimana perilaku `hintText` pada InputDecoration?",
 ("Hilang setelah user mengetik", "Jadi pesan error saat validasi", "Selalu tampil sebagai bantuan", "Mengganti nilai field kosong"),
 "Hint hanya placeholder visual sebelum ada input."),

("Keuntungan `Theme.of(context).textTheme` dibanding hardcode TextStyle?",
 ("Konsisten + ikut tema app", "Render font dua kali lebih cepat", "Teks otomatis jadi selectable", "Mengunci font Roboto permanen"),
 "Style terpusat ikut berubah saat tema berubah — konsistensi otomatis."),

("""Properti mana yang menandai ChoiceChip terpilih?
```dart
ChoiceChip(
  label: Text(p.name),
  ___: p == _priority,
  onSelected: (v) {...},
)
```""",
 ("selected", "isSelected", "activeChoice", "checkedState"),
 "ChoiceChip memakai pasangan `selected` dan `onSelected`."),

("Bedanya `FilledButton` vs `TextButton` secara visual?",
 ("Latar terisi vs polos", "Satu bisa icon satu tidak", "Filled tanpa onPressed null", "TextButton hanya untuk dialog"),
 "FilledButton berlatar solid (primary container); TextButton hanya teks."),

("""Makna argumen berikut?
```dart
showDatePicker(initialDate: _dueDate ?? now, ...)
```""",
 ("Pakai lama, cadangan now", "Selalu pakai now berapapun", "Selalu pakai _dueDate meski null", "Error bila dua-duanya terisi"),
 "`??` memakai _dueDate bila tidak null, kalau null pakai `now`."),
],

"P06": [
("""Pola berikut menunjukkan arah komunikasi seperti apa?
```dart
TaskCard(
  task: t,
  onToggle: (v) => _toggle(t.id, v),
  onDelete: () => _confirmDelete(t),
)
```""",
 ("Child lapor ke parent", "Parent ubah state child langsung", "Data dua arah otomatis sinkron", "Child akses setState parentnya"),
 "Widget anak tidak mengubah data sendiri — ia melapor lewat callback."),

("Cara termudah membuat fade 300 ms saat tugas selesai (tanpa controller)?",
 ("Ubah nilai opacity saja", "Buat AnimationController sendiri", "SetState dipanggil tiap frame", "Bungkus dengan Hero animation"),
 "Widget animasi implisit (AnimatedOpacity) menganimasikan perubahan properti otomatis."),

("Dismissible wajib diberi `key` karena?",
 ("Identitas item widget", "Background wajib lebih dulu", "Direction horizontal wajib", "OnDismissed pengganti key"),
 "Saat item dihapus, Key menjaga Flutter melacak identitas sisa item dengan benar."),

("""Nilai bool untuk `await showDialog<bool>` datang dari?
```dart
final ok = await showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(...),
);
```""",
 ("Navigator.pop(dialog, true)", "Return statement builder dialog", "SetState di parent sebelum pop", "GlobalKey dialog yang menyimpan"),
 "Dialog di-pop dengan nilai; itu hasil Future-nya."),

("Children ExpansionTile ditampilkan ketika?",
 ("Header ditekan user", "Scroll sampai batas bawah", "Long press tiga detik lamanya", "Swipe ke kiri pada tile cardnya"),
 "ExpansionTile membuka/collapse detail saat header di-tap."),

("""Kapan animasi berjalan?
```dart
TweenAnimationBuilder<double>(
  tween: Tween<double>(begin: 0, end: ratio),
  duration: const Duration(milliseconds: 400),
  builder: (context, value, _) =>
      LinearProgressIndicator(value: value),
)
```""",
 ("Nilai end berubah", "Setiap frame build berjalan", "Hanya saat initState pertama", "Saat curve diganti tipe lain"),
 "TweenAnimationBuilder menganimasikan dari nilai lama ke end baru setiap rebuild."),

("Cara dianjurkan membangun UI kompleks?",
 ("Widget kecil dirangkai", "Satu widget raksasa per layar", "Semua gaya hardcode di build", "Copy-paste kode antar berbagai layar"),
 "Komposisi widget kecil reusable = pilar custom widget library."),

("""`const TaskCard(...)` valid hanya bila?""",
 ("Argumen semua const-able", "Widget-nya StatefulWidget saja", "Sudah dipakai dua layar beda", "Mempunyai Key bernilai unik"),
 "Semua argumen (termasuk callback yang di-hold variabel const) harus const."),

("""Warna dot `PriorityIndicator` ditentukan oleh?
```dart
Color get _color => switch (priority) {
  Priority.high => const Color(0xFFC62828),
  ...
};
```""",
 ("switch pada enum Priority", "Random seed dari judul tugas", "Warna tema colorScheme container", "Index posisi item di dalam list"),
 "Expression switch di atas enum memetakan tiap prioritas ke warna."),

("Mengapa hapus tugas perlu dialog konfirmasi?",
 ("Aksi destruktif tak sengaja", "Wajib dari aturan lint analyzer", "Menaikkan skor performa rebuild", "Supaya state otomatis tersimpan"),
 "Konfirmasi mencegah kehilangan data akibat tap/salindia yang tak disengaja."),
],

"P07": [
("""Apa yang dimiliki `LayoutBuilder` dan tidak dimiliki `MediaQuery`?
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth >= 600) ...
  },
)
```""",
 ("Constraint parent langsung", "Ukuran fisik layar perangkat", "Orientasi aplikasi global saat ini", "Pixel ratio dan DPI platformnya"),
 "LayoutBuilder membaca constraint dari parent — paling tepat untuk keputusan layout."),

("""Teknik berikut disebut apa?
```dart
if (constraints.maxWidth >= Breakpoints.tablet) {
  return _twoColumn(horizontal);
}
return _singleColumn(horizontal);
```""",
 ("Conditional layout", "Responsive overloading method", "Adaptive inheritance pattern", "MediaQuery snapshot builder"),
 "Render berbeda berdasarkan kondisi lebar = conditional/adaptive layout."),

("""Jika `media.size.width == 1000`, berapa nilai `horizontal`?
```dart
final horizontal = (media.size.width * 0.04).clamp(12.0, 48.0);
```""",
 ("40.0", "48.0 dibulatkan otomatis", "12.0 sebagai batas bawahnya", "Error karena 40 di luar rentang"),
 "1000×0.04 = 40 — masih dalam rentang [12,48], clamp tidak mengubahnya."),

("Nilai default `fit` pada `Flexible` adalah?",
 ("loose", "tight seperti Expanded", "wrap mengikuti parentnya", "expand memenuhi semua sisa"),
 "Flexible default loose (boleh lebih kecil); Expanded = Flexible tight."),

("`maxCrossAxisExtent` pada SliverGridDelegate mengatur?",
 ("Lebar maks tiap kolom", "Jumlah kolom selalu tetap sama", "Tinggi setiap item dalam grid", "Jarak antar item sumbu utama"),
 "Grid menentukan jumlah kolom dari lebar tersedia dibagi batas extent ini."),

("Risiko `MediaQuery.of(context)` pada widget tingkat tinggi?",
 ("Rebuild luas tiap berubah", "Memory leak ketika dispose", "Font berubah jadi default sistem", "Layout error di mode gelap app"),
 "Perubahan apa pun pada MediaQuery (mis. keyboard) membangun ulang seluruh subscriber."),

("Apa fungsi `AspectRatio`?",
 ("Jaga rasio anak widget", "Memutar layar otomatis app", "Membuat grid golden rasio", "Menyamakan ukuran semua layar"),
 "AspectRatio memberi constraint anak sesuai rasio lebar:tinggi."),

("`SafeArea` dipakai agar konten?",
 ("Aman dari notch bar", "Kunci orientasi portrait", "Enkripsi area konten sensitif", "Animasi transisi jadi halus"),
 "SafeArea menjauhkan konten dari notch, status bar, dan gesture area."),

("Tiga konfigurasi uji wajib untuk responsif (syarat G1)?",
 ("Portrait, landscape, tablet", "Hanya emulator Pixel terbaru", "Web desktop dan TV 4K besar", "Dark mode dan light mode saja"),
 "RPS mensyaratkan minimal 3 konfigurasi: phone portrait, landscape, tablet."),

("Solusi pertama saat `textScaler` besar membuat teks overflow?",
 ("maxLines + ellipsis", "Fixed height semua widget", "Matikan scaling global user", "FittedBox semua teks di app"),
 "Batasi jumlah baris + ellipsis menjaga layout tetap utuh."),
],

"P09": [
("""Selain `body: jsonEncode(...)`, header apa yang wajib pada POST JSON?
```dart
final response = await _client.post(
  _uri(''),
  headers: _headers,
  body: jsonEncode({'title': title}),
);
```""",
 ("Content-Type application/json", "Accept-Encoding gzip br deflate", "X-Correlation-Id uuid v4 string", "Cache-Control no-store private"),
 "Tanpa Content-Type: application/json, banyak server menolak/menganggap body plain text."),

("""Kode sukses standar untuk `createTask` (POST) adalah?""",
 ("201", "200", "204", "422"),
 "201 Created adalah status sukses standar pembuatan resource."),

("Kode 403 berbeda dari 401 karena penerima 403?",
 ("Login tapi tak berhak", "Token salah atau kedaluwarsa", "Resource tidak ditemukan", "Server sibuk sementara"),
 "403 = authenticated tapi forbidden; 401 = kredensial tidak valid."),

("""`snapshot.hasError` bernilai true ketika?
```dart
FutureBuilder<List<Task>>(
  future: _future,
  builder: (context, snapshot) { ... },
)
```""",
 ("Future melempar exception", "connectionState belum selesai", "Data hasil list kosong arraynya", "Builder terpanggil dua kali build"),
 "Error pada Future ditangkap ke snapshot.hasError + snapshot.error."),

("""Untuk respons array of object, `data` bertipe?
```dart
final data = jsonDecode(response.body);
```""",
 ("List<dynamic>", "List<Map<String, dynamic>>", "Stream<dynamic> event berjalan", "String hasil re-serialize JSON"),
 "jsonDecode menghasilkan dynamic; tiap elemen perlu di-cast ke Map."),

("Pemanggilan API pertama kali sebaiknya dilakukan di?",
 ("initState, simpan Future", "Di dalam build setiap frame baru", "Pada dispose sebelum widget mati", "Constructor widget langsung await"),
 "Init sekali di initState, hasilnya dibaca FutureBuilder — bukan fetch tiap build."),

("""Kapan nilai `String.fromEnvironment('API_BASE_URL')` dievaluasi?""",
 ("Saat kompilasi saja", "Setiap aplikasi dijalankan ulang", "Saat tombol hot reload ditekan", "Setelah server merespons OK 200"),
 "dart-define bersifat compile-time; mengganti nilai = jalankan ulang build."),

("Header minimal khas REST Supabase adalah pasangan?",
 ("apikey & Bearer token", "Basic auth email dan password", "X-Supabase-Key dan secret key", "Cookie sesi dari browser web app"),
 "Supabase REST butuh apikey + Authorization Bearer (anon key / JWT user)."),

("Class `ApiException` di starter memisahkan apa?",
 ("Gagal jaringan vs bug", "Error UI dan error database web", "Warning lint dan info analyzer", "Error produksi dan error testing"),
 "Membedakan kegagalan HTTP yang bisa ditampilkan user dari bug kode."),

("`RefreshIndicator.onRefresh` wajib bertipe?",
 ("Future Function()", "Void Function() sinkron biasa", "Stream Function() tak berujung", "AsyncCallback dengan parameter"),
 "onRefresh harus Future agar indikator tahu kapan refresh selesai."),
],

"P10": [
("""Parameter `version` pada `openDatabase` menandai apa?
```dart
openDatabase(path, version: 1, onCreate: (db, _) => ...);
```""",
 ("Versi skema database", "Versi aplikasi di Play Store", "Jumlah tabel maksimum dibuat", "Versi paket sqflite terpasang"),
 "Naikkan version + onUpgrade untuk migrasi skema berikutnya."),

("""Placeholder `?` + `whereArgs` mencegah apa?
```dart
db.query('tasks', where: 'sync_state = ?', whereArgs: ['pending']);
```""",
 ("SQL injection input", "Query lambat pada tabel besar", "Error tipe kolom SQLite file", "Konflik dua koneksi menulis"),
 "Nilai terikat sebagai parameter, bukan digabung ke string SQL."),

("Pada strategi last-write-wins, pemenang konflik ditentukan oleh?",
 ("updatedAt terbaru menang", "Data lokal selalu menang duluan", "Data server selalu menang selalu", "id dengan angka terbesar menang"),
 "LWW membandingkan timestamp terakhir ubah di kedua sisi."),

("Sinkronisasi push dulu sebelum pull karena?",
 ("Pending tak tertimpa lama", "Server menuntut login ulang dulu", "Pull lebih lambat dari push jaringan", "Urutan keduanya tidak berpengaruh"),
 "Push dulu memastikan perubahan lokal tidak tertimpa versi lama server."),

("Prinsip inti arsitektur offline-first?",
 ("Lokal sumber utama", "Server sebagai cache aplikasi", "Semua fitur wajib pakai internet", "Sinkron hanya saat app ditutup user"),
 "App bekerja penuh dari DB lokal; jaringan hanya untuk sinkronisasi."),

("Baris dengan `sync_state = pending` berarti?",
 ("Belum terkirim server", "Sudah aman tersimpan di cloud", "Ditandai dihapus permanen nanti", "Menunggu keputusan user konflik"),
 "Pending = perubahan lokal yang menunggu diunggah."),

("""Apa yang terjadi pada baris lama?
```dart
db.insert('tasks', row, conflictAlgorithm: ConflictAlgorithm.replace);
```""",
 ("Baris lama ditimpa", "Insert gagal dengan exception", "Dibuat baris baru id berbeda", "Transaksi batch di-rollback"),
 "replace menimpa baris dengan PRIMARY KEY sama."),

("`getDatabasesPath()` mengembalikan?",
 ("Folder DB per platform", "URL project Supabase yang aktif", "Path folder assets aplikasi", "Direktori cache pub.dev di host"),
 "Lokasi standar penyimpanan database tiap platform."),

("Berikut pemicu sinkronisasi yang Wajar, KECUALI?",
 ("Rotasi layar device", "Koneksi pulih setelah hilang", "Langganan realtime perubahan", "Tombol sync manual oleh user"),
 "Rotasi layar bukan pemicu data; pemicu: koneksi, manual, realtime."),

("Saat pull menemukan item server yang belum ada di lokal, aksi benar?",
 ("Insert lokal baru", "Abaikan sampai reload berikutnya", "Tandai sebagai konflik wajib user", "Hapus dari server agar sinkron"),
 "Item baru server disimpan lokal — itulah arah download pull."),
],

"P11": [
("Apa yang dipicu `notifyListeners()` pada ChangeNotifier?",
 ("Listener rebuild", "Provider dihapus dari tree widget", "Semua method provider terkunci", "State disimpan ke penyimpanan disk"),
 "Semua widget yang listen (watch/Consumer) dijadwalkan rebuild."),

("""Kapan memakai `context.read` dan bukan `watch`?
```dart
onPressed: () => context.read<TaskProvider>().addTask(title),
```""",
 ("Aksi tanpa listen", "Listen perubahan setiap state", "Mengubah tipe provider runtime", "Membaca state dari dalam dispose"),
 "read untuk aksi sekali — tidak membuat widget berlangganan rebuild."),

("Parameter ketiga (biasa ditulis `_`) pada `Consumer` builder adalah?",
 ("child pra-build", "Context screen sebelum navigasi", "Index item ListView terkait itu", "Berapa kali state sudah berubah"),
 "Bagian child yang tidak berubah bisa diteruskan turun dan tidak dibangun ulang."),

("Keunggulan `Selector` dibanding `Consumer`?",
 ("Rebuild granular", "Tak butuh provider di atas tree", "Bisa dipakai tanpa context build", "Otomatis async semua mutasinya"),
 "Selector hanya rebuild saat nilai yang dipantau berubah."),

("`ChangeNotifierProvider(create: ...)` menjalankan create kapan?",
 ("Lazy, saat pertama dibaca", "Setiap kali child widget rebuild", "Setiap navigasi push screen baru", "Dua kali ketika dark mode aktif"),
 "Provider default lazy — dibuat saat pertama ada yang listen/read."),

("Provider harus dipasang di posisi mana?",
 ("Di atas pemakai state", "Di dalam body Scaffold setiap layar", "Bergantian bersama widget Builder", "Hanya di dalam HomeScreen bodynya"),
 "InheritedWidget hanya bisa dicari ke ATAS tree — provider di atas konsumen."),

("Masalah prop drilling yang diselesaikan state terpusat?",
 ("State lewat banyak lapis", "Widget rebuild terlalu jarang terjadi", "State hilang saat hot reload dipakai", "Provider tidak bisa method async"),
 "Tanpa provider, data dioper parent → child → grandchild berlapis-lapis."),

("Method `dispose()` pada ChangeNotifier dipakai untuk?",
 ("Bebas resource internal", "Reset state ke nilai awal aplikasi", "Menandai provider siap dipakai ulang", "Menyimpan state ke SQLite otomatis"),
 "Bebaskan controller/stream sebelum objek dibuang."),

("""`AuthGate` memakai `watch<AuthProvider>()`; berpindah layar terjadi karena?""",
 ("isSignedIn berubah", "Navigator.push dipanggil manualnya", "Tema berganti mode gelap mendadak", "Pop semua route sebelumnya otomatis"),
 "Rebuild AuthGate saat status sesi berubah — render HomeScreen/LoginScreen."),

("Dari `setState` ke Provider jadi wajib ketika?",
 ("State lintas widget/screen", "Widget punya animasi kompleksnya", "App memakai tema Cupertino style", "List berisi lebih seribu item"),
 "State yang dibaca banyak tempat butuh satu sumber kebenaran terpusat."),
],

"P12": [
("Apa fungsi `pumpWidget` pada widget test?",
 ("Render widget di test frame", "Menjalankan server API testing", "Membuat emulator headless Android", "Compile build release CI pipeline"),
 "pumpWidget memasang widget ke binding pengganti layar sungguhan."),

("`find.byKey` lebih tahan refactor daripada `find.text` karena?",
 ("Imun ubah copywriting teks", "Eksekusinya lebih cepat dari text", "Wajib dipakai semua widget test", "Bisa tanpa wrapper MaterialApp"),
 "Teks UI sering berubah; Key sengaja dipasang untuk keperluan test."),

("Syarat logika murni agar mudah di-unit-test?",
 ("Bebas dependensi UI", "Wajib memakai pumpWidget dulu", "Hanya untuk class model data saja", "Butuh emulator headless berjalan"),
 "Tanpa dependensi UI/jaringan, test cepat dan deterministik."),

("Urutan siklus TDD yang benar?",
 ("Red, green, refactor", "Refactor, red, lalu green loop", "Green dulu, red, deploy cepat", "Test ditulis setelah produksi jadi"),
 "Tulis test gagal (red), buat lulus (green), rapikan (refactor)."),

("`flutter test --coverage` menghasilkan berkas?",
 ("coverage/lcov.info", "build/coverage/report.html final", "test/coverage_summary.json file", "pubspec.lock bagian coverage flag"),
 "lcov.info adalah laporan standar yang bisa dibaca alat coverage."),

("Mengapa mock dibuat lewat `abstract interface` (pola starter P09)?",
 ("Isolasi jaringan & DB", "Mempercepat kompilasi build rilis", "Wajib untuk semua widget test jenis", "Menggantikan flutter_test sepenuhnya"),
 "Kontrak abstrak memungkinkan implementasi palsu saat test."),

("Urutan argumen `expect(...)` yang benar?",
 ("(actual, matcher)", "(matcher, expected value) saja", "(description, actual, matcher)", "(actual, expected, tolerance)"),
 "Pola flutter_test: expect(nilaiAktual, pencocok)."),

("Setelah `tester.tap(...)`, langkah wajib sebelum assert?",
 ("pump() proses frame", "Restart runtime test lengkapnya", "await Future delay satu detik", "tearDown setelah tester selesai"),
 "pump memproses frame reaksi tap sebelum diperiksa."),

("Blok `setUp` dijalankan?",
 ("Sebelum tiap test", "Sekali untuk seluruh file test", "Hanya sebelum test pertama file", "Setelah tiap test selesai dijalankan"),
 "setUp berjalan ulang per test — isolasi antar keadaan."),

("Test merah karena implementasi melanggar spesifikasi. Sikap TDD?",
 ("Perbaiki kode produksi", "Ubah expect agar selalu lolos kunci", "Hapus atau skip test bermasalahnya", "Tunda test sampai rilis versi baru"),
 "Test = spesifikasi; yang salah kode produksinya (pola starter P12)."),
],

"P13": [
("User membatalkan pemilihan foto. Apa kembalian `pickImage`?",
 ("null bukan error", "File kosong dengan path string", "Exception PlatformException cancel", "XFile ukuran nol byte kosong"),
 "Pembatalan mengembalikan null — bukan kondisi error."),

("Izin kamera di Android dideklarasikan di file?",
 ("AndroidManifest.xml", "build.gradle bagian permissions", "pubspec.yaml bagian permissions", "MainActivity.kt annotation camera"),
 "Uses-permission dideklarasikan di AndroidManifest.xml."),

("Tindakan tepat saat permission `deniedForever`?",
 ("Arahkan ke settings", "Minta ulang otomatis loop tiga kali", "Abaikan, fitur tetap berjalan baik", "Restart app agar izin ter-reset ulang"),
 "Permintaan sistem tidak akan muncul lagi — user harus ubah di pengaturan."),

("""Tujuan argumen berikut?
```dart
_picker.pickImage(source: s, maxWidth: 1080, imageQuality: 70)
```""",
 ("Kompresi hasil foto", "Crop ke rasio 16:9 otomatis hasilnya", "Menambah watermark foto plugin ini", "Membatasi jumlah foto per sesi itu"),
 "maxWidth + imageQuality mengecilkan foto sebelum disimpan/upload."),

("Urutan pengambilan lokasi yang benar?",
 ("Service, izin, posisi", "Posisi, izin, lalu service check", "Izin, posisi, lalu service check", "Langsung posisi tanpa pre-check apapun"),
 "Cek GPS aktif → cek/minta izin → baru getCurrentPosition."),

("Path foto hasil picker lazim disimpan di model sebagai?",
 ("String path file", "Uint8List bytes di kolom teks", "XFile di-serialize jadi JSON string", "Blob base64 di SharedPreferences ini"),
 "Simpan path; muat ulang via File(path) saat menampilkan."),

("Kamera tidak tersedia di device — ditangani lewat?",
 ("try-catch di service", "Null check operator pada hasilnya", "Diabaikan karena kasusnya jarang", "Assert cukup di build debug saja"),
 "Panggilan picker dibungkus try-catch dengan pesan yang bisa ditindak user."),

("Enum `ImageSource.camera` vs `.gallery` menentukan?",
 ("Kamera atau galeri", "Web atau native platform asalnya", "File manager atau cloud storage", "Thumbnail atau resolusi penuhnya"),
 "Source menentukan dari mana gambar diambil."),

("Objek `Position` dari geolocator memuat atribut?",
 ("latitude, longitude", "x, y dalam ukuran pixel layar", "altitude saja tanpa atribut lain", "placeId string dari Google Maps"),
 "Position membawa koordinat geografis (dan akurasi/altitude)."),

("Praktik aman untuk kredensial Supabase di sisi app?",
 ("dart-define saat build", "Anon key di-hardcode di widgetnya", "Service role key di app klien juga", "Password user disimpan di Hive box"),
 "Lewat --dart-define / .env tergitignore; jangan pernah hardcode."),
],

"P14": [
("`ListView.builder` membangun item kapan?",
 ("Saat akan terlihat", "Semuanya sekali di awal build", "Hanya item dengan index genap saja", "Saat koneksi internet tersedia lagi"),
 "Virtualisasi: item dibuat mendekati viewport saja."),

("Manfaat `itemExtent` pada list dengan tinggi seragam?",
 ("Tinggi tetap per item", "Animasi scroll lebih halus otomatis", "Card shadow otomatis tiap item", "Penghematan kuota jaringan data app"),
 "Tinggi diketahui → layout & scroll-jump presisi tanpa mengukur tiap anak."),

("""Saat rebuild, `const Text('x')` menghasilkan?""",
 ("Instansi dipakai ulang", "Widget tidak dibangun sama sekali", "Flutter simpan ke SQLite cache lokal", "Build berjalan di thread terpisah UI"),
 "Instance const canonical — identik == tidak perlu dibuat ulang."),

("Komputasi berat di dalam `build()` menyebabkan?",
 ("Jank frame terlewati", "Error kompilasi dari analyzer langsung", "Memory leak pasti tiap frame", "Hot reload gagal total selamanya"),
 "Build di UI thread; kerja berat melampaui budget frame = dropped frame."),

("Pengukuran performa yang valid dilakukan dengan mode?",
 ("--profile", "--release saja sudah cukup", "--debug dengan asserts aktif", "--verbose --no-pub kombinasi"),
 "Debug penuh assert/overlay menyesatkan; profile mendekati rilis."),

("`cacheExtent` pada scrollable mengatur?",
 ("Pre-render di luar viewport", "Jumlah maksimum item dalam list", "Pengukuran tinggi tiap item grid", "Cache hasil request HTTP GET app"),
 "Item dalam radius cacheExtent dibuat lebih awal — scroll mulus."),

("Bahaya `MediaQuery.of(context)` pada widget scope besar?",
 ("Rebuild luas tiap berubah", "Memory leak saat dispose state", "Font berubah jadi default sistemnya", "Layout error ketika dark mode aktif"),
 "Keyboard muncul/hilang = MediaQuery berubah = seluruh subscriber rebuild."),

("Budget satu frame pada 60 fps adalah sekitar?",
 ("±16 ms", "±60 ms per frame utuhnya", "±8 ms untuk dua frame berurutan", "±160 ms untuk frame yang berat"),
 "1000/60 ≈ 16,6 ms per frame."),

("Tree shaking pada build release membuang?",
 ("Kode tak terpakai", "Ikon debug banner aplikasi itu", "Aset gambar resolusi paling besar", "Log console saja sisanya tetap utuh"),
 "Kode yang tidak terjangkau dihapus dari binary — termasuk font ikon tak terpakai."),

("Performance overlay DevTools menampilkan?",
 ("Grafik UI & raster", "Daftar error analyzer kompilasi", "Penggunaan CPU oleh proses emulator", "Ukuran file APK hasil build final"),
 "Dua grafik thread: UI (build/layout) dan raster (painting)."),
],

"P15": [
("""Pada `version: 2.1.0+5`, angka setelah tanda plus adalah?""",
 ("Build number", "Versi SDK minimum Flutter", "Jumlah fitur di rilis ini", "Iteration patch perbaikan bug"),
 "+N = build number; wajib dinaikkan tiap upload baru ke store."),

("Artefak yang diunggah ke Google Play?",
 ("App Bundle (.aab)", "APK split-per-abi hasil build", "APK universal versi debug build", "Bundle debug yang sudah ter-sign"),
 "Play Store menerima .aab; APK di-generate oleh store."),

("""Kombinasi flag berikut untuk apa?
```bash
flutter build appbundle --release \
  --obfuscate --split-debug-info=build/symbols
```""",
 ("Buat simbol terpisah", "Enkripsi seluruh aset gambar app", "Mempercepat proses kompilasi debug", "Menandatangani APK dengan keystore"),
 "Obfuscate menyamarkan Dart; simbol disimpan terpisah untuk membaca crash."),

("Praktik benar untuk keystore dan `key.properties`?",
 ("Di luar repo, gitignore", "Di-commit agar tim ikut bisa build", "Disimpan di dalam folder lib app", "Dipush ke repositori pub.dev privat"),
 "Secret signing tidak boleh masuk repo — simpan aman di luar."),

("Konstanta `kReleaseMode` dipakai untuk?",
 ("Cabang kode produksi", "Deteksi emulator sedang berjalan", "Cek versi OS device pengguna app", "Ganti tema saat dark mode diaktifkan"),
 "Guard log/hanya-rilis lainnya dengan kReleaseMode."),

("Privacy policy menjadi wajib ketika aplikasi?",
 ("Kumpulkan data pribadi", "Gratis tanpa iklan apapun di dalam", "Hanya memakai tema Material bawaan", "Dipakai internal tim developer saja"),
 "Lokasi, kamera, akun = data pribadi → wajib kebijakan privasi."),

("Internal testing track di Play Console dipakai untuk?",
 ("Uji sebelum rilis luas", "Distribusi permanen pengganti store", "Melewati review kebijakan Play Store", "Menguji build debug tanpa signing"),
 "Rollout bertahap: internal → closed → open → produksi."),

("Efek `debugShowCheckedModeBanner: false`?",
 ("Banner debug hilang", "Log console otomatis ikut hilang", "Mode release penuh langsung aktif", "Hot reload dinonaktifkan produksinya"),
 "Hanya menyembunyikan pita 'debug' — bukan mengubah mode build."),

("Upload ditolak: \"version code sudah dipakai\". Solusinya?",
 ("Naikkan build number", "Ganti applicationId dengan yang baru", "Hapus project lama di Play Console", "Ubah nama aplikasi di pubspec saja"),
 "Store unik per build number — naikkan +N lalu rebuild."),

("Folder `build/symbols` wajib disimpan untuk?",
 ("Baca stack crash release", "Mengembalikan source saat rollback", "Dokumentasi arsitektur aplikasinya", "Keperluan upload ulang appbundle itu"),
 "Tanpa simbol, stack trace obfuscated tak bisa diterjemahkan."),
],
}
