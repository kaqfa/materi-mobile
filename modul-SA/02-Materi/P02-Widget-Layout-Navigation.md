# P02, Widget, Layout, dan Navigasi

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker
**Durasi sesi:** 150 menit (3 × 50) | **Estimasi belajar mandiri:** 4-5 jam
**Sub-CPMK:** 53.1 (widget, state) + 92.1 (UI responsive) | **Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`

> **Baca juga:** `../01-Orientasi/Panduan-Mahasiswa.md`, `../02-Materi/P01-Diagnosis-Dart-Debugging.md`. Pasangan kelas: `../03-Modul-Kelas/Modul-P02-Widget-Layout-Navigation.md`.

---

## Tujuan Pembelajaran

Setelah materi ini dikuasai, kamu mampu:

1. **Membaca dan menjelaskan** widget tree: `StatelessWidget` vs `StatefulWidget`, komposisi `Card`/`InkWell`/`Padding`/`Row`/`Column`/`Expanded`, serta `Theme.of(context)` untuk teks dan warna.
2. **Membangun dan menyambungkan** navigasi dua arah: tap `TaskCard` -> `TaskDetailScreen`, FAB -> `AddTaskScreen`, lalu mengembalikan hasil ke daftar memakai `Navigator.push` + `setState`.
3. **Menyusun layout responsive dasar** dengan `LayoutBuilder` + `ListView`/`GridView` agar tidak overflow pada portrait maupun landscape.

**Outcome sesi (bukti observable):**
- Starter `06-Starter-Code/p02-ui-navigation/` berjalan dan menampilkan 20 task dummy memakai `TaskCard` reusable.
- Tap card membuka `TaskDetailScreen`; FAB membuka `AddTaskScreen`; task hasil `pop` muncul di daftar.
- Portrait menampilkan 1 kolom; landscape (lebar ≥ 600) menampilkan grid 2 kolom; tidak ada overflow saat rotasi.

---

## Prasyarat

- Menyelesaikan `../02-Materi/P01-Diagnosis-Dart-Debugging.md`: paham model `Task`, `enum`, getter `status`, koleksi Dart.
- `../01-Orientasi/Checklist-Environment.md` lulus; `flutter doctor` bersih.
- Starter P02 sudah di-copy ke workspace kosong (lihat "Setup").

> **Kebijakan AI P02:** AI boleh untuk **penjelasan widget dan diagnosis error** (mis. "kenapa `Row` saya overflow?"). AI **tidak boleh** menulis implementasi `Navigator.push` atau layout responsive tanpa analisis sendiri. Bila memakai AI, isi `../01-Orientasi/Template-AI-Interaction-Log.md`.

---

## Setup

```bash
# 1. Copy folder starter ke workspace kosong, lalu di dalamnya:
flutter create --platforms=android,web. # hasilkan platform runner (android/, web/...)
flutter pub get
flutter analyze
flutter test # task_card_test.dart + smoke harus hijau (starter bersih)

flutter run
```

> Folder `android/`, `web/`, dll. sengaja **tidak** disertakan; dibuat oleh `flutter create`. Jalankan dari dalam folder starter; bila `flutter create` menimpa `pubspec.yaml`/`analysis_options.yaml`, pulihkan dari Git.

---

## Struktur starter P02

```text
06-Starter-Code/p02-ui-navigation/
├── pubspec.yaml
├── analysis_options.yaml
├── lib/
│ ├── main.dart
│ ├── app.dart
│ ├── core/{constants,theme}/
│ │ ├── app_colors.dart # seed + status/priority colors
│ │ ├── app_strings.dart # homeTitle, detailTitle, addTaskTitle...
│ │ └── theme/app_theme.dart # Material 3, ColorScheme.fromSeed
│ └── features/tasks/
│ ├── domain/task.dart # model + enum + getDummyTasks() (sama P01)
│ └── presentation/
│ ├── widgets/task_card.dart # reusable (siap pakai)
│ └── screens/
│ ├── task_list_screen.dart # list + responsive + TODO navigasi
│ ├── task_detail_screen.dart # stub detail (lengkapi konten)
│ └── add_task_screen.dart # stub add (ganti jadi form)
└── test/
 ├── widget_test.dart # smoke (hijau)
 └── task_card_test.dart # widget test TaskCard (hijau)
```

**Aturan batas (penting):**
- Boleh mengubah `task_list_screen.dart`, `task_detail_screen.dart`, `add_task_screen.dart`.
- Boleh menambah field/konstanta ke `AppStrings` bila perlu label baru.
- Tidak boleh mengubah `Task` class dan enum, `AppColors`, `AppTheme`, atau menambah package.
- `task_card.dart` adalah komponen siap pakai untuk checkpoint wajib. Ubah hanya bila memilih **Challenge Level 2**, lalu pertahankan API lama dan semua test tetap hijau.

**Role starter:** bersih (tidak bugged). Yang sengaja ditinggalkan sebagai TODO: navigasi `_openDetail`, `_addTask`, dan breakpoint responsive, bukan bug, melainkan tugas implementasi.

---

## Mengapa Widget/Navigation Sebelum State Management

P02 membongkar bagaimana Flutter menyusun layar sebelum kamu mengelola state lintas layar di P03 (Provider). Tiga prinsip yang dilatih di sini dipakai terus:

1. **Komposisi, bukan inheritance.** Layar = tumpukan widget. `TaskCard` adalah widget yang dipakai ulang di list dan grid, sekali tulis, dua tempat.
2. **State lokal dulu, state global nanti.** `_TaskListScreenState` pegang `_tasks`. Di P03, `_tasks` pindah ke `TaskProvider`. Struktur widget-nya nyaris tak berubah; yang berubah **sumber kebenaran**.
3. **Context punya siklus.** `Navigator.of(context)`, `Theme.of(context)`, `ScaffoldMessenger.of(context)` semua butuh `BuildContext` yang masih hidup. Penyalahgunaan context lintas `await` adalah sumber bug paling umum di P03, ditanamkan fondasinya di sini.

Mindset ini berlaku lintas sesi dan menjadi dasar rubrik "verifikasi & sikap debug" (`../05-Assessment/Lembar-Observasi.md`).

---

## CHECKPOINT 1: Membaca `TaskCard` + Task List

**Goal:** daftar 20 task tampil memakai `TaskCard` reusable; `task_card_test.dart` hijau.
**Time:** ~15 menit

### Apa yang dibangun
- Memahami komposisi `TaskCard` (siap pakai) dan bagaimana `task_list_screen.dart` merendernya via `ListView.separated`.
- Verifikasi `flutter test` dan `flutter run` tampil 20 task.

### 1.1 Baca `lib/features/tasks/presentation/widgets/task_card.dart`

`TaskCard` adalah `StatelessWidget`. Sketsa widget tree-nya:

```text
Card
└── InkWell(onTap) <- menerima klik dari luar via callback
 └── Padding
 └── Row
    ├── Icon(check_circle | radio_button_unchecked)
    └── Expanded <- penting: mencegah overflow horizontal
    └── Column
 ├── Text(title, lineThrough bila completed)
 ├── Text(description, maxLines: 2, ellipsis)
 └── Wrap(spacing, runSpacing)
    ├── _DueChip
    ├── _PriorityChip
    └── _StatusChip
```

**Poin penting kamu jelaskan (tanya dirimu sendiri):**

1. **Stateless, bukan stateful.** `TaskCard` tidak pegang data sendiri; semua datang dari `task` (properti `final`) dan aksi dari `onTap` (callback). Ini disebut **dumb component**, mudah diuji, mudah dipakai ulang.
2. **Callback, bukan aksi langsung.** `onTap` adalah `VoidCallback?`. `TaskCard` tidak tahu apa yang terjadi saat ditekan; layar pemilik yang menentukan. Mau buka detail, edit, atau hapus, urusan layar.
3. **`Expanded` mencegah overflow.** Tanpa `Expanded`, `Text` deskripsi yang panjang akan mendorong lebar `Column` melebihi layar -> `RenderFlex overflowed by N pixels`. Ini error paling sering di pemula.
4. **`Wrap` mengakomodasi banyak chip.** `Wrap` otomatis pindah ke baris baru bila `Row` penuh. Bedakan dengan `Row` (tidak otomatis wrap -> overflow).
5. **`maxLines: 2` + `TextOverflow.ellipsis`.** Deskripsi dipotong rapi dengan `…`, bukan mendorong layout.
6. **`Theme.of(context)`.** `titleMedium`, `bodyMedium` diambil dari tema global (`AppTheme`), bukan hardcode `TextStyle(fontSize:...)`. Ganti tema -> seluruh UI ikut.

### 1.2 Baca `task_list_screen.dart`, sumber data lokal

```dart
class _TaskListScreenState extends State<TaskListScreen> {
 late List<Task> _tasks;

 @override
 void initState() {
 super.initState();
 _tasks = Task.getDummyTasks(); // seed 20 task saat layar pertama dibangun
 }
 //...
}
```

**Poin:**

1. **`StatefulWidget`.** `_tasks` berubah saat nanti ada task baru (CP2). `initState` adalah tempat inisialisasi sekali-jalan; jangan taruh logika yang butuh `context` di sini (lihat troubleshooting).
2. **`late`.** Field diinisialisasi di `initState`, bukan langsung. `late` berjanji "akan diisi sebelum dibaca". Bila kamu baca sebelum `initState` jalan, crash `LateInitializationError`.
3. **`ListView.separated`.** Efisien untuk daftar panjang: hanya merender yang terlihat. `separatorBuilder` menyisipkan `SizedBox(height: 8)` antar item.

### 1.3 Verifikasi

```bash
flutter test test/task_card_test.dart # 2 test harus hijau
flutter analyze # No issues found!
flutter run
```

Amati: AppBar "My Tasks", FAB `+`, daftar 20 task dengan chip due/priority/status, task completed (t04, t05, t10, t15) berjudul strikethrough + ikon centang hijau.

### Checkpoint Validation

- [ ] `flutter test test/task_card_test.dart`, 2 test lulus (title+onTap, strikethrough completed).
- [ ] `flutter analyze` bersih.
- [ ] `flutter run` menampilkan 20 task dengan chip due/priority/status.
- [ ] Kamu bisa menjelaskan **kenapa** `TaskCard` memakai `Expanded` dan `Wrap`.
- [ ] Kamu bisa menjelaskan peran `onTap` sebagai callback (bukan aksi langsung).

**Run & Test:**
```bash
flutter run
# Expected: AppBar "My Tasks"; 20 task; task completed tampil strikethrough; tap card belum berbuat apa-apa (TODO CP2).
```

---

## CHECKPOINT 2: Navigasi List -> Detail / Add

**Goal:** tap card buka `TaskDetailScreen`; FAB buka `AddTaskScreen`; task hasil `pop` muncul di daftar.
**Time:** ~25 menit

**Melanjutkan CP 1:**
- Sudah punya: 20 task tampil memakai `TaskCard`; pemahaman callback.
- 🆕 Akan tambah: navigasi dua layar + aliran data kembali (result).

### 2.1 Konsep: Navigator sebagai stack

Flutter menyimpan layar dalam **stack**. `Navigator.push` menambah layar baru di atas; `Navigator.pop` membuang yang atas. `pop` bisa **membawa hasil** ke layar di bawahnya:

```text
[ListScreen] --push--> [DetailScreen]
[ListScreen] <--pop(result)-- [DetailScreen]
```

Dua pola yang kamu pakai:

```dart
// Pola A: detail, tidak butuh hasil balik
Navigator.of(context).push(
 MaterialPageRoute<void>(
 builder: (_) => TaskDetailScreen(task: task),
 ),
);

// Pola B: add, butuh task baru kembali ke list
final result = await Navigator.of(context).push<Task>(
 MaterialPageRoute<Task>(
 builder: (_) => const AddTaskScreen(),
);
if (result != null) {
 setState(() => _tasks.add(result));
}
```

**Poin:**

1. **`MaterialPageRoute`** memberi transisi geser standar Android/iOS. `builder` adalah fungsi yang membangun layar baru dengan **context baru**.
2. **Tipe generik `<Task>`** pada pola B menentukan tipe nilai yang `pop` kembalikan. Layar add wajib `Navigator.of(context).pop<Task>(task)`.
3. **`await`** menunggu sampai layar atas di-pop. Setelah itu `result` berisi nilai balik (atau `null` bila user batal/back).
4. **`setState`** memberi tahu Flutter "data berubah, rebuild". Tanpa ini, list tidak berubah walau `_tasks` sudah ditambah.

### 2.2 Implementasi `_openDetail` di `task_list_screen.dart`

Ganti isi method `void _openDetail(Task task)`:

```dart
void _openDetail(Task task) {
 Navigator.of(context).push<void>(
 MaterialPageRoute<void>(
 builder: (_) => TaskDetailScreen(task: task),
 ),
 );
}
```

> Hapus blok `ScaffoldMessenger`/`SnackBar(notImplemented)` yang lama, itu hanya placeholder.

### 2.3 Implementasi `_addTask` (alur penuh)

Ganti isi method `void _addTask()`. Karena sekarang ada `await`, ubah signature jadi `Future<void>`:

```dart
Future<void> _addTask() async {
 final result = await Navigator.of(context).push<Task>(
 MaterialPageRoute<Task>(
 builder: (_) => const AddTaskScreen(),
 ),
 );
 if (!mounted) return; // konteks bisa hilang setelah await
 if (result != null) {
 setState(() => _tasks.add(result));
 }
}
```

**Kenapa `if (!mounted) return;`?** Setelah `await`, `context` dan `State` ini **mungkin sudah tidak ada** (user menek back dari list saat form terbuka). Memanggil `setState` pada state yang sudah dispose melempar error. `mounted` adalah penjaga wajib setelah setiap `await` di `State`. Ini fondasi untuk P03 (context misuse).

### 2.4 Sambungkan `AddTaskScreen`

Starter `add_task_screen.dart` sudah `pop(_sampleTask())` saat tombol "Save (sample)" ditekan. Itu cukup untuk menguji alur di CP2, task contoh ("New Task") muncul di list. Di **P03** kamu akan menggantinya dengan form sungguhan (validasi + field).

Untuk P02, cukup pastikan: tekan FAB -> layar Add terbuka -> tekan "Save (sample)" -> kembali ke list -> "New Task" muncul di paling bawah.

### 2.5 Lengkapi `TaskDetailScreen` (opsional, tapi dianjurkan)

Stub sudah menampilkan title, deskripsi, dan baris `_InfoRow` untuk due/priority/status. Tidak ada TODO yang memblokir CP2, biarkan apa adanya bila waktu mepet. Bila ingin rapi, tambahkan:

- `Hero`/`Text` judul lebih besar, atau
- Tombol aksi (mark complete / delete) yang `pop<bool>(true)`, tapi logika toggle/delete datang di **P03** dengan Provider.

> **Disiplin scope:** jangan implementasi toggle/delete persisten di P02. State masih lokal; fokus P02 adalah **navigasi**, bukan mutasi state lintas layar.

### Checkpoint Validation

- [ ] Tap `TaskCard` -> `TaskDetailScreen` terbuka dengan data task yang benar.
- [ ] Back (panah/System back) -> kembali ke list tanpa error.
- [ ] FAB -> `AddTaskScreen` terbuka; "Save (sample)" -> "New Task" muncul di list.
- [ ] Tidak ada error `setState() called after dispose()` (cek log saat back cepat).
- [ ] `flutter analyze` tetap bersih.

**Run & Test:**
```bash
flutter run
# Expected: tap card buka detail; FAB buka add; task baru muncul setelah save.
```

---

## CHECKPOINT 3: Responsive Portrait / Landscape

**Goal:** layout adaptif lebar ≥ 600 -> grid 2 kolom; tidak ada overflow saat rotasi.
**Time:** ~15 menit

**Melanjutkan CP 2:**
- Sudah punya: navigasi penuh, list berjalan.
- 🆕 Akan tambah: breakpoint responsive + pencegahan overflow.

### 3.1 Baca `LayoutBuilder` yang sudah ada

`task_list_screen.dart` sudah memuat kerangka responsive:

```dart
body: _tasks.isEmpty
 ? const Center(child: Text(AppStrings.emptyAll))
 : LayoutBuilder(
 builder: (context, constraints) {
 final wide = constraints.maxWidth >= 600;
 return wide ? _grid() : _list();
 },
 ),
```

**Poin:**

1. **`LayoutBuilder`** memberi `constraints` dari parent, kamu tahu lebar aktual, bukan asumsi perangkat.
2. **Breakpoint 600.** Konvensi Material: ≥ 600 dp = tablet/landscape. Di bawahnya = ponsel portrait.
3. **`_list()` vs `_grid()`.** Kedua method sudah memakai `TaskCard` yang sama. Komponen reusable = sekali tulis, dua layout.

### 3.2 Perbaiki `_grid()` agar tidak overflow

GridView sudah dikonfigurasi:

```dart
gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
 crossAxisCount: 2, // kontrak P02: lebar ≥600 = dua kolom
 mainAxisExtent: 132, // tinggi tetap per sel
 crossAxisSpacing: 8,
 mainAxisSpacing: 8,
),
```

**Poin yang harus kamu pahami:**

1. **`crossAxisCount: 2`.** Saat `LayoutBuilder` mendeteksi lebar ≥600, starter selalu menampilkan dua kolom. Kontrak ini membuat hasil mudah diuji pada landscape dan tablet dasar.
2. **`mainAxisExtent: 132`.** Tinggi tiap sel. Harus muat konten `TaskCard` (2 baris teks + Wrap). Bila `TaskCard` membutuhkan lebih dari 132 -> konten **terpotong** atau overflow.
3. **Bila overflow di landscape:** naikkan `mainAxisExtent` (mis. 140) atau pangkas deskripsi di `TaskCard` jadi `maxLines: 1`. Jangan menurunkan lebar sel dengan menambah kolom sebelum memastikan chip tetap terbaca.

### 3.3 Uji rotasi

1. Jalankan di emulator.
2. Rotasi ke landscape memakai tombol rotasi emulator atau orientasi perangkat fisik.
3. Amati: grid dua kolom muncul (≥ 600), tidak ada overflow horizontal/vertikal.
4. Rotasi balik portrait -> 1 kolom list.

> **Uji device fisik bila ada.** Layar tablet 800dp dalam portrait sudah masuk "wide" -> grid. Itu **ekspektasi benar**, bukan bug.

### Checkpoint Validation

- [ ] Portrait (lebar < 600) -> 1 kolom list.
- [ ] Landscape / layar lebar (≥ 600) -> grid 2+ kolom.
- [ ] Tidak ada `RenderFlex overflowed` di log saat rotasi.
- [ ] `TaskCard` terlihat utuh di kedua layout (chip tidak terpotong).
- [ ] `flutter analyze` tetap bersih.

**Run & Test:**
```bash
flutter run
# Rotate emulator. Expected: portrait = 1 col; landscape = grid; no overflow.
```

---

## Summary

**Yang kamu kerjakan:**
- Membaca `TaskCard` reusable dan `task_list_screen` stateful.
- Menyambungkan navigasi list -> detail dan list -> add dengan `Navigator.push`/`pop`.
- Menyusun layout responsive `LayoutBuilder` + `ListView`/`GridView` tanpa overflow.

**Konsep kunci:**
- **Komposisi widget**, `StatelessWidget` + callback (dumb component), `Theme.of(context)`.
- **Navigator stack**, `push` menambah, `pop` membuang, `pop<T>(value)` membawa hasil.
- **`setState` + `mounted`**, penjaga wajib setelah `await` di `State`.
- **`Expanded`/`Wrap`/`maxLines`+`ellipsis`**, tiga senjata anti overflow.
- **`LayoutBuilder` + `constraints.maxWidth`**, responsive by available space, bukan by device name.

**Preview sesi berikutnya (P03):**
- `_tasks` pindah dari `_TaskListScreenState` ke `TaskProvider extends ChangeNotifier`.
- `Consumer`/`context.watch` menggantikan `setState` manual; UI reaktif otomatis.
- Form sungguhan menggantikan `AddTaskScreen` stub: `TextFormField`, validator, controller lifecycle (`dispose`).
- CRUD reaktif: add/update/delete/toggle + loading/error/empty state.
- **Assignment 1 dibuka di akhir P03**, semua fondasi P02 dipakai.

---

## Troubleshooting

**`RenderFlex overflowed by N pixels on the right`.**
Ada `Row`/`Column` yang isinya lebih lebar dari tempatnya. Periksa: apakah `Text` di dalam `Row` sudah dibungkus `Expanded`/`Flexible`? Apakah `Wrap` dipakai alih-alih `Row` untuk daftar chip? Di `TaskCard`, `Expanded` membungkus `Column` agar deskripsi tidak mendorong lebar. Jangan hilangkan.

**Tap `TaskCard` tidak responsif.**
Pastikan `onTap` benar-benar diteruskan: `TaskCard(task:..., onTap: () => _openDetail(...))`. `InkWell` di `TaskCard` sudah menerimanya. Jika masih, cek apakah ada widget di atas yang menyerap gesture (mis. `AbsorbPointer`, `IgnorePointer`).

**Grid overflow vertikal / `TaskCard` terpotong di landscape.**
Naikkan `mainAxisExtent` (mis. 132 -> 140) di `SliverGridDelegateWithMaxCrossAxisExtent`. Bila chip `Wrap` menumpuk ke 3 baris, tinggi tetap tidak akan muat, turunkan jumlah chip atau pangkas deskripsi. Atur `mainAxisExtent` agar sesuai dengan **tinggi terburuk** konten.

**Task baru tidak muncul di list setelah add.**
Dua penyebab umum: (1) `AddTaskScreen` tidak `pop<Task>(task)`, cek tombol save; (2) `_addTask` tidak memanggil `setState`. Tanpa `setState`, Flutter tidak tahu harus rebuild walau `_tasks` sudah berubah.

**`setState() called after dispose()` atau crash setelah `await`.**
Lupa `if (!mounted) return;` setelah `await Navigator.push`. Context/State mungkin sudah dibuang saat user menek back cepat. Tambahkan penjaga `mounted` di **setiap** method async yang menyentuh `context`/`setState`. Ini fondasi anti "context misuse" yang dipakai terus di P03.

**`flutter create` menimpa `pubspec.yaml`.**
Pulihkan dari Git: `git checkout -- pubspec.yaml analysis_options.yaml`. Jalankan `flutter create` dari dalam folder starter. Bila tetap, hapus file auto (`README.md` Flutter, `test/widget_test.dart` default) lalu pulihkan milikmu.

**`Hot reload` tidak mengubah layout setelah edit `_grid()`.**
Hot reload mempertahankan state. Bila `LayoutBuilder` tidak rebuild, lakukan **hot restart** (`R` besar), bukan hot reload (`r` kecil).

**`Color.withValues` tidak dikenal / lint peringatan `withOpacity`.**
Starter memakai `Color(0x...)` konstan + `ColorScheme.fromSeed`. Hindari `.withOpacity` di kode baru bila SDK < 3.27; konsisten dengan `AppColors`. Lihat constraint di `pubspec.yaml` (`sdk: ^3.4.0`, `flutter: ">=3.22.0"`).

---

## Self-Assessment (sebelum & sesudah)

**Skor kepercayaan 1-5, sebelum & sesudah P02:**
- Membaca widget tree `Card`/`InkWell`/`Row`/`Column`: -> 
- Membedakan `StatelessWidget` dan `StatefulWidget`: -> 
- `Navigator.push`/`pop` dengan result: -> 
- `mounted` guard setelah `await`: -> 
- `LayoutBuilder` + `Expanded`/`Wrap` anti overflow: -> 

**Verifikasi praktik:**
- Rotasi device, screenshot portrait + landscape, tempel di log.
- Jelaskan dengan kata sendiri **kenapa** `TaskCard` tidak memanggil `Navigator` sendiri (jawaban: separation of concerns; card reusable, navigasi urusan layar).

---

## Challenge Bertingkat (kerja sendiri, siapkan bukti)

Pilih satu level. Semua boleh pakai AI untuk **penjelasan**, bukan menulis core logic tanpa analisis.

**Level 1 (Basic):** Tambah satu `widget test` di `test/`: tap `TaskCard` membuka judul detail di layar baru (pakai `MaterialApp` + `Navigator` observer atau `find.text(task.title)` di detail). Kriteria: test lulus.

**Level 2 (Medium):** Tambah parameter `onToggleComplete` ke `TaskCard` (opsional, `VoidCallback?`) dan tombol centang leading. Saat ditekan, panggil callback; di list, `setState` toggle `isCompleted` memakai `copyWith`. Pastikan strikethrough berubah real-time. Kriteria: toggle bekerja + `task_card_test.dart` tetap lulus.

**Level 3 (Advanced):** Buat breakpoint tiga-kondisi di `LayoutBuilder`: `< 400` (1 kolom, font lebih kecil), `400-600` (1 kolom lebar), `≥ 600` (grid). Tambah satu widget test yang mengatur ukuran surface lewat API test Flutter versi kelas dan memverifikasi salah satu kondisi layout. Kriteria: tiga layout berbeda teruji, `analyze` bersih.

**Submit:** screenshot + paste kode + 2-3 kalimat penjelasan pendekatan.

---

## AI-Enhanced Learning (P02)

**Penggunaan AI produktif di P02:**
- "Jelaskan kapan memakai `Expanded` vs `Flexible` di `Row`."
- "Kenapa `Navigator.pop` saya tidak mengembalikan nilai ke layar sebelumnya?" (cek tipe generik `<Task>`).
- "Apa arti `setState() called after dispose()` dan bagaimana mencegahnya?" (jawaban: `mounted` guard).
- "Bagaimana `LayoutBuilder` berbeda dari `MediaQuery`?"

**Hindari:**
- "Tulis `Navigator.push` untuk membuka detail dari list." (core navigasi, analisis sendiri)
- "Buatkan layout responsive saya." (core layout, analisis sendiri)

**Wajib bila memakai AI:** isi `../01-Orientasi/Template-AI-Interaction-Log.md`, tujuan, prompt, ringkasan respons, perubahan dipilih/ditolak, dan **verifikasi pemahaman** (jelaskan ulang dengan kata sendiri + bukti `flutter test`/screenshot).

---

## Resources

- **Resmi:** [docs.flutter.dev/ui/layout](https://docs.flutter.dev/ui/layout), [docs.flutter.dev/cookbook/navigation/navigation-basics](https://docs.flutter.dev/cookbook/navigation/navigation-basics), [docs.flutter.dev/ui/adaptive-responsive](https://docs.flutter.dev/ui/adaptive-responsive).
- **Dalam paket:** `../02-Materi/P01-Diagnosis-Dart-Debugging.md`, `../01-Orientasi/Panduan-Mahasiswa.md`, `../05-Assessment/Lembar-Observasi.md`.
- **Starter:** `../06-Starter-Code/p02-ui-navigation/` (README + struktur di atas).

**Persiapan P03:** baca ulang `task_list_screen.dart` dan bayangkan `_tasks` pindah ke `TaskProvider`; coba sketsa form tambah task (title/description/date/priority) untuk diganti dengan stub `AddTaskScreen`.

---

**Estimasi belajar mandiri:** 4-5 jam | **Kesulitan:** dasar-menengah | **Updated:** 2026-08-08
