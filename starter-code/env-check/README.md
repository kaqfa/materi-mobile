# Env Check — Verifikasi Lingkungan Flutter

Proyek ini punya satu tugas: membuktikan bahwa komputer Anda sanggup
menjalankan **seluruh** materi mata kuliah, dari bab 1 sampai bab 14, sebelum
perkuliahan dimulai. Kalau ada yang akan patah di minggu kesepuluh, lebih baik
patahnya sekarang, saat masih ada waktu memperbaikinya.

Cara kerjanya sederhana: aplikasi kecil yang memakai setiap paket yang dipakai
buku, lalu melaporkan mana yang hidup dan mana yang tidak.

## Menjalankannya

Prasyarat: Flutter stable **3.47 atau lebih baru** sudah terpasang dan ada di
PATH. Kalau belum, ikuti https://docs.flutter.dev/get-started/install dulu.

> Terverifikasi pada Flutter **3.47.4** / Dart **3.13.3** (Linux x86_64,
> 15 September 2026): `flutter pub get`, `flutter analyze` (0 issue), dan
> `flutter test` (21 test) semuanya hijau.

```bash
cd env-check

# Folder android/ dan ios/ sengaja tidak lengkap di repo; isi dari template:
flutter create --platforms=android,ios .

# Lalu jalankan verifikasinya:
bash tool/verify.sh
```

`flutter create` di atas **tidak** menimpa `AndroidManifest.xml` yang sudah ada
bila berkasnya sudah lengkap. Bila ia menimpanya, salin ulang tiga baris
permission dari bagian [Konfigurasi platform](#konfigurasi-platform) di bawah.

Skrip berhenti dengan kode keluar bukan-nol bila ada yang gagal, jadi ia juga
aman dipakai di CI.

## Dua lapisan pembuktian

Ada batas yang penting dipahami, dan ini persis batas yang dijelaskan bab 11.

**Lapisan pertama, di komputer Anda, tanpa perangkat.** `bash tool/verify.sh`
memeriksa toolchain, resolusi dependensi, analisis statis, dan seluruh unit
serta widget test. Di lapisan ini `sqflite` diuji lewat `sqflite_common_ffi`
dan `shared_preferences` lewat store dalam memori. Yang terbukti: paket-paket
saling kompatibel dan logikanya benar. Yang **belum** terbukti: plugin platform
benar-benar hidup di Android.

**Lapisan kedua, di emulator atau perangkat fisik.**

```bash
flutter test integration_test/
```

Di sinilah `flutter_secure_storage`, `image_picker`, dan `geolocator` benar-benar
dijalankan, karena hanya di perangkat channel platform-nya hidup. Lingkungan
baru boleh disebut siap setelah lapisan ini hijau.

Atau jalankan aplikasinya dan lihat hasilnya langsung:

```bash
flutter run
```

Aplikasi menjalankan seluruh pemeriksaan otomatis saat dibuka. Tombol salin di
pojok kanan atas menyalin laporan JSON, tempelkan itu bila Anda perlu bertanya
ke dosen atau asisten; laporannya menyebut persis probe mana yang gagal dan
dengan pesan apa.

## Apa saja yang diperiksa

| Probe | Paket | Bab |
| --- | --- | --- |
| Null safety, generics, records, pattern matching, async, stream, JSON | (bahasa Dart) | 1–2 |
| shared_preferences: tulis, baca, hapus | `shared_preferences` | 7 |
| Berkas di direktori dokumen | `path_provider`, `path` | 8 |
| SQLite: buka, migrasi v1→v2, transaksi | `sqflite` | 8, 10 |
| HTTP GET ke internet + decode JSON | `http` | 9 |
| Penyimpanan aman: simpan & hapus token | `flutter_secure_storage` | 9 |
| Status jaringan + listener perubahan | `connectivity_plus` | 10 |
| Plugin kamera/galeri ter-register | `image_picker` | 12 |
| Status layanan & izin lokasi terbaca | `geolocator` | 12 |

Selain paket, proyek ini juga melatih jalur yang sama dengan buku: Material 3
dengan `ColorScheme.fromSeed` (bab 5), custom widget (bab 6), `ChangeNotifier`
dengan Provider (bab 7), serta unit, widget, dan integration test (bab 11).

### Yang sengaja tidak diperiksa

Probe kamera dan lokasi **tidak meminta izin** dan tidak membuka kamera.
Meminta izin memunculkan dialog yang menunggu manusia menekan tombol, dan
pemeriksaan otomatis yang menggantung menunggu manusia bukan pemeriksaan
otomatis. Yang diperiksa adalah bahwa plugin ter-register dan channel-nya
menjawab, dan itulah bagian yang benar-benar bisa gagal saat build.

## Konfigurasi platform

**Android** (`android/app/src/main/AndroidManifest.xml`) hanya mendeklarasikan
apa yang benar-benar dipakai, sesuai aturan bab 4:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

Tidak ada `READ_EXTERNAL_STORAGE`, `READ_MEDIA_IMAGES`, maupun `CAMERA`: photo
picker Android berjalan di proses sistem, dan `image_picker` membuka kamera
lewat intent, jadi ketiganya memang tidak diperlukan.

**iOS** butuh tiga kunci penjelasan di `ios/Runner/Info.plist`. Isinya sudah
disiapkan di [ios/Runner/Info.plist.additions](ios/Runner/Info.plist.additions),
tinggal disalin masuk. Tanpa kunci ini aplikasi iOS crash saat fitur pertama
kali dipakai, bukan saat build.

Tidak ada satu pun angka SDK yang ditulis manual di mana pun. `compileSdk`,
`minSdk`, dan `targetSdk` mengikuti variabel template Flutter, sehingga
kebijakan Play (target API 36 sejak 31 Agustus 2026) dikejar lewat
`flutter upgrade`, bukan lewat menyunting berkas Gradle.

## Kalau ada yang gagal

Baca kolom bab pada probe yang gagal, lalu buka bab itu. Beberapa pola umum:

- **`flutter pub get` gagal** — ada konflik versi paket. Biasanya karena Flutter
  Anda lebih lama dari baseline; jalankan `flutter upgrade`.
- **Android toolchain merah di doctor** — jalankan
  `flutter doctor --android-licenses` lalu setujui semuanya. Bila Android SDK
  belum ada sama sekali, pasang Android Studio dan buka SDK Manager-nya.
- **Probe `http` gagal** — hampir selalu soal jaringan atau proxy, bukan kode.
  Coba `curl https://api.dart.dev/stable/index.json` dari terminal yang sama.
- **Probe `flutter_secure_storage` gagal di emulator lama** — pakai image
  emulator dengan API level yang lebih baru.
- **`integration_test` tidak jalan** — pastikan `flutter devices` menampilkan
  setidaknya satu perangkat sebelum menjalankannya.
- **`flutter test` gagal dengan `Member not found: 'arm64e'`** — ini bug
  `objective_c` 9.6.1 di Dart 3.13.x, ditarik masuk oleh `path_provider`
  untuk iOS/macOS. `pubspec.yaml` sudah mengunci versinya ke 9.4.1 lewat
  `dependency_overrides`; kunci itu boleh dihapus begitu paketnya diperbaiki.

## Struktur

```
lib/
  models/check_result.dart        satu hasil pemeriksaan
  services/probe.dart             kontrak probe + penangkap error
  services/probes_*.dart          probe per kelompok kemampuan
  services/environment_report.dart ChangeNotifier yang menjalankan semuanya
  ui/                             Material 3 + custom widget
test/unit/                        logika, sqflite via FFI, preferences in-memory
test/widget/                      pohon widget dengan probe stub
integration_test/                 probe sungguhan di perangkat sungguhan
tool/verify.sh                    pemeriksa toolchain dari terminal
```
