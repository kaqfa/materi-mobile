# Starter UTS 20261 — Mini CRM (Sales Pipeline)

Starter code untuk ujian praktik UTS Pemrograman Mobile. Aplikasi internal
**Mini CRM** yang menampilkan daftar *lead* (calon nasabah) beserta tahap
(stage), nilai estimasi kontrak, dan prioritasnya.

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
├── main.dart                      # entry point + MiniCrmApp
├── theme/app_theme.dart           # tema Material 3
├── models/lead.dart               # model Lead + enum LeadStage, LeadPriority
├── screens/lead_list_screen.dart  # layar daftar lead
└── widgets/
    ├── lead_card.dart             # kartu lead
    ├── stage_chip.dart            # chip stage
    └── priority_indicator.dart    # indikator prioritas
```

## Verifikasi awal

- `flutter analyze` → 0 issue
- `flutter test` → 1 test hijau
