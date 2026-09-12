# RELEASE-CHECKLIST, P07 (Remedial Task Tracker)

> Checklist rilis Android (di luar Play Store upload, dikecualikan planning §2).
> Tandai setiap langkah sebelum demo individual. **Jangan commit signing key.**

## 1. Quality gate (wajib hijau)

- [ ] `flutter --version` sesuai pin kelas; `flutter doctor` bersih.
- [ ] `flutter pub get` tanpa konflik versi.
- [ ] `flutter analyze` -> **No issues found!** (warning wajib diperbaiki atau dijelaskan di README).
- [ ] `flutter test` -> **All tests passed!** (unit P06 + widget P06 + smoke P07).
- [ ] Tidak ada `print()` di production (`avoid_print` aktif).

## 2. `const` & performa dasar

- [ ] `prefer_const_constructors` / `prefer_const_literals_to_create_immutables` aktif di `analysis_options.yaml`.
- [ ] Subtree immutable ditandai `const`.
- [ ] Flutter Inspector: tidak ada rebuild berlebih saat `setState` (verifikasi di `PerfDemoScreen`).
- [ ] `RepaintBoundary` dipakai hanya bila terbukti perlu (bukan default).

## 3. Build APK release

- [ ] `flutter build apk --release` sukses; APK ada di
 `build/app/outputs/flutter-apk/app-release.apk`.
- [ ] (Opsional) obfuscate symbols:
 ```bash
 flutter build apk --release --obfuscate --split-debug-info=build/symbols
 ```
 Simpan folder `build/symbols` di luar repo bila perlu deobfuscate crash.
- [ ] Ukuran APK dicatat di README (mis. `du -h app-release.apk`).
- [ ] APK terinstall di perangkat/emulator tanpa error `INSTALL_FAILED_*`.

## 4. Uji fungsional pada APK rilis

- [ ] App launch tanpa crash.
- [ ] CRUD task (P03) bekerja pada build release.
- [ ] Persistensi SQLite (P04) bertahan setelah kill + relaunch.
- [ ] API/mock + state error (P05): `simulateNetworkError` -> error view + Retry.
- [ ] Device attachment (P06): pick gallery -> tampil; tolak izin -> banner denied (bukan crash).
- [ ] `PerfDemoScreen` bump counter bekerja.

## 5. Keamanan & hygiene repo

- [ ] Tidak ada `*.jks`, `*.keystore`, `key.properties`, token, `.env` rahasia di repo.
- [ ] `.gitignore` mengecualikan signing material + secrets.
- [ ] `git status` bersih (tidak ada file debug/symbol tidak sengaja).
- [ ] Base URL API hanya lewat `--dart-define` / placeholder (P05); tidak hardcode.

## 6. Demo prep (Proyek Akhir)

- [ ] `README` final: cara run, arsitektur singkat, fitur, known limitation, bukti test, AI log.
- [ ] **Narasi Pemanfaatan AI** (1000-1500 kata) siap di README §7. *(Demo dilakukan tatap muka di sesi final.)*
- [ ] `05-Assessment/Bank-Live-Coding.md` + `Rubrik-Demo-dan-Wawancara.md` dibaca; siap live modification.
- [ ] Device fisik/emulator terhubung & APK rilis terinstall sebelum jadwal demo.

> **Bila salah satu gate gagal:** tunda demo. Gate hijau adalah prasyarat penilaian Proyek Akhir (planning §9).
