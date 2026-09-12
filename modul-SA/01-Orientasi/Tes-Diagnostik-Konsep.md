# Tes Diagnostik Konsep, PPB Remidi 7 Pertemuan

> **Status:** v2.0, 2026-08-10 (format pilihan ganda penuh)
> **Aplikasi jangkar:Remedial Task Tracker**
> **Untuk:** mahasiswa peserta remidi, dikerjakan di awal **P01** sebelum sesi praktik.
> **Sumber kompetensi:** `../00-Planning/Peta-Capaian-dan-Assessment.md`, `../RPS PPB - 20251.md`
> **Pasangan:** `Tes-Diagnostik-Praktik.md` (tes praktik), `../05-Assessment/Kunci-Diagnostik.md` (kunci, khusus dosen).
> **Versi Moodle:** `../05-Assessment/Moodle-Question-Bank.xml`, kategori `PPB-Remidi/Diagnostik/Konsep`.

## 0. Tujuan tes

Tes ini **bukan penentu kelulusan** dan bukan hafalan. Tujuannya memetakan titik lemahmu di lima area inti Flutter sebelum sesi dimulai, supaya dosen dapat menempatkanmu di jalur perbaikan yang tepat (Merah/Kuning/Hijau). Kerjakan sendiri, jujur, tanpa AI.

- **Waktu:** 30 menit.
- **Format:** 25 soal pilihan ganda, satu jawaban benar per soal. Lima area × 5 soal.
- **Skor:** 1 poin per soal, dinormalkan ke 0-100 per area (5 soal = 100% area).
- **Boleh:** membaca dokumentasi Flutter/Dart resmi. **Tidak boleh:** menyalin dari teman, menggunakan AI (ChatGPT/Copilot/dll.), atau mencontek. Hasil diagnosis kau pakai sendiri sepanjang remidi, menipu di sini merugikan dirimu.

Jawab dengan menuliskan huruf pilihan (A/B/C/D) di lembar jawaban atau langsung di Moodle.

---

## 1. Dart, model, constructor, enum, null safety, collection

### Soal 1.1
Manakah deklarasi `Task` yang paling konsisten dengan null safety Dart modern?

- A. `class Task { String title; Task(this.title); }`
- B. `class Task { String? title; Task(this.title); }`
- C. `class Task { final String title; const Task(this.title); }`
- D. `class Task { String title = null; Task(this.title); }`

### Soal 1.2
Apa keluaran program berikut?

```dart
enum Priority { low, medium, high }

void main() {
  final xs = [Priority.high, Priority.low, Priority.medium];
  xs.sort((a, b) => a.index.compareTo(b.index));
  print(xs.map((p) => p.name).toList());
}
```

- A. `[high, low, medium]`
- B. `[low, medium, high]`
- C. `[Priority.low, Priority.medium, Priority.high]`
- D. `[0, 1, 2]`

### Soal 1.3
Potongan berikut gagal dikompilasi. Manakah perbaikan yang menyelesaikan **kedua** masalah sekaligus?

```dart
class Task {
  String title;
  String? description;
  Task(title); // baris A
}

void main() {
  Task t = Task();
  print(t.title.length);
}
```

- A. Ubah `String title` menjadi `String? title` saja.
- B. Ubah baris A menjadi `Task(this.title);` dan pemanggilan menjadi `Task('Belajar')`.
- C. Ubah `Task()` menjadi `Task(null)` saja.
- D. Tambahkan `late` pada `description` saja.

### Soal 1.4
Apa keluaran program berikut?

```dart
void main() {
  final tasks = [
    {'title': 'A', 'done': true},
    {'title': 'B', 'done': false},
    {'title': 'C', 'done': true},
  ];
  final open = tasks.where((t) => t['done'] == false).length;
  final titles = tasks.map((t) => t['title']).join(', ');
  print(open);
  print(titles);
}
```

- A. `1` lalu `A, B, C`
- B. `2` lalu `A, B, C`
- C. `1` lalu `B`
- D. `3` lalu `A B C`

### Soal 1.5
Manakah isian `copyWith` yang menjaga `Task` tetap **immutable** dan berperilaku benar?

```dart
class Task {
  final String title;
  final bool done;
  const Task(this.title, {this.done = false});

  Task copyWith({String? title, bool? done}) => /* ... */;
}
```

- A. `Task(title!, done: done!)`
- B. `Task(title ?? this.title, done: done ?? this.done)`
- C. `Task(this.title, done: this.done)`
- D. `this..title = title ?? this.title`

---

## 2. Widget dan state (Flutter)

### Soal 2.1
Kapan sebuah widget harus menjadi `StatefulWidget`, bukan `StatelessWidget`?

- A. Selalu, supaya aman.
- B. Hanya bila tampilan bergantung pada data dari internet.
- C. Bila ada state yang bisa berubah dan harus memicu rebuild UI pada widget itu.
- D. Bila widget punya banyak anak (children).

### Soal 2.2
Pada kode berikut, apa yang **terlihat di layar** setelah tombol ditekan dua kali?

```dart
class _CounterState extends State<Counter> {
  int count = 0;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text('$count'),
      ElevatedButton(onPressed: () => count += 1, child: const Text('+1')),
    ],
  );
}
```

- A. Layar menampilkan `2`.
- B. Layar tetap menampilkan `0` meskipun nilai `count` di memori sudah 2.
- C. Aplikasi crash karena `count` tidak `final`.
- D. Layar menampilkan `1` karena hanya rebuild sekali.

### Soal 2.3
Apa perubahan **terkecil** agar UI pada soal 2.2 ikut memperbarui saat tombol ditekan?

- A. Ubah `Counter` menjadi `StatelessWidget`.
- B. Bungkus kenaikan dengan `setState(() => count += 1);`
- C. Panggil `build(context)` secara manual di `onPressed`.
- D. Tambahkan `const` pada `Column`.

### Soal 2.4
Manakah pernyataan yang benar tentang `ChangeNotifier` + `provider`?

- A. `notifyListeners()` memaksa seluruh aplikasi rebuild.
- B. `Consumer`/`listen: true` akan rebuild widget yang mendengarkan saat `notifyListeners()` dipanggil.
- C. Provider menyimpan data di SharedPreferences otomatis.
- D. `ChangeNotifier` hanya boleh dipakai bersama SQLite.

### Soal 2.5
Layar berisi *chips filter* di atas dan daftar tugas panjang di bawahnya. Mengapa `Column(children: [chips, ListView(...)])` tanpa `Expanded` menyebabkan overflow kuning, dan apa perbaikannya?

- A. Karena `ListView` selalu dilarang di dalam `Column`; ganti dengan `Row`.
- B. Karena `ListView` meminta tinggi tak terbatas di dalam `Column` bertinggi terbatas; bungkus dengan `Expanded`.
- C. Karena chips terlalu lebar; bungkus chips dengan `Expanded`.
- D. Karena `Column` butuh `const`; tambahkan `const` pada `Column`.

---

## 3. Async, error, dan Future

### Soal 3.1
Apa perbedaan inti `Future` dan `Stream`?

- A. Tidak ada perbedaan.
- B. `Future` menghasilkan satu nilai/kesalahan di masa depan; `Stream` menghasilkan nol atau banyak nilai seiring waktu.
- C. `Future` selalu berhasil; `Stream` bisa gagal.
- D. `Stream` hanya untuk input pengguna; `Future` hanya untuk jaringan.

### Soal 3.2
Apa urutan cetakan program berikut?

```dart
void main() async {
  print('A');
  await Future.delayed(const Duration(milliseconds: 10));
  print('B');
  fetchAndPrint();
  print('C');
}

Future<void> fetchAndPrint() async {
  await Future.delayed(const Duration(milliseconds: 5));
  print('D');
}
```

- A. A, B, C, D
- B. A, B, D, C
- C. A, D, B, C
- D. A, C, B, D

### Soal 3.3
`loadTasks()` melempar exception saat status bukan 200. Manakah penanganan yang **paling tepat** agar aplikasi tidak crash **dan** UI tetap bisa membedakan sukses vs gagal?

```dart
Future<List<Task>> loadTasks() async {
  final res = await http.get(Uri.parse(url));
  if (res.statusCode != 200) throw Exception('bad status');
  return (jsonDecode(res.body) as List).map(Task.fromJson).toList();
}
```

- A. Bungkus `try/catch` lalu `return []` pada catch tanpa menandai error.
- B. Bungkus `try/catch` lalu kembalikan tipe yang membedakan sukses/gagal (mis. `Result`/record), sehingga pemanggil menampilkan state error.
- C. Hapus pengecekan `statusCode` agar tidak pernah melempar.
- D. Bungkus `try/catch` kosong agar error diabaikan diam-diam.

### Soal 3.4
`StatefulWidget` memanggil `http.get` di `initState`, lalu pengguna menutup halaman sebelum respons datang. Apa risikonya dan bagaimana mencegahnya?

- A. Tidak ada risiko; Flutter membatalkan request otomatis.
- B. `setState` dipanggil setelah widget dilepas ("setState after dispose"); cegah dengan cek `if (!mounted) return;` atau batalkan request di `dispose()`.
- C. Aplikasi kehabisan memori; cegah dengan menambah `const`.
- D. Request diulang tak terbatas; cegah dengan `StatelessWidget`.

### Soal 3.5
Diberikan `jsonDecode(s)` atas JSON `{"id":"1","title":"A","completed":false}`. Manakah cara mengakses `title` yang aman terhadap tipe/null?

- A. `final t = jsonDecode(s).title;`
- B. `final m = jsonDecode(s) as Map<String, dynamic>; final t = m['title'] as String?;`
- C. `final t = jsonDecode(s)['title'] as int;`
- D. `final t = jsonDecode(s)[0];`

---

## 4. Data, API, dan state jaringan

### Soal 4.1
Mengapa SQLite (`sqflite`) dipakai sebagai **local source of truth** pada arsitektur offline-first?

- A. Supaya tidak perlu menulis repository.
- B. Agar aplikasi tetap berfungsi tanpa jaringan dan data bertahan setelah restart.
- C. Karena REST selalu lambat.
- D. Karena SQLite menggantikan Provider.

### Soal 4.2
Layar daftar tugas memuat data remote. Manakah urutan/kelengkapan state UI yang **wajib** ditangani?

- A. Hanya success, karena error jarang terjadi.
- B. Loading terlebih dahulu, lalu salah satu dari success, empty, atau error (4xx/5xx/network) dengan aksi retry.
- C. Loading dan success saja; empty cukup ditampilkan sebagai list kosong tanpa pesan.
- D. Error saja, sisanya ditangani framework.

### Soal 4.3
Pasangan method HTTP yang tepat untuk: (1) ambil semua tugas, (2) buat tugas baru, (3) ubah status jadi done, (4) hapus tugas?

- A. GET, POST, PATCH, DELETE
- B. POST, GET, PUT, DELETE
- C. GET, PUT, POST, DELETE
- D. GET, POST, DELETE, PATCH

### Soal 4.4
Bagaimana cara menetapkan base URL API tanpa menulis kredensial di dalam kode sumber, dan mengapa hardcode kredensial salah?

- A. Tulis langsung di `main.dart` karena ini hanya tugas kelas.
- B. Lewat `--dart-define`/berkas env yang tidak di-commit, karena kredensial di kode ikut masuk version control dan bocor.
- C. Simpan di komentar kode agar tidak terbaca compiler.
- D. Simpan di `README.md` agar mudah dibagikan.

### Soal 4.5
Apa keuntungan memisahkan `repository` dari UI, dan apa yang berubah di UI bila sumber data berpindah dari remote ke mock lokal?

- A. UI tidak tahu asal data; berpindah sumber cukup mengganti implementasi repository, UI tetap sama.
- B. UI harus ditulis ulang setiap sumber data berganti.
- C. Repository hanya mempercepat jaringan, UI tetap memanggil `http` langsung.
- D. Tidak ada keuntungan; repository menambah kerumitan tanpa manfaat.

---

## 5. Testing dan kualitas

### Soal 5.1
Apa pembagian yang **paling tepat** antara unit test dan widget test?

- A. Unit test: tampilan warna; Widget test: algoritma filter.
- B. Unit test: logika murni (model/mapper/filter); Widget test: interaksi dan render widget.
- C. Keduanya sama; pilih satu saja.
- D. Unit test hanya untuk backend; widget test hanya untuk animasi.

### Soal 5.2
Manakah unit test yang benar untuk `filterByStatus`, beserta kasus *edge* yang layak ditambahkan?

```dart
List<Task> filterByStatus(List<Task> tasks, TaskStatus status) =>
    tasks.where((t) => t.status == status).toList();
```

- A. Uji bahwa hasilnya selalu tidak kosong, edge: list dengan 100 item.
- B. Siapkan list campuran status, `expect` semua hasil berstatus sama dengan argumen; edge: list kosong menghasilkan list kosong.
- C. Uji warna chip yang tampil, edge: rotasi layar.
- D. Uji bahwa fungsi melempar exception saat list kosong.

### Soal 5.3
Test berikut gagal. Manakah pasangan penyebab yang paling mungkin?

```dart
test('search finds case-insensitive substring', () {
  final tasks = [Task(title: 'Read History')];
  expect(searchTasks(tasks, 'hist'), [hasLength(1)]); // gagal
});
```

- A. Nama test terlalu panjang, dan `Task` butuh `const`.
- B. `searchTasks` case-sensitive atau memakai `startsWith` alih-alih `contains`; **dan** matcher `[hasLength(1)]` salah bentuk untuk list hasil.
- C. `flutter test` perlu emulator aktif, dan `Task` harus `StatefulWidget`.
- D. Test gagal karena `expect` hanya boleh dipakai sekali per file.

### Soal 5.4
Apa perbedaan tujuan `flutter analyze` dan `flutter test`?

- A. `analyze` menjalankan perilaku runtime; `test` memeriksa lint saja.
- B. `analyze` adalah analisis statis (lint/typing); `test` memverifikasi perilaku runtime. Lolos `analyze` tidak menjamin perilaku benar.
- C. Keduanya identik, hanya beda nama perintah.
- D. `analyze` menggantikan `test` bila tidak ada test.

### Soal 5.5
Daftar tugas tampil kosong padahal data seharusnya ada. Manakah urutan investigasi yang paling efektif mempersempit penyebab?

- A. Rebuild ulang project, hapus cache, install ulang Flutter.
- B. Cek sumber data (apakah list terisi) → cek filter/search aktif → cek render/empty-state.
- C. Cek warna widget → cek font → cek layout.
- D. Ganti `ListView` menjadi `GridView` lalu lihat hasilnya.

---

## 6. Penyerahan

- Tulis nama, NIM/NPM, tanggal di kepala lembar jawaban (atau kerjakan langsung di Moodle).
- Satu jawaban per soal. Tidak ada pengurangan untuk jawaban salah, jadi jangan kosongkan.
- Serahkan sebelum praktik dimulai. Hasil dikembalikan sebagai peta Merah/Kuning/Hijau per area beserta rekomendasi jalur perbaikan dari dosen.

> Catatan: tes ini menguji **konsep dan kemampuan membaca kode**. Bila banyak yang tidak terjawab, itu justru berita baik, artinya remidi ini tepat sasaran untukmu. Yang penting kau mulai dari posisi sebenarnya.
