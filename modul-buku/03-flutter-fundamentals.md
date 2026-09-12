---
title: 'Flutter Fundamental: Widget, Layout, State Lokal, dan Navigasi'
description: 'Membangun antarmuka pertama aplikasi Tracker: widget immutable, widget tree, layout berbasis constraints, state lokal dengan setState, siklus hidup widget, dan navigasi antar layar'
author: 'Kaqfa'
publishDate: 2024-09-21
category: 'Programming'
difficulty: 'beginner'
tags:
  ['flutter', 'widget', 'layout', 'state-management', 'navigation', 'mobile-ui']
estimatedReadTime: 30
accessLevel: 'free'
status: 'published'
chapterNumber: 3
chapterSlug: '03-flutter-fundamentals'
parentBook: 'pemrograman-flutter'
objectives:
  - 'Membaca kode Flutter sebagai widget tree dan menjelaskan mengapa widget bersifat immutable'
  - 'Menyusun layout dengan Column, Row, Expanded, dan ListView berdasarkan model constraints turun-ukuran naik'
  - 'Memilih StatelessWidget atau StatefulWidget dan mengubah tampilan lewat setState'
  - 'Mengelola siklus hidup State: initState, dispose, pemeriksaan mounted setelah async, dan pembersihan controller serta langganan'
  - 'Menavigasi antar layar dengan Navigator dan mengoper data bolak-balik lewat hasil push/pop'
nextChapter: '04-build-system-project-structure'
prevChapter: '02-dart-deep-dive'
---

## Tujuan Pembelajaran

Bab 1 dan 2 membangun model domain Tracker dengan Dart murni: `Task`, `Priority`, `TaskRepository`, sampai `Result`. Semuanya berjalan di terminal. Bab ini memindahkan model itu ke layar: antarmuka pertama aplikasi Tracker, mulai dari daftar tugas statis sampai layar detail yang bisa dinavigasi.

Setelah menyelesaikan bab ini, Anda bisa:

1. Membaca kode Flutter sebagai widget tree dan menjelaskan mengapa widget bersifat immutable.
2. Menyusun layout dengan `Column`, `Row`, `Expanded`, dan `ListView` berdasarkan model constraints.
3. Memilih `StatelessWidget` atau `StatefulWidget` dan mengubah tampilan lewat `setState`.
4. Mengelola siklus hidup `State`: `initState`, `dispose`, pemeriksaan `mounted` setelah operasi async, dan pembersihan controller serta langganan.
5. Menavigasi antar layar dengan `Navigator` dan mengoper data bolak-balik lewat hasil `push`/`pop`.

Estimasi: baca sekitar 45 menit, praktik contoh kode sekitar 120 menit.

## Dari Model ke Layar

Cara klasik membangun UI di Android native bersifat imperatif: Anda menahan referensi ke `TextView`, lalu memanggil `textView.setText(...)` setiap kali data berubah. Kode UI dan kode pembaruan data tersebar di banyak tempat, dan satu kondisi yang terlewat membuat tampilan tidak sinkron dengan data. Flutter membalik pendekatannya: Anda menulis fungsi yang memetakan data menjadi deskripsi tampilan, dan framework yang menghitung apa yang harus digambar ulang.

```dart
// Deklaratif: tampilan adalah fungsi dari data.
// Tidak ada "ubah teks judul": cukup kembalikan deskripsi baru.
Text(task.done ? 'Selesai' : task.title)
```

Konsekuensi gaya ini akan terasa di seluruh bab: satu fungsi `build` mengembalikan deskripsi, data berubah lewat `setState`, dan framework menyelaraskan keduanya. Tidak ada lagi sinkronisasi manual antara data dan tampilan.

Untuk mencoba contoh, buat proyek baru dengan `flutter create tracker`, lalu ganti isi `lib/main.dart` pada tiap versi. Salin juga `Priority` dan `Task` dari bab 2 ke `lib/task.dart`, bab ini hanya memakai field `id`, `title`, `note`, `priority`, `done`, dan `dueDate`. Anatomi lengkap proyek Flutter dibahas di bab 4; sekarang cukup `flutter run` di emulator atau perangkat.

Contoh kode disajikan bertahap sebagai satu aplikasi yang tumbuh: versi 1 daftar statis, versi 2 layout lebih kaya, versi 3 ada state, versi 4 memuat data async dan menambah tugas, versi 5 navigasi ke layar detail. Setiap versi hanya menampilkan kode yang berubah; sisanya tetap.

## Widget: Deskripsi Immutable

Semua elemen visual di Flutter adalah widget: `Text`, tombol, padding, alignment, bahkan aplikasi itu sendiri. Widget bukan objek yang digambar ke layar, melainkan deskripsi konfigurasi, immutable, murah dibuat, dan dibuang begitu selesai dipakai. Yang benar-benar hidup lama di memori adalah element dan render object yang dikelola framework; kode Anda hanya memproduksi deskripsi.

Karena widget tidak pernah diubah setelah dibuat, semua field-nya `final` dan konstruktornya bisa dibuat `const` bila semua argumennya konstanta:

```dart
class PriorityChip extends StatelessWidget {
  const PriorityChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
```

Beberapa hal dari potongan ini:

- `withValues(alpha: 0.12)` adalah pengganti metode `withOpacity` yang sudah deprecated sejak Flutter 3.27. `withValues` menerima komponen warna secara eksplisit dan konsisten dengan model warna baru Flutter; buku ini memakainya di semua tempat yang butuh transparansi.
- `const` pada konstruktor memungkinkan framework memakai ulang instance yang sama saat tree dibangun ulang, efisiensi gratis tanpa mengubah perilaku.
- `super.key` meneruskan identitas widget ke superclass. `key` dipakai framework saat membandingkan tree lama dengan tree baru; untuk daftar item yang bisa berubah urutan, misalnya setelah sortir, key berbasis id data (misalnya `ValueKey(task.id)`) menjaga state dan posisi tetap menempel pada item yang benar.

Flutter membangun UI dengan komposisi, bukan pewarisan. Tidak ada hierarki `SuperListTile` → `TaskListTile`; yang ada justru widget kecil yang saling membungkus. `PriorityChip` di atas adalah contohnya: daripada memberi properti prioritas pada `Text`, kita menyusun `Container` + `Text` menjadi satu widget baru yang punya nama dan tanggung jawab jelas.

## Widget Tree dan Fungsi build

Menjalankan aplikasi berarti menanam satu widget akar yang membentangkan seluruh layar. Dari akar itu tumbuh widget tree: setiap widget memiliki nol atau lebih child, dan setiap `build` mengembalikan potongan tree baru. Versi 1 Tracker adalah daftar tugas statis:

```dart
import 'package:flutter/material.dart';

import 'task.dart';

void main() => runApp(const TrackerApp());

class TrackerApp extends StatelessWidget {
  const TrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF1E88E5)),
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  static final _tasks = [
    Task(id: 't-1', title: 'Baca bab 3', priority: Priority.high),
    Task(id: 't-2', title: 'Coba contoh layout'),
    Task(
      id: 't-3',
      title: 'Kirim laporan mingguan',
      priority: Priority.low,
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Tracker')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          for (final task in _tasks)
            ListTile(
              leading: Icon(
                task.done ? Icons.check_circle : Icons.circle_outlined,
                color: task.done ? Colors.green : Colors.grey,
              ),
              title: Text(task.title),
              subtitle: Text(task.priority.label),
            ),
        ],
      ),
    );
  }
}
```

Pohonnya terbaca langsung dari indentasi: `MaterialApp` membungkus `TaskListScreen`; di dalamnya `Scaffold` menyediakan kerangka layar Material, app bar di atas, body di tengah; `ListView` di body menampung banyak `ListTile`. Bentuk `[for (final task in _tasks) ListTile(...)]` adalah collection-for dari bab 2: daftar `children` dibangun dari data, persis pola yang dijanjikan bab sebelumnya.

Dua aturan kerja yang membuat pola ini awet:

- `build` harus murni. Data sama menghasilkan tree yang sama; jangan memicu efek samping, menulis file, memanggil `setState`, mengubah variabel global, di dalam `build`. Framework memanggil `build` kapan saja dan sebanyak yang diperlukan.
- Widget yang tidak berubah sebaiknya `const`. `const Text('Task Tracker')` di-build sekali dan dipakai ulang di setiap rebuild berikutnya.

## Layout: Constraints Turun, Ukuran Naik

Flutter tidak punya sistem layout terpisah seperti CSS. Layout adalah negosiasi antar widget dalam tree, dan seluruhnya tunduk pada tiga aturan:

1. Parent memberikan constraints kepada child: nilai minimum dan maksimum lebar serta tinggi.
2. Child menentukan ukurannya sendiri di dalam constraints itu, lalu melapor ke parent.
3. Parent menentukan posisi child, child tidak punya kata putus soal posisi.

Aturan ini menjelaskan hampir semua kejanggalan layout yang Anda temui. Contohnya: mengapa `Column` memberi error saat berisi `ListView`? `Column` memberikan constraints tinggi tak terbatas (semua child boleh sebesar apa pun), `ListView` menuntut tinggi terbatas untuk tahu area scrollnya, dan negosiasi gagal. Solusinya selalu berupa mengubah constraints: bungkus dengan `Expanded` agar child dipaksa mengisi ruang yang tersedia.

Widget layout yang dipakai sepanjang buku hanya segelintir:

- `Column` dan `Row` menyusun child vertikal dan horizontal. Sumbu utamanya diatur `mainAxisAlignment`, sumbu silangnya `crossAxisAlignment`.
- `Expanded` dan `Flexible` memberi child bagian dari sisa ruang pada sumbu utama. `Expanded` memaksa penuh, `Flexible` boleh lebih kecil.
- `SizedBox` memberi jarak atau ukuran pasti; `Container` untuk dekorasi (warna, border, bayangan, bentuk).
- `ListView` menampung banyak child dengan scroll; `SingleChildScrollView` cukup untuk konten pendek yang mungkin meluas.

Versi 2 Tracker memakai semuanya sekaligus, yang berubah hanya bagian `subtitle` dan `leading` tiap tile:

```dart
ListTile(
  leading: Checkbox(value: task.done, onChanged: null),
  title: Text(task.title),
  subtitle: Row(
    children: [
      PriorityChip(label: task.priority.label),
      if (task.dueDate != null) ...[
        const SizedBox(width: 8),
        Text('Tenggat ${task.dueDate!.day}/${task.dueDate!.month}'),
      ],
    ],
  ),
)
```

Perhatikan strukturnya: `Row` pada `subtitle` berisi `PriorityChip`, lalu teks tenggat bila ada. `Checkbox` sementara dibiarkan mati (`onChanged: null`), versi 3 menghidupkannya. Pemakaian `...[` adalah collection-if dari bab 2 yang bekerja juga pada daftar `children` widget.

Apa yang terjadi bila teks tenggatnya panjang dan layarnya sempit? `Row` memberi constraints lebar tersisa kepada kedua childnya, keduanya menolak menyusut, dan Flutter menampilkan error `RenderFlex overflowed by N pixels on the right` lengkap dengan strip kuning-hitam. Perbaikannya sesuai aturan constraints: child yang boleh menyusut dibungkus `Expanded` atau `Flexible`, elemen yang boleh pindah baris memakai `Wrap`, dan deretan yang memang panjang dibungkus scroll. Untuk teks sendiri, `Expanded` plus `Text` dengan `overflow: TextOverflow.ellipsis` memotong rapi dengan tanda elipsis.

Saat daftar tugas bertambah banyak, `ListView` dengan `children` mulai boros: seluruh tile dibangun sekaligus meski hanya beberapa terlihat. `ListView.builder` membangun tile hanya saat masuk area layar:

```dart
ListView.builder(
  padding: const EdgeInsets.all(12),
  itemCount: _tasks.length,
  itemBuilder: (context, index) {
    final task = _tasks[index];
    return TaskTile(task: task); // versi 3, di bawah
  },
)
```

Aturan praktisnya: `SingleChildScrollView` untuk formulir pendek, `ListView` untuk puluhan item, `ListView.builder` untuk daftar yang tumbuh dari data.

## State Lokal: dari StatelessWidget ke StatefulWidget

Versi 1 dan 2 memetakan data tetap ke tampilan, `StatelessWidget` memang tepat untuk itu. Aplikasi sungguhan berbeda: pengguna menandai tugas selesai, menambah tugas, dan daftarnya berubah. Data yang bisa berubah itulah state, dan widget yang memilikinya menjadi `StatefulWidget`.

Mekanismenya penting dipahami sebelum dipakai. Saat framework menemukan `StatefulWidget` di tree, ia membuat satu objek `State` yang terpisah dari widgetnya. Widget tetap immutable dan dibuang tiap rebuild, tetapi objek `State` yang sama bertahan; field-nya bisa berubah dan nilainya awet lintas rebuild. `setState` tidak langsung menggambar apa pun, ia hanya menandai bahwa deskripsi sudah basi, sehingga `build` dipanggil ulang dengan data terbaru.

Versi 3 mengubah `TaskListScreen` menjadi stateful dan mengekstrak tile menjadi widget tersendiri:

```dart
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _tasks = <Task>[
    Task(id: 't-1', title: 'Baca bab 3', priority: Priority.high),
    Task(id: 't-2', title: 'Coba contoh layout'),
    Task(id: 't-3', title: 'Kirim laporan mingguan', priority: Priority.low),
  ];

  void _toggle(Task task) {
    setState(() {
      final index = _tasks.indexWhere((element) => element.id == task.id);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(done: !task.done);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pending = splitPending(_tasks);
    return Scaffold(
      appBar: AppBar(title: const Text('Task Tracker')),
      bottomNavigationBar: BottomAppBar(
        child: Text('${pending.length} tugas belum selesai'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _tasks.length,
        itemBuilder: (context, index) => TaskTile(
          task: _tasks[index],
          onToggle: () => _toggle(_tasks[index]),
        ),
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.onToggle});

  final Task task;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(value: task.done, onChanged: (_) => onToggle()),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Row(
          children: [
            PriorityChip(label: task.priority.label),
            if (task.dueDate != null) ...[
              const SizedBox(width: 8),
              Text('Tenggat ${task.dueDate!.day}/${task.dueDate!.month}'),
            ],
          ],
        ),
      ),
    );
  }
}
```

Perhatikan pembagian tanggung jawabnya: `TaskTile` tetap `StatelessWidget` tanpa tahu apa pun tentang daftar; ia hanya menerima `task` dan callback `onToggle`. State daftar dimiliki `_TaskListScreenState`. Saat checkbox di-tap, tile hanya memanggil callback; layar pemilik state yang mengubah `_tasks` lewat `setState`, dan `build` berjalan ulang menghasilkan deskripsi baru. Pola "widget presentasi menerima data plus callback, layar pemilik state mengeksekusinya" dipakai di seluruh buku, dan di bab 7 berkembang menjadi pemisahan lengkap antara UI dan logika.

Pembaruan daftar memakai `copyWith` dari bab 2, bukan mutasi field, `Task` memang immutable. Mendesain state sebagai koleksi objek immutable membuat setiap rebuild murah dan aman: tidak ada kode lain yang bisa mengubah objek lama secara diam-diam.

## Siklus Hidup State dan Pembersihan Sumber Daya

Objek `State` punya siklus hidup yang jauh lebih panjang dari widgetnya: dibuat sekali, di-build berkali-kali, dan akhirnya dibuang. Titik pentingnya:

1. `initState` dipanggil sekali sebelum build pertama, tempat alokasi: controller, langganan, pemuatan data awal.
2. `build` dipanggil setiap kali deskripsi perlu diperbarui.
3. `didUpdateWidget` dipanggil saat parent mengirim konfigurasi baru (widget baru dengan tipe sama).
4. `dispose` dipanggil sekali sebelum objek dibuang dari tree, satu-satunya kesempatan melepas sumber daya.

Aturan praktisnya sederhana: apa pun yang dialokasikan di `initState` atau field `State` yang memegang sumber daya, dilepas di `dispose`. Versi 4 Tracker memperlihatkan keduanya sekaligus, karena layarnya kini memuat data dari `TaskRepository` (salin juga `TaskRepository` dan `MemoryTaskRepository` dari bab 2) dan menambah tugas lewat dialog:

```dart
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, required this.repository});

  final TaskRepository repository;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _titleController = TextEditingController();
  var _tasks = <Task>[];

  @override
  void initState() {
    super.initState();
    _seedAndLoad();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _seedAndLoad() async {
    // Data contoh untuk demo; bab 8 menggantinya dengan penyimpanan lokal.
    // Await berantai: muat hanya setelah semua data contoh tersimpan.
    for (final task in [
      Task(id: 't-1', title: 'Baca bab 3', priority: Priority.high),
      Task(id: 't-2', title: 'Coba contoh layout'),
      Task(
        id: 't-3',
        title: 'Kirim laporan mingguan',
        priority: Priority.low,
      ),
    ]) {
      await widget.repository.save(task);
    }
    await _load();
  }

  Future<void> _load() async {
    final tasks = await widget.repository.all();
    if (!mounted) return;
    setState(() => _tasks = tasks);
  }

  Future<void> _openAddDialog() async {
    _titleController.clear();
    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tugas baru'),
        content: TextField(
          controller: _titleController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Judul tugas'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, _titleController.text),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (title == null || title.trim().isEmpty) return;
    if (!mounted) return;

    // Id dari timestamp hanya cukup untuk demo;
    // produksi memakai UUID (bab 9) atau autoincrement SQLite (bab 10).
    final task = Task(
      id: 't-${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim(),
    );
    await widget.repository.save(task);
    await _load();
  }

  Future<void> _toggle(Task task) async {
    await widget.repository.save(task.copyWith(done: !task.done));
    await _load();
  }

  // build: seperti versi 3, plus FloatingActionButton yang memanggil
  // _openAddDialog.
}
```

Ada lima pola penting di sini.

Pertama, `mounted`. Setiap `await` adalah celah waktu: pengguna bisa menutup layar selagi operasi berjalan, dan `State` yang sudah dibuang tidak boleh lagi menjalankan `setState`. Pemeriksaan `if (!mounted) return;` setelah setiap async gap adalah disiplin wajib; melewatkannya memunculkan error `setState() called after dispose()` tepat saat pengguna paling tidak menyangka. Versi `BuildContext` yang ditangkap dalam closure di `StatelessWidget` diperiksa dengan `context.mounted`, aturannya sama, objeknya berbeda:

```dart
Future<void> openDetail(BuildContext context, Task task) async {
  final toggled = await Navigator.of(context).push<bool>(
    MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
  );
  if (toggled == true && context.mounted) {
    // aman memakai context lagi di sini
  }
}
```

Kedua, `TextEditingController`. Controller yang dipakai `TextField` di dialog tetap dimiliki `State` dan dibuat sekali; `dispose()` melepas listener internalnya. Controller yang tidak dibuang meninggalkan listener terdaftar, kebocoran kecil yang menumpuk pada aplikasi besar. Pola yang sama berlaku untuk `AnimationController`, `ScrollController`, dan `FocusNode`.

Ketiga, `widget.repository`. Field widget dibaca lewat `widget`, bukan disalin ke `State`, menyalinnya membuat `didUpdateWidget` jadi rumit karena parent bisa mengganti widget dengan repository berbeda. Bila itu mungkin terjadi, tangani di `didUpdateWidget`:

```dart
@override
void didUpdateWidget(TaskListScreen oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.repository != widget.repository) {
    _load(); // repository berganti, muat ulang datanya
  }
}
```

Keempat, urutan async di `initState`. `initState` sendiri tidak bisa `await`, jadi pekerjaan async dipindah ke method terpisah. Perhatikan bahwa penyemaian data dan pemuatan dirantai dengan `await`: tanpa perantaian, `_load` bisa berjalan saat sebagian data contoh belum tersimpan, dan snapshot pertama yang digambar tidak lengkap. Dua pemanggilan async yang berurutan secara logika harus diikat, bukan dilepas bersamaan.

Kelima, `_toggle` menulis lewat repository (`save` task baru hasil `copyWith`) lalu memuat ulang. Repository menjadi satu-satunya pemilik data; layar hanya menyalin snapshot terbarinya ke state dan menggambarnya. Pola ini membuat data bisa diambil dari sumber lain nanti, SQLite di bab 10, API di bab 9, tanpa mengubah layar.

Langganan `StreamSubscription` dari bab 2 mengikuti disiplin yang sama persis. Layar yang mendengarkan `TaskStore.changes` membatalkan langgangannya di `dispose`:

```dart
StreamSubscription<List<Task>>? _subscription;

@override
void initState() {
  super.initState();
  _subscription = widget.store.changes.listen((tasks) {
    setState(() => _tasks = tasks);
  });
}

@override
void dispose() {
  _subscription?.cancel();
  super.dispose();
}
```

Bab 7 mengganti mekanisme ini dengan `ChangeNotifier` dan `Provider`, tetapi pola alokasi-di-awal dan pembersihan-di-`dispose` tidak pernah berubah.

## Navigasi Antar Layar

Sejauh ini Tracker berdiri di satu layar. Aplikasi mobile umumnya berisi banyak. Flutter memodelkan halaman sebagai tumpukan (stack) yang dikelola `Navigator`: `push` menambahkan layar baru di atas, `pop` melepasnya dan kembali ke bawahnya. Animasi transisi ikut otomatis.

Versi 5 Tracker menghubungkan tile ke layar detail. Yang berubah: `TaskTile` menerima callback `onTap`, dan layar daftar membuka detail lalu menunggu hasilnya:

```dart
Future<void> _openDetail(Task task) async {
  final toggled = await Navigator.of(context).push<bool>(
    MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
  );
  if (toggled == true && mounted) {
    _toggle(task);
  }
}
```

`push` mengembalikan `Future<T?>`: nilai yang dikirim `pop` dari layar atas, atau `null` bila pengguna kembali lewat tombol back sistem. `MaterialPageRoute` membungkus layar dengan transisi standar platform. Layar detailnya sendiri stateless, semua data sudah ada di konstruktornya:

```dart
class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tugas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(task.title, style: theme.textTheme.headlineSmall),
              ),
              const SizedBox(width: 8),
              PriorityChip(label: task.priority.label),
            ],
          ),
          if (task.dueDate != null) ...[
            const SizedBox(height: 8),
            Text(
              'Tenggat '
              '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
            ),
          ],
          if (task.note != null) ...[
            const SizedBox(height: 16),
            Text(task.note!),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () =>
                Navigator.of(context).pop(task.done ? false : true),
            icon: Icon(task.done ? Icons.undo : Icons.check),
            label: Text(
              task.done ? 'Tandai belum selesai' : 'Tandai selesai',
            ),
          ),
        ],
      ),
    );
  }
}
```

Alurnya utuh: tile di-tap, `push` menampilkan detail, pengguna menekan tombol, `pop` mengirim `true`/`false`, dan layar daftar, setelah `await` dan pemeriksaan `mounted`, menerapkan perubahannya lewat `_toggle`. Data mengalir ke bawah lewat konstruktor, kejadian mengalir ke atas lewat callback dan hasil `pop`.

Dua kekeliruan yang sering menghentikan navigasi pemula:

- **Context di atas Navigator.** Error `Navigator operation requested with a context that does not include a Navigator` muncul bila `context` yang dipakai berasal dari widget yang sama dengan yang membangun `MaterialApp`, navigator justru berada di bawah `MaterialApp`. Solusinya sudah diterapkan sejak versi 1: `home` diisi widget terpisah (`TaskListScreen`), sehingga semua `context` di dalamnya berada di bawah navigator. Alternatif cepat untuk kasus terjepit: bungkus dengan `Builder` agar mendapat context yang lebih rendah.
- **Context dialog yang tertukar.** Dialog dibuka dengan `showDialog(context: context, builder: (dialogContext) => ...)`. Di dalam builder, tutup dialog dengan `Navigator.pop(dialogContext)`, bukan `context` layar, karena tumpukan yang perlu dilepas adalah tumpukan overlay dialog. Versi 4 memakai pola ini.

Untuk aplikasi yang tumbuh, `MaterialApp` juga menerima peta `routes` agar layar dipanggil dengan nama (`Navigator.pushNamed(context, '/detail')`) alih-alih membangun `MaterialPageRoute` manual. Pola deklaratif penuh dengan paket seperti `go_router` melangkah lebih jauh lagi; keduanya membangun di atas mental model stack yang sama, dan cukup disinggung sebagai arah pengembangan setelah dasarnya kokoh.

## Ringkasan

- Flutter deklaratif: `build` mengembalikan deskripsi tampilan dari data; tidak ada pembaruan manual.
- Widget adalah deskripsi immutable yang murah; objek `State` pada `StatefulWidget` yang bertahan dan memegang data berubah.
- Layout adalah negosiasi constraints: parent membatasi, child menentukan ukuran, parent memposisikan. `Expanded`/`Flexible` mengubah constraints; overflow adalah negosiasi yang gagal.
- `Column`, `Row`, `SizedBox`, `Container`, dan `ListView` menutup hampir semua kebutuhan layout; `ListView.builder` untuk daftar dari data.
- `setState` menandai deskripsi basi dan memicu rebuild; state diperbarui dengan objek immutable lewat `copyWith`.
- Alokasi di `initState`, pembersihan di `dispose`: controller, langganan stream, semua sumber daya.
- Setiap async gap diikuti pemeriksaan `mounted` (atau `context.mounted`) sebelum `setState` atau pemakaian context.
- `Navigator` adalah tumpukan layar: `push` membuka dan mengembalikan `Future<T?>`, `pop` menutup sambil mengirim hasil; data turun lewat konstruktor, kejadian naik lewat callback.

Versi akhir Tracker di bab ini masih menyimpan data di memori: restart aplikasi menghapus semua tugas. Bab 4 membedah struktur proyek dan build system yang menopang aplikasi ini, bab 5-6 memperkaya tampilannya dengan Material 3 dan custom widget, dan bab 7 memindahkan state daftar ke tempat yang lebih terstruktur. Aplikasinya tetap yang sama.

## Referensi Lanjutan

- Pengantar widget dan komposisi: https://docs.flutter.dev/ui/widgets-intro
- Aturan constraints dan debugging layout: https://docs.flutter.dev/ui/layout/constraints
- Katalog widget beserta contohnya: https://docs.flutter.dev/ui/widgets
- Siklus hidup `State`: https://api.flutter.dev/flutter/widgets/State-class.html
- Navigasi dan `Navigator`: https://docs.flutter.dev/ui/navigation
