# P14 — Performance Optimization & Production Prep

> Pertemuan 14 • Sub-CPMK53.2 • Modul: [Performance Optimization](https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/13-performance-optimization)

Starter: lab performa — `Column` naif vs `ListView.builder` + `itemExtent`, beban komputasi di build, badge penghitung rebuild.

## Cara mulai

```bash
flutter create --platforms=android,ios,web .
flutter pub get
flutter run --profile   # ukur di mode profile, BUKAN debug
```

Profil dengan DevTools (terbuka otomatis / `dart devtools`): tab **Performance** → Performance Overlay + frame chart. Mode debug menampilkan angka menyesatkan — selalu `--profile`.

## Checkpoints

| # | Tugas | Validasi |
|---|---|---|
| 1 | Bandingkan mode naive vs builder pada 3000 item: frame timing saat scroll + penggunaan memori | Catat: builder jauh lebih halus |
| 2 | Hapus `itemExtent` lalu bandingkan lagi — catat pengaruhnya pada scroll lompat jauh (scroll anchor) | Catatan singkat di README-mu |
| 3 | Optimasi `HeavyRow` (TODO P14-1): keluarkan `expensiveLabel` dari build (cache di field / hitung di tempat data dibuat) | Frame rata-rata turun; badge rebuild tetap naik |
| 4 | Tambah `const` pada widget statis (appBar title, ikon) — jelaskan kenapa `const` memotong rebuild | Penjelasan 3-4 baris: canonical instance |

## Catatan

- Urutan dampak terbesar di Flutter UI: (1) kerja berat keluar dari build, (2) list virtualisasi (`builder` + `itemExtent`), (3) `const` & minimasi scope rebuild, (4) `cacheExtent` untuk prefetch.
- `MediaQuery.of(context)` di widget besar membuat SEMUA widget itu rebuild tiap perubahan (mis. keyboard muncul) — ambil bagian spesifik (`sizeOf`, `textScalerOf`) bila tersedia.
- Pertemuan ini bertepatan gate **G4 (Rilis)** — profiling DevTools adalah bagian dari gate.
