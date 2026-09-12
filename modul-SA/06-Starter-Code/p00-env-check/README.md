# p00-env-check, Environment Checker

> **Pra-P01**, fokus: bukti otomatis bahwa seluruh library & device feature PPB Remidi (P01-P07) jalan di mesin mahasiswa. **Bukan aplikasi nyata**: yang penting tiap dependency ter-import, ter-panggil, dan menampilkan status OK/GAGAL/SKIP.

## Tujuan

Sebelum P01, mahasiswa wajib memastikan laptop + device siap. `Checklist-Environment.md` hanya berisi perintah manual (`flutter doctor`, `pub get`, `analyze`, `test`). Proyek ini menjadi **bukti otomatis**: satu screen menjalankan smoke test tiap library dan melaporkan hasilnya. Kalau semua OK/SKIP, toolchain + plugin siap tempur.

## Library yang diuji

| # | Library | Yang dibuktikan | Status smoke |
|---|---------|-----------------|--------------|
| 1 | `provider` | `ChangeNotifier` + `notifyListeners`; `watch`/`read` aktif via UI | OK penuh |
| 2 | `sqflite` + `sqflite_common_ffi` | open DB, create table, insert, query (in-memory); native di Android/iOS, FFI di desktop/test | OK penuh |
| 3 | `http` | GET 200 ke `https://jsonplaceholder.typicode.com/todos/1` | OK (butuh koneksi) |
| 4 | `image_picker` | plugin ter-construct + handler platform terdaftar | SKIP (uji ambil foto nyata di P06) |
| 5 | `geolocator` | location service on/off + status permission (non-interaktif) | OK penuh |
| 6 | `path` + `path_provider` | `p.join`/`p.basename` + `getTemporaryDirectory`/`getApplicationDocumentsDirectory` | OK penuh |

> Catatan istilah: tugas awal menyebut `path` untuk `getTemporaryPath`/`getApplicationDocumentsPath`. Fungsi itu sebenarnya di `path_provider`. Proyek menguji keduanya agar jelas bedanya.

## Instruksi run

```bash
# 1. Resolve dependency
flutter pub get

# 2. Analisis statis
flutter analyze

# 3. Widget smoke harus hijau
flutter test

# 4. Jalankan (butuh emulator/device aktif)
flutter run
```

> Folder `android/` dan `web/` **sudah disertakan** di repo. Jangan jalankan `flutter create` — perintah itu bisa menimpa `android/app/src/main/AndroidManifest.xml` yang sudah berisi permission `INTERNET` dan lokasi, sehingga check `http` dan `geolocator` jadi gagal.

Saat aplikasi terbuka, tekan **Run all checks** di kanan atas. Tunggu hingga semua item `done`. Baca hasil tiap baris (OK/GAGAL/SKIP + pesan).

## Interpretasi hasil

- **OK** = library ter-import dan dieksekusi sukses. Toolchain OK untuk library ini.
- **SKIP** = library ter-registrasi namun uji nyata butuh interaksi/device dan ditangguhkan ke pertemuan terkait (mis. `image_picker`  P06). SKIP **bukan** kegagalan.
- **GAGAL** = ada error. Baca pesan, lihat [Troubleshooting](#troubleshooting).

**Syarat hijau penuh:** semua item `done`, `FAIL = 0`. SKIP diizinkan.

## Struktur

```text
lib/
├── main.dart
├── app.dart                      # MaterialApp + ChangeNotifierProvider
├── core/{constants,theme}/       # AppColors, AppStrings, AppTheme
└── features/env_check/
    ├── domain/check_result.dart  # sealed CheckOk / CheckFail / CheckSkip
    └── presentation/
        ├── checks/               # 1 file smoke per library + all_checks.dart
        ├── providers/env_check_provider.dart  # ChangeNotifier state
        └── screens/env_check_screen.dart      # ListView + tombol Run
test/
└── widget_test.dart              # render smoke (tidak menyentuh plugin)
```

## Troubleshooting

### Umum
- **Tombol Run tidak bisa ditekan / muter terus?** Sedang running. Tunggu selesai; check berjalan berurutan.
- **`flutter pub get` gagal resolusi versi?** Pin versi Flutter/Dart kelas (lihat `06-Starter-Code/README.md`). Ubah caret di `pubspec.yaml` saat pinning.
- **Gagal install: `Requested internal only, but not enough space`?** Emulator kehabisan storage internal, bukan masalah kode. APK debug ~73 MB dan Android butuh ruang beberapa kali lipat saat install. Cek sisa ruang lalu bersihkan app lama:
  ```bash
  adb shell df -h /data          # lihat sisa ruang
  adb shell pm list packages -3  # daftar app pihak ketiga
  adb uninstall <nama.package>   # hapus app latihan lama
  ```
  Alternatif: wipe data emulator, atau perbesar internal storage AVD lewat AVD Manager.

### sqflite
- **GAGAL `dlopen failed: library "libsqlite3.so" not found`?** Artinya check memakai jalur FFI di Android. FFI hanya untuk desktop/test: di Android/iOS harus pakai `databaseFactory` bawaan `sqflite` (plugin native sudah membundel SQLite OS). Lihat `_factoryForPlatform()` di `lib/features/env_check/presentation/checks/sqlite_check.dart`. `flutter create`/`pub get` **tidak** memperbaiki error ini.
- **GAGAL "unable to load ffi" di desktop?** `sqflite_common_ffi` mengandalkan `libsqlite3` dari sistem. Di macOS/Linux umumnya sudah ada; kalau tidak, pasang paket `sqlite3` OS.

### http
- **GAGAL "Network error / SocketException"?** Cek koneksi internet, DNS, proxy kampus, atau firewall. Endpoint `jsonplaceholder.typicode.com` harus reachable. Tes manual: `curl -i https://jsonplaceholder.typicode.com/todos/1`.

### image_picker
- **SKIP itu normal.** Uji ambil foto/camera nyata dikerjakan di P06. Yang diuji di sini hanya registrasi plugin.
- **GAGAL registrasi?** Plugin native belum ter-link. Jalankan `flutter clean && flutter pub get`, lalu build ulang. Jangan pakai `flutter create` (lihat catatan di [Instruksi run](#instruksi-run)).

### geolocator
- **`permission=LocationPermission.denied` itu normal.** Check ini sengaja non-interaktif: hanya membaca status, tidak memunculkan dialog izin. Selama hasilnya OK, plugin sudah terbukti jalan.
- **`LocationService=false`?** Aktifkan GPS di perangkat/emulator. Check tetap OK (non-interaktif), namun nilai menunjukkan status nyata.
- Permission `ACCESS_FINE_LOCATION`/`ACCESS_COARSE_LOCATION` sudah dideklarasikan di `android/app/src/main/AndroidManifest.xml`. Kalau di-generate ulang dengan `flutter create`, pastikan tidak tertimpa.

### path + path_provider
- **GAGAL `MissingPluginException`?** Plugin belum ter-link ke build. Jalankan `flutter clean && flutter pub get`, lalu jalankan ulang (hot restart tidak cukup untuk plugin native baru).

## Catatan keamanan

- Tidak ada secret/token/credential di source.
- Endpoint HTTP hanya placeholder publik (`jsonplaceholder.typicode.com`) untuk membuktikan network stack. **Bukan** API kelas. Konfigurasi API kelas ada di P05 (`06-Starter-Code/API-CONTRACT.md`) via `--dart-define`, bukan hardcode.

## Yang TIDAK boleh diubah

- Tambah/hapus package baru selain yang sudah terdaftar di `pubspec.yaml`.
- Mengganti endpoint dengan URL internal/ber-token.

## Status verifikasi

Terverifikasi pada Flutter 3.38.7 stable (macOS, emulator Android API 36):

| Langkah | Hasil |
|---------|-------|
| `flutter analyze` | 1 info (`prefer_const_constructors` di `http_check.dart`, false positive: argumen string interpolasi runtime) |
| `flutter build apk --debug` | ✓ sukses |
| `flutter test` | ✓ hijau |
| Runtime di emulator | **OK 5, FAIL 0, SKIP 1** (SKIP = `image_picker`, by design) |
