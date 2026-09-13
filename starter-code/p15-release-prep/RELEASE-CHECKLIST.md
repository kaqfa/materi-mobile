# Release Checklist — StudyTracker / Capstone

Checklist sebelum meng-upload ke Play Store (atau distribusi internal).
Kerjakan berurutan; setiap butir punya bukti (link/screenshot) di CHANGELOG gate G4.

## 1. Kode & fungsi
- [ ] `flutter analyze` 0 issue
- [ ] `flutter test` hijau (coverage baris ≥ 70% bila jadi bagian gate)
- [ ] Tidak ada `print()` produksi (ganti `AppLogger`)
- [ ] Tidak ada API key/token di kode — hanya `--dart-define` / .env tergitignore
- [ ] Error reporting terpasang (P15-2) & teruji dengan crash uji

## 2. Identitas & metadata
- [ ] `applicationId` / bundle ID final (bukan com.example.*)
- [ ] Nama app, ikon (`flutter_launcher_icons`), splash screen
- [ ] `version: X.Y.Z+N` di pubspec — N naik tiap upload
- [ ] CHANGELOG ringkas untuk rilis ini

## 3. Build rilis
- [ ] Keystore dibuat & disimpan aman (jangan di-commit); `key.properties` tergitignore
- [ ] `flutter build appbundle --release --obfuscate --split-debug-info=build/symbols`
- [ ] Ukuran bundle dicatat; aset besar di-compress
- [ ] Uji install `.abb` via internal testing track (bukan langsung produksi)

## 4. Legal & listing
- [ ] Privacy policy URL (khususnya bila ada login/lokasi/foto)
- [ ] Deskripsi, screenshot (min. 2 layout layar berbeda), kategori
- [ ] Deklarasi penggunaan izin (kamera/lokasi) dijelaskan di listing

## 5. Pasca rilis
- [ ] Monitoring crash aktif (dashboard dicek minggu pertama)
- [ ] Rencana patch: bug kritis → hotfix PATCH segera
- [ ] Simpan `build/symbols` untuk de-obfuscate stack trace crash

## Perintah cepat

```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols
flutter build apk --release --split-per-abi   # hanya untuk distribusi langsung
```
