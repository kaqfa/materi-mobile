# Ujian 20261 — UTS Praktikum

Paket ujian praktik UTS Pemrograman Mobile (Flutter) semester 20261.

## Isi

| Topik | Starter code | Soal |
|---|---|---|
| Mini CRM — Sales Pipeline | `starter-code/mini_crm/` | `UTS/UJIAN_MINI_CRM.md` |
| HRIS Mini — Pengajuan Cuti | `starter-code/hris_mini/` | `UTS/UJIAN_HRIS_MINI.md` |

## Environment

- Flutter stable **3.47.x** · Dart **3.13.x**
- Starter **tidak menyertakan** folder `android/` dan `web/`, supaya tidak
  bentrok dengan versi Flutter/Gradle/AGP di lab. Mahasiswa membuatnya sendiri
  sekali di awal ujian:
  `flutter create . --platforms=android,web` (tidak menimpa `lib/` dan `pubspec.yaml`)
- Tanpa package pihak ketiga (hanya `cupertino_icons`)
- Kedua starter terverifikasi: `flutter analyze` 0 issue, `flutter test` hijau,
  dan `flutter run -d web-server` berhasil di-serve (HTTP 200) setelah
  folder platform dibuat.

## Alur ujian

1. Bagikan satu starter (zip) ke mahasiswa.
2. Bagikan soal markdown topik terkait.
3. Mahasiswa menjalankan `flutter create . --platforms=android,web` lalu
   `flutter pub get` di folder starter.
4. Waktu pengerjaan: **100 menit** (Selasa, 27 Okt 2026, 09.30 - 11.00,
   kelompok A11.4704, praktikum buka buku).
5. Mahasiswa menambah/mengubah fitur dari starter code yang sudah jalan.

Starter **tidak** menyelesaikan inti soal — fitur yang dinilai dibangun
mahasiswa selama ujian, sesuai panduan di file soal.
