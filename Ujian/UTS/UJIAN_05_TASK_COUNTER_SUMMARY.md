# Ujian Praktik: Task Counter Summary

## Informasi Ujian
- **Waktu Pengerjaan**: 20 menit
- **Tingkat Kesulitan**: Low-Medium
- **Bobot**: 100 poin
- **File yang Dimodifikasi**: `lib/features/tasks/screens/task_list_screen.dart`

---

## Deskripsi Tugas

Anda diminta menambahkan **summary section** di bagian atas Task List yang menampilkan statistik ringkasan tasks berdasarkan status mereka.

Saat ini user harus scroll dan hitung manual untuk mengetahui berapa banyak tasks yang overdue, pending, atau completed. Summary section ini memberikan overview cepat tentang status tasks user dalam satu pandangan.

---

## Requirements

### 1. Summary Information
Tampilkan **4 counter metrics** berikut:
- **Total**: Total semua tasks
- **Pending**: Jumlah tasks dengan status `TaskStatus.pending`
- **Overdue**: Jumlah tasks dengan status `TaskStatus.overdue`
- **Completed**: Jumlah tasks dengan status `TaskStatus.completed`

### 2. Visual Design
Summary bisa ditampilkan dalam salah satu format berikut (pilih yang menurut Anda paling baik):

**Option A: Horizontal Card/Row**
```
┌────────────────────────────────────────────┐
│  📊  5 Total  •  2 Pending  •  1 Overdue  •  2 Done  │
└────────────────────────────────────────────┘
```

**Option B: Grid of Small Cards**
```
┌──────────┬──────────┬──────────┬──────────┐
│    5     │    2     │    1     │    2     │
│  Total   │ Pending  │ Overdue  │   Done   │
└──────────┴──────────┴──────────┴──────────┘
```

**Option C: Chips/Badges**
```
[5 Total]  [2 Pending]  [1 Overdue]  [2 Done]
```

Requirements:
- Summary harus ditempatkan **di atas task list** (antara AppBar dan ListView)
- Setiap metric harus memiliki **label jelas** (Total, Pending, Overdue, Completed/Done)
- Gunakan **icons** yang sesuai (opsional tapi recommended)
- Gunakan **colors** yang sesuai dengan status colors di `AppColors`

### 3. Dynamic Update
- Counter harus **auto-update** ketika:
  - Task deleted (via swipe dismiss)
  - Task completion toggled (jika sudah implement fitur toggle - opsional)
  - Data tasks berubah
- Counter harus **accurate** dan realtime

### 4. Color Scheme
Gunakan warna yang konsisten dengan app theme:
- **Total**: Primary color atau neutral (`AppColors.primary` atau `AppColors.outline`)
- **Pending**: `AppColors.statusPending`
- **Overdue**: `AppColors.statusOverdue`
- **Completed**: `AppColors.statusCompleted`

### 5. Empty State
- Jika **tidak ada tasks** (`tasks.isEmpty`), summary bisa:
  - Tidak ditampilkan (hidden), ATAU
  - Tetap tampil dengan semua counter = 0

---

## Batasan dan Ketentuan

### ✅ Yang Boleh Dilakukan:
- Membuat widget method baru di `_TaskListScreenState` untuk render summary
- Menggunakan helper methods untuk calculate counters
- Menggunakan Flutter layout widgets: `Row`, `Column`, `GridView`, `Wrap`, `Card`, dll
- Menggunakan icons dari `Icons` class
- Menggunakan colors dari `AppColors`

### ❌ Yang Tidak Boleh Dilakukan:
- Mengubah `TaskModel` class atau enum
- Menambah package baru
- Hardcode counter values (harus calculated dari data)
- Mengubah struktur data tasks

---

## Kriteria Penilaian

| No | Aspek | Poin | Deskripsi |
|----|-------|------|-----------|
| 1 | **Counter Logic** | 35 | Semua 4 counters (Total, Pending, Overdue, Completed) menghitung dengan benar |
| 2 | **UI Implementation** | 30 | Summary section ditampilkan dengan baik, layout rapi, mudah dibaca |
| 3 | **Color Usage** | 15 | Menggunakan warna yang sesuai dengan status colors dari AppColors |
| 4 | **Dynamic Update** | 10 | Counter update otomatis saat data berubah (misal: setelah delete) |
| 5 | **Icons/Labels** | 5 | Menggunakan icons yang appropriate dan labels yang jelas |
| 6 | **Code Quality** | 5 | Code clean, menggunakan helper functions untuk calculate counters |
| **TOTAL** | | **100** | |

---

## Expected Result

### Visual Example (Grid Style):

```
┌─────────────────────────────────────┐
│          My Tasks            🔍     │
├─────────────────────────────────────┤
│  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐│
│  │  5  │  │  2  │  │  1  │  │  2  ││  ← Summary counters
│  │Total│  │Pend │  │Over │  │Done ││
│  └─────┘  └─────┘  └─────┘  └─────┘│
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │ Complete Math Assignment    │   │
│  │ ...                         │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ Read History Chapter 3      │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Visual Example (Horizontal Card Style):

```
┌─────────────────────────────────────┐
│          My Tasks            🔍     │
├─────────────────────────────────────┤
│ ╔═════════════════════════════════╗ │
│ ║ 📊 5 Total • 2 Pending • 1 Over ║ │  ← Summary card
│ ║         • 2 Completed           ║ │
│ ╚═════════════════════════════════╝ │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │ Complete Math Assignment    │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## Technical Guidance

### 1. Calculate Counters
Anda perlu calculate 4 values dari `List<TaskModel> tasks`:

```dart
// Pseudocode - bukan code lengkap!
int total = tasks.length;
int pending = // count tasks where status == TaskStatus.pending
int overdue = // count tasks where status == TaskStatus.overdue
int completed = // count tasks where status == TaskStatus.completed
```

**Hint**: Gunakan `.where()` dan `.length`

### 2. Layout Structure
Untuk place summary di atas ListView, structure-nya bisa seperti:

```dart
// Pseudocode structure
Column(
  children: [
    _buildSummary(),    // Summary section (NEW)
    Expanded(
      child: _buildTaskList(), // Existing ListView
    ),
  ],
)
```

Atau gunakan `ListView` dengan header item.

### 3. Color Application
Setiap counter bisa punya background color (light) dan text color (dark):
- Pending: bg = `statusPendingLight`, text = `statusPending`
- Overdue: bg = `statusOverdueLight`, text = `statusOverdue`
- Completed: bg = `statusCompletedLight`, text = `statusCompleted`

### 4. Widget Suggestions
- **Container**: Untuk card/box individual counter
- **Row/Column**: Untuk layout counters
- **GridView.count**: Untuk grid layout (4 columns)
- **Wrap**: Untuk flexible horizontal layout
- **Card**: Untuk elevation effect

### 5. Icons Suggestions
- Total: `Icons.assessment`, `Icons.list_alt`, `Icons.dashboard`
- Pending: `Icons.schedule`, `Icons.pending`
- Overdue: `Icons.warning`, `Icons.error_outline`
- Completed: `Icons.check_circle`, `Icons.done_all`

---

## Hints & Tips

1. **List Operations**:
   ```dart
   // Count items with condition
   int count = list.where((item) => condition).length;
   ```

2. **Responsive Grid**:
   - `GridView.count(crossAxisCount: 4)` untuk 4 columns
   - Atau `Row` dengan `Expanded` untuk equal width

3. **Padding & Spacing**:
   - Berikan padding yang cukup agar tidak cramped
   - Gunakan `SizedBox` untuk spacing antar elements

4. **Text Style**:
   - Number bisa bold & larger
   - Label bisa smaller & lighter

5. **Testing Counter Logic**:
   - Coba delete task, pastikan counter berkurang
   - Cek apakah total = pending + overdue + completed

---

## Challenge Points

Yang perlu dipikirkan:
1. Bagaimana calculate count untuk setiap status dengan efisien?
2. Layout mana yang paling user-friendly untuk 4 metrics?
3. Bagaimana integrate summary dengan existing ListView tanpa break layout?
4. Bagaimana pastikan counter update saat data berubah?

---

## Submission

Pastikan sebelum mengumpulkan:
- ✅ Code dapat di-run tanpa error
- ✅ Semua 4 counters (Total, Pending, Overdue, Completed) accurate
- ✅ Summary ditampilkan di atas task list
- ✅ Visual design clean dan readable
- ✅ Warna sesuai dengan status colors
- ✅ Counter update saat delete task
- ✅ Layout tidak broken di different screen sizes

**Selamat Mengerjakan!** 🚀
