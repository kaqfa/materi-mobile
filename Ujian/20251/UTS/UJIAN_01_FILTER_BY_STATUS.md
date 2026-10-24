# Ujian Praktik: Filter Task by Status

## Informasi Ujian
- **Waktu Pengerjaan**: 20 menit
- **Tingkat Kesulitan**: Medium
- **Bobot**: 100 poin
- **File yang Dimodifikasi**: `lib/features/tasks/screens/task_list_screen.dart`

---

## Deskripsi Tugas

Anda diminta menambahkan **fitur filter** pada halaman Task List yang memungkinkan user untuk memfilter daftar tasks berdasarkan status mereka.

Aplikasi saat ini menampilkan semua tasks tanpa filter. User kesulitan menemukan tasks dengan status tertentu ketika daftar tasks sudah banyak. Fitur filter ini akan membantu user fokus pada tasks yang relevan dengan kebutuhan mereka saat itu.

---

## Requirements

### 1. Filter Options
Sediakan **4 pilihan filter** yang harus ditampilkan dalam bentuk chip/button:
- **All**: Tampilkan semua tasks (default)
- **Pending**: Hanya tasks dengan status `TaskStatus.pending`
- **Overdue**: Hanya tasks dengan status `TaskStatus.overdue`
- **Completed**: Hanya tasks dengan status `TaskStatus.completed`

### 2. Visual Design
- Filter chips harus ditampilkan di **atas task list** (sebelum ListView)
- Chip yang sedang aktif harus memiliki **visual indicator** yang jelas (warna berbeda, atau style yang berbeda dari yang tidak aktif)
- Gunakan warna yang sesuai dengan **status colors** yang sudah didefinisikan di `AppColors`:
  - Pending: `AppColors.statusPending`
  - Overdue: `AppColors.statusOverdue`
  - Completed: `AppColors.statusCompleted`
  - All: Boleh gunakan primary color atau neutral color

### 3. Functionality
- Default state saat screen dibuka pertama kali adalah **"All"** (tampilkan semua tasks)
- Ketika user tap salah satu filter chip, daftar tasks harus **langsung ter-update** menampilkan hanya tasks yang sesuai dengan filter tersebut
- Filter harus bekerja dengan **data yang sudah ada** di state `tasks` (tidak perlu fetch data baru)

### 4. Empty State Handling
- Jika hasil filter **kosong** (tidak ada tasks yang match), tampilkan empty state yang informatif
- Empty state harus menunjukkan bahwa "tidak ada tasks dengan status [nama status]", bukan sekadar "no tasks"

### 5. UI/UX Considerations
- Pastikan filter chips **mudah diakses** dan tidak menghalangi view tasks
- Layout harus **responsive** dan tidak broken di different screen sizes
- Gunakan **scrolling** yang appropriate jika filter + tasks list melebihi screen height

---

## Batasan dan Ketentuan

### ✅ Yang Boleh Dilakukan:
- Menambahkan state variables baru di `_TaskListScreenState`
- Membuat helper methods baru untuk filtering logic
- Membuat widget methods baru untuk filter UI components
- Menggunakan Flutter widgets standar (Chip, FilterChip, ChoiceChip, atau custom buttons)
- Modifikasi method `_buildTaskList()` untuk apply filtering
- Menggunakan constants yang sudah ada di `AppColors` dan `AppStrings`

### ❌ Yang Tidak Boleh Dilakukan:
- Mengubah `TaskModel` class atau enum `TaskStatus`
- Menambah library/package baru
- Mengubah struktur data `tasks` (tetap gunakan `List<TaskModel>`)
- Mengubah fungsi existing yang tidak related (seperti delete, navigate to detail, dll)
- Hardcode strings (gunakan `AppStrings` atau buat constant baru jika perlu)

---

## Kriteria Penilaian

| No | Aspek | Poin | Deskripsi |
|----|-------|------|-----------|
| 1 | **Filter Logic** | 30 | Filter bekerja dengan benar untuk semua 4 options (All, Pending, Overdue, Completed) |
| 2 | **UI Implementation** | 25 | Filter chips ditampilkan dengan baik, layout rapi, visual design sesuai Material Design |
| 3 | **Active State Indicator** | 15 | Chip yang aktif memiliki visual indicator yang jelas dan mudah dipahami |
| 4 | **Empty State Handling** | 15 | Menampilkan empty state yang informatif ketika hasil filter kosong |
| 5 | **Code Quality** | 10 | Code clean, readable, mengikuti naming conventions yang ada di project |
| 6 | **Color Usage** | 5 | Menggunakan warna dari `AppColors` sesuai dengan status colors |
| **TOTAL** | | **100** | |

---

## Expected Result

### Behavior:
1. User membuka Task List screen → Semua tasks ditampilkan dengan filter "All" aktif
2. User tap chip "Overdue" → Hanya tasks dengan `task.status == TaskStatus.overdue` yang ditampilkan
3. User tap chip "Completed" → Hanya tasks dengan `task.isCompleted == true` yang ditampilkan
4. User tap chip "All" lagi → Kembali menampilkan semua tasks

### Visual:
```
┌─────────────────────────────────────┐
│        My Tasks                     │
├─────────────────────────────────────┤
│  [ All ]  Pending  Overdue  Done    │  ← Filter chips
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │ Complete Math Assignment    │   │
│  │ Finish calculus homework... │   │
│  │ 📅 Oct 30  [High]  [Overdue]│   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ Read History Chapter 3      │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## Hints & Tips

1. **State Management**: Pikirkan state variable apa yang perlu ditambahkan untuk track filter yang sedang aktif
2. **List Filtering**: Dart memiliki method built-in untuk filtering list berdasarkan kondisi
3. **Widget Suggestions**:
   - `FilterChip` atau `ChoiceChip` cocok untuk use case ini
   - Atau bisa gunakan `Container` + `InkWell` untuk custom chip
4. **Layout**: `Column` + `Expanded` + `ListView` bisa membantu organize filter + list
5. **Enum Comparison**: `task.status` adalah enum `TaskStatus`, bisa dibandingkan langsung dengan `==`

---

## Setup Data

Sebelum mengerjakan ujian ini, pastikan aplikasi sudah memiliki **minimal 20 dummy tasks** dengan berbagai status (pending, overdue, completed). Gunakan data ini untuk testing filter functionality:

**Contoh dummy data yang bisa ditambahkan:**
- 7-8 tasks dengan status `TaskStatus.pending`
- 6-7 tasks dengan status `TaskStatus.overdue`
- 5-6 tasks dengan status `TaskStatus.completed`

Dummy data bisa ditambahkan langsung di code (hardcoded di `initState()` atau di mock data) untuk memudahkan testing saat ujian.

---

## Submission

Pastikan sebelum mengumpulkan:
- ✅ Minimal 20 dummy tasks sudah ada di aplikasi dengan berbagai status
- ✅ Code dapat di-run tanpa error
- ✅ Hot reload bekerja normal
- ✅ Semua 4 filter options berfungsi dengan benar
- ✅ Visual design clean dan sesuai dengan app theme
- ✅ Tidak ada warning di console

**Selamat Mengerjakan!** 