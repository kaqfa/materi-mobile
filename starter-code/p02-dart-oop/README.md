# P02 — Dart Programming Deep Dive

> Pertemuan 2 • Sub-CPMK53.1 • Modul: [Dart Deep Dive](https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/02-dart-deep-dive)

Starter: model `Task` (OOP + null safety + mixin) + mock API async (Future, try-catch). UI hanya jendela observasi — fokus di `lib/models/task.dart`.

## Cara mulai

```bash
flutter create --platforms=android,ios,web .
flutter pub get
flutter run
flutter test   # <- mulai MERAH, itu memang tujuannya
```

## Checkpoints

| # | Tugas | Validasi |
|---|---|---|
| 1 | Kerjakan `TODO(student) P02-2..P02-4` di `lib/models/task.dart` (fromJson, isOverdue, copyWith) | `flutter test` hijau |
| 2 | Error-First: jalankan app, tap refresh berulang kali sampai error network muncul; lacah sumber throw di `TaskApiMock.fetchTasks` | Bisa menjelaskan kenapa UI tidak crash |
| 3 | Generate-Analyze-Improve: minta AI membuat class `StudySession` (durasi menit + mata kuliah), analisis, lalu tambahkan method `summary()` buatan sendiri | File baru + method jalan, tidak menyalin mentah keluaran AI |

## Catatan

- Tugas individu **P02 Dart OOP Challenge** dikerjakan terpisah dari starter ini — lihat brief di Moodle/`penugasan/individu/`. Rezim pembatasan AI berlaku untuk artefak yang dikumpulkan.
- `Priority.values.byName(...)` dipakai dari string JSON — perhatikan bagaimana enum & string dijembatani.
