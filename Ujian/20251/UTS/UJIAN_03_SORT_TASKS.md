# Ujian Praktik: Sort Tasks

## Informasi Ujian
- **Waktu Pengerjaan**: 30 menit
- **Tingkat Kesulitan**: Medium-Hard
- **Bobot**: 100 poin
- **File yang Dimodifikasi**: `lib/features/tasks/screens/task_list_screen.dart`

---

## Deskripsi Tugas

Anda diminta menambahkan **fitur sorting** pada halaman Task List yang memungkinkan user untuk mengurutkan tasks berdasarkan kriteria tertentu.

Saat ini tasks ditampilkan dalam urutan tetap (sesuai urutan dari dummy data). User membutuhkan fleksibilitas untuk melihat tasks berdasarkan urutan yang berbeda, misalnya tasks dengan deadline terdekat di atas, atau tasks dengan prioritas tinggi di atas.

---

## Requirements

### 1. Sort Options
Sediakan **minimal 4 pilihan sorting** berikut:
- **Due Date (Nearest First)**: Tasks dengan due date paling dekat ditampilkan di atas
- **Due Date (Farthest First)**: Tasks dengan due date paling jauh ditampilkan di atas
- **Priority (High to Low)**: Tasks dengan priority High → Medium → Low
- **Priority (Low to High)**: Tasks dengan priority Low → Medium → High

**Bonus** (opsional, +10 poin):
- **Title (A-Z)**: Alfabetis ascending
- **Title (Z-A)**: Alfabetis descending

### 2. UI Component
- Gunakan **Dropdown Menu** atau **PopupMenuButton** untuk menampilkan sort options
- Sort control harus ditempatkan di **AppBar** (bisa di actions atau di bagian lain yang accessible)
- Icon yang cocok: `Icons.sort`, `Icons.filter_list`, `Icons.swap_vert`
- Tampilkan indicator sort yang sedang aktif (bisa di dropdown label atau di tempat lain)

### 3. Sorting Logic
- **Due Date Sorting**:
  - Urutkan berdasarkan `task.dueDate`
  - Gunakan comparison DateTime di Dart

- **Priority Sorting**:
  - `TaskPriority.high` = nilai tertinggi
  - `TaskPriority.medium` = nilai menengah
  - `TaskPriority.low` = nilai terendah
  - Anda perlu convert enum ke numeric value untuk comparison

### 4. Default State
- Default sorting saat pertama kali buka screen bisa bebas (terserah Anda pilih yang paling make sense)
- Atau bisa "No Sort" / "Default Order" yang menampilkan tasks sesuai urutan original

### 5. Behavior
- Sorting harus **langsung apply** ketika user pilih option dari dropdown/popup
- List tasks harus **re-render** dengan urutan yang baru
- Sorting **tidak menghilangkan** tasks, hanya mengubah urutan

---

## Batasan dan Ketentuan

### ✅ Yang Boleh Dilakukan:
- Menambahkan **enum baru** untuk represent sort options (recommended)
- Menambahkan state variable untuk track sort option yang aktif
- Membuat helper methods untuk sorting logic
- Menggunakan `List.sort()` method dengan custom comparator
- Membuat copy dari list `tasks` untuk di-sort (atau sort in-place)
- Menggunakan `DropdownButton`, `PopupMenuButton`, atau widget serupa

### ❌ Yang Tidak Boleh Dilakukan:
- Mengubah `TaskModel` class atau enum existing
- Menambah package baru
- Mengubah data source (tetap gunakan `TaskModel.getDummyTasks()`)
- Sorting berdasarkan field yang tidak diminta (misal: description)

---

## Kriteria Penilaian

| No | Aspek | Poin | Deskripsi |
|----|-------|------|-----------|
| 1 | **Sort Logic - Date** | 25 | Sorting berdasarkan due date bekerja dengan benar (nearest & farthest) |
| 2 | **Sort Logic - Priority** | 25 | Sorting berdasarkan priority bekerja dengan benar (high-to-low & low-to-high) |
| 3 | **UI Implementation** | 20 | Sort control (dropdown/popup) ditampilkan dengan baik di AppBar, mudah digunakan |
| 4 | **Active Sort Indicator** | 10 | User dapat melihat sort option mana yang sedang aktif |
| 5 | **Code Quality** | 10 | Code clean, menggunakan helper functions, comparator logic jelas |
| 6 | **Enum Usage** | 10 | Menggunakan enum untuk represent sort options (bukan hardcode strings) |
| **BONUS** | **Alfabetis Sorting** | +10 | Implementasi title sorting (A-Z dan Z-A) |
| **TOTAL** | | **100** | **(+10 bonus)** |

---

## Expected Result

### Visual Example:

```
┌─────────────────────────────────────┐
│  My Tasks        [Due Date ▼]  🔍  │  ← Sort dropdown
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │ Physics Lab Report          │   │  ← Overdue (Oct 27)
│  │ 📅 Oct 27  [High] [Overdue] │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ Complete Math Assignment    │   │  ← Coming soon (Oct 30)
│  │ 📅 Oct 30  [High] [Pending] │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ Read History Chapter 3      │   │  ← Later (Nov 02)
│  │ 📅 Nov 02  [Medium] [...]   │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Dropdown Menu Options:
```
┌──────────────────────────────┐
│ Due Date (Nearest First)  ✓  │  ← Currently active
│ Due Date (Farthest First)    │
│ Priority (High to Low)       │
│ Priority (Low to High)       │
│ ──────────────────────────   │
│ Title (A-Z)              [B] │  ← Bonus
│ Title (Z-A)              [B] │  ← Bonus
└──────────────────────────────┘
```

---

## Hints & Tips

### 1. Enum untuk Sort Options
```dart
enum SortOption {
  dueDateAsc,    // Nearest first
  dueDateDesc,   // Farthest first
  priorityDesc,  // High to Low
  priorityAsc,   // Low to High
  // Bonus:
  titleAsc,      // A-Z
  titleDesc,     // Z-A
}
```

### 2. List Sorting di Dart
- Gunakan `List.sort()` method yang menerima comparator function
- Comparator function return:
  - Negative value jika item pertama lebih kecil
  - Positive value jika item pertama lebih besar
  - Zero jika sama
- Contoh: `list.sort((a, b) => a.value.compareTo(b.value))`

### 3. Priority Comparison
Priority adalah enum, perlu convert ke int untuk comparison:
```dart
// Contoh approach:
int getPriorityValue(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.high: return 3;
    case TaskPriority.medium: return 2;
    case TaskPriority.low: return 1;
  }
}
```

### 4. DateTime Comparison
- `DateTime` objects bisa dibandingkan langsung dengan `.compareTo()`
- Atau gunakan `.isBefore()`, `.isAfter()`

### 5. Reverse Sorting
- Untuk descending order, bisa reverse hasil comparator
- Atau gunakan `list.sort().reversed.toList()`

### 6. PopupMenuButton Example Structure
```dart
PopupMenuButton<SortOption>(
  icon: Icon(Icons.sort),
  onSelected: (value) {
    // Handle sort change
  },
  itemBuilder: (context) => [
    PopupMenuItem(
      value: SortOption.dueDateAsc,
      child: Text('Due Date (Nearest)'),
    ),
    // ... other options
  ],
)
```

---

## Challenge Points

Yang perlu dipikirkan dengan baik:
1. **Priority Conversion**: Bagaimana convert `TaskPriority` enum ke comparable value?
2. **Comparator Logic**: Bagaimana write comparator function yang benar untuk ascending vs descending?
3. **State Management**: Di mana simpan current sort option? Kapan apply sorting?
4. **Active Indicator**: Bagaimana tampilkan ke user sort option mana yang sedang aktif?

---

## Submission

Pastikan sebelum mengumpulkan:
- ✅ Code dapat di-run tanpa error
- ✅ Minimal 4 sort options bekerja dengan benar
- ✅ UI sort control accessible dan mudah digunakan
- ✅ Sorting logic benar (test dengan berbagai kombinasi tasks)
- ✅ Code menggunakan enum, bukan hardcode strings
- ✅ Helper functions untuk sorting logic clean dan reusable

**Selamat Mengerjakan!** 🚀
