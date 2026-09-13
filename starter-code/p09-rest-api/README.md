# P09 — API Integration & HTTP Operations

> Pertemuan 9 • Sub-CPMK53.2 • Modul: [REST API Integration](https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/09-rest-api-integration)

Starter: lapisan API dengan dua implementasi — `RemoteTaskApiClient` (http, header Supabase-style, mapping status code) dan `MockTaskApi` (fallback kelas). UI: FutureBuilder + RefreshIndicator + loading/error state.

## Cara mulai

```bash
flutter create --platforms=android,ios,web .
flutter pub get
flutter run                       # mode mock (tanpa backend)

# dengan backend Supabase (ganti nilai milikmu):
flutter run --dart-define=API_BASE_URL=https://xxxx.supabase.co/rest/v1 \
            --dart-define=API_KEY=eyJ...anon-key...
```

Buat tabel `tasks` (id serial PK, title text, completed bool default false) + enable anonymous read/write di Supabase untuk latihan.

## Checkpoints

| # | Tugas | Validasi |
|---|---|---|
| 1 | Jalankan mode mock: add + delete lewat UI | SnackBar error muncul bila operasi gagal (ubah kode untuk memicu) |
| 2 | Uji `RemoteTaskApiClient.fetchTasks` ke Supabase-mu (lihat modul bab 9 untuk setup) | List tampil dari server |
| 3 | Ganti satu pesan `_messageFor` jadi salah (mis. 401 → 'OK'), lihat efeknya, kembalikan — lalu tulis di catatanmu kenapa pemetaan status code penting | Catatan singkat di README-mu |
| 4 | Tambahkan kolom `category` ke tabel + model + toJson/fromJson | Nilai baru tersimpan & tampil |

## Catatan

- `String.fromEnvironment` di-evaluasi saat kompilasi — mengganti nilai artinya hot restart tidak cukup, jalankan ulang `flutter run`.
- Aturan emas kredensial: dart-define lokal / file .env tergitignore — jangan pernah hardcode key lalu push.
- Pola `abstract TaskApi` di sini = dependency injection sederhana; dipakai lagi di P10 (sync) dan P12 (test dengan mock).
