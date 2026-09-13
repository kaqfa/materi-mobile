# P06 — Advanced UI & Custom Widgets

> Pertemuan 6 • Sub-CPMK92.1 • Modul: [Advanced UI & Custom Widgets](https://classroom.fahrifirdaus.my.id/book/pemrograman-flutter/06-advanced-ui-custom-widgets)

Starter: pustaka widget reusable (TaskCard + PriorityIndicator + CategoryChip + ProgressSummary), expandable details, dialog konfirmasi, latihan animasi implisit.

## Cara mulai

```bash
flutter create --platforms=android,ios,web .
flutter pub get
flutter run
```

## Checkpoints

| # | Tugas | Validasi |
|---|---|---|
| 1 | Tambahkan `Dismissible` swipe-to-delete (TODO P06-1) | Swipe kiri → konfirmasi → item hilang |
| 2 | Fade saat selesai: `AnimatedOpacity` pada judul (TODO P06-2) | Toggle → judul memudar 300 ms, tanpa jeda |
| 3 | Progres bar animatif: `TweenAnimationBuilder` (TODO P06-3) | Rasio berubah → bar bergerak halus |
| 4 | Core-logic manual: tulis ulang `_confirmDelete` versimu dari nol (tanpa copilot) — lalu jelaskan tiap baris ke teman sebangku | Bisa menjelaskan kenapa pakai `Future<bool>` bukan `bool` |

## Catatan

- Callback (`onToggle`, `onDelete`) = arah data satu jalur: parent punya data, child hanya melapor.
- Animasi implisit (AnimatedXxx/TweenAnimationBuilder) cukup untuk transisi state sederhana; animasi eksplisit (AnimationController) dibahas di modul.
- Latihan P06-4 tergolong rezim "tulis manual" — latih refleks menulis kode, bukan menyusun prompt.
