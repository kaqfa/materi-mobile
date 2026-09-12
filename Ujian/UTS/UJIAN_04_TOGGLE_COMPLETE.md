# Ujian Praktik: Toggle Task Completion

## Informasi Ujian
- **Waktu Pengerjaan**: 20 menit
- **Tingkat Kesulitan**: Low-Medium
- **Bobot**: 100 poin
- **File yang Dimodifikasi**:
  - `lib/features/tasks/screens/task_list_screen.dart`
  - `lib/features/tasks/widgets/task_card.dart`

---

## Deskripsi Tugas

Anda diminta menambahkan **fitur toggle completion status** pada task card yang memungkinkan user untuk menandai task sebagai completed atau incomplete langsung dari task list.

Saat ini user hanya bisa melihat status task, tapi tidak bisa mengubahnya. Dengan fitur ini, user dapat dengan cepat mark task sebagai done atau un-mark jika ternyata belum selesai, tanpa perlu masuk ke detail screen.

---

## Requirements

### 1. UI Component
Tambahkan **interactive element** di `TaskCard` untuk toggle completion. Pilih salah satu:
- **Checkbox**: Di kiri atau kanan task card
- **IconButton**: Icon checkmark yang bisa di-tap
- **Circular checkbox**: Seperti todo apps pada umumnya

**Placement**:
- Harus jelas visible di task card
- Tidak mengganggu tap gesture untuk navigate ke detail
- Recommended: Di leading (kiri) atau trailing (kanan) task card

### 2. Visual Feedback
**Ketika task completed** (`isCompleted = true`):
- Checkbox/icon menunjukkan state "checked"
- Task title harus memiliki **strikethrough** (sudah ada di code existing)
- Task card bisa memiliki opacity lebih rendah atau warna lebih muted (opsional)

**Ketika task incomplete** (`isCompleted = false`):
- Checkbox/icon menunjukkan state "unchecked"
- Task title normal tanpa strikethrough
- Task card tampilan normal

### 3. Functionality
- **Tap** pada checkbox/icon harus **toggle** value `task.isCompleted`
- Perubahan harus **langsung terlihat** di UI (task card re-render dengan visual baru)
- Status badge di card harus **update** dari "Pending/Overdue" menjadi "Completed" atau sebaliknya
- Perubahan state harus **persist** selama session (tidak perlu save ke database/storage)

### 4. Interaction
- Toggle completion **tidak** trigger navigation ke detail screen
- Toggle action dan tap card untuk detail adalah **dua action berbeda**
- User harus bisa toggle tanpa accidentally navigate ke detail

### 5. User Feedback (Opsional Bonus +5 poin)
- Tampilkan **SnackBar** singkat ketika task di-complete atau un-complete
- Message: "Task marked as completed" atau "Task marked as incomplete"

---

## Batasan dan Ketentuan

### ✅ Yang Boleh Dilakukan:
- Modifikasi `TaskCard` widget untuk tambah checkbox/icon
- Tambah callback parameter di `TaskCard` untuk communicate ke parent
- Modifikasi `task_list_screen.dart` untuk handle state update
- Menggunakan `setState()` untuk update UI
- Menggunakan Flutter widgets: `Checkbox`, `IconButton`, `GestureDetector`, dll

### ❌ Yang Tidak Boleh Dilakukan:
- Mengubah `TaskModel` class (tetap immutable)
- Menambah package baru
- Save state ke database/storage (cukup in-memory)
- Mengubah existing navigation ke detail screen

---

## Kriteria Penilaian

| No | Aspek | Poin | Deskripsi |
|----|-------|------|-----------|
| 1 | **Toggle Functionality** | 35 | Toggle completion bekerja dengan benar, state berubah saat di-tap |
| 2 | **UI Implementation** | 25 | Checkbox/icon ditampilkan dengan baik, placement yang tepat, tidak ganggu UX |
| 3 | **Visual Feedback** | 20 | Visual state completed vs incomplete jelas (checked/unchecked, strikethrough updated) |
| 4 | **Parent-Child Communication** | 15 | Callback dari TaskCard ke parent screen bekerja dengan benar |
| 5 | **Code Quality** | 5 | Code clean, proper state management dengan setState() |
| **BONUS** | **SnackBar Feedback** | +5 | Menampilkan SnackBar informatif saat toggle |
| **TOTAL** | | **100** | **(+5 bonus)** |

---

## Expected Result

### Visual Example:

**Before Toggle (Incomplete):**
```
┌─────────────────────────────────────┐
│  ☐  Complete Math Assignment        │  ← Unchecked
│     Finish calculus homework...     │
│     📅 Oct 30  [High]  [Pending]    │
└─────────────────────────────────────┘
```

**After Toggle (Completed):**
```
┌─────────────────────────────────────┐
│  ☑  Complete Math Assignment        │  ← Checked + strikethrough
│     Finish calculus homework...     │
│     📅 Oct 30  [High]  ✓ Completed  │  ← Status updated
└─────────────────────────────────────┘
```

### Behavior Flow:
1. User membuka Task List → Melihat tasks dengan checkbox unchecked
2. User tap checkbox pada "Math Assignment" → Checkbox checked, title strikethrough, status badge berubah "Completed"
3. User tap checkbox lagi → Kembali unchecked, title normal, status kembali "Pending/Overdue"
4. User tap pada task card (bukan checkbox) → Navigate ke detail screen (existing behavior)

---

## Technical Guidance

### 1. TaskCard Modification
- `TaskCard` perlu menerima **callback function** sebagai parameter
- Callback akan dipanggil saat checkbox/icon di-tap
- Pass task.id atau index agar parent tahu task mana yang di-toggle

**Contoh signature (tidak harus sama persis):**
```dart
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onToggleComplete; // NEW parameter

  const TaskCard({
    required this.task,
    this.onToggleComplete, // NEW
  });
}
```

### 2. Parent State Management
- `TaskListScreen` harus maintain state `List<TaskModel>`
- Ketika callback dipanggil, update `isCompleted` field dari task yang bersangkutan
- Karena `TaskModel` kemungkinan immutable, perlu create instance baru dengan `copyWith()` atau recreate object

**Challenge**: TaskModel saat ini tidak punya `copyWith()` method. Anda perlu:
- Tambahkan method `copyWith()` di TaskModel, ATAU
- Recreate TaskModel object dengan parameter baru, ATAU
- Modifikasi list secara manual

### 3. Prevent Navigation Conflict
- Saat ini `TaskCard` dibungkus `InkWell` untuk navigation
- Checkbox di dalam InkWell akan trigger navigation juga
- **Solution**: Checkbox harus block tap propagation atau positioned outside InkWell

### 4. Widget Suggestions
- `Checkbox` widget: Standard Material checkbox
- `IconButton`: Dengan `Icons.check_circle` atau `Icons.circle_outlined`
- `GestureDetector`: Untuk custom tap handling

---

## Hints & Tips

1. **Callback Pattern**:
   - Child widget (TaskCard) tidak ubah state sendiri
   - Child hanya notify parent via callback
   - Parent yang update state dan rebuild child

2. **Finding Task to Update**:
   - Bisa pass task.id di callback
   - Bisa pass index dari list
   - Parent find task by id/index, then update

3. **TaskModel Immutability**:
   - Jika TaskModel immutable, tidak bisa langsung ubah field
   - Perlu create new instance dengan perubahan
   - `copyWith()` method sangat helpful untuk ini

4. **GestureDetector Behavior**:
   - `onTap` on checkbox should not trigger card tap
   - Use separate GestureDetector or prevent event bubbling

5. **Status Update**:
   - `task.status` adalah computed property dari `isCompleted` dan `dueDate`
   - Setelah toggle `isCompleted`, status akan auto-update
   - Tidak perlu manual update status

---

## Challenge Points

Yang perlu dipikirkan:
1. Bagaimana pass information dari child ke parent (callback with what parameter?)
2. Bagaimana update immutable object (TaskModel)?
3. Bagaimana prevent checkbox tap trigger card navigation?
4. Di mana place checkbox agar UX optimal?

---

## Submission

Pastikan sebelum mengumpulkan:
- ✅ Code dapat di-run tanpa error
- ✅ Toggle completion bekerja di semua tasks
- ✅ Visual feedback jelas (checked/unchecked, strikethrough)
- ✅ Status badge update otomatis
- ✅ Tap checkbox tidak trigger navigation ke detail
- ✅ Tap card area lain tetap navigate ke detail (existing behavior)
- ✅ Code clean dengan proper callback pattern

**Selamat Mengerjakan!** 🚀
