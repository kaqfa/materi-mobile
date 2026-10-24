# Starter UTS 20261 — HRIS Mini (Pengajuan Cuti)

Starter code untuk ujian praktik UTS Pemrograman Mobile. Aplikasi internal
**HRIS mini** yang menampilkan daftar pengajuan cuti karyawan beserta tipe,
status, dan rentang tanggalnya.

## Menjalankan

```bash
flutter pub get
flutter run -d chrome        # mode web
# atau (Android emulator):
flutter run -d <device-id>
```

Platform **web** dan **android** sudah dibuat via `flutter create`. Tanpa
package pihak ketiga.

## Struktur

```
lib/
├── main.dart                          # entry point + HrisApp
├── theme/app_theme.dart               # tema Material 3
├── models/leave_request.dart          # model LeaveRequest + enum LeaveType, LeaveStatus
├── screens/leave_list_screen.dart     # layar daftar pengajuan
└── widgets/
    ├── leave_card.dart                # kartu pengajuan
    └── status_chip.dart               # chip status
```

## Verifikasi awal

- `flutter analyze` → 0 issue
- `flutter test` → 1 test hijau
