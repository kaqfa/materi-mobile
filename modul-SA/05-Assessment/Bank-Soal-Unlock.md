# Bank Soal Unlock, PPB Remidi 7 Pertemuan

> **Status:** v1.0, 2026-08-10
> **Klasifikasi:** soal boleh dilihat mahasiswa lewat Moodle; **kunci di dokumen ini khusus dosen** (kunci ditandai **tebal** pada tiap soal).
> **Fungsi:** gerbang (gate) *unlock* materi berikutnya. Mahasiswa hanya dapat membuka materi P(n+1) setelah lulus kuis P(n).
> **Cakupan:** 6 kuis × 10 soal = **60 soal**, satu set unik per pertemuan (P02-P07). Tidak ada soal yang diulang antar pertemuan.
> **Versi Moodle:** `Moodle-Question-Bank.xml`, kategori `PPB-Remidi/Unlock/P02` … `P07`.
> **Sumber materi:** `../02-Materi/P0*.md` (checkpoint 1-3 tiap sesi).

## 0. Skema gerbang

| Kuis | Membuka | Jumlah soal | Passing | Attempt |
|---|---|---:|---:|---|
| Unlock P02 | Materi P03 | 10 | 80% (8/10) | Unlimited |
| Unlock P03 | Materi P04 | 10 | 80% | Unlimited |
| Unlock P04 | Materi P05 | 10 | 80% | Unlimited |
| Unlock P05 | Materi P06 | 10 | 80% | Unlimited |
| Unlock P06 | Materi P07 | 10 | 80% | Unlimited |
| Unlock P07 | Proyek Akhir / Demo | 10 | 80% | Unlimited |

**Gerbang P01 → P02** tidak memakai bank ini; pembukanya adalah **Tes Diagnostik** (`../01-Orientasi/Tes-Diagnostik-Konsep.md` + `Tes-Diagnostik-Praktik.md`) yang wajib dikerjakan, bukan wajib lulus, karena fungsinya memetakan posisi awal.

**Setup di Moodle:** aktifkan *Restrict access* pada aktivitas materi P(n+1) → `Grade: Unlock P(n) ≥ 80%`. Semua soal `shuffleanswers` aktif, penalti 0, attempt tak terbatas (tujuannya penguasaan, bukan penyaringan).

---

## 1. Unlock P02, Widget, Layout, dan Navigasi

### U02.1
Apa perbedaan mendasar `StatelessWidget` dan `StatefulWidget`?

- A. `StatelessWidget` lebih lambat dirender.
- **B. `StatelessWidget` tidak menyimpan state yang berubah; `StatefulWidget` punya objek `State` yang bertahan antar rebuild dan dapat memicu rebuild lewat `setState`.**
- C. `StatefulWidget` hanya boleh dipakai di halaman utama.
- D. `StatelessWidget` tidak boleh punya widget anak.

### U02.2
Pada `TaskCard`, mengapa warna dan gaya teks diambil lewat `Theme.of(context)` alih-alih ditulis literal?

- A. Karena literal warna dilarang compiler.
- **B. Agar konsisten satu sumber gaya dan otomatis mengikuti tema (termasuk dark mode) tanpa mengubah tiap widget.**
- C. Karena `Theme.of(context)` mempercepat rendering.
- D. Karena warna literal tidak dapat dipakai dalam `Card`.

### U02.3
Widget mana yang membuat `TaskCard` merespons ketukan dengan efek ripple?

- A. `Padding`
- **B. `InkWell` (di dalam `Material`/`Card`)**
- C. `SizedBox`
- D. `Align`

### U02.4
`Navigator` bekerja sebagai struktur data apa, dan apa efek `Navigator.push`?

- **A. Stack; `push` menaruh route baru di atas route sekarang sehingga halaman lama tetap ada di bawahnya.**
- B. Queue; `push` menaruh route di antrean paling belakang.
- C. Map; `push` menimpa route dengan key yang sama.
- D. Tree; `push` mengganti seluruh cabang navigasi.

### U02.5
Mahasiswa membuka `AddTaskScreen`, membuat task, lalu ingin task itu muncul di daftar. Alur yang benar?

- A. `Navigator.push` lalu baca variabel global di `build`.
- **B. `final result = await Navigator.push(...)`, lalu `Navigator.pop(context, task)` di layar Add, kemudian `setState` menambah `result` ke daftar bila tidak null.**
- C. `Navigator.pop()` tanpa argumen, lalu daftar refresh otomatis.
- D. Menyimpan task di `initState` layar daftar.

### U02.6
Mengapa hasil `Navigator.pop(context, task)` perlu dicek null di layar pemanggil?

- **A. Karena pengguna bisa kembali tanpa menyimpan (tombol back), sehingga hasilnya null dan tidak boleh ditambahkan ke daftar.**
- B. Karena `pop` selalu mengembalikan null.
- C. Karena Dart melarang tipe non-nullable pada await.
- D. Karena null menandakan terjadi error jaringan.

### U02.7
Apa fungsi `LayoutBuilder` pada layar responsive?

- A. Mengatur tema warna berdasarkan platform.
- **B. Memberi `constraints` (mis. `maxWidth`) dari parent sehingga layout dapat memilih tampilan berbeda untuk portrait/landscape.**
- C. Mengunci orientasi perangkat.
- D. Membangun animasi transisi antar halaman.

### U02.8
Target P02: portrait 1 kolom, landscape (lebar ≥ 600) grid 2 kolom. Implementasi yang tepat?

- **A. `LayoutBuilder(builder: (ctx, c) => c.maxWidth >= 600 ? _grid() : _list())`**
- B. `MediaQuery.of(context).size.height > 600 ? _grid() : _list()`
- C. `if (Platform.isAndroid) _grid() else _list()`
- D. Selalu `_grid()` lalu batasi dengan `SizedBox` tinggi tetap.

### U02.9
`GridView` di dalam `Column` menampilkan overflow kuning. Perbaikan yang benar?

- A. Menambahkan `const` pada `GridView`.
- **B. Membungkus `GridView` dengan `Expanded` agar mendapat tinggi terbatas dari `Column`.**
- C. Mengganti `Column` dengan `Stack` tanpa perubahan lain.
- D. Mengurangi jumlah item menjadi 5.

### U02.10
Apa yang menyebabkan overflow kuning ("yellow-black stripes") muncul di Flutter?

- **A. Widget anak meminta ruang lebih besar daripada constraint yang diberikan parent.**
- B. Warna tema tidak diatur.
- C. Terlalu banyak `setState` dipanggil.
- D. Gambar tidak ditemukan di assets.

---

## 2. Unlock P03, Form, CRUD, dan Provider

### U03.1
Apa peran `ChangeNotifier` dalam state management Provider?

- **A. Menyimpan state dan memberi tahu pendengarnya lewat `notifyListeners()` agar widget yang mendengarkan rebuild.**
- B. Menyimpan data ke disk secara otomatis.
- C. Menggantikan `setState` di seluruh aplikasi tanpa listener.
- D. Mengatur rute navigasi aplikasi.

### U03.2
Kapan memakai `context.watch<T>()` dan kapan `context.read<T>()`?

- **A. `watch` saat widget perlu rebuild mengikuti perubahan state; `read` saat hanya memanggil aksi sekali (mis. di dalam `onPressed`).**
- B. `watch` di `onPressed`; `read` di `build`.
- C. Keduanya identik, pilih bebas.
- D. `read` untuk rebuild; `watch` untuk aksi.

### U03.3
Memanggil `context.watch<TaskProvider>()` di dalam `onPressed` adalah praktik buruk karena:

- A. Menyebabkan error kompilasi.
- **B. `watch` ditujukan untuk fase build; di callback ia menambah langganan tak perlu, memicu rebuild berlebih. Gunakan `read`.**
- C. `watch` tidak dapat mengakses provider di luar `build`, sehingga selalu null.
- D. `onPressed` tidak boleh mengakses provider sama sekali.

### U03.4
Setelah menambah task ke list internal `TaskProvider`, UI tidak berubah. Penyebab paling mungkin?

- **A. `notifyListeners()` tidak dipanggil setelah mutasi data.**
- B. `ChangeNotifierProvider` harus dipasang ulang tiap rebuild.
- C. Task belum disimpan ke SQLite.
- D. `ListView` perlu `const`.

### U03.5
Di mana `ChangeNotifierProvider` sebaiknya dipasang agar seluruh fitur task dapat mengaksesnya?

- **A. Di atas subtree yang membutuhkannya (mis. membungkus `MaterialApp`/root fitur), agar semua turunan dapat membacanya.**
- B. Di dalam `build` tiap `TaskCard`.
- C. Di dalam `initState` layar detail.
- D. Di file `pubspec.yaml`.

### U03.6
Operasi `toggle` (tandai selesai/belum) pada model immutable dilakukan dengan:

- A. Mengubah langsung `task.isCompleted = !task.isCompleted`.
- **B. Mengganti elemen dengan `task.copyWith(isCompleted: !task.isCompleted)` lalu `notifyListeners()`.**
- C. Menghapus task lalu membuat ulang dengan id acak baru.
- D. Memanggil `setState` di provider.

### U03.7
Bagaimana cara memvalidasi seluruh field form sebelum menyimpan?

- **A. Bungkus field dalam `Form` dengan `GlobalKey<FormState>`, lalu panggil `_formKey.currentState!.validate()` yang menjalankan semua `validator`.**
- B. Cek manual `if (controller.text.isEmpty)` untuk tiap field tanpa `Form`.
- C. Panggil `TextFormField.validate()` satu per satu.
- D. Validasi otomatis berjalan saat `TextFormField` dibuat.

### U03.8
Aturan P03: title wajib diisi dan minimal 3 karakter. Validator yang benar?

- **A. `(v) => v == null \|\| v.trim().isEmpty ? AppStrings.titleRequired : (v.trim().length < 3 ? AppStrings.titleTooShort : null)`**
- B. `(v) => v!.length > 3 ? 'terlalu panjang' : null`
- C. `(v) => null` lalu cek di `onPressed`.
- D. `(v) => v!.isEmpty ? '' : null`

### U03.9
Sebuah `validator` mengembalikan `null`. Apa artinya?

- **A. Field dinyatakan valid, tidak ada pesan error yang ditampilkan.**
- B. Field kosong dan ditolak.
- C. Validator gagal dijalankan.
- D. Form otomatis tersimpan.

### U03.10
Urutan state UI yang benar saat provider memuat daftar task pertama kali?

- **A. loading → success (daftar tampil) atau empty (pesan "belum ada task") atau error (pesan + retry).**
- B. success → loading → empty.
- C. empty → error → loading.
- D. Langsung success; state lain tidak perlu.

---

## 3. Unlock P04, SQLite dan Offline-First

### U04.1
Apa arti "local source of truth" pada arsitektur offline-first?

- **A. Data lokal (SQLite) menjadi acuan utama yang dibaca UI, sehingga aplikasi tetap berfungsi tanpa jaringan dan data bertahan setelah restart.**
- B. Server selalu menjadi acuan; lokal hanya cache sementara yang dihapus tiap buka app.
- C. Data hanya disimpan di memori selama app berjalan.
- D. UI membaca langsung dari API tanpa perantara.

### U04.2
Pada `sqflite`, kapan callback `onCreate` dijalankan?

- **A. Hanya saat file database belum ada dan pertama kali dibuat.**
- B. Setiap kali aplikasi dibuka.
- C. Setiap kali `insert` dipanggil.
- D. Saat `version` diturunkan.

### U04.3
Mengapa `openDatabase` dilakukan secara lazy (dibuka saat pertama dibutuhkan, lalu disimpan)?

- **A. Agar tidak membuka koneksi berulang dan tidak menghambat startup; satu instance dipakai ulang.**
- B. Karena SQLite melarang lebih dari satu query.
- C. Agar database terhapus saat app ditutup.
- D. Karena `path_provider` hanya bisa dipanggil sekali seumur hidup app.

### U04.4
SQLite tidak punya tipe boolean asli. Bagaimana `isCompleted` disimpan?

- **A. Sebagai INTEGER 0/1, dikonversi bolak-balik di mapper (`value == 1`).**
- B. Sebagai TEXT "true"/"false" yang dibaca langsung tanpa konversi.
- C. Sebagai BLOB.
- D. Boolean disimpan apa adanya karena sqflite mengonversi otomatis.

### U04.5
Format penyimpanan `DateTime` yang tepat pada kolom TEXT agar dapat diurutkan dan diparse kembali?

- **A. ISO-8601 lewat `dueDate.toIso8601String()`, dibaca dengan `DateTime.parse(...)`.**
- B. `dueDate.toString()` dengan format lokal perangkat.
- C. Format "dd/MM/yyyy" agar mudah dibaca manusia.
- D. Disimpan sebagai nama hari.

### U04.6
`TaskPriority` (enum) disimpan sebagai TEXT nama. Cara membacanya kembali yang benar?

- **A. `TaskPriority.values.byName(row['priority'] as String)`**
- B. `TaskPriority.values[row['priority'] as int]` tanpa perubahan skema.
- C. `row['priority'] as TaskPriority`
- D. `TaskPriority.parse(row['priority'])`

### U04.7
Apa tugas utama `TaskMapper` dalam arsitektur P04?

- **A. Mengonversi dua arah antara model `Task` dan baris SQLite `Map<String, Object?>`, sehingga detail penyimpanan tidak bocor ke domain/UI.**
- B. Membuka dan menutup koneksi database.
- C. Menjalankan query SQL kompleks.
- D. Mengatur rebuild widget.

### U04.8
Query `db.update('tasks', values, where: 'id = ?', whereArgs: [id])` memakai `?` alih-alih menyisipkan nilai langsung ke string. Mengapa?

- **A. Untuk mencegah SQL injection dan kesalahan escaping; nilai dikirim terpisah dari pernyataan SQL.**
- B. Karena `sqflite` tidak mendukung string interpolation sama sekali.
- C. Agar query berjalan lebih cepat di emulator.
- D. Karena `where` wajib berisi tepat satu karakter `?`.

### U04.9
Bukti observable bahwa persistence P04 benar-benar bekerja adalah:

- **A. Menutup (kill) aplikasi lalu `flutter run` lagi, dan task hasil add/edit/delete/toggle tetap sesuai kondisi terakhir.**
- B. Hot reload menampilkan task yang sama.
- C. `flutter analyze` bersih.
- D. Daftar task tampil setelah loading pertama.

### U04.10
Skema berubah (menambah kolom baru) pada aplikasi yang sudah terpasang. Mekanisme yang benar?

- **A. Naikkan `version` dan tangani perubahan di `onUpgrade` (mis. `ALTER TABLE`), agar data pengguna lama tidak hilang.**
- B. Ubah `onCreate` saja; database lama akan menyesuaikan sendiri.
- C. Hapus aplikasi pengguna dan minta install ulang.
- D. Turunkan `version` agar `onCreate` dipanggil ulang.

---

## 4. Unlock P05, REST API dan Error Handling

### U05.1
Mengapa `ApiError` dimodelkan sebagai `sealed class` dengan subtype (`NotFoundError`, `ClientError`, `ServerError`, `NetworkError`)?

- **A. Agar `switch` atas error bersifat exhaustif dan dicek compiler, sehingga tidak ada kondisi error yang lupa ditangani UI.**
- B. Agar error dapat disimpan ke SQLite.
- C. Karena Dart melarang penggunaan `Exception`.
- D. Agar semua error dapat diabaikan dengan satu `catch`.

### U05.2
Status 401 dari server sebaiknya dipetakan dan ditampilkan sebagai:

- **A. Error autentikasi (kredensial/token tidak valid) dengan pesan spesifik, bukan sekadar "gagal memuat".**
- B. Empty state, karena tidak ada data yang diterima.
- C. Loading berkepanjangan sampai token diperbarui sendiri.
- D. Success dengan daftar kosong.

### U05.3
Perbedaan penanganan 404 dan 500 bagi pengguna adalah:

- **A. 404 berarti resource tidak ditemukan (mis. task sudah dihapus, tawarkan refresh daftar); 500 berarti server bermasalah (di luar kendali klien, tawarkan retry).**
- B. Keduanya identik, cukup satu pesan generik.
- C. 404 harus membuat aplikasi keluar; 500 diabaikan.
- D. 404 ditangani server; 500 ditangani UI.

### U05.4
`SocketException`/timeout saat request dipetakan ke:

- **A. `NetworkError`, karena kegagalan konektivitas, bukan respons HTTP dari server.**
- B. `ServerError`, karena server pasti sedang mati.
- C. `ClientError`, karena kesalahan penulisan kode.
- D. Success dengan data kosong.

### U05.5
Method HTTP yang tepat untuk mengubah **sebagian** field task (mis. hanya `isCompleted`)?

- **A. PATCH (atau PUT bila mengirim representasi penuh)**
- B. GET
- C. DELETE
- D. HEAD

### U05.6
`Task.fromJson` menerima `dueDate` sebagai string ISO-8601. Konversi yang benar?

- **A. `DateTime.parse(json['dueDate'] as String)`**
- B. `json['dueDate'] as DateTime`
- C. `DateTime.fromMillisecondsSinceEpoch(json['dueDate'] as String)`
- D. `json['dueDate'].toDate()`

### U05.7
Endpoint kadang mengembalikan array langsung `[...]`, kadang objek terbungkus `{"data": [...]}`. Penanganan yang tepat?

- **A. Periksa tipe hasil `jsonDecode`: bila `List` pakai langsung; bila `Map` ambil `body['data']` sebagai `List`.**
- B. Selalu cast ke `List`, dan biarkan crash bila berbentuk `Map`.
- C. Minta backend mengubah kontrak sebelum aplikasi bisa jalan.
- D. Gunakan `jsonDecode` dua kali berturut-turut.

### U05.8
Apa manfaat `MockTaskApiClient` pada starter P05?

- **A. Menguji seluruh alur CRUD dan state error tanpa server nyata, termasuk mensimulasikan network error secara deterministik.**
- B. Mempercepat request ke server produksi.
- C. Menggantikan kebutuhan repository.
- D. Menyimpan data secara permanen ke disk.

### U05.9
Base URL API sebaiknya dirutekan lewat `--dart-define` karena:

- **A. Nilainya dapat berbeda per lingkungan tanpa mengubah kode, dan kredensial/URL sensitif tidak ikut ter-commit ke repo.**
- B. `--dart-define` mempercepat koneksi jaringan.
- C. Flutter melarang string URL dalam kode.
- D. Agar URL dapat diubah pengguna dari menu setting.

### U05.10
Tampilan error yang baik pada layar daftar memuat:

- **A. Pesan yang menjelaskan jenis kegagalan + tombol Retry yang memanggil ulang `loadTasks()`.**
- B. Layar putih kosong tanpa keterangan.
- C. Dialog yang tidak dapat ditutup sampai jaringan pulih.
- D. `print()` pesan error ke konsol saja.

---

## 5. Unlock P06, Testing dan Device Feature

### U06.1
Mengapa logika murni (`Task.status`, `TaskFilterService`) paling murah dan andal diuji dengan unit test?

- **A. Karena tidak bergantung pada widget/perangkat, sehingga berjalan cepat dan hasilnya deterministik.**
- B. Karena unit test dapat merender UI lebih cepat daripada widget test.
- C. Karena logika murni tidak mungkin salah.
- D. Karena unit test hanya berlaku untuk kode backend.

### U06.2
Menguji `Task.status` yang memakai `DateTime.now()` bisa rapuh (flaky). Strategi paling tepat?

- **A. Menyusun `dueDate` relatif terhadap sekarang dengan selisih jelas (mis. `now.subtract(Duration(days: 1))`), atau menyuntikkan sumber waktu.**
- B. Menjalankan test hanya di pagi hari.
- C. Menghapus test yang bergantung tanggal.
- D. Menambahkan `sleep(60)` sebelum assert.

### U06.3
Test untuk filter status sebaiknya menegaskan:

- **A. Setiap elemen hasil berstatus sama dengan argumen, dan jumlahnya sesuai data uji (termasuk kasus list kosong).**
- B. Hasil tidak pernah kosong apa pun datanya.
- C. Hasil selalu berisi 20 task.
- D. Fungsi melempar exception saat tidak ada yang cocok.

### U06.4
Test search harus membuktikan sifat *case-insensitive substring*. Kasus uji paling representatif?

- **A. Query `hist` menemukan "Read History", dan query `HIST` memberi hasil sama.**
- B. Query `Read History` menemukan "Read History" saja.
- C. Query kosong menghasilkan list kosong.
- D. Query berupa angka menghasilkan error.

### U06.5
Mengapa hasil akses galeri/kamera dipetakan ke `sealed AttachmentResult` (`Success`/`Unavailable`/`Denied`)?

- **A. Agar setiap kemungkinan (berhasil, perangkat tidak tersedia, izin ditolak) ditangani eksplisit di UI tanpa exception yang membuat app crash.**
- B. Agar gambar tersimpan otomatis ke SQLite.
- C. Karena `image_picker` mewajibkan sealed class.
- D. Agar permission tidak perlu diminta.

### U06.6
Pengguna menolak izin kamera. Perilaku aplikasi yang benar?

- **A. Menampilkan pesan/banner "izin ditolak" dan tetap berjalan normal; tidak crash dan tidak memaksa.**
- B. Menutup aplikasi.
- C. Melempar exception ke UI agar terlihat jelas.
- D. Meminta izin berulang dalam loop sampai diterima.

### U06.7
Apa manfaat `LocalAttachmentService` (implementasi palsu) dalam pengujian?

- **A. Menyuntikkan perilaku `success`/`denied`/`unavailable` secara deterministik sehingga fallback dapat diuji hijau tanpa perangkat fisik.**
- B. Mempercepat kamera pada perangkat nyata.
- C. Menghapus kebutuhan permission di production.
- D. Menyimpan foto ke server otomatis.

### U06.8
Apa yang tepat diuji dengan **widget test**, bukan unit test?

- **A. Validasi form yang menampilkan pesan error saat title kosong dan callback terpanggil saat valid.**
- B. Konversi `DateTime` ke ISO-8601 di mapper.
- C. Pemetaan status HTTP ke `ApiError`.
- D. Algoritma pencarian substring.

### U06.9
Dalam widget test, setelah `await tester.enterText(...)` dan `await tester.tap(...)`, mengapa perlu `await tester.pump()`/`pumpAndSettle()`?

- **A. Agar frame dibangun ulang sehingga perubahan UI (pesan error, daftar baru) benar-benar terlihat oleh matcher.**
- B. Agar test berjalan lebih lambat dan stabil secara acak.
- C. Karena `expect` hanya bekerja setelah delay.
- D. Untuk mengosongkan cache gambar.

### U06.10
Mengapa `flutter test` hijau dijadikan **gate rilis** menuju P07?

- **A. Karena memberi bukti otomatis dan berulang bahwa logika inti + state UI masih benar sebelum membangun rilis.**
- B. Karena test menggantikan kebutuhan uji manual sepenuhnya.
- C. Karena `flutter build` menolak berjalan bila ada test merah.
- D. Karena test hijau menjamin tidak ada bug sama sekali.

---

## 6. Unlock P07, Release, Performa, dan Demo

### U07.1
Urutan quality gate rilis yang benar sebelum menyerahkan build?

- **A. `flutter analyze` bersih → `flutter test` hijau → `flutter build apk --release` sukses.**
- B. `flutter build apk` dulu; analyze dan test opsional bila build sukses.
- C. Cukup `flutter run` di emulator tanpa perintah lain.
- D. `flutter clean` berulang sampai tidak ada output.

### U07.2
`flutter analyze` melaporkan "No issues found!" tetapi aplikasi masih salah perilaku. Kesimpulan yang benar?

- **A. Analyze hanya memeriksa statis (lint/tipe); kebenaran perilaku tetap harus dibuktikan lewat test dan uji manual.**
- B. Aplikasi pasti benar; kesalahan ada pada perangkat.
- C. Analyze rusak dan perlu diinstal ulang.
- D. Test tidak diperlukan bila analyze bersih.

### U07.3
Apa efek menandai subtree widget sebagai `const`?

- **A. Instance dibuat sekali dan dapat di-*skip* saat rebuild karena identitasnya tidak berubah, mengurangi kerja render.**
- B. Widget menjadi tidak dapat ditampilkan ulang selamanya.
- C. Widget dirender di thread terpisah.
- D. `const` hanya memperindah kode tanpa efek performa apa pun.

### U07.4
Sebuah counter berubah dan menyebabkan seluruh halaman rebuild. Perbaikan yang tepat?

- **A. Memisahkan bagian yang membaca state ke `StatefulWidget`/builder kecil, dan menjadikan subtree statis `const`, sehingga hanya bagian yang membaca state yang rebuild.**
- B. Memindahkan seluruh state ke variabel global.
- C. Memanggil `setState` dua kali agar sinkron.
- D. Menghapus `const` dari semua widget.

### U07.5
Alat yang tepat untuk memverifikasi widget mana yang benar-benar rebuild?

- **A. Flutter Inspector (mis. highlight repaint/rebuild) atau `debugPrint` pada `build` widget terkait.**
- B. `flutter analyze --verbose`
- C. `flutter clean`
- D. Membaca ukuran file APK.

### U07.6
Lint `avoid_print` aktif pada P07. Pengganti yang tepat untuk logging saat debug?

- **A. `debugPrint` (atau logger yang dapat dimatikan di release), karena `print` ikut terbawa ke build rilis.**
- B. Menghapus semua logging dan menonaktifkan lint.
- C. Menulis log ke `README.md`.
- D. `print` di dalam blok `try` saja.

### U07.7
Berkas mana yang **tidak boleh** di-commit ke repo tugas?

- **A. Keystore/signing key, `key.properties`, token API, dan `.env` berisi rahasia.**
- B. `pubspec.yaml`
- C. `analysis_options.yaml`
- D. Folder `test/`

### U07.8
Tidak sengaja meng-commit token API ke repo. Tindakan yang benar?

- **A. Cabut/rotasi token tersebut (anggap sudah bocor), lalu bersihkan dari riwayat dan pindahkan konfigurasi ke `--dart-define`/env yang tidak di-commit.**
- B. Cukup hapus barisnya di commit berikutnya; riwayat lama tidak masalah.
- C. Jadikan repo privat dan biarkan token tetap aktif.
- D. Ganti nama variabelnya agar tidak dikenali.

### U07.9
APK rilis terbentuk di lokasi mana?

- **A. `build/app/outputs/flutter-apk/app-release.apk`**
- B. `android/app/release.apk`
- C. `lib/build/app-release.apk`
- D. `build/release/apk/app.apk`

### U07.10
Saat live modification (mis. diminta menambah sorting berdasarkan prioritas), pendekatan yang paling tepat?

- **A. Ubah logika di service/domain, jalankan `flutter analyze` + `flutter test` untuk memastikan tetap hijau, lalu jelaskan perubahan dengan kata sendiri.**
- B. Menyalin solusi dari internet tanpa membaca, asal aplikasi jalan.
- C. Mengubah UI saja tanpa menyentuh logika, lalu klaim selesai.
- D. Menonaktifkan lint agar perubahan cepat lolos.

---

## 7. Catatan pemeliharaan

- Kunci ditandai **tebal**. Bila dokumen ini dibagikan ke mahasiswa, hapus penanda tebal terlebih dahulu, atau arahkan mahasiswa ke Moodle saja.
- Tiap kuis memakai soal **berbeda** dan terikat checkpoint sesi terkait; jangan memindahkan soal antar pertemuan tanpa mengecek prasyarat materi.
- Bila starter berubah (nama kelas/berkas), perbarui soal yang menyebut nama konkret: U04.7 (`TaskMapper`), U05.8 (`MockTaskApiClient`), U06.7 (`LocalAttachmentService`), U07.9 (path APK).
- Untuk semester berikutnya, buat variasi setara dengan mempertahankan **kompetensi yang diuji per nomor**, bukan teks soalnya.
