# P12 — Testing & Quality Assurance

> Pertemuan 12 • Sub-CPMK92.2 • Modul: [Testing & Quality Assurance](https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/11-testing-quality-assurance)

Starter: suite test unit (logika murni) + widget test (render & interaksi). Sebagian test **sengaja merah** — bug ada di `lib/`, bukan di test. Perbaiki `lib/` sampai hijau (TDD: red → green → refactor).

## Cara mulai

```bash
flutter create --platforms=android,ios,web .
flutter pub get
flutter test            # <- mulai MERAH (5 test gagal), itu tujuannya
flutter run             # app tetap jalan normal
```

## Checkpoints

| # | Tugas | Validasi |
|---|---|---|
| 1 | Perbaiki `Task.isTitleValid` (TODO P12-1) — tanpa mengubah test | 3 test validasi hijau |
| 2 | Perbaiki cabang `StatusFilter.open` di `TaskFilter.apply` (TODO P12-2) | Test filter hijau |
| 3 | Perbaiki `TaskCard` untuk tugas completed (TODO P12-3) | Widget test hijau |
| 4 | TDD: tulis 2 test BARU dulu untuk `sortByPriority` kasus prioritas sama (stabil), verifikasi merah/hijau sesuai ekspektasi, lalu refactor | Test baru hijau, lama tetap hijau |
| 5 | Coverage: `flutter test --coverage` lalu lihat `coverage/lcov.info` | Nilai coverage baris ≥ 70% untuk `lib/` |

## Catatan

- Hukum TDD starter ini: **test adalah spesifikasi** — bug ada di kode produksi, bukan di test.
- Widget test ≠ unit test: perlu `pumpWidget` + MaterialApp; interaksi memakai `tester.tap` + `pump()`.
- `Key` pada widget yang ingin diuji (`toggle-t1`) membuat test tahan terhadap perubahan teks UI.
- Mock dependency eksternal (API/DB) — pola `abstract TaskApi` dari starter P09 membuat ini mudah; lihat modul bab 11.
