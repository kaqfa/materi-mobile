# P07 — Responsive Design & Adaptive Layouts

> Pertemuan 7 • Sub-CPMK92.1 • Modul: [Material Design — Checkpoint Responsive](https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/05-material-design-implementation)

Starter: adaptive home (1 kolom → 2 kolom → master-detail) dengan breakpoint terpusat, dynamic padding, `Expanded`/`Spacer`, `AspectRatio`.

## Cara mulai

```bash
flutter create --platforms=android,ios,web .
flutter pub get
flutter run
```

## Uji 3 konfigurasi (syarat G1)

1. Phone portrait (mis. Pixel 7, 412×915)
2. Phone landscape — rotasi emulator
3. Tablet (mis. Pixel Tablet, 1280×800)

Juga coba: Settings > Display > Font size maksimum (uji `textScaler`).

## Checkpoints

| # | Tugas | Validasi |
|---|---|---|
| 1 | Jalankan 3 konfigurasi di atas, catat masalah (overflow? teks kecil?) | Catatan di README-mu sendiri |
| 2 | Font scaling: bungkus `Text` bermasalah dengan `maxLines` + ellipsis, atau turunkan `textScaler` HANYA pada widget dekoratif | Font besar → tidak overflow |
| 3 | Master-detail desktop (TODO P07-3): panel kiri list tetap, panel kanan detail | ≥1024px → dua panel tampil |

## Catatan

- `LayoutBuilder` = constraint dari parent (paling tepat untuk keputusan layout); `MediaQuery` = fakta layar (padding sistem, textScaler, orientasi).
- Breakpoint jangan angka ajaib di banyak tempat — pusatkan (lihat `utils/breakpoints.dart`).
- Pertemuan ini bertepatan gate **G1 (Fondasi)** — syarat: UI utuh + navigasi + 3 konfigurasi layar. Uji starter ini sebagai latihan.
