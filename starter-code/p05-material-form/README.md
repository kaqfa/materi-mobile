# P05 — UI Design & Material Design Implementation

> Pertemuan 5 • Sub-CPMK92.1 • Modul: [Material Design Implementation](https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/05-material-design-implementation)

Starter: theme terpusat + form tambah tugas (validasi, dropdown, date picker, chips).

## Cara mulai

```bash
flutter create --platforms=android,ios,web .
flutter pub get
flutter run
```

## Checkpoints

| # | Tugas | Validasi |
|---|---|---|
| 1 | Kustomisasi `AppTheme` (seed color, inputDecorationTheme, cardTheme) | Semua input tampil konsisten tanpa style manual per-widget |
| 2 | Tambahkan validator judul (wajib, ≥3 karakter) di form | Submit kosong → pesan error; tidak bisa pop dengan data kosong |
| 3 | Ganti teks prioritas menjadi `ChoiceChip` interaktif | Pilihan tersimpan di `_priority`, terlihat di list |
| 4 | Buat filter bottom sheet kategori (IconButton di AppBar) | Filter benar-benar memengaruhi list |

## Catatan

- Aturan konsistensi: warna dari `colorScheme`, teks dari `textTheme`, spacing seragam — bukan angka acak per screen.
- Aksesibilitas: label + `Semantics`/semanticLabel untuk ikon; kontras teks cukup ( Accessibility guidelines di modul).
- Form screen mengembalikan `Task` via `Navigator.pop` — pola yang sama dengan P03, kini dengan data hasil form.
