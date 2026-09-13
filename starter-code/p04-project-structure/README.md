# P04 — Build System & Project Structure

> Pertemuan 4 • Sub-CPMK92.1 • Modul: [Build System & Project Structure](https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/04-build-system-project-structure)

Starter: kerangka struktur folder + named routes + latihan manajemen dependensi. Dari pertemuan ini capstone dimulai (deklarasi proyek P04) — starter StudyTracker jadi pola acuan.

## Cara mulai

```bash
flutter create --platforms=android,ios,web .
flutter pub get
flutter run
```

## Checkpoints

| # | Tugas | Validasi |
|---|---|---|
| 1 | Aktifkan dependensi `http` di pubspec (uncomment), jalankan `flutter pub get`, lalu amati perubahan `pubspec.lock` | `flutter pub get` sukses; lockfile berisi `http` |
| 2 | Pindahkan `Task` + `TaskCard` + service statis dari starter P03 ke struktur folder ini (lihat placeholder) | App menampilkan list tugas di route `/tasks` |
| 3 | Tambahkan route `/tasks/new` (konstanta + onGenerateRoute) | `Navigator.pushNamed(context, '/tasks/new')` sampai ke screen baru |

## Capstone (paralel, dikumpulkan via Moodle)

Pertemuan ini juga mulai **capstone**: pilih domain (Local Business / EdTech / Health & Wellness), susun deklarasi proyek 1 halaman, dan rancang struktur folder. Tidak wajib memakai Flutter — tapi struktur `models/services/screens/widgets` di starter ini adalah pola pemisahan concern yang berlaku umum.

## Catatan

- Bedakan `pubspec.yaml` (keinginanmu, constraints) vs `pubspec.lock` (kompromi versi hasil resolve — di-commit untuk app).
- Mulai P04, rezim AI berubah: bebas dipakai di capstone, wajib dideklarasikan di CHANGELOG tiap gate.
