# Starter UTS 20261 — HRIS Mini (Pengajuan Cuti)

Starter code untuk ujian praktik UTS Pemrograman Mobile. Aplikasi internal
**HRIS mini** yang menampilkan daftar pengajuan cuti karyawan beserta tipe,
status, dan rentang tanggalnya. Tap kartu untuk membuka layar detail.

## Menjalankan

```bash
flutter pub get
flutter run -d chrome        # mode web
# atau (Android emulator):
flutter run -d <device-id>
```

Folder platform belum disertakan — buat sekali dengan
`flutter create . --platforms=android,web`. Tanpa package pihak ketiga.

## Struktur

```
lib/
├── main.dart                          # entry point + HrisApp
├── theme/app_theme.dart               # tema Material 3 (card, chip, tombol)
├── models/leave_request.dart          # model LeaveRequest + enum LeaveType, LeaveStatus
├── utils/date_format.dart             # format tanggal & durasi cuti
├── screens/
│   ├── leave_list_screen.dart         # layar daftar pengajuan
│   └── leave_detail_screen.dart       # layar detail pengajuan
└── widgets/
    ├── leave_card.dart                # kartu pengajuan (tap → detail)
    ├── status_chip.dart               # chip status
    ├── employee_avatar.dart           # avatar inisial (Hero)
    └── leave_visuals.dart             # ikon & warna per tipe/status
```

## Verifikasi awal

- `flutter analyze` → 0 issue
- `flutter test` → 1 test hijau
