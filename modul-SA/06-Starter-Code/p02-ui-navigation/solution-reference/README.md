# Solution Reference, p02-ui-navigation

> **KHUSUS DOSEN. Jangan dibagikan ke mahasiswa sebelum sesi P02 selesai.**

## Lokasi solusi lengkap

Repo/tag privat dosen: `solution/p02`. File ini ringkasan pendekatan.

## Navigasi yang diharapkan

`task_list_screen.dart`:

```dart
void _openDetail(Task task) {
 Navigator.of(context).push(
 MaterialPageRoute<void>(
 builder: (_) => TaskDetailScreen(task: task),
 ),
 );
}

Future<void> _addTask() async {
 final created = await Navigator.of(context).push<Task>(
 MaterialPageRoute<Task>(builder: (_) => const AddTaskScreen()),
 );
 if (created != null) {
 setState(() => _tasks = [..._tasks, created]);
 }
}
```

## Titik pengajaran

- `Navigator.push` + `MaterialPageRoute`; kembalikan nilai via `pop<T>`.
- Reusable widget (`TaskCard`) menerima `onTap`, tidak mengelola state sendiri.
- Responsive: `LayoutBuilder` + breakpoint sederhana; `GridView` untuk layar lebar.

## Catatan

Form sungguhan untuk add/edit dituntaskan di P03 bersama Provider & validasi.
Di P02, stub `AddTaskScreen` cukup mengembalikan task contoh untuk menguji alur.
