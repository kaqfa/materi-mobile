# Checklist Environment, PPB Remidi 7 Pertemuan

> **Status:** v1.0, 2026-08-08
> **Aplikasi jangkar:Remedial Task Tracker**
> **Tujuan:** memastikan environment siap sebelum P01. Jalankan sekali di awal, ulang bila ada masalah.

## 0. Cara pakai

Jalankan setiap perintah pada terminal di mesinmu. Centang hanya bila hasil sesuai "Expected". Jika gagal, lihat "Troubleshooting" di bawah sebelum lanjut. Semua command dijalankan dari root proyek starter yang diberikan dosen.

## 1. Instalasi dasar

| # | Item | Perintah / cara | Expected |
|---|---|---|---|
| 1 | Flutter SDK terpasang | `flutter --version` | Cetak versi Flutter + Dart; tidak ada error |
| 2 | Editor + plugin | buka VS Code / Android Studio | Flutter & Dart plugin aktif |
| 3 | Git terpasang | `git --version` | Cetak versi git |

> **Catatan versi**: dosen akan menetapkan Flutter/Dart version kelas dan mem-pin dependency setelah diverifikasi di mesin target. Sebelum itu, pakai versi stabil terbaru dan catat di sini: `Flutter: ______` / `Dart: ______`.

## 2. `flutter doctor`

```bash
flutter doctor -v
```

- [ ] Tidak ada error pada baris **Flutter**, **Android toolchain**, dan **Connected device**.
- [ ] Untuk membangun Android: **Android SDK** + **license** accepted (`flutter doctor --android-licenses` bila diminta).
- [ ] Editor (VS Code/Android Studio) terdeteksi (info, bukan blocker utama).
- [ ] Tidak ada peringatan **Chrome/web** yang menghalangi (web tidak dipakai; abaikan bila hanya info).

**Expected:** `[]` (atau minimal tidak ada `[]`) pada Flutter, Android toolchain, Connected device.

## 3. Ambil dependency

```bash
flutter pub get
```

- [ ] Perintah selesai tanpa error.
- [ ] Tidak ada konflik versi dependency (`provider`, `sqflite`, `path`, `http`, `image_picker`).

**Expected:** `Got dependencies!` (atau pesan sukses setara).

## 4. Analisis statis

```bash
flutter analyze
```

- [ ] Hasil: `No issues found!` **atau** hanya info/peringatan yang sudah dijelaskan di README.
- [ ] Tidak ada error tingkat `error`.

**Expected:** keluar tanpa `error`.

## 5. Tes otomatis

```bash
flutter test
```

- [ ] Semua tes lulus.
- [ ] Tidak ada tes gagal atau crash.

**Expected:** `All tests passed!` (atau `+N -0`).

## 6. Perangkat / emulator

Pilih salah satu jalur Android:

### 6a. Emulator (AVD)
- [ ] AVD dibuat via Android Studio -> Device Manager / `flutter emulators --create`.
- [ ] Jalankan: `flutter emulators --launch <emulator_id>`.
- [ ] `flutter devices` mencantumkan emulator sebagai **connected device**.

### 6b. Perangkat fisik
- [ ] **Developer options** + **USB debugging** aktif.
- [ ] Hubungkan via USB (atau debugging nirkabel); otorisasi komputer di perangkat.
- [ ] `flutter devices` mencantumkan perangkat.

**Run sanity check:**
```bash
flutter run
```
- [ ] Aplikasi starter terpasang dan tampil di perangkat/emulator.
- [ ] Hot reload (`r`) dan hot restart (`R`) bekerja.

**Expected:** aplikasi berjalan tanpa crash.

## 7. Pemeriksaan device feature (untuk Proyek Akhir)

Karena Proyek Akhir memerlukan `image_picker` (kamera/gallery), cek kemampuan perangkat sejak awal:

- [ ] Perangkat/emulator punya kamera **atau** galeri yang dapat dipakai.
- [ ] Bila tidak ada kamera: rencanakan **gallery picker + permission/error branch** sebagai fallback (sah menurut rubrik).

## 8. Troubleshooting

| Gejala | Perbaikan |
|---|---|
| `flutter doctor` `[]` Android license | `flutter doctor --android-licenses`, terima semua. |
| `flutter doctor` SDK tidak ditemukan | Set `ANDROID_HOME` / `flutter` di PATH; restart terminal. |
| `flutter pub get` konflik versi | Hapus `pubspec.lock`, jalankan ulang; laporkan ke dosen bila tetap. |
| `flutter analyze` banyak error setelah `pub get` | Jalankan `dart format.` lalu `flutter clean && flutter pub get`. |
| `flutter test` gagal pada starter | Jangan lanjut; anggap environment belum siap. Lapor dosen. |
| Emulator tidak muncul di `flutter devices` | Restart AVD; cek HAXM/KVM; pakai perangkat fisik sebagai fallback. |
| Perangkat fisik `unauthorized` | Cabut/colok USB, otorisasi dialog "Allow USB debugging". |
| `flutter run` hang di "Waiting for connection" | Pastikan satu perangkat aktif; `flutter devices` dulu. |
| Kamera tidak berfungsi di emulator | Konfigurasi kamera di AVD, atau pakai fallback gallery. |

## 9. Sign-off

Sebelum P01, semua nomor 1-6 tercentang. Tandatangani:

- Nama: ____________________
- NIM/NPM: ____________________
- Tanggal: ____________________
- `flutter --version` tercatat: ____________________
- Perangkat yang dipakai: ____________________

Environment yang tidak lolos checklist ini **tidak boleh** dipakai untuk mengerjakan tugas; selesaikan dulu sebelum sesi dimulai.
