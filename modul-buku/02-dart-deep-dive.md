---
title: 'Dart Lanjutan: Pemodelan Data'
description: 'Dart lanjutan untuk aplikasi nyata: enum bertipe, konstruktor factory, komposisi, sealed class, generics, pemetaan JSON, Stream, dan error bertipe di atas model domain aplikasi Tracker'
author: 'Kaqfa'
publishDate: 2024-09-21
category: 'Programming'
difficulty: 'intermediate'
tags: ['dart', 'oop', 'data-modeling', 'json', 'async', 'mobile-development']
accessLevel: 'free'
estimatedReadTime: 30
status: 'published'
chapterNumber: 2
chapterSlug: '02-dart-deep-dive'
parentBook: 'pemrograman-flutter'
objectives:
  - 'Memodelkan data aplikasi dengan enum bertipe, konstruktor factory, dan pola copyWith yang aman terhadap null'
  - 'Memetakan JSON ke objek bertipe dan sebaliknya dengan validasi yang jelas'
  - 'Memilih pewarisan atau komposisi saat merancang kontrak dan merangkai perilaku'
  - 'Menangani perubahan data dengan Stream dan kegagalan operasi dengan error bertipe'
nextChapter: '03-flutter-fundamentals'
prevChapter: '01-dart-fundamentals'
---

## Tujuan Pembelajaran

Bab 1 menutup fondasi bahasa: tipe, koleksi, fungsi, null safety, class sederhana, dan `Future`. Bab ini mengangkat semuanya ke level pemodelan data yang benar-benar dipakai aplikasi. Setelah menyelesaikannya, Anda bisa:

1. Memodelkan data aplikasi dengan enum bertipe, konstruktor `factory`, dan pola `copyWith` yang aman terhadap null.
2. Memetakan JSON ke objek bertipe dan sebaliknya, dengan error yang jelas saat data tidak sesuai.
3. Memilih pewarisan atau komposisi saat merancang kontrak dan merangkai perilaku.
4. Menangani perubahan data dengan `Stream` dan kegagalan operasi dengan tipe error yang eksplisit.

Estimasi: baca sekitar 30 menit, praktik contoh kode sekitar 90 menit.

## Dari Sintaks ke Model Domain

Sepanjang sisa buku, contoh implementasi memakai satu aplikasi acuan: pencatat tugas dan jadwal belajar (Tracker). Bab ini membangun model domainnya, `Task` beserta tipe pendukungnya, yang akan terus dipakai: bab 7 mengelolanya sebagai state, bab 9 mengirimnya sebagai JSON lewat REST API, dan bab 10 menyimpannya ke SQLite. Model yang sama, tiga konteks berbeda. Karena itu keputusan desain di bab ini bukan latihan kosong; kesalahannya akan terasa sampai bab terakhir.

Model `Task` di bab 1 cukup untuk memperkenalkan class, tetapi terlalu miskin untuk aplikasi sungguhan. Tugas nyata punya prioritas, catatan, label, dan waktu dibuat. Data datang dari jaringan sebagai JSON yang harus diurai, dan daftar tugas berubah setiap saat pengguna menambah atau menandai selesai. Semua kebutuhan itu diurai satu per satu di bab ini.

Semua contoh tetap berbasis teks dan bisa dijalankan di DartPad (https://dartpad.dev) atau dengan `dart run`. Contoh yang membutuhkan `Task` dari bagian sebelumnya ditandai sebagai kelanjutan, salin definisi sebelumnya bila mencoba di file terpisah.

## Nilai Terbatas dengan Enum

Prioritas tugas hanya punya tiga kemungkinan. Memodelkannya sebagai `String` berarti menerima typo `'hight'` sebagai data sah sampai aplikasi crash jauh di tempat lain. Enum mempersempit nilai ke daftar tetap sejak kompilasi. Dart 3 memperkaya enum dengan field dan method, jadi label tampilan dan bobot urutan bisa menyatu di satu tempat:

```dart
enum Priority {
  low('Rendah', 1),
  medium('Sedang', 2),
  high('Tinggi', 3);

  const Priority(this.label, this.weight);

  final String label;
  final int weight;
}

void main() {
  final p = Priority.high;
  print('${p.label} (bobot ${p.weight})'); // Tinggi (bobot 3)

  // Konversi dari teks, misalnya dari JSON atau input pengguna
  print(Priority.values.byName('medium')); // Priority.medium
}
```

`Priority.values.byName('medium')` melempar `ArgumentError` bila teksnya tidak cocok nilai mana pun. Perilaku ini diandalkan nanti saat mengurai JSON: data rusak gagal cepat di satu titik yang jelas, bukan merembet diam-diam.

Untuk nilai yang mungkin berubah kumpulannya saat aplikasi berjalan, nama pengguna, judul tugas, enum justru salah pilihan; `String` tetap tepat. Enum hanya untuk kumpulan tertutup yang diketahui saat menulis kode.

## Konstruktor Lanjutan dan copyWith yang Aman

Model `Task` lengkap sekaligus menjadi versi kanonik untuk bab-bab berikutnya:

```dart
class Task {
  final String id;
  final String title;
  final String? note;
  final Priority priority;
  final List<String> tags;
  final bool done;
  final DateTime? dueDate;
  final DateTime createdAt;

  const Task._({
    required this.id,
    required this.title,
    required this.createdAt,
    this.note,
    this.priority = Priority.medium,
    this.tags = const [],
    this.done = false,
    this.dueDate,
  });

  factory Task({
    required String id,
    required String title,
    DateTime? dueDate,
    DateTime? createdAt,
    String? note,
    Priority priority = Priority.medium,
    List<String> tags = const [],
    bool done = false,
  }) {
    if (title.trim().isEmpty) {
      throw ArgumentError.value(title, 'title', 'judul tidak boleh kosong');
    }
    return Task._(
      id: id,
      title: title,
      note: note,
      priority: priority,
      tags: tags,
      done: done,
      dueDate: dueDate,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  bool get isOverdue =>
      !done && dueDate != null && DateTime.now().isAfter(dueDate!);
}
```

Ada tiga keputusan desain di sini:

- Konstruktor generatif dibuat privat (`Task._`) dan konstruktor `factory` publik menggantikannya. Factory bisa menjalankan validasi sebelum membuat objek: judul kosong ditolak saat pembuatan, bukan saat ditampilkan. Konsekuensinya konstruktor tidak lagi bisa `const`, itu harga yang layak untuk invariant. Bila kelas Anda murni nilai tanpa aturan, pertahankan `const` seperti di bab 1.
- `id` selalu diisi pemanggil secara eksplisit. Aplikasi sungguhan menghasilkan id dari UUID (bab 9) atau autoincrement SQLite (bab 10); membuat id dari `DateTime.now()` hanya cocok untuk demo cepat karena dua pembuatan dalam milidetik yang sama menghasilkan id sama.
- `createdAt` diisi `DateTime.now()` sebagai nilai bawaan karena waktu pembuatan memang waktu saat itu, ini bukan id.

Model dengan field `final` tidak bisa diubah setelah dibuat. Untuk perubahan, misalnya menandai tugas selesai, dibuat salinan baru lewat `copyWith`. Versi naifnya punya jebakan:

```dart
// Versi naif: tidak bisa menghapus tenggat
Task copyWithNaive({String? title, Priority? priority, bool? done, DateTime? dueDate}) {
  return Task._(
    id: id,
    title: title ?? this.title,
    note: note,
    priority: priority ?? this.priority,
    tags: tags,
    done: done ?? this.done,
    dueDate: dueDate ?? this.dueDate,
    createdAt: createdAt,
  );
}
```

Pola `dueDate ?? this.dueDate` tidak bisa membedakan "pemanggil tidak menyentuh tenggat" dan "pemanggil sengaja menghapus tenggat", keduanya datang sebagai `null`. Solusi standarnya adalah nilai penanda (sentinel):

```dart
static const _unset = Object();

Task copyWith({
  String? title,
  Priority? priority,
  bool? done,
  Object? dueDate = _unset,
}) {
  return Task._(
    id: id,
    title: title ?? this.title,
    note: note,
    priority: priority ?? this.priority,
    tags: tags,
    done: done ?? this.done,
    dueDate: dueDate == _unset ? this.dueDate : dueDate as DateTime?,
    createdAt: createdAt,
  );
}
```

Parameter `dueDate` bertipe `Object?` dengan bawaan `_unset`: `null` berarti "hapus tenggat", tidak mengisi berarti "biarkan seperti sebelumnya". Pemanggilan `task.copyWith(done: true)` dan `task.copyWith(dueDate: null)` kini keduanya benar. Pola ini dipakai lagi di bab 7 setiap kali state berubah.

## Memetakan JSON

REST API dan penyimpanan lokal berbicara dalam JSON, sementara kode aplikasi ingin bekerja dengan `Task` bertipe. Jembatannya adalah `fromJson` dan `toJson`:

```dart
factory Task.fromJson(Map<String, dynamic> json) {
  return Task._(
    id: json['id'] as String,
    title: json['title'] as String,
    note: json['note'] as String?,
    priority: Priority.values.byName(json['priority'] as String),
    tags: [for (final tag in json['tags'] as List) tag as String],
    done: json['done'] as bool? ?? false,
    dueDate:
        json['due_date'] == null ? null : DateTime.parse(json['due_date'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}

Map<String, dynamic> toJson() {
  return {
    'id': id,
    'title': title,
    'note': note,
    'priority': priority.name,
    'tags': tags,
    'done': done,
    'due_date': dueDate?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
  };
}
```

Beberapa hal yang perlu diperhatikan:

- `Map<String, dynamic>` hanya hidup di batas sistem, masuk dari `jsonDecode`, keluar lewat `toJson`. Begitu berada di dalam `fromJson, kode kembali bertipe penuh. Ini alasan `dynamic` di bab 1 dibenarkan hanya untuk JSON mentah.
- Field nullable (`note`, `due_date`) diurai eksplisit: `as String?`, atau cek `null` sebelum `DateTime.parse`. Asumsi "pasti ada" tanpa cek berarti crash saat server mengirim data berbeda.
- `DateTime` tidak ada di JSON; dikirim sebagai string ISO 8601 lewat `toIso8601String()` dan diurai kembali dengan `DateTime.parse`. Konvensi snake_case (`due_date`) mengikuti format API; pemetaan nama field menjadi tugas tetap `fromJson`/`toJson`.
- Enum dikirim sebagai `name`-nya dan diurai kembali dengan `byName`, error nama yang tidak dikenal muncul di satu titik ini.

Putaran lengkapnya bisa diuji langsung:

```dart
import 'dart:convert';

void main() {
  final task = Task(
    id: 't-1',
    title: 'Kirim laporan mingguan',
    priority: Priority.high,
    dueDate: DateTime(2026, 9, 10),
  );

  final jsonText = jsonEncode(task.toJson());
  print(jsonText);

  final restored = Task.fromJson(jsonDecode(jsonText) as Map<String, dynamic>);
  print(restored.title); // Kirim laporan mingguan
  print(restored.priority); // Priority.high
}
```

Menulis `fromJson`/`toJson` manual seperti ini memang berulang, tetapi di buku ini sengaja dipertahankan sampai bab 9 supaya Anda melihat persis apa yang terjadi. Bab 9 kemudian memperkenalkan `json_serializable` yang menghasilkan kode yang sama otomatis, alat itu masuk akal justru setelah pola manualnya dipahami.

## Kontrak, Pewarisan, dan Komposisi

Sampai di sini kelas berdiri sendiri. Aplikasi nyata merangkai banyak kelas, dan Dart menyediakan tiga cara: `extends` mewarisi implementasi, `implements` memenuhi kontrak, dan komposisi merangkai objek sebagai field. Ketiganya bukan sinonim.

Untuk memisahkan "aplikasi butuh apa" dari "bagaimana disediakan", definisikan kontrak dengan `abstract interface class`:

```dart
abstract interface class TaskRepository {
  Future<List<Task>> all();
  Future<void> save(Task task);
  Future<void> delete(String id);
}

class MemoryTaskRepository implements TaskRepository {
  final _store = <String, Task>{};

  @override
  Future<List<Task>> all() async {
    final tasks = _store.values.toList();
    tasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return tasks;
  }

  @override
  Future<void> save(Task task) async {
    _store[task.id] = task;
  }

  @override
  Future<void> delete(String id) async {
    _store.remove(id);
  }
}
```

`TaskRepository` tidak punya implementasi sama sekali, ia hanya daftar operasi yang dijanjikan. `MemoryTaskRepository` memenuhinya dengan menyimpan di memori, cukup untuk pengujian dan pengembangan awal. Bab 8 dan 10 menambah `SqliteTaskRepository`, bab 9 `ApiTaskRepository`; kode yang memakai kontrak tidak perlu berubah.

Perhatikan bahwa `MemoryTaskRepository` memakai `implements`, bukan `extends`: tidak ada perilaku yang diwarisi, hanya kontrak yang dipenuhi. `extends` tepat bila subclass memang versi khusus dari superclass yang berbagi implementasi, misalnya widget Flutter yang menimpa sebagian method `build` sambil mewarisi sisanya. Komposisi, pada gilirannya, dipakai untuk merangkai:

```dart
class TaskListViewModel {
  TaskListViewModel({required this.repository});

  final TaskRepository repository;

  Future<List<Task>> pendingOnly() async {
    final tasks = await repository.all();
    return tasks.where((task) => !task.done).toList(growable: false);
  }
}
```

`TaskListViewModel` tidak mewarisi `TaskRepository` dan tidak mengimplementasikannya, ia _memiliki_ satu instance lewat field. Konsekuensinya besar: ganti `MemoryTaskRepository` dengan implementasi SQLite tanpa menyentuh `TaskListViewModel`, dan uji logikanya dengan repository palsu yang cepat.

Aturan praktisnya: pakai `implements` untuk kontrak yang dijanjikan ke konsumen, `extends` hanya untuk relasi "adalah-a" dengan implementasi yang benar-benar dibagikan, dan komposisi untuk yang lainnya. Kalau ragu, pilih komposisi, relasinya paling longgar dan paling mudah diubah.

## State sebagai Sealed Class

Layar daftar tugas selalu berada di salah satu dari tiga kondisi: sedang memuat, siap menampilkan data, atau gagal memuat. Kondisi seperti ini bisa dimodelkan dengan beberapa flag boolean, tetapi kombinasi flag (`loading == true` sekaligus `error != null`?) tidak pernah jelas. Dart 3 punya alat yang lebih tepat:

```dart
sealed class TaskListState {}

final class TaskListLoading extends TaskListState {}

final class TaskListReady extends TaskListState {
  TaskListReady(this.tasks);
  final List<Task> tasks;
}

final class TaskListError extends TaskListState {
  TaskListError(this.message);
  final String message;
}

String describe(TaskListState state) => switch (state) {
      TaskListLoading() => 'Memuat daftar tugas...',
      TaskListReady(:final tasks) =>
        'Siap: ${tasks.length} tugas, ${tasks.where((t) => t.done).length} selesai',
      TaskListError(:final message) => 'Terjadi error: $message',
    };
```

`sealed` berarti semua subclass wajib dideklarasikan di file yang sama, dan compiler tahu daftarnya tertutup. Keuntungannya langsung terasa pada `switch` di atas: setiap kasus diperiksa polanya, dan bila Anda menambah `TaskListEmpty` kelak, compiler menolak semua `switch` yang belum menanganinya. Bandingkan dengan flag boolean: kasus terlupakan baru ketahuan saat runtime, di depan pengguna.

Pola `TaskListReady(:final tasks)` membongkar field objek langsung di kasus `switch`, fitur pattern matching Dart 3. Bab 7 memakai struktur persis ini untuk state layar, dan bab 9 untuk hasil permintaan API.

## Generics dan Transformasi Koleksi

Bab 1 memperkenalkan `where`/`map`/`toList`. Untuk tampilan nyata, dua hal lagi dibutuhkan: mengelompokkan dan mengurutkan. Pengelompokan adalah operasi umum yang layak jadi fungsi generik:

```dart
Map<K, List<V>> groupBy<K, V>(Iterable<V> items, K Function(V) keyOf) {
  final result = <K, List<V>>{};
  for (final item in items) {
    result.putIfAbsent(keyOf(item), () => []).add(item);
  }
  return result;
}
```

Tanda `<K, V>` di awal mendeklarasikan dua tipe parameter: `K` untuk kunci pengelompokan, `V` untuk elemen. Sekali ditulis, fungsi bekerja untuk tugas per prioritas, kontak per huruf awal, apa saja, dengan tipe yang tetap diperiksa compiler. Berlaku untuk kelas juga; `List<Task>` yang dipakai sepanjang bab ini adalah kelas generik dari pustaka Dart.

Contoh pemakaiannya bersama operasi koleksi lain:

```dart
void main() {
  final tasks = [
    Task(id: 't-1', title: 'Kirim laporan', priority: Priority.high),
    Task(id: 't-2', title: 'Baca bab 3', priority: Priority.low),
    Task(id: 't-3', title: 'Review PR', priority: Priority.high),
  ];

  // Kelompokkan per prioritas untuk tampilan bertingkat
  final byPriority = groupBy(tasks, (Task t) => t.priority);
  for (final entry in byPriority.entries) {
    print('${entry.key.label}:');
    for (final task in entry.value) {
      print('  - ${task.title}');
    }
  }

  // Salin lalu urutkan: tugas terpenting dulu
  final sorted = [...tasks]
    ..sort((a, b) => b.priority.weight.compareTo(a.priority.weight));
  print(sorted.map((t) => t.title).toList());

  // Hitung agregat dengan fold
  final doneCount = tasks.fold<int>(0, (acc, task) => task.done ? acc + 1 : acc);
  print('$doneCount selesai');

  // Bangun baris tampilan: collection-for dan collection-if
  final pendingLines = [
    for (final task in tasks)
      if (!task.done) '- ${task.title} (${task.priority.label})',
  ];
  print(pendingLines.join('\n'));
}
```

Tiga pola terakhir ini yang paling sering dipakai Flutter: `..sort` memakai cascade pada salinan list (spread `[...tasks]` mencegah mutasi list asli), `fold` merangkum koleksi menjadi satu nilai, dan collection-for/collection-if membangun list literal dari kondisi, persis bentuk daftar `children` widget di bab 3 nanti.

## Data yang Berubah: Stream

`Future` dari bab 1 mewakili satu nilai yang datang sekali. Daftar tugas berbeda: ia berubah berkali-kali sepanjang umur aplikasi. `Stream` adalah tipe untuk urutan nilai dari waktu ke waktu:

```dart
import 'dart:async';

class TaskStore {
  final _tasks = <Task>[];
  final _changes = StreamController<List<Task>>.broadcast();

  /// Aliran snapshot daftar tugas setiap kali berubah.
  Stream<List<Task>> get changes => _changes.stream;

  List<Task> get snapshot => List.unmodifiable(_tasks);

  void add(Task task) {
    _tasks.add(task);
    _changes.add(snapshot);
  }

  void toggleDone(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(done: !_tasks[index].done);
    _changes.add(snapshot);
  }

  void dispose() {
    _changes.close();
  }
}

Future<void> main() async {
  final store = TaskStore();

  final subscription = store.changes.listen((tasks) {
    print('Perubahan: ${tasks.length} tugas, '
        '${tasks.where((t) => t.done).length} selesai');
  });

  store.add(Task(id: 't-1', title: 'Baca bab 2'));
  store.add(Task(id: 't-2', title: 'Coba contoh Stream'));
  store.toggleDone('t-1');

  await Future<void>.delayed(Duration.zero); // tunggu event terkirim
  subscription.cancel();
  store.dispose();
}
```

Hal penting dari contoh ini:

- `StreamController.broadcast()` mengirim setiap snapshot ke semua pendengar. Setiap kali daftar berubah, snapshot baru dikirim, pendengar tidak pernah melihat list internal yang bisa berubah di belakangnya (`List.unmodifiable` menjaga itu).
- Event dari stream controller asinkron terkirim lewat event loop; karena itu contoh menunggu satu putaran event loop sebelum membatalkan langganan.
- `listen` mengembalikan `StreamSubscription` yang harus dibatalkan, dan controller harus ditutup lewat `close()` saat tidak dipakai. Di Flutter, pembatalan ini dilakukan di `dispose()` widget, dibahas di bab 3 dan 7.

Di aplikasi Tracker, bab 7 memakai `ChangeNotifier` dan `Provider` untuk kebutuhan yang sama, keduanya dibangun di atas mekanisme pendengar seperti ini, jadi memahami stream membuat alat itu tidak terlihat seperti sihir.

## Error Bertipe dengan Result

Bagian terakhir menyatukan semuanya: memuat daftar tugas dari sumber luar (file, API) bisa gagal dengan beberapa cara, format JSON salah, field hilang, nilai enum tak dikenal. Kegagalan semacam ini _diharapkan_, berbeda dari bug pemrograman. Untuk kegagalan yang diharapkan, kode panggilan sebaiknya dipaksa menanganinya. Caranya: jadikan hasil operasi sebagai tipe:

```dart
sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.error);
  final Object error;
}
```

`Result<T>` menggabungkan dua teknik dari bab ini: `sealed` agar `switch` atas hasilnya tuntas diperiksa compiler, dan generics agar membungkus tipe apa pun. Versi sukses membawa nilai, versi gagal membawa objek error. Pemakaiannya pada pemuatan JSON:

```dart
import 'dart:convert';

Future<Result<List<Task>>> loadTasks(String source) async {
  try {
    await Future<void>.delayed(const Duration(milliseconds: 50)); // simulasi latensi I/O
    final data = jsonDecode(source);
    if (data is! List) {
      return Err(FormatException('Akar dokumen harus berupa array'));
    }
    return Ok([
      for (final (i, row) in data.indexed)
        if (row is Map<String, dynamic>)
          Task.fromJson(row)
        else
          throw FormatException('Elemen #$i bukan objek JSON'),
    ]);
  } on FormatException catch (e) {
    return Err(e); // JSON rusak atau tanggal tidak sah
  } on TypeError catch (e) {
    return Err(FormatException('Struktur field tidak sesuai: $e'));
  } on ArgumentError catch (e) {
    return Err(e); // misalnya priority tidak dikenal
  }
}
```

Di dalam `loadTasks`, `try`/`catch` menangkap error parsing dari `jsonDecode`, `DateTime.parse`, cast `as`, dan `byName`, lalu membungkusnya menjadi `Err`. Di luar, pemanggil tidak bisa mengabaikan kegagalan karena hasilnya harus dibongkar dulu:

```dart
Future<void> main() async {
  final result = await loadTasks('''
  [
    {"id": "t-1", "title": "Baca bab 2", "priority": "high",
     "tags": ["dart"], "created_at": "2026-09-03T10:00:00Z"},
    {"id": "t-2", "title": "Rapat kelompok", "priority": "urgent",
     "created_at": "2026-09-03T11:00:00Z"}
  ]
  ''');

  switch (result) {
    case Ok(value: final tasks):
      print('Berhasil memuat ${tasks.length} tugas');
    case Err(:final error):
      print('Gagal memuat: $error');
  }
}
```

Contoh di atas sengaja memuat satu baris dengan `priority: "urgent"` yang tidak ada di enum, jalur `Err` yang diambil, dan pesan errornya menunjuk penyebabnya. Coba ganti ke `"high"` untuk melihat jalur `Ok`.

Kapan memakai exception, kapan `Result`? Exception tetap tepat untuk kondisi yang menandakan bug, `ArgumentError` dari konstruktor `Task` menandakan kesalahan pemrograman yang harus diperbaiki, bukan ditangani di runtime. `Result` untuk kegagalan operasional yang pemanggil wajib putuskan: tampilkan pesan, coba lagi, atau pakai data cadangan. Buku ini memakai keduanya dengan pembagian itu.

## Ringkasan

- Enum bertipe (`Priority`) mempersempit nilai tetap; `byName` mengurai teks ke enum dan gagal cepat bila tidak dikenal.
- Konstruktor `factory` memvalidasi sebelum objek dibuat; `copyWith` dengan sentinel `Object()` menangani field nullable yang perlu dihapus nilainya.
- `fromJson`/`toJson` menjadi satu-satunya tempat `Map<String, dynamic>` berada; field nullable dan `DateTime` diurai eksplisit.
- `abstract interface class` mendefinisikan kontrak implementasi; komposisi merangkai perilaku dan lebih disukai daripada pewarisan.
- `sealed class` + pattern matching memodelkan kondisi eksklusif; compiler memaksa semua kasus ditangani.
- `groupBy` generik, `..sort` pada salinan, `fold`, dan collection-for/if adalah pola pembentuk daftar tampilan.
- `StreamController` menyiarkan perubahan koleksi; langganan dibatalkan dan controller ditutup saat selesai.
- `Result<T>` menggabungkan sealed + generics memaksa pemanggil menangani kegagalan operasional, sementara exception tetap untuk bug pemrograman.

Model `Task` beserta `TaskRepository`, `TaskListState`, dan `Result` dari bab ini adalah basis kode yang dipegang sepanjang buku. Bab 3 mulai menampilkan semuanya di layar lewat widget Flutter.

## Bekerja dengan AI di Bab Ini

**Pantas didelegasikan:** meminta contoh perbandingan antara dua cara memodelkan hal yang sama, misalnya pewarisan versus komposisi untuk kasus Anda sendiri.

**Tulis sendiri:** keputusan pemodelan: kelas apa yang ada, apa yang boleh null, dan apa yang menjadi enum. AI memberi model yang masuk akal secara umum, sedangkan yang Anda butuhkan adalah model yang cocok dengan aturan domain Anda, dan aturan itu hanya Anda yang tahu. Bagian ini yang menentukan apakah bab ini benar-benar Anda kuasai.

**Latihan:** Berikan tiga aturan domain Anda kepada AI dan minta ia membuat sealed class untuk state layar. Lalu cari keadaan mustahil yang masih bisa dibuat dari hasilnya, misalnya dua field yang seharusnya tidak pernah terisi bersamaan. Perbaiki sendiri, dan catat apa yang terlewat.

## Referensi Lanjutan

- Classes, enum, dan class modifiers: https://dart.dev/language
- Patterns dan switch expressions: https://dart.dev/language/patterns
- Generics: https://dart.dev/language/generics
- Asynchronous programming dan Stream: https://dart.dev/libraries/async
- JSON serialization: https://dart.dev/guides/json
- DartPad untuk mencoba kode tanpa instalasi: https://dartpad.dev
