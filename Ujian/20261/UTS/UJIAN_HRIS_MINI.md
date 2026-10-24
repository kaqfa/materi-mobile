# Ujian Praktik UTS: HRIS Mini — Pengajuan Cuti

## Informasi Ujian
- **Waktu Pengerjaan**: 60 menit
- **Tingkat Kesulitan**: Medium
- **Bobot**: 100 poin
- **Starter Code**: `Ujian/20261/starter-code/hris_mini/`
- **Environment**: Flutter stable 3.47.x · Dart 3.13.x · platform **web** & **android** (sudah dibuat) · tanpa package pihak ketiga
- **Fokus Pengerjaan**: `lib/screens/leave_list_screen.dart` dan `lib/widgets/leave_card.dart`

---

## Studi Kasus

Anda adalah developer di divisi HR PT Nusantara Digital. Perusahaan memakai aplikasi internal **HRIS mini** untuk mengelola pengajuan cuti karyawan.

Setiap pengajuan memiliki tipe cuti (**Cuti Tahunan / Sakit / Tanpa Gaji**), status (**Menunggu / Disetujui / Ditolak**), serta rentang tanggal mulai dan selesai.

Aplikasi saat ini baru bisa **menampilkan** daftar pengajuan. Tim HR mengeluh karena:
1. Tidak ada cara untuk **menyetujui / menolak** pengajuan.
2. Tidak bisa **memfilter** pengajuan berdasarkan status atau tipe cuti.
3. Tidak ada **form** untuk menambah pengajuan baru.

Tugas Anda: lengkapi aplikasi ini dengan ketiga fitur tersebut.

---

## Starter Code

Aplikasi starter sudah berjalan, lolos `flutter analyze` (0 issue), dan `flutter test` (1 test hijau). Struktur yang relevan:

```
lib/
├── main.dart                          # entry point + HrisApp
├── theme/app_theme.dart               # tema Material 3 (tidak perlu diubah)
├── models/leave_request.dart          # model LeaveRequest + enum LeaveType, LeaveStatus + mockLeaveRequests
├── screens/leave_list_screen.dart     # layar daftar pengajuan (fokus pengerjaan)
└── widgets/
    ├── leave_card.dart                # kartu pengajuan (fokus pengerjaan)
    └── status_chip.dart               # chip status reusable
```

Yang sudah berfungsi: daftar `mockLeaveRequests` (8 pengajuan) ditampilkan sebagai `LeaveCard`, masing-masing menampilkan nama karyawan, tipe cuti, rentang tanggal, dan status (chip).

---

## Tugas yang Harus Dikerjakan

### Tugas 1 — Approve / Reject (30 poin)
Tambahkan aksi untuk mengubah status pengajuan:
- Aksi **Setujui** → status berubah menjadi `Disetujui`.
- Aksi **Tolak** → status berubah menjadi `Ditolak`.
- Aksi bisa berupa tombol di kartu, tap pada kartu, atau elemen interaktif lain yang jelas.
- Setelah status berubah, `StatusChip` harus menampilkan label & warna status yang baru.
- Perubahan harus langsung terlihat di UI (gunakan `setState`).

### Tugas 2 — Filter Status & Tipe (35 poin)
Tambahkan **filter chips** di bagian atas daftar:
- Filter **status**: `Semua`, `Menunggu`, `Disetujui`, `Ditolak`.
- Filter **tipe**: `Semua`, `Cuti Tahunan`, `Sakit`, `Tanpa Gaji`.
- Kedua filter bisa **dikombinasikan** (logika AND).
- Chip yang aktif harus punya indikator visual yang jelas.
- Jika hasil filter kosong, tampilkan empty state yang informatif.

### Tugas 3 — Form Pengajuan Cuti (35 poin)
Tambahkan **form** untuk menambah pengajuan baru:
- **Nama karyawan**: `TextFormField`, wajib diisi.
- **Tipe cuti**: pilihan (`Cuti Tahunan` / `Sakit` / `Tanpa Gaji`), mis. dropdown atau selector.
- **Tanggal mulai** dan **tanggal selesai**: pakai `showDatePicker`.
- **Validasi**:
  - Nama tidak boleh kosong.
  - `tanggalSelesai >= tanggalMulai`.
  - Tanggal tidak boleh di masa lalu (tidak sebelum hari ini).
- Saat submit, pengajuan baru ditambahkan ke daftar dengan status awal `Menunggu`.
- Bersihkan resource (`TextEditingController`/`FocusNode`) di `dispose`.

---

## Batasan dan Ketentuan

### ✅ Yang Boleh Dilakukan
- Menambah state variables, helper methods, dan widget methods di `_LeaveListScreenState`.
- Menambah callback parameter di `LeaveCard` (mis. `onApprove`, `onReject`).
- Membuat screen/widget baru (mis. `lib/screens/add_leave_screen.dart`).
- Menggunakan `setState`, `Navigator`, `showDatePicker`, `TextFormField`, `DropdownButton`, `FilterChip`/`ChoiceChip`, dan widget Material lainnya.
- Menggunakan `copyWith` untuk membuat instance baru saat status berubah.

### ❌ Yang Tidak Boleh Dilakukan
- Mengubah class `LeaveRequest`, enum `LeaveType`, atau enum `LeaveStatus`.
- Menambah package/library baru (tetap tanpa dependency pihak ketiga).
- Mengubah struktur data `_requests` menjadi tipe lain selain `List<LeaveRequest>`.
- Hardcode status hasil approve/reject (harus di-set dari aksi user).

---

## Kriteria Penilaian

| No | Aspek | Poin | Deskripsi |
|----|-------|------|-----------|
| 1 | **Approve / Reject** | 30 | Setujui & tolak mengubah status dengan benar, chip update |
| 2 | **Filter status** | 12 | Filter status bekerja benar untuk semua nilai |
| 3 | **Filter tipe** | 12 | Filter tipe bekerja benar, bisa dikombinasikan dengan status |
| 4 | **Empty state** | 11 | Menampilkan empty state informatif saat hasil filter kosong |
| 5 | **Form & validasi** | 25 | Form lengkap, validasi nama/tanggal benar, data masuk ke daftar |
| 6 | **Code quality** | 10 | Clean, readable, resource dibuang benar, tidak hardcode |
| **TOTAL** | | **100** | |

---

## Expected Result

### Behavior
1. Buka aplikasi → semua 8 pengajuan tampil, filter "Semua" aktif di kedua baris.
2. Tekan "Setujui" pada pengajuan "Budi Santoso" → status berubah `Menunggu → Disetujui`, chip berubah warna hijau.
3. Tekan "Tolak" pada pengajuan lain → status berubah `Ditolak`, chip berubah warna merah.
4. Pilih filter status "Menunggu" → hanya pengajuan `Menunggu` yang tampil.
5. Kombinasikan filter status "Menunggu" + tipe "Cuti Tahunan" → hanya pengajuan `Menunggu` **dan** `Cuti Tahunan`.
6. Buka form, isi nama, pilih tipe & tanggal, submit → pengajuan baru muncul dengan status `Menunggu`.

### Visual (contoh)
```
┌──────────────────────────────────────────────┐
│ HRIS — Pengajuan Cuti                        │
├──────────────────────────────────────────────┤
│ Status: [Semua] Menunggu Disetujui Ditolak   │
│ Tipe: [Semua] Tahunan Sakit Tanpa Gaji       │
├──────────────────────────────────────────────┤
│ ┌───────────────────────────────┐  [Menunggu]│
│ │ Budi Santoso                  │            │
│ │ Cuti Tahunan · 10/11 – 14/11  │  [✓] [✕]  │
│ └───────────────────────────────┘            │
│ ┌───────────────────────────────┐  [Disetujui]│
│ │ Siti Aminah                   │            │
│ │ Sakit · 20/10 – 21/10         │            │
│ └───────────────────────────────┘            │
│                              [+ Tambah Cuti] │
└──────────────────────────────────────────────┘
```

---

## Hints & Tips

1. **Approve/Reject**: `LeaveRequest` immutable — gunakan `request.copyWith(status: ...)` lalu perbarui list.
2. **Filter**: simpan `LeaveStatus? _statusFilter` dan `LeaveType? _typeFilter`, lalu filter dengan `.where(...)` di `build`.
3. **Form**: gunakan `Form` + `GlobalKey<FormState>`, validator untuk nama, dan `showDatePicker` dengan `firstDate: DateTime.now()`.
4. **Validasi tanggal**: bandingkan `endDate.isBefore(startDate)` dan `startDate.isBefore(DateTime.now())`.
5. **Navigasi form**: buka form via `Navigator.push`, lalu kirim hasil balik (`pop`) dengan data pengajuan baru, atau kelola state di layar yang sama.
6. **Resource**: `TextEditingController` dan `FocusNode` wajib di-`dispose()`.
7. **Chip aktif**: `ChoiceChip` punya properti `selected`; `FilterChip` juga punya state terpilih bawaan.

---

## Cara Menjalankan Starter Code

```bash
cd Ujian/20261/starter-code/hris_mini
flutter pub get
flutter run -d chrome        # mode web
# atau (Android emulator):
flutter run -d <device-id>
```

Verifikasi awal yang diharapkan:
- `flutter analyze` → **No issues found!**
- `flutter test` → **All tests passed!**

---

## Submission

Pastikan sebelum mengumpulkan:
- ✅ Aplikasi bisa di-run tanpa error (web/emulator)
- ✅ Setujui & tolak mengubah status dengan benar, chip update
- ✅ Filter status & tipe bekerja, bisa dikombinasikan
- ✅ Empty state muncul saat tidak ada hasil
- ✅ Form menambah pengajuan baru dengan validasi tanggal yang benar
- ✅ `flutter analyze` bersih, controller/focus node di-`dispose` dengan benar

**Selamat Mengerjakan!** 🚀
