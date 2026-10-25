# Ujian Praktik UTS: Mini CRM — Sales Pipeline

## Informasi Ujian
- **Waktu Pengerjaan**: 100 menit
- **Tingkat Kesulitan**: Medium
- **Bobot**: 100 poin
- **Starter Code**: `Ujian/20261/starter-code/mini_crm/`
- **Environment**: Flutter stable 3.47.x · Dart 3.13.x · platform **android** & **web** (dibuat lewat `flutter create`, lihat langkah di bawah) · tanpa package pihak ketiga
- **Fokus Pengerjaan**: `lib/screens/lead_list_screen.dart` dan `lib/widgets/lead_card.dart`

---

## Studi Kasus

Anda adalah developer baru di tim penjualan PT Nusantara Digital. Perusahaan memakai aplikasi internal **Mini CRM** untuk mengelola calon nasabah (*lead*) mulai dari kontak pertama sampai penutupan kontrak (*closing*).

Setiap lead memiliki tahap (*stage*): **Baru → Dihubungi → Qualified → Closing**, beserta nilai estimasi kontrak dan prioritasnya.

Aplikasi saat ini baru bisa **menampilkan** daftar lead. Tim sales mengeluh karena:
1. Tidak ada cara untuk **memajukan stage** lead ketika progres berubah.
2. Tidak bisa **memfilter** lead berdasarkan stage atau prioritas.
3. Tidak ada **ringkasan nilai** per stage untuk melihat pipeline secara cepat.

Tugas Anda: lengkapi aplikasi ini dengan ketiga fitur tersebut.

---

## Starter Code

Aplikasi starter sudah berjalan, lolos `flutter analyze` (0 issue), dan `flutter test` (1 test hijau). Struktur yang relevan:

```
lib/
├── main.dart
├── theme/app_theme.dart
├── models/lead.dart
├── screens/lead_list_screen.dart
└── widgets/
    ├── lead_card.dart
    ├── stage_chip.dart
    └── priority_indicator.dart
```

Yang sudah berfungsi: daftar `mockLeads` (8 lead) ditampilkan sebagai `LeadCard`, masing-masing menampilkan perusahaan, kontak, prioritas, stage (chip), dan nilai kontrak (`Rp X jt`).

---

## Tugas yang Harus Dikerjakan

### Tugas 1 — Advance Stage (35 poin)
Tambahkan cara untuk **memajukan stage** sebuah lead satu langkah:
- Urutan: `Baru → Dihubungi → Qualified → Closing`.
- Lead yang sudah `Closing` adalah stage terakhir, **tidak bisa** dimajukan lagi.
- Aksi bisa berupa tombol di kartu, tap pada kartu, atau elemen interaktif lain yang jelas.
- Setelah stage berubah, `StageChip` harus menampilkan label & warna stage yang baru.
- Perubahan harus langsung terlihat di UI (gunakan `setState`).

### Tugas 2 — Filter Stage & Prioritas (40 poin)
Tambahkan **filter chips** di bagian atas daftar:
- Filter **stage**: `Semua`, `Baru`, `Dihubungi`, `Qualified`, `Closing`.
- Filter **prioritas**: `Semua`, `Rendah`, `Sedang`, `Tinggi`.
- Kedua filter bisa **dikombinasikan** (logika AND).
- Chip yang aktif harus punya indikator visual yang jelas.
- Jika hasil filter kosong, tampilkan empty state yang informatif.
- Gunakan `FilterChip`/`ChoiceChip` atau komponen Material lain yang sesuai.

### Tugas 3 — Ringkasan Nilai per Stage (25 poin)
Tambahkan **ringkasan total nilai kontrak** untuk tiap stage:
- Hitung total `value` (dalam juta rupiah) untuk setiap `LeadStage`.
- Tampilkan di atas daftar (di bawah/atas filter) atau posisi lain yang mudah dibaca.
- Ringkasan harus **update otomatis** ketika sebuah lead dimajukan stage-nya.
- Bentuk bebas (kartu, baris, grid, atau chip), asal jelas dan rapi.

---

## Batasan dan Ketentuan

### ✅ Yang Boleh Dilakukan
- Menambah state variables, helper methods, dan widget methods di `_LeadListScreenState`.
- Menambah callback parameter di `LeadCard` (mis. `onAdvance`).
- Membuat widget baru di `lib/widgets/` atau `lib/screens/`.
- Menggunakan `setState`, `ListView`, `Wrap`, `FilterChip`/`ChoiceChip`, dan widget Material lainnya.
- Menggunakan `switch` expression untuk memetakan stage/prioritas.

### ❌ Yang Tidak Boleh Dilakukan
- Mengubah class `Lead`, enum `LeadStage`, atau enum `LeadPriority`.
- Menambah package/library baru (tetap tanpa dependency pihak ketiga).
- Mengubah struktur data `_leads` menjadi tipe lain selain `List<Lead>`.
- Hardcode nilai ringkasan (harus dihitung dari data saat itu).

---

## Kriteria Penilaian

| No | Aspek | Poin | Deskripsi |
|----|-------|------|-----------|
| 1 | **Advance stage** | 35 | Stage berubah sesuai urutan, berhenti di `Closing`, visual chip update |
| 2 | **Filter stage** | 15 | Filter stage bekerja benar untuk semua nilai |
| 3 | **Filter prioritas** | 15 | Filter prioritas bekerja benar, bisa dikombinasikan dengan stage |
| 4 | **Empty state** | 10 | Menampilkan empty state informatif saat hasil filter kosong |
| 5 | **Ringkasan nilai** | 15 | Total `value` per stage dihitung benar dan update saat stage berubah |
| 6 | **Code quality** | 10 | Clean, readable, pakai enum & helper, tidak ada hardcode |
| **TOTAL** | | **100** | |

---

## Expected Result

### Behavior
1. Buka aplikasi → semua 8 lead tampil, filter "Semua" aktif di kedua baris.
2. Tekan tombol advance pada "PT Nusantara Logistik" → stage berubah `Baru → Dihubungi`, chip berubah warna.
3. Pilih filter stage "Qualified" → hanya lead dengan stage `Qualified` yang tampil.
4. Kombinasikan filter stage "Qualified" + prioritas "Tinggi" → hanya lead `Qualified` **dan** `Tinggi`.
5. Lead ber-stage `Closing` yang ditekan advance **tidak berubah** (sudah tahap akhir).
6. Ringkasan nilai per stage menampilkan total yang benar dan ikut berubah saat ada lead dimajukan.

> Data awal (untuk self-check): `Baru` 180 jt · `Dihubungi` 195 jt · `Qualified` 510 jt · `Closing` 175 jt.

### Visual (contoh)
```
┌──────────────────────────────────────────────┐
│ Mini CRM — Sales Pipeline                    │
├──────────────────────────────────────────────┤
│ Stage: [Semua] Baru Dihubungi Qual. Closing  │
│ Prioritas: [Semua] Rendah Sedang Tinggi      │
│ ┌────────────────────────────────────────────┐│
│ │ Closing 175 jt · Qualified 510 jt · ...    ││
│ └────────────────────────────────────────────┘│
│ ┌───────────────────────────────┐  Rp 120 jt │
│ │ PT Nusantara Logistik         │            │
│ │ Budi Santoso                  │            │
│ │ ● Tinggi  [Baru]              │  [Advance] │
│ └───────────────────────────────┘            │
└──────────────────────────────────────────────┘
```

---

## Hints & Tips

1. **Advance stage**: gunakan `LeadStage.values` untuk mencari stage berikutnya, atau tulis getter/`switch`. Jaga index agar tidak melewati `Closing`.
2. **copyWith**: `Lead` immutable — gunakan `lead.copyWith(stage: next)` lalu perbarui list.
3. **Filter**: simpan `LeadStage? _stageFilter` dan `LeadPriority? _priorityFilter`, lalu filter dengan `.where(...)` di `build`.
4. **Ringkasan**: hitung dengan `fold` atau loop, dan selalu hitung di `build` supaya otomatis update.
5. **Empty state**: cek apakah hasil filter kosong sebelum render `ListView`.
6. **Chip aktif**: `ChoiceChip` punya properti `selected`; `FilterChip` juga punya state terpilih bawaan.

---

## Cara Menjalankan Starter Code

```bash
cd Ujian/20261/starter-code/mini_crm
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
- ✅ Advance stage bekerja dan berhenti di `Closing`
- ✅ Filter stage & prioritas bekerja, bisa dikombinasikan
- ✅ Empty state muncul saat tidak ada hasil
- ✅ Ringkasan nilai per stage akurat dan update dinamis
- ✅ `flutter analyze` bersih, tidak ada hardcode nilai ringkasan

**Selamat Mengerjakan!** 🚀
