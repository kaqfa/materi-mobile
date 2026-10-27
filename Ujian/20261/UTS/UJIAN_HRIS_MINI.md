# Ujian Praktik UTS: HRIS Mini — Pengajuan Cuti

## Informasi Ujian
- **Waktu Pengerjaan**: 100 menit
- **Tingkat Kesulitan**: Medium
- **Bobot**: 100 poin
- **Starter Code**: `Ujian/20261/starter-code/hris_mini/`
- **Environment**: Flutter stable 3.47.x · Dart 3.13.x · platform **android** & **web** (dibuat lewat `flutter create`, lihat langkah di bawah) · tanpa package pihak ketiga
- **Fokus Pengerjaan**: `lib/screens/leave_list_screen.dart`, `lib/screens/leave_detail_screen.dart`, dan `lib/widgets/leave_card.dart`

---

## Studi Kasus

Anda adalah developer di divisi HR PT Nusantara Digital. Perusahaan memakai aplikasi internal **HRIS mini** untuk mengelola pengajuan cuti karyawan.

Setiap pengajuan memiliki tipe cuti (**Cuti Tahunan / Sakit / Tanpa Gaji**), status (**Menunggu / Disetujui / Ditolak**), serta rentang tanggal mulai dan selesai.

Aplikasi saat ini baru bisa **menampilkan** daftar pengajuan dan **detail** tiap pengajuan. Tim HR mengeluh karena:
1. Tidak ada cara untuk **menyetujui / menolak** pengajuan.
2. Tidak bisa **memfilter** pengajuan berdasarkan status atau tipe cuti.

Tugas Anda: lengkapi aplikasi ini dengan kedua fitur tersebut.

---

## Starter Code

Aplikasi starter sudah berjalan, lolos `flutter analyze` (0 issue), dan `flutter test` (1 test hijau). Struktur yang relevan:

```
lib/
├── main.dart
├── theme/app_theme.dart
├── models/leave_request.dart
├── utils/date_format.dart
├── screens/
│   ├── leave_list_screen.dart
│   └── leave_detail_screen.dart
└── widgets/
    ├── leave_card.dart
    ├── status_chip.dart
    ├── employee_avatar.dart
    └── leave_visuals.dart
```

Yang sudah berfungsi:
- Daftar `mockLeaveRequests` (8 pengajuan) ditampilkan sebagai `LeaveCard`: avatar inisial, nama karyawan, tipe cuti, rentang tanggal, durasi, dan status (chip).
- **Tap kartu** → membuka `LeaveDetailScreen` (profil, periode cuti, info pengajuan) lewat `_openDetail()` di `leave_list_screen.dart`.
- Tema (`AppTheme`) sudah mengatur bentuk `Card`, `Chip`, `FilledButton`, dan `OutlinedButton` — widget Material yang Anda tambahkan otomatis tampil seragam.

---

## Tugas yang Harus Dikerjakan

### Tugas 1 — Approve / Reject (45 poin)
Tambahkan aksi untuk mengubah status pengajuan:
- Aksi **Setujui** → status berubah menjadi `Disetujui`.
- Aksi **Tolak** → status berubah menjadi `Ditolak`.
- Letak aksi bebas: tombol di **layar detail** (disarankan), tombol di kartu, atau elemen interaktif lain yang jelas.
- Aksi hanya tersedia untuk pengajuan berstatus `Menunggu` (pengajuan yang sudah diputuskan tidak bisa diubah lagi).
- Setelah status berubah, `StatusChip` di **kartu daftar** harus menampilkan label & warna status yang baru (gunakan `setState`). Bila aksi ada di layar detail, status baru harus terlihat di daftar setelah kembali.

### Tugas 2 — Filter Status & Tipe (45 poin)
Tambahkan **filter chips** di bagian atas daftar:
- Filter **status**: `Semua`, `Menunggu`, `Disetujui`, `Ditolak`.
- Filter **tipe**: `Semua`, `Cuti Tahunan`, `Sakit`, `Tanpa Gaji`.
- Kedua filter bisa **dikombinasikan** (logika AND).
- Chip yang aktif harus punya indikator visual yang jelas.
- Jika hasil filter kosong, tampilkan empty state yang informatif.

> **Code quality (10 poin)** dinilai dari keseluruhan kode Tugas 1 & 2.

---

## Batasan dan Ketentuan

### ✅ Yang Boleh Dilakukan
- Menambah state variables, helper methods, dan widget methods di `_LeaveListScreenState`.
- Menambah parameter (mis. callback `onApprove`, `onReject`) di `LeaveCard` atau `LeaveDetailScreen`.
- Membuat widget baru (mis. `lib/widgets/empty_state.dart`).
- Menggunakan `setState`, `Navigator` (push/pop dengan nilai balik), `FilterChip`/`ChoiceChip`, `FilledButton`, dan widget Material lainnya.
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
| 1 | **Setujui & tolak** | 25 | Kedua aksi mengubah status dengan benar (`copyWith` + `setState`), chip di kartu ter-update |
| 2 | **Sinkron detail & daftar** | 10 | Status baru konsisten di layar detail dan daftar (mis. via nilai balik `Navigator.pop`) |
| 3 | **Aksi hanya untuk `Menunggu`** | 10 | Tombol aksi tidak tampil/nonaktif untuk pengajuan yang sudah diputuskan |
| 4 | **Filter status** | 15 | Filter status bekerja benar untuk semua nilai |
| 5 | **Filter tipe + kombinasi** | 15 | Filter tipe bekerja benar, bisa dikombinasikan (AND) dengan status |
| 6 | **Chip aktif** | 5 | Chip yang terpilih punya indikator visual jelas di kedua baris filter |
| 7 | **Empty state** | 10 | Menampilkan empty state informatif saat hasil filter kosong |
| 8 | **Code quality** | 10 | Clean, readable, `flutter analyze` bersih, tidak hardcode |
| **TOTAL** | | **100** | |

---

## Expected Result

1. Buka aplikasi → semua 8 pengajuan tampil, filter "Semua" aktif di kedua baris.
2. Tap kartu "Budi Santoso" → layar detail terbuka, tombol **Setujui** & **Tolak** tampil.
3. Tekan "Setujui" → kembali ke daftar, status Budi berubah `Menunggu → Disetujui`, chip berubah warna hijau.
4. Buka pengajuan `Menunggu` lain, tekan "Tolak" → status berubah `Ditolak`, chip merah.
5. Buka pengajuan yang sudah `Disetujui`/`Ditolak` → tombol aksi tidak tersedia.
6. Pilih filter status "Menunggu" → hanya pengajuan `Menunggu` yang tampil.
7. Kombinasikan filter status "Menunggu" + tipe "Cuti Tahunan" → hanya pengajuan `Menunggu` **dan** `Cuti Tahunan`.
8. Kombinasi yang tidak punya hasil (mis. `Ditolak` + `Sakit`) → empty state tampil.

---

## Hints & Tips

1. **Approve/Reject**: `LeaveRequest` immutable — gunakan `request.copyWith(status: ...)` lalu ganti elemen di `_requests` (cari index berdasarkan `id`) di dalam `setState`.
2. **Aksi dari layar detail**: kirim keputusan balik dengan `Navigator.pop(context, LeaveStatus.approved)`, lalu di daftar tangkap hasilnya: `final status = await Navigator.push<LeaveStatus>(...)` dan cek `null` (user menekan tombol back).
3. **Tempat tombol**: di `LeaveDetailScreen`, tombol bisa ditaruh di `bottomNavigationBar` (dibungkus `SafeArea` + `Padding`) atau ditambahkan sebagai child terakhir `ListView`.
4. **Filter**: simpan `LeaveStatus? _statusFilter` dan `LeaveType? _typeFilter` (`null` = Semua), lalu filter dengan `.where(...)` di `build`.
5. **Tempat filter chips**: `body` daftar sudah berupa `Column` — tambahkan baris chip sebelum `Expanded(ListView...)`. Bungkus dengan `SingleChildScrollView(scrollDirection: Axis.horizontal)` agar tidak overflow.
6. **Chip aktif**: `ChoiceChip` punya properti `selected`; loop `LeaveStatus.values` / `LeaveType.values` dan pakai `.label` untuk teksnya.
7. **Empty state**: bila list hasil filter kosong, tampilkan widget lain (mis. `Center` + `Icon` + `Text`) sebagai ganti `ListView`.

---

## Cara Menjalankan Starter Code

```bash
cd Ujian/20261/starter-code/hris_mini
flutter create . --platforms=android,web   # sekali saja, membuat folder platform
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
- ✅ Setujui & tolak mengubah status dengan benar, chip di daftar ter-update
- ✅ Aksi hanya tersedia untuk pengajuan `Menunggu`
- ✅ Filter status & tipe bekerja, bisa dikombinasikan
- ✅ Empty state muncul saat tidak ada hasil
- ✅ `flutter analyze` bersih

**Selamat Mengerjakan!** 🚀
