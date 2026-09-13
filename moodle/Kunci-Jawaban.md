# Kunci Jawaban — Quiz Unlock PPB 20251

> **Dokumen dosen.** Jangan diunggah ke ruang mahasiswa.
> Kunci selalu opsi pertama pada tabel di bawah; Moodle tetap mengacak urutan opsi saat attempt.

## P01 — Introduction to Mobile Development & Dart Fundamentals

| # | Kunci | Penjelasan |
|---|---|---|
| 1 | **App: StudyTracker** | Interpolasi `$nama` menyisipkan nilai variabel ke string. |
| 2 | **Memasang widget root** | `runApp` menempelkan widget paling atas ke layar sebagai akhir widget tree. |
| 3 | **pubspec.yaml** | pubspec.yaml adalah manifest dependensi; lock hanya hasil resolve. |
| 4 | **UI baru, state utuh** | Hot reload mempertahankan state bila struktur tree tidak berubah; hot restart yang meresetnya. |
| 5 | **lib/main.dart** | `lib/` adalah tempat seluruh kode Dart; folder platform hanya runner. |
| 6 | **Objek dipakai ulang** | Instance const dibuat sekali dan dipakai ulang — rebuild jadi murah. |
| 7 | **Toolchain bermasalah** | doctor memeriksa kesehatan toolchain; merah berarti ada komponen yang perlu diperbaiki. |
| 8 | **flutter pub get** | `pub get` me-resolve dan mengunduh dependensi baru. |
| 9 | **Error: null tak bisa** | `String` non-nullable menolak null; harus dideklarasikan `String?`. |
| 10 | **Kerangka halaman Material** | Scaffold menyediakan struktur halaman: AppBar, body, FAB, drawer, dll. |

## P02 — Dart Programming Deep Dive

| # | Kunci | Penjelasan |
|---|---|---|
| 1 | **Task(title: 'Belajar')** | Parameter named wajib diisi dengan label `title:`. |
| 2 | **null** | `?.` menghentikan akses saat penerima null — hasilnya null, bukan error. |
| 3 | **with** | Sintaks Dart: `class X extends Y with M`. |
| 4 | **A lalu B** | `await` menunda continuation sampai Future selesai — urutan tetap A dulu. |
| 5 | **tangkap lalu akhir** | `finally` selalu berjalan setelah blok try/catch selesai. |
| 6 | **Tamu** | `??` memberi nilai cadangan saat sisi kiri null. |
| 7 | **String → enum** | byName mencari anggota enum dari string — jembatan JSON ke enum. |
| 8 | **Objek lama tetap** | copyWith membuat salinan baru — model immutable tidak dimutasi. |
| 9 | **Dibungkus Future** | Fungsi async membungkus nilai kembalian ke Future. |
| 10 | **Default harus konstanta** | Nilai default parameter harus compile-time constant. |

## P03 — Flutter Fundamentals & Widget System

| # | Kunci | Penjelasan |
|---|---|---|
| 1 | **Build ulang dijadwalkan** | setState menandai State ini kotor sehingga build() dijadwalkan ulang. |
| 2 | **pop() di detail** | Future dari push selesai saat route di-pop dengan nilai. |
| 3 | **Item dibuat saat perlu** | builder membuat item secara lazy ketika mendekati viewport. |
| 4 | **Ikut dibangun ulang** | Stateless tidak punya state sendiri — selalu dibangun ulang oleh parent. |
| 5 | **Text pakai sisa ruang** | Expanded memberi anak sisa ruang sumbu utama — mencegah overflow. |
| 6 | **Sekali seumur State** | initState hanya sekali; perubahan berikutnya lewat build. |
| 7 | **Lewat constructor** | DetailScreen(task: task) — data eksplisit lewat parameter constructor. |
| 8 | **Hasil push jadi true** | Nilai pop menjadi hasil Future dari push yang di-await. |
| 9 | **Semua field final** | Constructor const butuh semua field final dan argumen const-able. |
| 10 | **Masih menunggu data** | connectionState belum done berarti Future masih berjalan — tampilkan loading. |

## P04 — Build System & Project Structure

| # | Kunci | Penjelasan |
|---|---|---|
| 1 | **>=6.1.2 <7.0.0** | Caret mengizinkan upgrade minor/patch dalam major yang sama. |
| 2 | **Di-commit agar stabil** | Lock yang di-commit menjamin semua anggota tim dapat versi sama persis. |
| 3 | **Isi pubspec + resolve** | pub add menulis dependensi ke pubspec.yaml lalu me-resolve-nya. |
| 4 | **Pemisahan tanggung jawab** | Tiap lapisan punya satu tanggung jawab — separation of concerns. |
| 5 | **Referensi terpusat** | Konstanta terpusat: anti typo, mudah rename, mudah dicari. |
| 6 | **Route tak ada di map** | Route yang tidak terdaftar di `routes` jatuh ke onGenerateRoute. |
| 7 | **Stabil, absolut dari lib/** | Import package absolut dari `lib/` tidak rusak saat file dipindah. |
| 8 | **assets: - images/** | Aset didaftarkan di `flutter: assets:` di pubspec.yaml. |
| 9 | **Aturan lint analyzer** | File ini mengatur aturan analisis statis (termasuk flutter_lints). |
| 10 | **Folder platform runner** | `flutter create .` menghasilkan folder android/ios/web dst tanpa menimpa lib dan test. |

## P05 — UI Design & Material Design Implementation

| # | Kunci | Penjelasan |
|---|---|---|
| 1 | **Palet turun satu warna** | fromSeed menurunkan seluruh palet Material 3 dari satu warna benih. |
| 2 | **Saat return null** | Validator mengembalikan null = tidak ada error; string = pesan error. |
| 3 | **Semua validator field** | `validate()` memicu seluruh validator form dan true hanya bila semua lolos. |
| 4 | **Future<DateTime?>** | Future selesai saat dialog ditutup; null bila user membatalkan. |
| 5 | **Semua opsi termasuk nilai** | items mendefinisikan seluruh opsi; `initialValue` harus termasuk di dalamnya. |
| 6 | **Hilang setelah user mengetik** | Hint hanya placeholder visual sebelum ada input. |
| 7 | **Konsisten + ikut tema app** | Style terpusat ikut berubah saat tema berubah — konsistensi otomatis. |
| 8 | **selected** | ChoiceChip memakai pasangan `selected` dan `onSelected`. |
| 9 | **Latar terisi vs polos** | FilledButton berlatar solid (primary container); TextButton hanya teks. |
| 10 | **Pakai lama, cadangan now** | `??` memakai _dueDate bila tidak null, kalau null pakai `now`. |

## P06 — Advanced UI & Custom Widgets

| # | Kunci | Penjelasan |
|---|---|---|
| 1 | **Child lapor ke parent** | Widget anak tidak mengubah data sendiri — ia melapor lewat callback. |
| 2 | **Ubah nilai opacity saja** | Widget animasi implisit (AnimatedOpacity) menganimasikan perubahan properti otomatis. |
| 3 | **Identitas item widget** | Saat item dihapus, Key menjaga Flutter melacak identitas sisa item dengan benar. |
| 4 | **Navigator.pop(dialog, true)** | Dialog di-pop dengan nilai; itu hasil Future-nya. |
| 5 | **Header ditekan user** | ExpansionTile membuka/collapse detail saat header di-tap. |
| 6 | **Nilai end berubah** | TweenAnimationBuilder menganimasikan dari nilai lama ke end baru setiap rebuild. |
| 7 | **Widget kecil dirangkai** | Komposisi widget kecil reusable = pilar custom widget library. |
| 8 | **Argumen semua const-able** | Semua argumen (termasuk callback yang di-hold variabel const) harus const. |
| 9 | **switch pada enum Priority** | Expression switch di atas enum memetakan tiap prioritas ke warna. |
| 10 | **Aksi destruktif tak sengaja** | Konfirmasi mencegah kehilangan data akibat tap/salindia yang tak disengaja. |

## P07 — Responsive Design & Adaptive Layouts

| # | Kunci | Penjelasan |
|---|---|---|
| 1 | **Constraint parent langsung** | LayoutBuilder membaca constraint dari parent — paling tepat untuk keputusan layout. |
| 2 | **Conditional layout** | Render berbeda berdasarkan kondisi lebar = conditional/adaptive layout. |
| 3 | **40.0** | 1000×0.04 = 40 — masih dalam rentang [12,48], clamp tidak mengubahnya. |
| 4 | **loose** | Flexible default loose (boleh lebih kecil); Expanded = Flexible tight. |
| 5 | **Lebar maks tiap kolom** | Grid menentukan jumlah kolom dari lebar tersedia dibagi batas extent ini. |
| 6 | **Rebuild luas tiap berubah** | Perubahan apa pun pada MediaQuery (mis. keyboard) membangun ulang seluruh subscriber. |
| 7 | **Jaga rasio anak widget** | AspectRatio memberi constraint anak sesuai rasio lebar:tinggi. |
| 8 | **Aman dari notch bar** | SafeArea menjauhkan konten dari notch, status bar, dan gesture area. |
| 9 | **Portrait, landscape, tablet** | RPS mensyaratkan minimal 3 konfigurasi: phone portrait, landscape, tablet. |
| 10 | **maxLines + ellipsis** | Batasi jumlah baris + ellipsis menjaga layout tetap utuh. |

## P09 — API Integration & HTTP Operations

| # | Kunci | Penjelasan |
|---|---|---|
| 1 | **Content-Type application/json** | Tanpa Content-Type: application/json, banyak server menolak/menganggap body plain text. |
| 2 | **201** | 201 Created adalah status sukses standar pembuatan resource. |
| 3 | **Login tapi tak berhak** | 403 = authenticated tapi forbidden; 401 = kredensial tidak valid. |
| 4 | **Future melempar exception** | Error pada Future ditangkap ke snapshot.hasError + snapshot.error. |
| 5 | **List<dynamic>** | jsonDecode menghasilkan dynamic; tiap elemen perlu di-cast ke Map. |
| 6 | **initState, simpan Future** | Init sekali di initState, hasilnya dibaca FutureBuilder — bukan fetch tiap build. |
| 7 | **Saat kompilasi saja** | dart-define bersifat compile-time; mengganti nilai = jalankan ulang build. |
| 8 | **apikey & Bearer token** | Supabase REST butuh apikey + Authorization Bearer (anon key / JWT user). |
| 9 | **Gagal jaringan vs bug** | Membedakan kegagalan HTTP yang bisa ditampilkan user dari bug kode. |
| 10 | **Future Function()** | onRefresh harus Future agar indikator tahu kapan refresh selesai. |

## P10 — Real-time Features & Advanced API Integration

| # | Kunci | Penjelasan |
|---|---|---|
| 1 | **Versi skema database** | Naikkan version + onUpgrade untuk migrasi skema berikutnya. |
| 2 | **SQL injection input** | Nilai terikat sebagai parameter, bukan digabung ke string SQL. |
| 3 | **updatedAt terbaru menang** | LWW membandingkan timestamp terakhir ubah di kedua sisi. |
| 4 | **Pending tak tertimpa lama** | Push dulu memastikan perubahan lokal tidak tertimpa versi lama server. |
| 5 | **Lokal sumber utama** | App bekerja penuh dari DB lokal; jaringan hanya untuk sinkronisasi. |
| 6 | **Belum terkirim server** | Pending = perubahan lokal yang menunggu diunggah. |
| 7 | **Baris lama ditimpa** | replace menimpa baris dengan PRIMARY KEY sama. |
| 8 | **Folder DB per platform** | Lokasi standar penyimpanan database tiap platform. |
| 9 | **Rotasi layar device** | Rotasi layar bukan pemicu data; pemicu: koneksi, manual, realtime. |
| 10 | **Insert lokal baru** | Item baru server disimpan lokal — itulah arah download pull. |

## P11 — Advanced State Management

| # | Kunci | Penjelasan |
|---|---|---|
| 1 | **Listener rebuild** | Semua widget yang listen (watch/Consumer) dijadwalkan rebuild. |
| 2 | **Aksi tanpa listen** | read untuk aksi sekali — tidak membuat widget berlangganan rebuild. |
| 3 | **child pra-build** | Bagian child yang tidak berubah bisa diteruskan turun dan tidak dibangun ulang. |
| 4 | **Rebuild granular** | Selector hanya rebuild saat nilai yang dipantau berubah. |
| 5 | **Lazy, saat pertama dibaca** | Provider default lazy — dibuat saat pertama ada yang listen/read. |
| 6 | **Di atas pemakai state** | InheritedWidget hanya bisa dicari ke ATAS tree — provider di atas konsumen. |
| 7 | **State lewat banyak lapis** | Tanpa provider, data dioper parent → child → grandchild berlapis-lapis. |
| 8 | **Bebas resource internal** | Bebaskan controller/stream sebelum objek dibuang. |
| 9 | **isSignedIn berubah** | Rebuild AuthGate saat status sesi berubah — render HomeScreen/LoginScreen. |
| 10 | **State lintas widget/screen** | State yang dibaca banyak tempat butuh satu sumber kebenaran terpusat. |

## P12 — Testing & Quality Assurance

| # | Kunci | Penjelasan |
|---|---|---|
| 1 | **Render widget di test frame** | pumpWidget memasang widget ke binding pengganti layar sungguhan. |
| 2 | **Imun ubah copywriting teks** | Teks UI sering berubah; Key sengaja dipasang untuk keperluan test. |
| 3 | **Bebas dependensi UI** | Tanpa dependensi UI/jaringan, test cepat dan deterministik. |
| 4 | **Red, green, refactor** | Tulis test gagal (red), buat lulus (green), rapikan (refactor). |
| 5 | **coverage/lcov.info** | lcov.info adalah laporan standar yang bisa dibaca alat coverage. |
| 6 | **Isolasi jaringan & DB** | Kontrak abstrak memungkinkan implementasi palsu saat test. |
| 7 | **(actual, matcher)** | Pola flutter_test: expect(nilaiAktual, pencocok). |
| 8 | **pump() proses frame** | pump memproses frame reaksi tap sebelum diperiksa. |
| 9 | **Sebelum tiap test** | setUp berjalan ulang per test — isolasi antar keadaan. |
| 10 | **Perbaiki kode produksi** | Test = spesifikasi; yang salah kode produksinya (pola starter P12). |

## P13 — Platform Features & Device Integration

| # | Kunci | Penjelasan |
|---|---|---|
| 1 | **null bukan error** | Pembatalan mengembalikan null — bukan kondisi error. |
| 2 | **AndroidManifest.xml** | Uses-permission dideklarasikan di AndroidManifest.xml. |
| 3 | **Arahkan ke settings** | Permintaan sistem tidak akan muncul lagi — user harus ubah di pengaturan. |
| 4 | **Kompresi hasil foto** | maxWidth + imageQuality mengecilkan foto sebelum disimpan/upload. |
| 5 | **Service, izin, posisi** | Cek GPS aktif → cek/minta izin → baru getCurrentPosition. |
| 6 | **String path file** | Simpan path; muat ulang via File(path) saat menampilkan. |
| 7 | **try-catch di service** | Panggilan picker dibungkus try-catch dengan pesan yang bisa ditindak user. |
| 8 | **Kamera atau galeri** | Source menentukan dari mana gambar diambil. |
| 9 | **latitude, longitude** | Position membawa koordinat geografis (dan akurasi/altitude). |
| 10 | **dart-define saat build** | Lewat --dart-define / .env tergitignore; jangan pernah hardcode. |

## P14 — Performance Optimization & Production Prep

| # | Kunci | Penjelasan |
|---|---|---|
| 1 | **Saat akan terlihat** | Virtualisasi: item dibuat mendekati viewport saja. |
| 2 | **Tinggi tetap per item** | Tinggi diketahui → layout & scroll-jump presisi tanpa mengukur tiap anak. |
| 3 | **Instansi dipakai ulang** | Instance const canonical — identik == tidak perlu dibuat ulang. |
| 4 | **Jank frame terlewati** | Build di UI thread; kerja berat melampaui budget frame = dropped frame. |
| 5 | **--profile** | Debug penuh assert/overlay menyesatkan; profile mendekati rilis. |
| 6 | **Pre-render di luar viewport** | Item dalam radius cacheExtent dibuat lebih awal — scroll mulus. |
| 7 | **Rebuild luas tiap berubah** | Keyboard muncul/hilang = MediaQuery berubah = seluruh subscriber rebuild. |
| 8 | **±16 ms** | 1000/60 ≈ 16,6 ms per frame. |
| 9 | **Kode tak terpakai** | Kode yang tidak terjangkau dihapus dari binary — termasuk font ikon tak terpakai. |
| 10 | **Grafik UI & raster** | Dua grafik thread: UI (build/layout) dan raster (painting). |

## P15 — Deployment & Distribution Strategies

| # | Kunci | Penjelasan |
|---|---|---|
| 1 | **Build number** | +N = build number; wajib dinaikkan tiap upload baru ke store. |
| 2 | **App Bundle (.aab)** | Play Store menerima .aab; APK di-generate oleh store. |
| 3 | **Buat simbol terpisah** | Obfuscate menyamarkan Dart; simbol disimpan terpisah untuk membaca crash. |
| 4 | **Di luar repo, gitignore** | Secret signing tidak boleh masuk repo — simpan aman di luar. |
| 5 | **Cabang kode produksi** | Guard log/hanya-rilis lainnya dengan kReleaseMode. |
| 6 | **Kumpulkan data pribadi** | Lokasi, kamera, akun = data pribadi → wajib kebijakan privasi. |
| 7 | **Uji sebelum rilis luas** | Rollout bertahap: internal → closed → open → produksi. |
| 8 | **Banner debug hilang** | Hanya menyembunyikan pita 'debug' — bukan mengubah mode build. |
| 9 | **Naikkan build number** | Store unik per build number — naikkan +N lalu rebuild. |
| 10 | **Baca stack crash release** | Tanpa simbol, stack trace obfuscated tak bisa diterjemahkan. |
