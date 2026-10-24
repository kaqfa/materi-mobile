# Ujian Praktik: Search Task by Title

## Informasi Ujian
- **Waktu Pengerjaan**: 25 menit
- **Tingkat Kesulitan**: Medium
- **Bobot**: 100 poin
- **File yang Dimodifikasi**: `lib/features/tasks/screens/task_list_screen.dart`

---

## Deskripsi Tugas

Anda diminta menambahkan **fitur search/pencarian** pada halaman Task List yang memungkinkan user untuk mencari tasks berdasarkan title mereka.

Saat ini user harus scroll manual untuk menemukan task tertentu di daftar yang panjang. Dengan fitur search ini, user dapat dengan cepat menemukan task yang dicari hanya dengan mengetikkan sebagian atau seluruh title task tersebut.

---

## Requirements

### 1. Search Input
- Tambahkan **search bar/text field** yang mudah diakses user
- Search bar bisa ditempatkan di salah satu lokasi berikut (pilih yang menurut Anda paling user-friendly):
  - Di dalam `AppBar` sebagai title (bisa toggle dengan icon search)
  - Di bawah AppBar, di atas task list
  - Atau implementasi lain yang tetap accessible

### 2. Search Behavior
- Search harus bekerja **case-insensitive** (tidak memperhatikan huruf besar/kecil)
  - Contoh: "math" harus match dengan "Complete Math Assignment"
- Search harus mencari **substring** dalam title (partial matching)
  - Contoh: "hist" harus match dengan "Read History Chapter 3"
- Hasil search harus **update secara real-time** saat user mengetik (tidak perlu tombol "Search")
- Jika search field **kosong**, tampilkan semua tasks

### 3. Search Results Display
- Tasks yang **match** dengan search query ditampilkan di list
- Tasks yang **tidak match** disembunyikan (tidak ditampilkan)
- Urutan tasks tetap sama seperti list original

### 4. Empty Results Handling
- Jika **tidak ada tasks** yang match dengan search query, tampilkan empty state yang informatif
- Empty state harus menunjukkan bahwa "tidak ada tasks yang match dengan '[query]'", bukan generic empty state
- Berikan hint atau suggestion ke user (misalnya: "Coba kata kunci lain")

### 5. Clear Search
- User harus bisa **clear/reset search** dengan mudah
- Bisa dengan:
  - Clear button (X) di dalam search field
  - Menghapus semua text secara manual
  - Icon button terpisah
- Setelah clear, tampilkan kembali semua tasks

---

## Batasan dan Ketentuan

### ✅ Yang Boleh Dilakukan:
- Menambahkan `TextEditingController` untuk manage search input
- Menambahkan state variables baru di `_TaskListScreenState`
- Membuat helper methods untuk search/filter logic
- Membuat widget methods untuk search UI component
- Menggunakan Flutter widgets standar (TextField, SearchBar, IconButton, dll)
- Modifikasi method `_buildTaskList()` untuk apply search filtering
- Menggunakan atau menambah constants di `AppStrings`

### ❌ Yang Tidak Boleh Dilakukan:
- Mengubah `TaskModel` class
- Menambah library/package baru
- Mengubah struktur data `tasks`
- Mengubah fungsi existing yang tidak related (delete, navigate, dll)
- Search hanya di description (harus search di **title**)

---

## Kriteria Penilaian

| No | Aspek | Poin | Deskripsi |
|----|-------|------|-----------|
| 1 | **Search Logic** | 30 | Search bekerja dengan benar: case-insensitive, substring matching, real-time update |
| 2 | **UI Implementation** | 25 | Search field ditampilkan dengan baik, accessible, dan terintegrasi smooth dengan UI existing |
| 3 | **TextEditingController** | 15 | TextEditingController di-manage dengan benar (initialization & disposal) |
| 4 | **Empty Results State** | 15 | Menampilkan informative empty state ketika search tidak ada hasil, dengan search query ditampilkan |
| 5 | **Clear Functionality** | 10 | User dapat clear search dengan mudah dan list kembali ke state semua tasks |
| 6 | **Code Quality** | 5 | Code clean, readable, proper lifecycle management |
| **TOTAL** | | **100** | |

---

## Expected Result

### Behavior:
1. User membuka Task List screen → Semua tasks ditampilkan, search field kosong
2. User ketik "math" di search field → Hanya tasks dengan title mengandung "math" (case-insensitive) yang ditampilkan
3. User ketik "xyz" (tidak ada match) → Empty state muncul dengan message "No tasks found for 'xyz'"
4. User clear search → Kembali menampilkan semua tasks

### Visual Example:

**State 1: Search field kosong**
```
┌─────────────────────────────────────┐
│   My Tasks            🔍            │
├─────────────────────────────────────┤
│  [    Search tasks...           ]   │  ← Search field
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │ Complete Math Assignment    │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ Read History Chapter 3      │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ Physics Lab Report          │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

**State 2: User search "math"**
```
┌─────────────────────────────────────┐
│   My Tasks            🔍            │
├─────────────────────────────────────┤
│  [ math                      X  ]   │  ← Search active
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │ Complete Math Assignment    │   │  ← Match found
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

**State 3: User search "xyz" (no results)**
```
┌─────────────────────────────────────┐
│   My Tasks            🔍            │
├─────────────────────────────────────┤
│  [ xyz                       X  ]   │
├─────────────────────────────────────┤
│                                     │
│         🔍                          │
│   No tasks found for "xyz"          │
│   Try different keywords            │
│                                     │
└─────────────────────────────────────┘
```

---

## Hints & Tips

1. **String Operations**:
   - Dart String memiliki method `.toLowerCase()` dan `.contains()`
   - Gunakan untuk case-insensitive search

2. **Real-time Search**:
   - `TextField` memiliki property `onChanged` untuk listen ke setiap perubahan text
   - Atau bisa listen via `TextEditingController.addListener()`

3. **Clear Button**:
   - `TextField` memiliki property `decoration` dengan `suffixIcon`
   - `IconButton` dengan `Icons.clear` bisa digunakan

4. **Controller Lifecycle**:
   - Jangan lupa initialize di `initState()`
   - Jangan lupa dispose di `dispose()`

5. **Empty State**:
   - Bisa modifikasi `_buildEmptyState()` yang sudah ada untuk handle dua case:
     - Empty karena memang tidak ada tasks
     - Empty karena search tidak ada hasil

6. **Search Widget Alternatives**:
   - `TextField` dengan custom decoration
   - `SearchBar` (Material 3 widget) - lebih modern
   - `TextFormField` jika perlu validation

---

## Setup Data

Sebelum mengerjakan ujian ini, pastikan aplikasi sudah memiliki **minimal 20 dummy tasks** dengan berbagai title untuk testing search functionality:

**Contoh dummy data yang bisa ditambahkan:**
- Tasks dengan berbagai keywords: "Math", "Physics", "History", "Chemistry", "Biology", "English", "Programming", "Design", dll
- Beberapa tasks dengan title yang mirip untuk test case insensitive search
- Tasks dengan substring yang bisa dicari (misalnya "Complete Math", "Read History", "Finish Report", dll)

Dummy data bisa ditambahkan langsung di code (hardcoded di `initState()` atau di mock data) untuk memudahkan testing saat ujian.

---

## Submission

Pastikan sebelum mengumpulkan:
- ✅ Minimal 20 dummy tasks sudah ada di aplikasi dengan berbagai title
- ✅ Code dapat di-run tanpa error
- ✅ Search bekerja case-insensitive dan real-time
- ✅ TextEditingController properly disposed
- ✅ Clear search functionality bekerja
- ✅ Empty state untuk "no results" informatif
- ✅ UI terintegrasi dengan baik dengan existing design
- ✅ Tidak ada memory leaks (controller disposed properly)

**Selamat Mengerjakan!** 🚀
