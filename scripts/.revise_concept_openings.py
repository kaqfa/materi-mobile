#!/usr/bin/env python3
"""Sisipkan pengantar konseptual minimal pada modul dan slide PPB.
Idempotent: berhenti bila penanda tambahan sudah ada.
"""
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def insert_before(path: str, marker: str, addition: str, guard: str) -> None:
    p = ROOT / path
    text = p.read_text()
    if guard in text:
        print(f"SKIP {path}: sudah ada")
        return
    if marker not in text:
        raise RuntimeError(f"marker tidak ditemukan: {path}: {marker[:70]!r}")
    p.write_text(text.replace(marker, addition.rstrip() + "\n\n" + marker, 1))
    print(f"OK   {path}")


# --- MODUL ---
insert_before(
    "modul-buku/03-flutter-fundamentals.md",
    "Cara klasik membangun UI di Android native bersifat imperatif:",
    """Sebelum membandingkan cara Flutter dan Android native menyusun UI, pegang definisi paling sederhananya: **widget adalah deskripsi tampilan**. `Text('Baca bab 3')` berarti "tampilkan teks ini", bukan objek layar yang kita ubah manual. Seluruh antarmuka Flutter dibangun dengan menyusun deskripsi kecil seperti ini menjadi widget tree. Ketika data berubah, Flutter meminta deskripsi baru dan menyelaraskan tampilan di layar.

```dart
Text(task.done ? 'Selesai' : task.title)
```

Contoh kecil itu juga menjelaskan mengapa pembahasan berikutnya memakai istilah *deklaratif*: kode menyatakan tampilan yang diinginkan dari data saat ini.""",
    "pegang definisi paling sederhananya: **widget adalah deskripsi tampilan**",
)

insert_before(
    "modul-buku/05-material-design-implementation.md",
    "Material 3 (M3) aktif sebagai tampilan bawaan Flutter sejak versi 3.16.",
    """**UI design** mengatur tampilan agar pengguna memahami prioritas, aksi yang tersedia, dan keadaan aplikasi. **Material Design** adalah sistem desain dari Google yang memberi aturan bersama untuk warna, tipografi, bentuk, komponen, gerak, dan aksesibilitas. Di Flutter, aturan itu hadir melalui widget Material dan tema aplikasi.

Contoh paling sederhana adalah tombol simpan:

```dart
FilledButton(
  onPressed: saveTask,
  child: const Text('Simpan'),
)
```

Tombol itu sudah membawa ukuran sentuh, state saat ditekan, semantik dasar, dan warna dari tema. Karena itu pembahasan Material 3 dimulai dari sistem yang mengatur komponen, bukan dari memilih warna satu per satu.""",
    "**UI design** mengatur tampilan agar pengguna memahami prioritas",
)

insert_before(
    "modul-buku/05-material-design-implementation.md",
    "## Checkpoint 2: Layout yang Mengikuti Ruang",
    """## Responsif dan Adaptif: Mulai dari Ruang yang Tersedia

**Layout responsif** mempertahankan susunan dasar sambil menyesuaikan ukuran, jarak, atau jumlah kolom terhadap ruang yang tersedia. **Layout adaptif** mengubah struktur interaksi ketika ruangnya cukup berbeda. Pada ponsel, detail tugas dapat dibuka sebagai layar baru; pada tablet, daftar dan detail dapat tampil berdampingan.

```dart
// Responsif: komponen sama, lebarnya dibatasi.
ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 600),
  child: TaskCard(task: task),
)

// Adaptif: struktur layar berubah.
return isWide ? const TaskTwoPane() : const TaskListScreen();
```

Pegangan untuk dua checkpoint berikutnya: responsif mengubah ukuran dan susunan kecil; adaptif dapat mengubah struktur layar. Keduanya dimulai dari pertanyaan yang sama, berapa ruang yang benar-benar diterima widget?""",
    "## Responsif dan Adaptif: Mulai dari Ruang yang Tersedia",
)

insert_before(
    "modul-buku/06-advanced-ui-custom-widgets.md",
    "Setiap custom widget yang Anda tulis adalah API kecil bagi pemakainya",
    """**Custom widget** adalah widget buatan sendiri yang membungkus susunan widget lain menjadi komponen bernama. Tujuannya bukan membuat jenis UI yang terpisah dari Flutter, tetapi memberi nama dan batas yang jelas pada pola yang sering dipakai.

```dart
class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
```

Setelah diberi nama, komponen itu dipakai seperti widget bawaan: `const CategoryChip(label: 'Kuliah')`. Ini berguna ketika StudyTracker mulai mengulang chip kategori, label tenggat, kartu tugas, dan pemilih prioritas di beberapa layar. Data masuk melalui parameter, kejadian keluar melalui callback; detail tampilannya tinggal di satu tempat.""",
    "**Custom widget** adalah widget buatan sendiri",
)

insert_before(
    "modul-buku/07-state-management-shared-preferences.md",
    "Solusinya strukturnya sederhana diucapkan:",
    """Sebelum melihat implementasinya, definisikan dua peran yang akan dipakai. **`ChangeNotifier`** adalah objek yang menyimpan state dan mengirim pemberitahuan setelah state berubah. **Provider** menaruh objek itu di widget tree sehingga beberapa widget bisa menemukannya lewat `BuildContext`.

```dart
class CounterState extends ChangeNotifier {
  int value = 0;

  void increment() {
    value++;
    notifyListeners();
  }
}
```

`context.watch<CounterState>()` membaca sekaligus mendengarkan perubahan, sedangkan `context.read<CounterState>()` mengambil objek untuk menjalankan aksi tanpa ikut mendengarkan. Contoh kecil ini belum menyelesaikan Tracker, tetapi menunjukkan pembagian tugasnya: notifier menyimpan dan memberi tahu; Provider menyebarkan aksesnya.""",
    "definisikan dua peran yang akan dipakai. **`ChangeNotifier`**",
)

insert_before(
    "modul-buku/10-offline-first-sqlite.md",
    "Penggabungan yang dilakukan dengan asal punya tiga penyakit klasik",
    """**Offline-first** berarti aplikasi membaca dan menulis ke penyimpanan lokal lebih dahulu, lalu memakai jaringan untuk menyamakan data. Ini berbeda dari sekadar menyimpan cache hasil unduhan: pengguna tetap boleh membuat, mengubah, dan menghapus data ketika jaringan tidak tersedia.

Contoh perilakunya mudah diamati. Saat mode pesawat aktif, pengguna menambah tugas. Tugas langsung muncul dan tetap ada setelah aplikasi dibuka ulang. Ketika koneksi pulih, aplikasi mengirim perubahan itu ke server tanpa meminta pengguna mengulang pekerjaannya. Janji sederhana inilah yang menuntut mekanisme sinkronisasi di sepanjang bab ini.""",
    "**Offline-first** berarti aplikasi membaca dan menulis ke penyimpanan lokal",
)

insert_before(
    "modul-buku/10-offline-first-sqlite.md",
    "## Checkpoint 1: Skema v3 dan OutboxStore",
    """## Dua Catatan yang Menjaga Niat Pengguna

Dua istilah akan terus muncul. **Outbox** adalah daftar operasi lokal yang sudah terjadi tetapi belum diterima server. **Tombstone** adalah penanda bahwa sebuah id sudah dihapus, supaya data lama dari server tidak menghidupkannya kembali.

```text
offline: tambah T1  -> tasks memuat T1, outbox memuat upsert T1
offline: hapus T1   -> tasks kosong, tombstone memuat T1, outbox memuat delete T1
online:  sinkron     -> kirim outbox, lalu tarik dan gabungkan data server
```

Outbox menyimpan niat "perubahan ini belum terkirim"; tombstone menyimpan niat "data ini memang sudah dihapus". Setelah arti keduanya jelas, tabel baru pada checkpoint berikutnya tidak lagi terlihat sebagai tambahan skema tanpa alasan.""",
    "## Dua Catatan yang Menjaga Niat Pengguna",
)

insert_before(
    "modul-buku/11-testing-quality-assurance.md",
    "Setelah menyelesaikan bab ini, Anda bisa:",
    """Bentuk paling kecil dari test adalah menjalankan satu perilaku lalu membandingkan hasilnya dengan harapan. Misalnya:

```dart
expect(Task.isTitleValid('ab'), isFalse);
```

Kalimat kodenya sederhana: "judul dua karakter tidak valid." Aturan itu sekarang menjadi spesifikasi yang bisa dijalankan ulang setiap kali kode berubah. Seluruh bab ini memperluas ide yang sama ke widget, penyimpanan, tampilan visual, dan perangkat, sambil memilih lingkungan uji yang biayanya sepadan dengan klaim yang dibuktikan.""",
    "Bentuk paling kecil dari test adalah menjalankan satu perilaku",
)

insert_before(
    "modul-buku/12-platform-features-device.md",
    "### Studi kasus: level baterai",
    """Dengan kata lain, **plugin adalah pembungkus platform channel yang sudah dikemas menjadi API Dart**. Ketika kode memanggil `ImagePicker().pickImage(...)`, kamera bukan dijalankan oleh Flutter. Plugin meminta Android atau iOS membuka alur kamera atau galeri, menunggu hasil sistem operasi, lalu mengembalikan jalur file ke Dart. Definisi ini penting: API plugin terlihat sederhana, tetapi izin, lifecycle, dan kemungkinan gagal tetap mengikuti aturan perangkat.""",
    "**plugin adalah pembungkus platform channel",
)

insert_before(
    "modul-buku/13-performance-optimization.md",
    "## Frame Budget: 16 ms Bukan Angka Suci",
    """## Frame dan Jank

Satu **frame** adalah satu gambar UI yang harus disiapkan aplikasi sebelum layar meminta gambar berikutnya. **Jank** terjadi ketika frame terlambat, sehingga scroll, animasi, atau respons sentuhan terasa tersendat.

Bayangkan daftar tugas sedang digulir dan satu frame membutuhkan 58 ms. Pada layar 60 Hz, aplikasi hanya punya sekitar 16,67 ms untuk menyiapkannya. Pengguna melihat hentakan karena beberapa kesempatan menggambar terlewat. Tugas profiling adalah menemukan tempat yang menghabiskan 58 ms itu, bukan menebak widget mana yang kelihatannya mahal.""",
    "## Frame dan Jank",
)

insert_before(
    "modul-buku/14-deployment-distribution.md",
    "Deployment sering diajarkan sebagai resep langkah",
    """Tiga istilah dipakai sepanjang bab ini. **Deployment** berarti menyiapkan build rilis yang layak dipasang pengguna. **Distribution** berarti menyalurkan build itu melalui jalur yang benar, misalnya internal testing, closed testing, atau production. **Signing** adalah tanda tangan digital yang membuktikan bahwa pembaruan berasal dari pemilik aplikasi yang sama.

Ketiganya terhubung. File `.aab` yang berhasil dibuat belum tentu bisa menjadi pembaruan: package name harus sama, versi harus naik, dan tanda tangannya harus cocok dengan versi yang sudah terpasang. Definisi ini menjadi peta untuk pembahasan build, kunci, Play Console, dan rollout berikutnya.""",
    "Tiga istilah dipakai sepanjang bab ini. **Deployment**",
)

# update tanggal buku karena perubahan berarti pada banyak bab
index = ROOT / "modul-buku/index.md"
text = index.read_text()
if "updateDate: 2026-09-29" not in text:
    text = text.replace("updateDate: 2026-09-13", "updateDate: 2026-09-29", 1)
    index.write_text(text)
    print("OK   modul-buku/index.md")

print("SELESAI modul")
