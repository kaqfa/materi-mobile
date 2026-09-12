# 06-Starter-Code, Starter Code Remedial Task Tracker

> **Status:** Scaffold v1.0, 2026-08-08
> **Cakupan:**
> - task-003: `p01-diagnosis`, `p02-ui-navigation`, `p03-provider-crud`.
> - task-007: `p04-sqlite`, `p05-api`, `API-CONTRACT.md`, `.env.example`.
> - task-011: `p06-testing-device`, `p07-release` (+ `p06/PERMISSIONS.md`, `p07/RELEASE-CHECKLIST.md`).

## Tujuan

Satu repo template berseragam untuk klinik remidi PPB. Mahasiswa **fork/copy** starter terbaru per pertemuan, bukan menyambung proyek lama. Tiap starter:

- Bisa menjalankan `flutter pub get` dan `flutter analyze` di environment target.
- Baseline P02 memiliki seluruh test hijau. P01/P03 sengaja memiliki test merah yang menjadi target diagnosis/TDD; setelah TODO checkpoint diselesaikan, `flutter test` harus hijau.
- **Tidak** menyelesaikan inti penugasan. Starter hanya memberi struktur, data dummy, konstanta, tema, dan **TODO terarah**.
- Punya README checkpoint dengan instruksi run dan target validasi.

## Struktur

```text
06-Starter-Code/
├── README.md # file ini
├── API-CONTRACT.md # kontrak REST P05 (endpoint, JSON, error)
├──.env.example # placeholder konfigurasi (BUKAN secret)
├── p01-diagnosis/ # diagnosis Dart/debugging: filter + search sengaja rusak
├── p02-ui-navigation/ # UI/layout/navigasi: TaskCard, list, navigasi TODO
├── p03-provider-crud/ # Provider + form + CRUD shell: TODO inti CRUD
├── p04-sqlite/ # SQLite offline-first: datasource/mapper/repository TODO
├── p05-api/ # REST + error type + mock fallback: TODO wiring provider
├── p06-testing-device/ # device feature (image picker + gallery fallback) + 3 unit + 2 widget test
└── p07-release/ # quality gate + const/rebuild basics + release checklist (no signing secret)
```

## Kontrak aplikasi (sama untuk semua starter)

```text
lib/
├── app.dart
├── main.dart
├── core/
│ ├── constants/ # AppColors, AppStrings
│ └── theme/ # AppTheme (Material 3)
└── features/tasks/
 ├── domain/ # Task, TaskStatus, TaskPriority, filter service
 └── presentation/
 ├── providers/ # TaskProvider (mulai P03)
 ├── screens/ # list, detail, add/edit
 └── widgets/ # TaskCard
test/ # unit + widget test
```

Model `Task` identik antar starter (field, enum, `copyWith`, `getDummyTasks`) supaya progres seragam dan P02/P03 melanjutkan P01.

## Dependency minimum (P01-P07)

| Package | Mulai | Catatan |
|--------------------|-------|-----------------------------------------------|
| `provider` | P03 | `ChangeNotifier` untuk CRUD reaktif |
| `sqflite` + `path` | P04 | persistence lokal SQLite |
| `sqflite_common_ffi` | P04 (dev) | test headless SQLite |
| `http` | P05 | REST client |
| `image_picker` | P06 | satu fitur device (gallery + camera fallback) |
| `flutter_lints` | semua | analisis statis (dev) |

`mocktail` opsional; P05 memakai fixture fallback sendiri, P06 memakai `LocalAttachmentService` lokal (tanpa package mock) agar headless test hijau.

## Versi Flutter/Dart

Versi kelas belum ditetapkan. Constraint `pubspec.yaml` sementara:

```yaml
environment:
 sdk: ^3.4.0
 flutter: ">=3.22.0"
```

**Pin versi setelah `flutter --version` mesin kelas diketahui** (lihat `00-Planning/Rencana-Modul-PPB-Remedial-7-Pertemuan.md` §11). Ubah constraint di tiap `pubspec.yaml` saat pinning.

## Cara memakai starter (mahasiswa)

1. Copy salah satu subfolder, mis. `p02-ui-navigation/`, ke workspace kosong.
2. Di dalam folder itu:
 ```bash
 flutter create --platforms=android,web. # hasilkan platform runner
 flutter pub get
 flutter run
 ```
 Folder platform (`android/`, `web/`, `ios/`, dll.) sengaja tidak disertakan; dibuat oleh `flutter create`.
3. Kerjakan TODO bertanda `// TODO(student):` dan ikuti README checkpoint.

## Verifikasi cepat (toolchain tersedia)

```bash
for d in p01-diagnosis p02-ui-navigation p03-provider-crud p04-sqlite p05-api p06-testing-device p07-release; do
 (cd "$d" && flutter pub get && flutter analyze && flutter test) || exit 1
done
```

Catatan: `p04-sqlite` tidak berjalan di web (target Android/test ffi). Lihat README subfolder.
Kontrak REST P05 ada di `API-CONTRACT.md`; konfigurasi endpoint lewat `--dart-define`.

## Catatan keamanan

- Tidak ada secret, token, atau endpoint eksternal hardcode di starter P01-P05.
- Base URL API hanya relevan di P05; lewat `--dart-define=API_BASE_URL=...` / `.env.example` (placeholder), bukan hardcode. Default kosong -> fallback mock/fixture.

## Solution reference

Tiap subfolder punya `solution-reference/README.md` **khusus dosen**. Isinya referensi pendekatan solusi + lokasi repo/tag privat lengkap. **Jangan dibagikan ke mahasiswa sebelum sesi selesai.**

## Status verifikasi host

Host produksi tidak punya Flutter/Dart SDK. Verifikasi runtime (`pub get`, `analyze`, `test`) ditangguhkan sampai SDK tersedia; lihat handoff di tiap README subfolder dan di `.pi-status/task-003.json` / `task-007.json` / `task-011.json`.
