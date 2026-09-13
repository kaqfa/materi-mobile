---
title: 'Dart Fundamentals'
description: 'Fondasi bahasa Dart untuk Flutter: tipe data, koleksi, fungsi, null safety, class, error handling, hingga async sebagai pengantar'
author: 'Kaqfa'
publishDate: 2024-09-18
category: 'Programming'
difficulty: 'beginner'
tags: ['flutter', 'dart', 'mobile', 'programming', 'fundamentals']
accessLevel: 'free'
estimatedReadTime: 25
status: 'published'
chapterNumber: 1
chapterSlug: '01-dart-fundamentals'
parentBook: 'pemrograman-flutter'
objectives:
  - 'Menulis program Dart dengan tipe data, koleksi, dan fungsi'
  - 'Menerapkan null safety dengan benar'
  - 'Membuat class sederhana untuk pemodelan data'
  - 'Menangani error dan menulis kode asynchronous dengan Future dan async/await'
nextChapter: '02-dart-deep-dive'
prevChapter: null
---

## Tujuan Pembelajaran

Bab ini membangun fondasi bahasa Dart yang dipakai sepanjang buku. Setelah menyelesaikannya, Anda bisa:

1. Menulis dan menjalankan program Dart sederhana dengan tipe data, koleksi, dan fungsi.
2. Menggunakan null safety: tipe nullable, operator `?.`, `??`, dan inisialisasi `late`.
3. Membuat class untuk pemodelan data: konstruktor bernama, properti privat, dan pewarisan dasar.
4. Menangani error dengan `try`/`catch` dan menulis kode asynchronous dengan `Future`, `async`/`await`, serta mengenal `Isolate` sebagai pengantar.

Estimasi: baca sekitar 20 menit, praktik contoh kode sekitar 60 menit.

## Konteks Singkat: Mobile dan Flutter

Aplikasi mobile berbeda dari aplikasi web dalam hal yang memengaruhi cara kita menulis kode. Aplikasi berjalan langsung di perangkat dengan sumber daya terbatas: baterai, memori, dan CPU yang bisa menurun performanya saat panas. Interaksinya berbasis sentuhan, bukan mouse, sehingga elemen UI harus lebih besar dan responsnya instan. Aplikasi juga harus tetap berfungsi saat jaringan tidak stabil, dan distribusinya lewat app store dengan proses review.

Dari sekian banyak pendekatan pengembangan mobile, buku ini memakai Flutter. Ringkasnya:

| Pendekatan            | Karakteristik utama                                                                      |
| --------------------- | ---------------------------------------------------------------------------------------- |
| Native (Kotlin/Swift) | Performa dan akses platform terbaik, tetapi kode terpisah per platform                   |
| React Native          | Satu basis kode JavaScript, UI dari komponen native, komunikasi lewat bridge             |
| Flutter               | Satu basis kode Dart, UI digambar sendiri oleh engine sehingga konsisten lintas platform |

Flutter mengompilasi Dart langsung ke kode native untuk aplikasi rilis, dan memakai kompilasi JIT saat pengembangan agar hot reload bekerja cepat. Flutter dipakai secara publik pada aplikasi seperti Google Ads, BMW, dan Nubank. Untuk buku ini yang terpenting: satu bahasa (Dart), satu basis kode untuk Android dan iOS, dan UI yang konsisten di kedua platform.

Sisanya tentang Flutter, instalasi, struktur proyek, hingga widget, dibahas di bab 3 dan 4. Bab ini dan bab 2 fokus pada bahasanya dulu, memakai contoh berbasis teks. Anda bisa mencoba semua contoh di bab ini tanpa menginstal apa pun lewat DartPad (https://dartpad.dev), atau menginstal Dart SDK dan menjalankannya di terminal.

## Program Dart Pertama

Buat file `hello.dart`:

```dart
void main() {
  print('Halo, Dart!');
}
```

Jalankan dengan:

```bash
dart run hello.dart
```

Setiap program Dart memulai eksekusi dari fungsi `main`. Fungsi `print` menulis ke stdout. Itu cukup untuk seluruh contoh di bab ini, fokus kita adalah bahasa, bukan UI.

## Variabel dan Tipe

Dart adalah bahasa dengan tipe statis: setiap variabel punya tipe, dan kesalahan tipe tertangkap saat kompilasi, bukan saat aplikasi berjalan. Anda jarang perlu menulis tipe secara eksplisit karena Dart bisa menyimpulkannya.

```dart
var title = 'Belajar Dart';   // String
var count = 42;               // int
var price = 19.99;            // double
var isActive = false;         // bool

// Deklarasi dengan tipe eksplisit, berguna untuk API publik
String name = 'Kaqfa';
int amount = 100;

// final: tidak bisa di-reassign setelah diisi
final today = DateTime.now();

// const: nilai compile-time constant
const pi = 3.14159;
```

Aturan praktis: gunakan `var` untuk variabel lokal, `final` untuk nilai yang dihitung saat runtime tetapi tidak berubah, dan `const` untuk nilai yang sudah diketahui saat kompilasi.

Angka memiliki tipe `int` dan `double`, keduanya subtipe dari `num`. String memakai kutip satu atau dua, dan mendukung interpolasi dengan `$` atau `${}`:

```dart
void main() {
  var item = 'kopi';
  var qty = 2;
  print('$qty porsi ${item.toUpperCase()}'); // 2 porsi KOPI
}
```

Konversi antar tipe selalu eksplisit. Ini perbedaan penting dari PHP dan JavaScript yang sering mengonversi secara implisit:

```dart
var input = '25';
int age = int.parse(input);          // String -> int, error bila bukan angka
int? maybe = int.tryParse(input);    // null bila bukan angka
double d = double.parse('3.5');
String s = age.toString();
```

Tipe `dynamic` menonaktifkan pemeriksaan tipe, error tipe baru muncul saat runtime. Hindari `dynamic` kecuali berurusan dengan data yang bentuknya benar-benar tidak pasti, misalnya JSON yang belum diurai; itu pun sebaiknya segera diubah ke class atau tipe eksplisit.

## Koleksi

Tiga koleksi utama: `List` (urutan), `Map` (pasangan kunci-nilai), dan `Set` (nilai unik). Semuanya generik, sehingga tipe isinya diketahui compiler.

```dart
void main() {
  // List
  var skills = <String>['Dart', 'Flutter'];
  skills.add('SQLite');
  print(skills[0]); // Dart
  print(skills.length); // 3

  // Map
  var scores = <String, int>{
    'Dart': 90,
    'Flutter': 85,
  };
  scores['SQLite'] = 88;
  print(scores['Dart']); // 90

  // Set: tidak ada duplikat
  var tags = ['dart', 'flutter', 'dart'].toSet();
  print(tags); // {dart, flutter}
}
```

Iterasi memakai `for` biasa atau `for-in`. Untuk mengubah koleksi menjadi koleksi baru, gunakan method `where`, `map`, dan `toList`:

```dart
void main() {
  var tasks = ['belajar dart', 'beli kopi', 'kerjakan tugas'];

  var long = tasks.where((t) => t.length > 10).toList();
  var upper = tasks.map((t) => t.toUpperCase()).toList();
  print(long); // [belajar dart, kerjakan tugas]
  print(upper); // [BELAJAR DART, BELI KOPI, KERJAKAN TUGAS]

  for (final task in tasks) {
    print('- $task');
  }
}
```

Pola `where`/`map`/`toList` ini dipakai berulang kali sepanjang buku, terutama saat menyaring daftar tugas di aplikasi acuan.

## Fungsi

Fungsi Dart mendukung parameter posisi dan parameter bernama. Parameter bernama adalah cara idiomatis Dart untuk membuat panggilan fungsi jelas:

```dart
// Parameter wajib
int add(int a, int b) => a + b;

// Parameter bernama; required membuatnya wajib diisi
void greet({required String name, String greeting = 'Halo'}) {
  print('$greeting, $name!');
}

// Fungsi ekspresi singkat (arrow syntax)
double half(int n) => n / 2;

void main() {
  print(add(20, 4)); // 24
  print(half(5)); // 2.5
  greet(name: 'Kaqfa'); // Halo, Kaqfa!
  greet(name: 'Budi', greeting: 'Selamat pagi');
}
```

Fungsi adalah nilai: bisa disimpan di variabel, dikirim sebagai argumen, dan dikembalikan dari fungsi lain. Method `where` di atas menerima fungsi `(t) => t.length > 10` sebagai argumen, pola ini disebut higher-order function dan menjadi dasar gaya pemrograman yang dipakai Flutter.

```dart
bool isLong(String s) => s.length > 10;

void main() {
  var tasks = ['belajar dart', 'beli kopi', 'kerjakan tugas'];

  // isLong dipakai sebagai argumen, bukan dipanggil
  var long = tasks.where(isLong).toList();
  print(long); // [belajar dart, kerjakan tugas]
}
```

## Null Safety

Di Dart, tipe secara default tidak boleh `null`. Variabel bertipe `String` dijamin berisi string; kalau bisa kosong, Anda harus menuliskannya eksplisit sebagai `String?`. Compiler lalu memaksa Anda menangani kemungkinan null sebelum mengakses nilainya. Ini menghilangkan seluruh kelas error "null reference" saat runtime, error yang paling sering membuat aplikasi crash.

```dart
String? lookupName() => 'kaqfa'; // bisa saja null, tergantung data

void main() {
  String title = 'Bab 1'; // tidak mungkin null
  String? nickname = lookupName(); // bertipe String?, bisa null

  // print(nickname.length); // ERROR: bisa null
  print(nickname?.length); // null bila nickname null
  print(nickname?.length ?? 0); // 0 sebagai nilai pengganti
  print(title.length); // 5: title tidak mungkin null
}
```

Empat alat utama:

1. `Type?`: menyatakan boleh null.
2. `?.`: akses anggota hanya bila tidak null, hasilnya null bila nilainya null.
3. `??`: memberi nilai pengganti bila kiri null.
4. `!`: asersi bahwa nilai tidak null; memakai `!` pada nilai null tetap melempar error saat runtime, jadi gunakan hanya saat Anda yakin dan singkat.

```dart
String? lookup(String key) => key.isEmpty ? null : key;

void main() {
  String? middleName = lookup('Aji'); // bisa null, tergantung isi

  // Pola umum: cek dulu, lalu akses langsung
  if (middleName != null) {
    print(middleName.length); // 3, aman: compiler tahu sudah dicek
  }

  // Pola umum: beri nilai pengganti
  String? backup = lookup(''); // null
  print(backup ?? '-'); // -
}
```

Setelah pengecekan `!= null`, compiler otomatis mempersempit tipe sehingga Anda tidak perlu `!`. Untuk field yang baru diisi belakangan tetapi dijamin terisi sebelum dibaca, gunakan `late`:

```dart
class Profile {
  late final String token; // diisi sekali saat login, bukan di konstruktor
}
```

`late` menunda pemeriksaan ke runtime: membaca field `late` yang belum pernah diisi melempar error. Jangan gunakan `late` hanya untuk menghindari error compiler; kalau bisa null sungguhan, `String?` adalah jawaban yang jujur.

## Class Dasar

Class mengelompokkan data dan perilaku. Berikut pola class yang dipakai sepanjang buku untuk pemodelan data, ini versi sederhana dari model `Task` di aplikasi acuan:

```dart
class Task {
  final String id;
  final String title;
  final bool done;
  final DateTime? dueDate; // bisa null: tidak semua tugas punya tenggat

  const Task({
    required this.id,
    required this.title,
    this.done = false,
    this.dueDate,
  });

  bool get isOverdue {
    if (dueDate == null || done) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  Task copyWith({String? title, bool? done}) {
    return Task(
      id: id,
      title: title ?? this.title,
      done: done ?? this.done,
      dueDate: dueDate,
    );
  }
}

final t1 = Task(id: 't-1', title: 'Belajar Dart');

void main() {
  final t2 = t1.copyWith(done: true);
  print('${t2.title}: ${t2.done}'); // Belajar Dart: true
}
```

Hal penting dari contoh ini:

- Parameter bernama `required` membuat konstruktor mudah dibaca pada pemanggilan.
- Konstruktor bisa `const` bila semua field-nya final dan nilainya compile-time constant; ini memungkinkan Dart berbagi satu instance untuk nilai yang sama.
- Field dengan awalan underscore (`_nama`) bersifat privat terhadap file (library) tempatnya dideklarasikan.
- Getter (`isOverdue`) menghitung nilai tanpa menyimpannya.
- Pola `copyWith` membuat salinan objek dengan beberapa perubahan, karena field final tidak bisa diubah langsung. Pola ini dipakai terus di Flutter.

Pewarisan dan abstraksi:

```dart
abstract class Storage {
  Future<void> save(String key, String value);
  Future<String?> read(String key);
}

class MemoryStorage implements Storage {
  final _data = <String, String>{};

  @override
  Future<void> save(String key, String value) async {
    _data[key] = value;
  }

  @override
  Future<String?> read(String key) async => _data[key];
}
```

`abstract class` mendefinisikan kontrak tanpa implementasi; `implements` berarti class lain wajib mengimplementasikan semua anggotanya, `extends` mewarisi implementasi, dan `@override` menandai anggota yang ditimpa. Dart juga punya `mixin` untuk berbagi perilaku lintas hierarki class, dibahas di bab 2 bersama topik OOP lainnya. Untuk nilai tetap, gunakan `enum`:

```dart
enum Priority { low, medium, high }

void main() {
  final p = Priority.high;
  print(p.name); // high
}
```

## Error Handling

Dart memakai exception. Error tidak tertangani membuat program berhenti, jadi operasi yang bisa gagal, parsing, file, jaringan, harus dibungkus `try`/`catch`:

```dart
int parseAge(String input) {
  return int.parse(input); // melempar FormatException bila bukan angka
}

void main() {
  try {
    print(parseAge('dua puluh'));
  } on FormatException catch (e) {
    print('Input bukan angka: ${e.message}');
  } catch (e) {
    print('Error tak terduga: $e');
  } finally {
    print('Selesai.');
  }
}
```

- `on TipeTertentu` menangkap exception tipe itu saja; `catch (e)` menangkap sisanya.
- Blok `finally` selalu berjalan, cocok untuk pembersihan.
- `throw` bisa melempar objek apa pun, tapi kebiasaan yang baik adalah membuat subclass `Exception` untuk error domain aplikasi:

```dart
class ValidationError implements Exception {
  final String message;
  ValidationError(this.message);

  @override
  String toString() => 'ValidationError: $message';
}

void setAge(int age) {
  if (age < 0) throw ValidationError('Umur tidak boleh negatif');
}
```

Untuk argumen fungsi yang salah, Dart sudah menyediakan `ArgumentError` dan `ArgumentError.value`. Bila handler setempat tidak bisa menangani error, lempar kembali dengan `rethrow` agar handler di atasnya yang menanganinya.

## Asynchronous: Future dan async/await

Operasi I/O, permintaan jaringan, baca-tulis file, query database, membutuhkan waktu yang tidak bisa diprediksi. Dart menyelesaikannya dengan satu event loop per isolate: kode Anda berjalan satu per satu, dan operasi I/O mengembalikan `Future`, yaitu nilai yang baru tersedia nanti. Selama menunggu, event loop bebas memproses hal lain, di Flutter, artinya UI tetap responsif. Memanggil operasi berat secara sinkron di event loop membuat UI macet.

Fungsi bertanda `async` bisa memakai `await` untuk menunggu `Future` sebelum lanjut, sehingga kode asynchronous terbaca seperti kode biasa:

```dart
import 'dart:convert';
import 'dart:io';

Future<String> fetchTitle(Uri url) async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(url);
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    return body;
  } finally {
    client.close();
  }
}

Future<void> main() async {
  try {
    final title = await fetchTitle(Uri.parse('https://dart.dev'));
    print('Panjang respons: ${title.length}');
  } on SocketException {
    print('Koneksi gagal.');
  } catch (e) {
    print('Error: $e');
  }
}
```

Poin penting:

- `await` hanya sah di dalam fungsi `async`. Fungsi `main` boleh `async`.
- Error pada `Future` ditangkap dengan `try`/`catch` di sekitar `await`, sama seperti kode sinkron.
- `Future<T>` adalah tipe return async dengan anotasi tipe lengkap; gunakan `Future<void>` bila tidak mengembalikan nilai.

Untuk beberapa operasi yang bisa berjalan bersamaan, `Future.wait` menunggu semuanya sekaligus:

```dart
Future<void> collectTwo() async {
  final results = await Future.wait([
    Future.delayed(Duration(milliseconds: 300), () => 'dart'),
    Future.delayed(Duration(milliseconds: 200), () => 'flutter'),
  ]);
  print(results); // [dart, flutter]
}
```

Tanpa `Future.wait`, dua `await` berurutan memakan waktu 300 + 200 milidetik; dengan `Future.wait` keduanya berjalan bersamaan dan totalnya yang terlama saja. Pola yang sama berlaku untuk dua permintaan HTTP yang tidak saling bergantung.

Alternatif tanpa `await` adalah rantai `.then`, mirip `.then` di JavaScript:

```dart
void main() {
  Future.delayed(Duration(milliseconds: 300), () => 'selesai')
      .then((value) => print(value))
      .catchError((e) => print('Error: $e'));
}
```

Untuk pembaca dari JavaScript: `Future` dan `Promise` keduanya eager, pekerjaan sudah dimulai begitu fungsi dipanggil, menunggu `.then` atau `await` hanya berarti menunggu hasil, bukan menunda pekerjaan. Perbedaan praktisnya: `Future<T>` bertipe eksplisit sehingga hasil dan error terlihat di tanda tangan fungsi, dan pemeriksaan null safety berlaku juga di sini.

Satu catatan kejujuran soal event loop: karena hanya ada satu thread eksekusi per isolate, dua thread tidak pernah menulis memori yang sama bersamaan sehingga data race antar thread tidak terjadi. Namun race condition logis tetap mungkin bila Anda membaca dan menulis state yang sama di antara beberapa `await` yang saling berpotongan. State perlu dilindungi lewat urutan operasi yang disiplin, bukan dianggap aman otomatis.

## Pengantar Isolate

Bila pekerjaan berat benar-benar memblokir, misalnya mem-parsing file JSON besar atau kompresi gambar, `await` tidak menolong karena pekerjaannya sendiri sinkron di event loop. Untuk itu ada `Isolate`: unit eksekusi dengan memori sendiri, tidak berbagi state dengan isolate lain. Dart menjalankan kode Anda dan Flutter menjalankan UI-nya di isolate utama; pekerjaan berat dipindah ke isolate terpisah:

```dart
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

Future<int> countTopLevelFields(String jsonPath) {
  return Isolate.run(() {
    final content = File(jsonPath).readAsStringSync();
    final data = jsonDecode(content) as Map<String, dynamic>;
    return data.length;
  });
}
```

`Isolate.run` menjalankan fungsi di isolate baru dan mengembalikan hasilnya sebagai `Future`. Detail isolasi, pengiriman pesan antar isolate, dan `Stream` untuk data yang mengalir terus-menerus dibahas di bab lanjutan. Untuk sekarang, cukup ingat dua aturan: jangan blokir event loop utama, dan pindahkan komputasi berat ke isolate.

## Ringkasan

- Dart bertipe statis dengan type inference; gunakan `var` untuk lokal, `final` untuk nilai tetap, `const` untuk konstanta kompilasi.
- Koleksi utama: `List`, `Map`, `Set`; pola `where`/`map`/`toList` dipakai sepanjang buku.
- Null safety: default tidak null, `Type?` untuk yang bisa null, tangani dengan `?.`, `??`, atau pengecekan `!= null`.
- Pemodelan data: class dengan parameter bernama `required`, konstruktor `const`, field privat `_`, getter, dan pola `copyWith`.
- Error: `try`/`on`/`catch`/`finally`, exception kustom untuk error domain, `rethrow` bila tidak bisa ditangani setempat.
- Async: `Future` untuk hasil yang datang nanti, `async`/`await` untuk menunggunya, `Future.wait` untuk paralel, `Isolate.run` untuk komputasi berat.

Bab berikutnya memperdalam Dart: OOP penuh, generics, dan pola transformasi koleksi untuk data aplikasi.

## Bekerja dengan AI di Bab Ini

**Pantas didelegasikan:** menanyakan padanan sintaks dari bahasa yang sudah Anda kuasai ("bagaimana menulis ini dalam Dart?"), dan meminta penjelasan pesan error compiler yang belum Anda kenali.

**Tulis sendiri:** setiap latihan di bab ini, sampai selesai, tanpa menyalin jawaban. Bab ini sengaja kecil; mengerjakannya sendiri butuh menit, sementara kerugian melewatkannya terasa sepanjang tiga belas bab berikutnya. Bagian ini yang menentukan apakah bab ini benar-benar Anda kuasai.

**Latihan:** Minta AI menulis fungsi yang mengembalikan daftar tugas yang tenggatnya sudah lewat. Sebelum menjalankannya, tebak lebih dulu apa yang terjadi jika daftarnya kosong, dan apakah tanggal hari ini termasuk "lewat". Baru jalankan, dan bandingkan tebakan Anda dengan hasilnya.

## Referensi Lanjutan

- Dart language tour: https://dart.dev/language
- Async programming di Dart: https://dart.dev/libraries/async
- DartPad untuk mencoba kode tanpa instalasi: https://dartpad.dev
