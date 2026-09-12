# P03, Form, CRUD, dan Provider

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker
**Durasi sesi:** 150 menit (3 × 50) | **Estimasi belajar mandiri:** 4-6 jam
**Sub-CPMK:** 53.1 (state) + 92.1 (UI interaktif) | **Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`

> **Baca juga:** `../02-Materi/P02-Widget-Layout-Navigation.md`, `../01-Orientasi/Panduan-Mahasiswa.md`. Pasangan kelas: `../03-Modul-Kelas/Modul-P03-Form-CRUD-Provider.md`.

---

## Tujuan Pembelajaran

Setelah materi ini dikuasai, kamu mampu:

1. **Menjelaskan dan mengelola state reaktif** memakai `ChangeNotifier` + `provider`: `ChangeNotifierProvider`, `context.watch` (rebuild), `context.read` (sekali pakai).
2. **Mengimplementasikan CRUD inti** (add/update/delete/toggle) di `TaskProvider` dengan `notifyListeners()`, sampai seluruh `test/task_provider_test.dart` hijau dan UI reaktif.
3. **Membangun form tervalidasi** dengan `TextFormField` + `FormState.validate()`, lifecycle controller (`dispose`), serta loading/error/empty state yang terlihat pengguna.

**Outcome sesi (bukti observable):**
- Starter `06-Starter-Code/p03-provider-crud/` berjalan: loading singkat -> daftar task reaktif.
- `flutter test test/task_provider_test.dart`, semua test **hijau**.
- CRUD bekerja end-to-end: FAB -> form -> save -> muncul; tap -> edit; swipe -> delete; tap centang -> toggle.
- Form menolak title kosong dan title < 3 karakter dengan pesan `AppStrings`.
- **Assignment 1 dibuka di akhir sesi**, kamu siap memulainya dari fondasi P03.

---

## Prasyarat

- Menyelesaikan `../02-Materi/P02-Widget-Layout-Navigation.md`: paham widget tree, navigasi `push`/`pop`, `mounted` guard, layout responsive.
- `../01-Orientasi/Checklist-Environment.md` lulus; `flutter doctor` bersih.
- Starter P03 sudah di-copy ke workspace kosong (lihat "Setup").

> **Kebijakan AI P03:** AI boleh untuk **penjelasan konsep Provider/ChangeNotifier dan diagnosis error**. AI **tidak boleh** menulis core logic CRUD (`addTask`/`updateTask`/`deleteTask`/`toggleComplete`) atau validator tanpa analisis sendiri. Bila memakai AI, isi `../01-Orientasi/Template-AI-Interaction-Log.md`. Assignment 1 dibuka setelah checkpoint ini, kebijakan AI tugas mengikuti panduan tugas.

---

## Setup

```bash
# 1. Copy folder starter ke workspace kosong, lalu di dalamnya:
flutter create --platforms=android,web. # hasilkan platform runner
flutter pub get # menambah dependency `provider` (sudah di pubspec)
flutter analyze
flutter test # widget_test.dart (smoke) hijau;
 # task_provider_test.dart sebagian MERAH (TODO CRUD)

flutter run
```

> Folder `android/`, `web/`, dll. sengaja **tidak** disertakan. Jalankan `flutter create` dari dalam folder starter; pulihkan `pubspec.yaml`/`analysis_options.yaml` dari Git bila ditimpa. **Jangan ubah `pubspec.yaml`**, `provider: ^6.1.2` sudah dipasang.

---

## Struktur starter P03

```text
06-Starter-Code/p03-provider-crud/
├── pubspec.yaml # dependencies: provider ^6.1.2
├── lib/
│ ├── main.dart # ChangeNotifierProvider(TaskProvider()..loadTasks())
│ ├── app.dart
│ ├── core/{constants,theme}/
│ │ ├── app_strings.dart # errTitleRequired, errTitleTooShort, field*, action*
│ │ ├── app_colors.dart
│ │ └── theme/app_theme.dart
│ └── features/tasks/
│ ├── domain/task.dart # model + enum + getDummyTasks()
│ └── presentation/
│ ├── providers/task_provider.dart # CRUD inti = TODO (no-op)
│ ├── screens/
│ │ ├── task_list_screen.dart # Consumer-like: loading/error/empty/list
│ │ └── task_form_screen.dart # form + _validateTitle TODO
│ └── widgets/task_card.dart # tap(edit) + onToggle
└── test/
 ├── widget_test.dart # smoke (hijau)
 └── task_provider_test.dart # beberapa test sengaja MERAH
```

**Aturan batas (penting):**
- Boleh mengubah `task_provider.dart` (isi TODO CRUD) dan `task_form_screen.dart` (isi `_validateTitle`).
- Tidak boleh mengubah `Task` class dan enum, `main.dart` wiring Provider, `task_list_screen.dart` Consumer, atau menambah package.
- Tidak boleh mengubah signature metode `addTask`/`updateTask`/`deleteTask`/`toggleComplete`.

**Role starter:** shell lengkap. Provider terhubung, form terbangun, state UI (loading/error/empty) terpasang. Yang sengaja no-op: **inti CRUD** dan **validator**. Bukan bug, tugas implementasi yang diverifikasi oleh test merah.

---

## Mengapa Provider, dan Kenapa Setelah Widget/Navigation

P03 memindahkan **sumber kebenaran** `_tasks` dari `_TaskListScreenState` (P02, lokal) ke `TaskProvider` (global, reaktif). Tiga prinsip yang dilatih di sini:

1. **State terpisah dari UI.** `TaskProvider` pegang data + logika mutasi; layar hanya membaca dan menampilkan. Saat data berubah, semua layar yang `watch` rebuild otomatis, tanpa `setState` manual, tanpa passing callback.
2. **`notifyListeners()` = kontrak reaktif.** Setiap mutasi (`_tasks` berubah) **wajib** memanggilnya. Lupa satu panggilan -> UI tidak update, walau data sudah benar. Ini bug paling umum di P03.
3. **`context.watch` vs `context.read`.** `watch` = "saya mau rebuild kalau provider berubah" (taruh di `build`). `read` = "saya mau aksi sekali, jangan rebuild" (taruh di `onPressed`/handler). Tukar keduanya -> rebuild berlebihan atau UI diam.

Fondasi ini dipakai terus: di P04 data persisten (SQLite) tetap lewat `TaskProvider`; di P05 sumber remote tetap lewat `TaskProvider`. Yang berubah cuma **sumber data**, bukan arsitektur UI.

> **Sambungan dengan P02:** `TaskCard` sekarang punya `onToggle`. `task_list_screen.dart` sekarang `StatelessWidget` (bukan `StatefulWidget`) karena tidak pegang state lagi. Navigasi `push` form tetap sama, bedanya hasil `pop` sekarang tak perlu `setState`; provider yang memicu rebuild.

---

## CHECKPOINT 1: Provider + State UI (Wiring)

**Goal:** memahami wiring Provider; loading -> error -> empty -> list terlihat; `toggleComplete` terpanggil (belum mengubah = TODO, oke untuk cek alur).
**Time:** ~15 menit

### 1.1 Baca `main.dart`, injeksi provider

```dart
void main() {
 runApp(
 ChangeNotifierProvider(
 create: (_) => TaskProvider()..loadTasks(),
 child: const TaskTrackerApp(),
 ),
 );
}
```

**Poin:**

1. **`ChangeNotifierProvider`** menyediakan instance `TaskProvider` ke seluruh subtree. `create` dijalankan sekali; instance hidup selama app.
2. **`..loadTasks()`** (cascade) memanggil load tepat setelah dibuat -> seed 20 task dummy dengan delay 300ms (simulasi load). Di P04 ini diganti baca SQLite.
3. **Tidak perlu `MultiProvider`** sekarang (cuma satu provider). P04+ mungkin menambah.

### 1.2 Baca `task_list_screen.dart`, konsumsi reaktif

```dart
class TaskListScreen extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
 final provider = context.watch<TaskProvider>();
 //...
 body: _body(context, provider),
 }
}
```

Dan di handler:

```dart
onToggle: () => context.read<TaskProvider>().toggleComplete(task.id),
```

**Poin penting kamu jelaskan:**

1. **`context.watch` di `build`.** Layar rebuild setiap `notifyListeners()`. Karena `TaskListScreen` StatelessWidget, tidak ada `setState`, rebuild dipicu provider.
2. **`context.read` di handler.** Akses provider tanpa berlangganan rebuild. Pakai di `onPressed`/`onToggle`/`onDismissed`.
3. **Empat state UI.** `_body` mengecek berurutan: `isLoading` -> spinner; `error != null` -> `_ErrorView` + retry; `tasks.isEmpty` -> empty message; sisanya -> list. Urutan penting: loading dicek sebelum empty (data belum ada ≠ kosong permanen).
4. **`Dismissible` + `confirmDismiss`.** Swipe kiri mengkonfirmasi dialog dulu, baru `onDismissed` memanggil `deleteTask`. Bila dialog dibatalkan (`pop(false)`), item tidak hilang.

### 1.3 Baca `task_provider.dart`, struktur state

```dart
class TaskProvider extends ChangeNotifier {
 TaskProvider({List<Task> initialTasks = const []}) : _tasks = initialTasks;

 List<Task> _tasks;
 bool _isLoading = false;
 String? _error;

 List<Task> get tasks => List.unmodifiable(_tasks); // anti mutasi luar
 bool get isLoading => _isLoading;
 String? get error => _error;
 int get count => _tasks.length;
 Task? findById(String id) {... }

 Future<void> loadTasks() async { /* _isLoading true; seed; false; notify */ }

 // CRUD = TODO (CP2)
 void addTask(Task task) { /* no-op */ }
 void updateTask(Task task) { /* no-op */ }
 void deleteTask(String id) { /* no-op */ }
 void toggleComplete(String id) { /* no-op */ }
}
```

**Poin:**

1. **`List.unmodifiable`.** Getter `tasks` mengembalikan view read-only. Konsumen tidak bisa `provider.tasks.add(...)` diam-diam; harus lewat `addTask` yang memanggil `notifyListeners`.
2. **`loadTasks` adalah contoh pola.** `_isLoading = true; notifyListeners()` -> (kerja) -> `_isLoading = false; notifyListeners()`. Dua panggilan notify: satu saat mulai, satu saat selesai. CP2 CRUD meniru pola ini.
3. **`findById`** untuk lookup by id, dipakai `updateTask`/`toggleComplete`.

### 1.4 Verifikasi alur (CRUD masih no-op, wajar)

```bash
flutter test test/widget_test.dart # smoke hijau
flutter analyze
flutter run
```

Amati: spinner 300ms -> 20 task muncul. Tap centang -> **tidak berubah** (TODO). Swipe kiri -> dialog -> confirm -> item hilang dari layar **tapi** data tidak benar-benar berubah karena `deleteTask` no-op (item akan kembali setelah rebuild/hot restart). Ini ekspektasi "belum diimplementasi", bukan bug.

### Checkpoint Validation

- [ ] `flutter test test/widget_test.dart` lulus (smoke).
- [ ] `flutter run`: loading singkat -> daftar 20 task reaktif.
- [ ] `flutter run`: error view bisa dipicu (bila kamu uji dengan memaksa exception di load, opsional).
- [ ] Kamu bisa menjelaskan perbedaan `context.watch` dan `context.read`.
- [ ] Kamu bisa menjelaskan **kenapa** `tasks` getter pakai `List.unmodifiable`.

**Run & Test:**
```bash
flutter run
# Expected: loading -> list; tap centang belum berubah (TODO CP2); swipe -> dialog.
```

---

## CHECKPOINT 2: CRUD Inti (Inti)

**Goal:** implementasi `addTask`/`updateTask`/`deleteTask`/`toggleComplete`; semua `test/task_provider_test.dart` hijau; UI reaktif.
**Time:** ~30 menit

**Melanjutkan CP 1:**
- Sudah punya: wiring Provider, state UI, pemahaman `notifyListeners`.
- 🆕 Akan tambah: mutasi data + reaktivitas + bukti via test.

### 2.1 Baca test yang merah dulu

```bash
flutter test test/task_provider_test.dart
```

Baca **nama test** yang gagal, mereka menyebut ekspektasi:
- `addTask menambah task dan memanggil notifyListeners` -> jumlah +1, listener terpanggil.
- `updateTask mengganti task dengan id sama` -> field berubah, jumlah tetap.
- `deleteTask menghapus task` -> jumlah −1, id tak ditemukan.
- `toggleComplete membalik isCompleted` -> false -> true -> false.

### 2.2 Pola implementasi tiap metode

Siklus yang sama untuk semua: **mutasi `_tasks` -> `notifyListeners()`**.

**`addTask`:**
```dart
void addTask(Task task) {
 _tasks = [..._tasks, task];
 notifyListeners();
}
```

**`updateTask`:** ganti elemen dengan id cocok, pertahankan urutan dan jumlah.
```dart
void updateTask(Task task) {
 _tasks = [
 for (final t in _tasks)
 if (t.id == task.id) task else t,
 ];
 notifyListeners();
}
```

**`deleteTask`:**
```dart
void deleteTask(String id) {
 _tasks = _tasks.where((t) => t.id != id).toList();
 notifyListeners();
}
```

**`toggleComplete`:** immutability via `copyWith`; `status` getter dihitung ulang otomatis.
```dart
void toggleComplete(String id) {
 _tasks = [
 for (final t in _tasks)
 if (t.id == id) t.copyWith(isCompleted: !t.isCompleted) else t,
 ];
 notifyListeners();
}
```

**Poin penting (bukan hafal):**

1. **Immutability.** `Task` field `final`; ubah lewat `copyWith`, bukan `t.isCompleted = true`. Kenapa? UI membandingkan instance; data prediktif; aman untuk rebuild. `_tasks` sendiri boleh reassign (field non-final), itu mutasi state provider, sah.
2. **`notifyListeners()` wajib di setiap metode.** Tanpa itu, `Consumer`/`watch` tak tahu harus rebuild. Lupa di satu metode -> bug diam-diam: data benar, UI diam.
3. **Idempotensi toggle.** `!t.isCompleted` membalik apa adanya; panggil dua kali -> kembali semula. Tidak peduli nilai awal.
4. **Urutan dipertahankan.** `updateTask` pakai collection-for yang memetakan elemen; urutan input tak berubah. `deleteTask` pakai `where` yang juga preserve order (dipelajari di P01).
5. **Jangan ubah signature.** Test memanggil `addTask(Task)`, `updateTask(Task)`, `deleteTask(String)`, `toggleComplete(String)`. Ubah signature -> test rusak cara lain.

> **Petunjuk (bukan jawaban):** bila ragu antara mutasi in-place (`_tasks[i] =...`) vs reassign list baru, keduanya valid. Reassign (`_tasks = [...]`) lebih konsisten dengan `List.unmodifiable` dan aman dari efek samping. Pilih satu, konsisten.

### 2.3 Verifikasi reaktif + test

```bash
flutter test test/task_provider_test.dart # all tests passed!
flutter analyze
flutter run
```

Uji manual:
1. FAB -> form -> (title apa pun, validator masih longgar) save -> task baru muncul di list bawah.
2. Tap card -> form (mode edit, field terisi) -> ubah title -> save -> data berubah.
3. Swipe kanan-ke-kiri -> dialog -> Delete -> task hilang.
4. Tap centang -> strikethrough + ikon berubah + status chip `COMPLETED`. Tap lagi -> balik.

### 2.4 Catatan `setState` vs `notifyListeners`

`task_form_screen.dart` memanggil `provider.addTask(task)` lalu `Navigator.pop()`. **Tidak ada `setState`** di form maupun list. Rebuild list terjadi karena `context.watch<TaskProvider>()` di `build` berlangganan. Ini inti reaktif: mutasi di satu tempat -> UI di tempat lain update otomatis.

### Checkpoint Validation

- [ ] `flutter test test/task_provider_test.dart`, **semua test hijau**.
- [ ] `addTask`: FAB -> form -> save -> task muncul + `count` +1.
- [ ] `updateTask`: tap card -> edit -> save -> data berubah + `count` tetap.
- [ ] `deleteTask`: swipe -> confirm -> hilang + `count` −1.
- [ ] `toggleComplete`: tap centang -> status flip real-time; dua kali tap kembali semula.
- [ ] `flutter analyze` tetap bersih (tidak menambah error).
- [ ] UI update tanpa `setState` manual (reaktif via provider).

**Run & Test:**
```bash
flutter test test/task_provider_test.dart # All tests passed!
flutter analyze # No issues found!
flutter run # uji CRUD end-to-end
```

---

## CHECKPOINT 3: Validasi Form

**Goal:** `_validateTitle` menolak input tidak valid; form hanya submit bila valid.
**Time:** ~15 menit

**Melanjutkan CP 2:**
- Sudah punya: CRUD reaktif, UI update.
- 🆕 Akan tambah: aturan validasi + lifecycle controller.

### 3.1 Konsep validator

`TextFormField` menerima `validator: (String? value) => String?`. Aturannya:

- Kembalikan `null` -> **valid**, lanjut.
- Kembalikan `String` -> **tidak valid**, string itu jadi pesan error di bawah field.

`FormState.validate()` menjalankan semua validator. `_submit` sudah memeriksanya:

```dart
if (!(_formKey.currentState?.validate() ?? false)) return;
```

Jadi kamu **cuma perlu** mengisi `_validateTitle`.

### 3.2 Implementasi `_validateTitle` di `task_form_screen.dart`

```dart
String? _validateTitle(String? value) {
 final text = value?.trim() ?? '';
 if (text.isEmpty) return AppStrings.errTitleRequired;
 if (text.length < 3) return AppStrings.errTitleTooShort;
 return null;
}
```

**Poin:**

1. **`value?.trim()`.** Whitespace (`' '`) dianggap kosong setelah trim. Tanpa trim, `' '` lolos `isEmpty` -> bug.
2. **Urutan cek.** Kosong dulu, baru terlalu pendek. Kalau dibalik, `' '` (2 spasi) lolos cek panjang tapi sebenarnya kosong.
3. **Konstanta `AppStrings`.** Pakai `errTitleRequired`/`errTitleTooShort`, bukan hardcode. Ganti bahasa/teks cukup di satu tempat. Ujian memakai nama konstanta yang sama.
4. **`return null` = valid.** Jangan lupa; tanpa ini semua input ditolak.

### 3.3 Lifecycle controller (kenapa `dispose`)

```dart
@override
void initState() {
 super.initState();
 _titleController = TextEditingController(text: widget.task?.title ?? '');
 _descriptionController = TextEditingController(text: widget.task?.description ?? '');
 //...
}

@override
void dispose() {
 _titleController.dispose();
 _descriptionController.dispose();
 super.dispose();
}
```

**Poin:**

1. **`TextEditingController` punya listener.** Flutter melacaknya. Bila state dibuang (layar di-pop) tanpa `dispose()`, controller bocor -> **memory leak** + warning di devtools.
2. **`initState` vs deklarasi langsung.** `late final` + `initState` karena nilai awal butuh `widget.task` (baru tersedia setelah konstruktor). Jangan akses `widget` di field initializer.
3. **`super.dispose()` di akhir.** Urutan: bebaskan resource milikmu dulu, baru kasih tahu superclass.

### 3.4 Uji validasi

1. Kosongkan title -> tekan Save -> pesan "Title is required.", tidak submit.
2. Ketik `ab` (2 karakter) -> Save -> "Title must be at least 3 characters.", tidak submit.
3. Ketik `abc` -> Save -> berhasil, kembali ke list.

> **Edge case opsional:** ubah validator agar **due date tidak di masa lalu** saat add (boleh saat edit). Ini bukan TODO starter, tapi bahan challenge / Assignment 1.

### Checkpoint Validation

- [ ] Title kosong -> `AppStrings.errTitleRequired`, tidak submit.
- [ ] Title < 3 karakter (termasuk whitespace) -> `AppStrings.errTitleTooShort`, tidak submit.
- [ ] Title valid -> Save berhasil, kembali ke list, data berubah.
- [ ] `dispose()` memanggil `_titleController.dispose()` + `_descriptionController.dispose()`.
- [ ] `flutter analyze` bersih; `flutter test` tetap hijau.

**Run & Test:**
```bash
flutter run
# Expected: form menolak title kosong/pendek; valid -> CRUD (CP2) berjalan.
```

---

## Assignment 1, Kickoff (akhir sesi)

Setelah ketiga checkpoint hijau, **Assignment 1 dibuka**. Lingkup Assignment 1 membangun di atas semua fondasi P01-P03:

- `Task` model + enum (P01) 
- UI responsive portrait+landscape, form validation, navigation, `TaskCard` reusable (P02) 
- `ChangeNotifier`/Provider CRUD + loading/error/empty state (P03) 

**Yang sudah kamu miliki sebagai titik mulai:**
- Starter P03 = basis langsung. Assignment 1 menambah: search title **dan** filter status/category, detail screen penuh, delete confirmation (sudah ada `Dismissible`), toggle completion (sudah ada).

**Yang harus kamu kerjakan sendiri di Assignment 1** (bukan dari starter):
- Search + filter reaktif di provider atau selector UI.
- Konsistensi state lintas layar (edit -> list update otomatis).
- Material 3 rapi di dua orientasi.
- `flutter analyze` bersih atau warning dijelaskan.

> **Baca brief lengkap** di `04-Penugasan/Assignment-01-Task-Tracker-Core.md` + rubrik `Rubrik-Assignment-01.md` (dibuka dosen di akhir sesi). Tenggat: **sebelum P04**. Gunakan waktu sisa sesi + belajar mandiri untuk memulai. Konsultasikan langkah pertama dengan dosen sebelum pulang.

---

## Summary

**Yang kamu kerjakan:**
- Memahami wiring Provider (`ChangeNotifierProvider`, `watch`/`read`) dan empat state UI.
- Mengimplementasikan CRUD inti sampai seluruh `task_provider_test.dart` hijau dan UI reaktif.
- Mengisi validator form + menjaga lifecycle controller (`dispose`).

**Konsep kunci:**
- **`ChangeNotifier` + `notifyListeners()`**, kontrak reaktif; wajib di tiap mutasi.
- **`watch` vs `read`**, rebuild berlangganan vs aksi sekali pakai.
- **`List.unmodifiable` + immutability (`copyWith`)**, data aman, anti mutasi diam-diam.
- **`FormState.validate()` + `validator`**, `null` = valid, `String` = pesan error.
- **Controller lifecycle**, `initState` isi, `dispose` bebaskan; cegah memory leak.

**Preview sesi berikutnya (P04):**
- `loadTasks()` diganti baca **SQLite** (`sqflite` + `path`); data bertahan setelah restart.
- `addTask`/`updateTask`/`deleteTask` menulis ke DB lalu `notifyListeners`.
- Arsitektur: `TaskProvider` -> repository -> local datasource. UI tak berubah.

---

## Troubleshooting

**CRUD tidak mengubah list (UI diam walau data benar).**
Hampir selalu: lupa `notifyListeners()` di akhir metode. Periksa tiap metode `addTask`/`updateTask`/`deleteTask`/`toggleComplete`, harus ada `notifyListeners()` setelah mutasi. Atau: layar memakai `context.read` (sekali pakai) alih-alih `context.watch` (berlangganan rebuild). `read` di `build` = UI tak pernah rebuild.

**Toggle lalu status chip tidak berubah, walau `notifyListeners` dipanggil.**
`status` dihitung ulang otomatis dari `isCompleted` (getter di model). Cukup `copyWith(isCompleted: !t.isCompleted)`, jangan set `status` manual (field itu turunan, bukan tersimpan). Bila chip tetap diam, cek apakah `TaskCard` benar-benar membaca `task.status` (bukan cache lama).

**`flutter test` tetap merah padahal CRUD sudah diisi.**
Periksa: apakah kamu mengubah signature metode? Test memanggil `provider.addTask(Task(...))` tanpa `await`. Apakah `notifyListeners` benar-benar dipanggil (test `addTask` cek `changed > 0` lewat `addListener`)? Apakah `updateTask` menjaga `count` tetap (tidak menambah)? Jalankan satu test: `flutter test test/task_provider_test.dart --plain-name "toggleComplete"`.

**Form save diam (tidak ada error, tidak pindah layar).**
Validator masih `return null` selalu (TODO belum diisi), itu bukan penyebab diam. Yang membuat diam: `_submit` keluar awal karena `validate()` false. Bila kamu sudah isi validator dan title valid, cek `_formKey.currentState?.validate()`, bila `_formKey` tidak terpasang di `Form(key: _formKey...)`, `currentState` null.

**`TextEditingController` leak / warning `dispose` di devtools.**
`dispose()` tidak memanggil `_titleController.dispose()` + `_descriptionController.dispose()`. Starter sudah benar; bila kamu menambah controller baru (mis. date), wajib `dispose` juga. Aturan: tiap `TextEditingController`/`ScrollController`/`FocusNode` yang dibuat di state -> `dispose` di `dispose()`.

**`Looking up a deactivated widget's ancestor` / error pakai `context` setelah `await`.**
Kamu menyimpan `context` sebelum `await` lalu memakainya setelahnya. Aturan aman: ambil provider **sebelum** `await` (`final provider = context.read<TaskProvider>();`), lalu setelah `await` cek `if (!mounted) return;` sebelum menyentuh `context`/`setState`. Di `task_form_screen._submit` tidak ada `await` sebelum `Navigator.pop`, jadi aman, tapi bila kamu menambah async (mis. simpan ke DB di Assignment 1), terapkan pola ini. Ini fondasi anti **context misuse** yang dipakai terus di P04-P05.

**`A ValueNotifier/ChangeNotifier used after dispose`.**
Listener ditambah tapi tidak dilepas, atau provider dipakai ulang setelah dispose. Bila kamu `addListener` manual di test, hapus di `tearDown`. Di kode app, `context.watch`/`Consumer` mengurus listener otomatis, jangan `addListener` manual di widget.

**`flutter create` menimpa `pubspec.yaml`.**
Pulihkan dari Git (`git checkout -- pubspec.yaml analysis_options.yaml`). **Jangan** hapus dependency `provider`, wajib untuk P03. Jalankan `flutter create` dari dalam folder starter.

**Hot reload tidak mengaktifkan perubahan provider.**
Hot reload mempertahankan state instance. Bila kamu mengubah metode provider, lakukan **hot restart** (`R` besar) agar instance baru dibuat dan `loadTasks` ulang.

---

## Self-Assessment (sebelum & sesudah)

**Skor kepercayaan 1-5, sebelum & sesudah P03:**
- `ChangeNotifier` + `notifyListeners`: -> 
- `context.watch` vs `context.read`: -> 
- CRUD reaktif (add/update/delete/toggle): -> 
- `FormState.validate()` + validator: -> 
- Controller lifecycle (`dispose`): -> 

**Verifikasi praktik:**
- Tulis satu unit test tambahan untuk edge case (mis. `addTask` dengan id duplikat, atau `toggleComplete` pada id yang tidak ada, apa perilaku yang diharapkan?).
- Jelaskan dengan kata sendiri **kenapa** `Task` immutable + `copyWith` lebih aman untuk UI reaktif.

---

## Challenge Bertingkat (kerja sendiri, siapkan bukti)

Pilih satu level. Semua boleh pakai AI untuk **penjelasan**, bukan menulis core logic tanpa analisis.

**Level 1 (Basic):** Tambah satu **unit test** di `task_provider_test.dart`: `updateTask` pada id yang tidak ada tidak menambah jumlah (idempotent). Kriteria: test lulus.

**Level 2 (Medium):** Tambah validator **due date tidak di masa lalu** saat add (boleh masa lalu saat edit). Tambahkan konstanta `AppStrings.errDueDateInPast`. Kriteria: form menolak tanggal lewat; valid -> save.

**Level 3 (Advanced):** Tambah `filterByStatus` di provider (field `_statusFilter` + getter + `notifyListeners`) yang berinteraksi AND dengan search. Tambah 2 unit test untuk kombinasi filter+search. Kriteria: filter reaktif + test hijau + `analyze` bersih.

**Submit:** screenshot + paste kode + 2-3 kalimat penjelasan pendekatan.

> Challenge Level 2/3 langsung relevan untuk **Assignment 1** (search + filter status/category wajib). Kerjakan = semakin siap mulai tugas.

---

## AI-Enhanced Learning (P03)

**Penggunaan AI produktif di P03:**
- "Jelaskan perbedaan `context.watch` dan `context.read` di Provider."
- "Kenapa saya harus `dispose` `TextEditingController`?"
- "Apa itu `List.unmodifiable` dan kenapa dipakai di getter provider?"
- "Bagaimana `ChangeNotifier` tahu widget mana yang harus rebuild?"

**Hindari:**
- "Tulis `addTask`/`updateTask`/`toggleComplete` untuk starter ini." (core CRUD, analisis sendiri)
- "Buatkan validator title saya." (core validation, analisis sendiri)

**Wajib bila memakai AI:** isi `../01-Orientasi/Template-AI-Interaction-Log.md`, tujuan, prompt, ringkasan respons, perubahan dipilih/ditolak, dan **verifikasi pemahaman** (jelaskan ulang dengan kata sendiri + bukti `flutter test`).

---

## Resources

- **Resmi:** [docs.flutter.dev/data-and-backend/state-mgmt/simple](https://docs.flutter.dev/data-and-backend/state-mgmt/simple), [pub.dev/packages/provider](https://pub.dev/packages/provider), [docs.flutter.dev/cookbook/forms/validation](https://docs.flutter.dev/cookbook/forms/validation).
- **Dalam paket:** `../02-Materi/P01-Diagnosis-Dart-Debugging.md`, `../02-Materi/P02-Widget-Layout-Navigation.md`, `../01-Orientasi/Panduan-Mahasiswa.md`, `../05-Assessment/Lembar-Observasi.md`.
- **Starter:** `../06-Starter-Code/p03-provider-crud/` (README + struktur di atas).

**Persiapan P04:** baca ulang `loadTasks()` di `task_provider.dart` dan bayangkan sumbernya berganti dari `Task.getDummyTasks()` ke query SQLite; `addTask`/`updateTask`/`deleteTask` akan menulis ke DB lalu `notifyListeners`.

---

**Estimasi belajar mandiri:** 4-6 jam | **Kesulitan:** menengah | **Updated:** 2026-08-08
