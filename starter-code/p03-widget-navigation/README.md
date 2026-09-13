# P03 — Flutter Fundamentals & Widget System

> Pertemuan 3 • Sub-CPMK53.1 • Modul: [Flutter Fundamentals](https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/03-flutter-fundamentals)

Starter: daftar tugas + navigasi list → detail. StatelessWidget (`TaskCard`) vs StatefulWidget (`TaskListScreen`), passing data via constructor & `Navigator.push`/`pop`.

## Cara mulai

```bash
flutter create --platforms=android,ios,web .
flutter pub get
flutter run
```

## Checkpoints

| # | Tugas | Validasi |
|---|---|---|
| 1 | Tambahkan `theme` di MaterialApp (lihat TODO di `main.dart`) | Warna app berubah |
| 2 | Ganti ikon leading `TaskCard` jadi `IconButton` interaktif (TODO P03-2) | Tap ikon di list langsung toggle, tanpa buka detail |
| 3 | Pahami alur `push`/`pop` di `_openDetail`: ubah `TaskDetailScreen` agar `pop` tanpa nilai (`Navigator.pop(context)`) | Setelah itu toggle dari detail tidak berefek — jelaskan kenapa |
| 4 | Error-First (di README ini, bagian bawah): perbaiki snippet overflow | Kode milikmu sendiri, tanpa overflow |

## Latihan Error-First (P03-4)

Snippet berikut sengaja rusak — overflow saat keyboard/layar kecil. Perbaiki dengan `Expanded`/`Flexible`:

```dart
// BUG: RenderFlex overflowed
Row(
  children: [
    Text('Status: '),
    Text('Belum selesai — panjang sekali sampai keluar layar'),
    Icon(Icons.info),
  ],
)
```

## Catatan

- Aturan praktis: mulai dengan StatelessWidget; naik ke StatefulWidget hanya saat ada state lokal yang berubah.
- `setState` memberi tahu Flutter "build ulang widget ini" — bandingkan dengan P11 (Provider) nanti.
