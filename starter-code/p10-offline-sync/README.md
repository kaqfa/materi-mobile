# P10 — Real-time Features & Advanced API Integration

> Pertemuan 10 • Sub-CPMK53.2 • Modul: [Offline-First & SQLite](https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/10-offline-first-sqlite)

Starter: SQLite lokal (`TaskDao`) + orkestrator sinkronisasi dua arah (`SyncService`) + server palsu in-memory untuk latihan pull/push/konflik tanpa jaringan.

## Cara mulai

```bash
flutter create --platforms=android,ios .
flutter pub get
flutter run
```

> Catatan: `sqflite` tidak berjalan di web — buat platform android/ios saja (plus `macos` bila ingin).

## Checkpoints

| # | Tugas | Validasi |
|---|---|---|
| 1 | Jalankan, tambah 2 tugas offline (lihat badge ⏳ pending), tekan Sinkronkan | Semua jadi ✓ synced; teks hasil sinkron muncul di snackbar |
| 2 | Implement pull (TODO P10-2): item `srv-1` dari server muncul lokal setelah sync | Item server tampil di list dengan status synced |
| 3 | Implement konflik LWW (TODO P10-3): panggil `debugServerSideEdit('srv-1', 'Diubah di server')` (mis. dari tombol debug) lalu edit item sama secara lokal, sync | Yang `updatedAt` lebih baru menang; `conflicts` terhitung |
| 4 | Nyalakan airplane mode, tambah tugas, sync gagal diam-diam — tambahkan try-catch + pesan gagal di `_syncNow` | Mode offline: app tetap usable, gagal sync ditampilkan jelas |

## Catatan

- Urutan sinkron: push dulu baru pull — mencegah data pending tertimpa versi lama dari server.
- Last-write-wins sederhana tapi bisa kehilangan edit; alternatif (field-level merge, queue operasi) dibahas di modul bab 10.
- Pemicu sync di app nyata: pulihnya koneksi, timer, aksi manual (tombol), dan langganan realtime server — starter ini manual; modul menunjukkan sisanya.
- Pertemuan ini bertepatan gate **G2 (Data)**.
