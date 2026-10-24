#!/usr/bin/env python3
"""Tambahkan slide konsep dasar sebelum trade-off/best practice."""
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def insert_before(path: str, marker: str, slide: str, guard: str) -> None:
    p = ROOT / path
    text = p.read_text()
    if guard in text:
        print(f"SKIP {path}: sudah ada")
        return
    if marker not in text:
        raise RuntimeError(f"marker tidak ditemukan: {path}: {marker!r}")
    p.write_text(text.replace(marker, slide.rstrip() + "\n\n---\n\n" + marker, 1))
    print(f"OK   {path}")


insert_before(
    "slides/P03-flutter-fundamentals.md",
    "## Imperatif vs deklaratif",
    """## Widget dalam satu menit

**Widget** adalah deskripsi bagian UI: teks, tombol, jarak, daftar, bahkan satu layar penuh.

```dart
Text('Baca bab 3')
```

Ketika data berubah, kita membuat deskripsi baru:

```dart
Text(task.done ? 'Selesai' : task.title)
```

<div class="note">

Flutter menyelaraskan deskripsi baru itu dengan tampilan. Inilah dasar gaya deklaratif yang kita bandingkan setelah ini.

</div>""",
    "## Widget dalam satu menit",
)

insert_before(
    "slides/P05-material-design.md",
    "## Material 3: sistem, bukan katalog warna",
    """## UI design dan Material Design

**UI design** mengatur tampilan agar pengguna memahami:

- apa yang penting,
- aksi apa yang tersedia,
- dan apa yang sedang terjadi.

**Material Design** memberi aturan bersama untuk warna, teks, bentuk, komponen, gerak, dan aksesibilitas.

```dart
FilledButton(
  onPressed: saveTask,
  child: const Text('Simpan'),
)
```

Tombol ini sudah membawa ukuran sentuh, state saat ditekan, semantik dasar, dan warna dari tema.""",
    "## UI design dan Material Design",
)

insert_before(
    "slides/P06-custom-widgets.md",
    "## Custom widget adalah API kecil",
    """## Custom widget dalam satu menit

**Custom widget** adalah widget yang kita buat sendiri dengan menggabungkan widget bawaan menjadi komponen bernama.

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

Dipakai seperti widget bawaan:

```dart
const CategoryChip(label: 'Kuliah')
```

Satu nama, satu tempat untuk mengubah tampilannya.""",
    "## Custom widget dalam satu menit",
)

insert_before(
    "slides/P07-responsive-design.md",
    "## `MediaQuery` — jendela ke fakta layar",
    """## Contoh paling kecil: kartu tugas yang sama

Satu `TaskCard`, dua jenis penyesuaian:

<div class="two-col">
<div>

**Responsif**

Kartu tetap satu kartu. Lebar, padding, dan jumlah baris teks mengikuti ruang.

```dart
ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 600),
  child: TaskCard(task: task),
)
```

</div>
<div>

**Adaptif**

Struktur berubah: daftar dan detail tampil berdampingan saat layar lebar.

```dart
return isWide
    ? const TaskTwoPane()
    : const TaskListScreen();
```

</div>
</div>

<div class="note">Responsif mengubah ukuran; adaptif dapat mengubah struktur.</div>""",
    "## Contoh paling kecil: kartu tugas yang sama",
)

insert_before(
    "slides/P10-offline-sync.md",
    "## Tiga penyakit penggabungan yang dilakukan asal",
    """## Offline-first dalam satu kalimat

**Offline-first** berarti aplikasi membaca dan menulis ke penyimpanan lokal lebih dahulu. Jaringan menyamakan data setelahnya.

Contoh di StudyTracker:

```text
mode pesawat aktif
→ tambah tugas
→ tugas langsung muncul
→ tutup dan buka aplikasi: tugas tetap ada
→ koneksi pulih: perubahan dikirim ke server
```

<div class="ok">

Pengguna tetap bisa bekerja tanpa jaringan dan tidak perlu mengulang pekerjaannya saat koneksi kembali.

</div>""",
    "## Offline-first dalam satu kalimat",
)

insert_before(
    "slides/P10-offline-sync.md",
    "## Skema v3: tiga tabel baru, migrasi tambah-saja",
    """## Outbox dan tombstone

Dua catatan kecil menjaga niat pengguna:

- **Outbox**: operasi lokal yang sudah terjadi tetapi belum diterima server.
- **Tombstone**: penanda id yang sudah dihapus agar tidak hidup lagi saat pull.

```text
offline: tambah T1 → tasks: T1, outbox: upsert T1
offline: hapus T1  → tasks: -, tombstone: T1, outbox: delete T1
online: sinkron    → kirim antrean, baru tarik data server
```

<div class="note">

Outbox menyimpan "belum terkirim"; tombstone menyimpan "memang sudah dihapus".

</div>""",
    "## Outbox dan tombstone",
)

insert_before(
    "slides/P11-state-management.md",
    "## Solusi strukturnya: pisahkan penyebaran dan pemberitahuan",
    """## Provider dalam contoh paling kecil

`ChangeNotifier` menyimpan state dan mengirim pemberitahuan:

```dart
class CounterState extends ChangeNotifier {
  int value = 0;

  void increment() {
    value++;
    notifyListeners();
  }
}
```

Provider menaruh objek itu di widget tree:

```dart
context.watch<CounterState>().value; // baca + dengarkan
context.read<CounterState>().increment(); // jalankan aksi
```

<div class="ok">Notifier menyimpan dan memberi tahu; Provider menyebarkan aksesnya.</div>""",
    "## Provider dalam contoh paling kecil",
)

insert_before(
    "slides/P11-state-management.md",
    "## Riverpod: provider sebagai grafik, bukan widget",
    """## Kenapa ada pustaka lain?

Provider cukup untuk StudyTracker hari ini. Masalah baru muncul ketika state saling bergantung:

```text
TaskProvider butuh user aktif dari AuthProvider
SyncProvider butuh antrean dari TaskProvider
SettingsProvider memengaruhi banyak layar
```

- **Riverpod** membuat dependency graph lebih eksplisit dan mudah ditukar saat test.
- **BLoC** memodelkan perubahan sebagai peristiwa, misalnya `TaskToggled` dan `SyncRequested`.

<div class="note">

Ini bukan tanda Provider buruk. Alat yang lebih berat baru layak dipakai ketika masalahnya ikut membesar.

</div>""",
    "## Kenapa ada pustaka lain?",
)

insert_before(
    "slides/P12-testing.md",
    "## Lima jenis test: satu tabel untuk memutuskan",
    """## Test dalam bentuk paling kecil

**Test** adalah kode yang menjalankan satu perilaku lalu membandingkan hasilnya dengan harapan.

```dart
expect(Task.isTitleValid('ab'), isFalse);
```

Kalimatnya: "judul dua karakter tidak valid".

<div class="note">

Model, widget, plugin, dan perangkat membutuhkan biaya pengujian yang berbeda. Setelah bentuk kecil ini jelas, kita memilih jenis test berdasarkan klaim yang ingin dibuktikan.

</div>""",
    "## Test dalam bentuk paling kecil",
)

# P13: setelah penjelasan channel dan sebelum PhotoService pertama.
insert_before(
    "slides/P13-platform-features.md",
    "## PhotoService — tipis, tapi tiga keputusan di dalamnya",
    """## Plugin adalah pembungkus channel

**Plugin Flutter** menyembunyikan percakapan Android/iOS di balik API Dart yang lebih nyaman.

```dart
final file = await ImagePicker().pickImage(
  source: ImageSource.camera,
);
```

Satu pemanggilan itu sebenarnya:

1. meminta sistem operasi membuka kamera,
2. menunggu pengguna selesai,
3. menerima jalur file kembali ke Flutter.

<div class="note">

API-nya ringkas, tetapi izin, lifecycle, dan kegagalannya tetap mengikuti aturan perangkat.

</div>""",
    "## Plugin adalah pembungkus channel",
)

insert_before(
    "slides/P14-performance.md",
    "## Mode profile, bukan debug, bukan emulator",
    """## Frame dan jank

**Frame** adalah satu gambar UI yang dikirim ke layar.

**Jank** terjadi ketika frame terlambat, sehingga scroll atau animasi terasa tersendat.

```text
layar 60 Hz → anggaran sekitar 16,67 ms per frame
satu frame daftar tugas selesai dalam 58 ms
→ beberapa kesempatan menggambar terlewat
→ pengguna melihat hentakan
```

<div class="ok">

Tugas profiling adalah menemukan tempat yang menghabiskan 58 ms itu, bukan menebak widget mana yang terlihat mahal.

</div>""",
    "## Frame dan jank",
)

insert_before(
    "slides/P15-deployment.md",
    "## Tiga mode build, satu tabel",
    """## Deployment, distribution, signing

- **Deployment**: menyiapkan build rilis yang layak dipasang pengguna.
- **Distribution**: menyalurkannya lewat internal test, closed test, atau store.
- **Signing**: tanda tangan digital yang membuktikan pembaruan berasal dari pemilik aplikasi yang sama.

Contoh: versi `1.0.1` hanya bisa menggantikan `1.0.0` jika package name sama, nomor versi naik, dan tanda tangannya cocok.

<div class="warn">

File `.aab` yang berhasil dibuat belum tentu dapat diperbarui, dipercaya perangkat, atau diterima Play Console.

</div>""",
    "## Deployment, distribution, signing",
)

print("SELESAI slide")
