# Starter Code — Pemrograman Mobile (Flutter) 20251

Starter code per pertemuan untuk kuliah Pemrograman Mobile. Reference app: **StudyTracker** (task/study tracker) — dibangun bertahap, konsisten dengan modul di `../modul-buku/`.

## Cakupan

| Folder | Pertemuan | Topik (RPS) | Dependensi tambahan |
|---|---|---|---|
| `p01-hello-flutter/` | P01 | Setup env, project pertama, struktur project, pubspec | — |
| `p02-dart-oop/` | P02 | Dart OOP: class, constructor, mixin, null safety, async | — |
| `p03-widget-navigation/` | P03 | Widget tree, stateless/stateful, ListView, `Navigator.push` | — |
| `p04-project-structure/` | P04 | Build system, pubspec, struktur folder, named routes | (komentar, diaktifkan bertahap) |
| `p05-material-form/` | P05 | Material Design: ThemeData, form, validasi, date picker | — |
| `p06-custom-widgets/` | P06 | Custom widget reusable, komposisi, animasi dasar | — |
| `p07-responsive/` | P07 | MediaQuery, LayoutBuilder, breakpoint, adaptive layout | — |
| `p09-rest-api/` | P09 | REST API: http, CRUD, header, status code, loading state | `http` |
| `p10-offline-sync/` | P10 | SQLite lokal, sinkronisasi offline-first, conflict resolution | `sqflite`, `path`, `http` |
| `p11-provider-state/` | P11 | State management: ChangeNotifier, Provider, Consumer/Selector | `provider` |
| `p12-testing/` | P12 | Unit & widget test, TDD, coverage | — (`flutter_test`) |
| `p13-device-features/` | P13 | Kamera/galeri, lokasi, permission handling | `image_picker`, `geolocator` |
| `p14-performance/` | P14 | Profiling, const constructor, ListView optimization | — |
| `p15-release-prep/` | P15 | Release build, obfuscation, checklist deployment | — |

P08 (UTS) dan P16 (UAS) tidak punya starter — lihat `../Ujian/UTS/`.

## Kontrak starter

- **Tanpa folder platform** (`android/`, `ios/`, `web/`, …) — dihindari agar repo ringan dan tidak menyimpan file Gradle yang cepat usang. Mahasiswa membuatnya sendiri sekali di awal (lihat bawah).
- Lolos `flutter pub get` dan `flutter analyze` (0 issue) dalam keadaan awal.
- Tidak menyelesaikan inti praktikum: inti ada di penanda `// TODO(student)` + README checkpoint per starter.
- Model `Task` seragam antar starter (field, enum `Priority`) supaya progres bisa dibawa antar pertemuan.
- Test sengaja merah pada starter tertentu (`p02`, `p12`) — setelah TODO selesai, `flutter test` hijau.

## Cara memakai (mahasiswa)

```bash
# 1. Copy salah satu subfolder ke workspace kosong, lalu di dalamnya:
flutter create --platforms=android,ios,web .
# 2. Ambil dependensi:
flutter pub get
# 3. Jalankan:
flutter run
```

> `flutter create .` menghasilkan folder platform sesuai mesin masing-masing dan tidak menimpa file `lib/`, `pubspec.yaml` (field utama dipertahankan), maupun `test/` milik starter. Jika `flutter create` menimpa `test/widget_test.dart` bawaan, biarkan — test milik starter ada di berkas lain.

## Distribusi

Starter **tidak dibagikan via link repo** — di-zip per pertemuan lewat `../moodle/pack_starters.py` dan diunggah ke Moodle sebagai File. Tiap zip terkunci sampai mahasiswa lulus quiz pertemuan sebelumnya (≥ 80%); starter P01 terbuka sejak awal. Detail: `../moodle/README.md`.

## Verifikasi (dosen/assistants)

```bash
for d in p0*/ p1*/; do
  (cd "$d" && flutter pub get && flutter analyze) || exit 1
done
```

Baseline: Flutter stable 3.38.x, Dart ^3.4.0, `flutter_lints` ^4.

## Relasi ke modul

Tiap README starter menautkan bab modul terkait di <https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/>. Pemetaan pertemuan ↔ bab ada di `../README.md`.
