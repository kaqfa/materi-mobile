# Template Submission README, Tugas Remidi Task Tracker

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker

> **Cara pakai:** salin template ini menjadi `README.md` di root proyek submission kamu. Ganti semua teks di dalam `<...>` dan hapus bagian yang tidak relevan untuk tugas bersangkutan. Pertahankan struktur heading dan urutan agar penilaian konsisten lintas mahasiswa.

---

# `<Nama Mahasiswa>`, `<NIM>`, Remedial Task Tracker

**Tugas:** `<Assignment 1 / Assignment 2 / Proyek Akhir>`, `<Judul Tugas>` 
**Tanggal submit:** `<YYYY-MM-DD>` 
**Repo URL (bila ada):** `<https://...>` 
**Jalur penyimpanan lokal:** `<A (in-memory) / B (SQLite)>` (Assignment 2 & Proyek Akhir) 
**Pemakaian AI:** `<Ya / Tidak>` (bila Ya, lampirkan `AI-LOG.md`, lihat §7)

---

## 1. Ringkasan

`<2-4 kalimat: apa yang dibangun, fitur utama yang berjalan, dan apa yang menjadi fokus tugas ini.>`

Contoh (Assignment 1): Aplikasi task tracker berbasis Flutter + Provider. Mendukung CRUD task, toggle completion, search title + filter status/priority (kombinasi AND), validasi form, dan layout responsive portrait+landscape.

---

## 2. Cara menjalankan

Persyaratan environment:
- Flutter `<versi, mis. >=3.22.0>`, Dart `<sdk, mis. ^3.4.0>`
- Perangkat/emulator Android atau web

```bash
# 1. Ekstrak ZIP (atau clone repo), lalu di dalam folder proyek:
flutter create --platforms=android,web. # hanya bila folder platform belum ada
flutter pub get
flutter analyze
flutter test
flutter run
```

> Catatan: jika `flutter create` menimpa `pubspec.yaml`/`analysis_options.yaml`, pulihkan dari salinan di ZIP.

Akun/endpoint (Assignment 2 & Proyek Akhir bila pakai API):
- Base URL via `--dart-define=API_BASE_URL=<...>` atau `.env.example`. **Tidak ada secret di-hardcode.**

---

## 3. Fitur yang diimplementasikan

Centang yang berjalan. Hapus yang tidak relevan untuk tugas ini.

**Assignment 1, Task Tracker Core**
- [ ] Model `Task` + enum + `copyWith`
- [ ] List / detail / add / edit / delete (dengan konfirmasi)
- [ ] Toggle completion (idempotent)
- [ ] Search title (case-insensitive, reaktif)
- [ ] Filter status (pending/overdue/completed/all)
- [ ] Filter priority (low/medium/high/all)
- [ ] Kombinasi search + filter (AND)
- [ ] Validasi title (kosong / < 3 karakter)
- [ ] Validasi due date tidak lampau (mode add)
- [ ] Responsive portrait + landscape (tidak overflow)
- [ ] State UX: loading / error / empty

**Assignment 2, Serialization dan API** *(hapus blok ini untuk Assignment 1 / Proyek Akhir)*
- [ ] CRUD lokal (jalur A in-memory **atau** jalur B SQLite)
- [ ] Serialization `toJson`/`fromJson` + round-trip lossless
- [ ] REST GET + minimal satu write (POST/PUT/PATCH)
- [ ] Error/network state (4xx/5xx/network) + retry manual
- [ ] Mode offline + status lokal/sync
- [ ] *(Bonus, jalur B)* SQLite + data bertahan setelah restart

**Proyek Akhir, QA, Release, Demo** *(hapus blok ini untuk Assignment 1/2)*
- [ ] Fitur device (image picker/camera + fallback)
- [ ] ≥3 unit test
- [ ] ≥2 widget test
- [ ] Release APK berhasil
- [ ] `flutter test` + `flutter analyze` bersih/dijelaskan
- [ ] *(Bonus, jalur B)* Persistensi terbukti pada APK rilis

---

## 4. Arsitektur singkat

`<Jelaskan struktur folder utama dan alur data. 1 paragraf + diagram teks opsional.>`

Contoh:
```text
lib/
├── main.dart # ChangeNotifierProvider(TaskProvider)
├── app.dart
├── core/{constants,theme}/ # AppStrings, AppColors, AppTheme
└── features/tasks/
 ├── domain/task.dart # model + enum
 └── presentation/
 ├── providers/task_provider.dart # ChangeNotifier: CRUD + filter/search
 ├── screens/ # list, detail, form
 └── widgets/task_card.dart
```

Alur data: UI (`context.watch`) -> `TaskProvider` (mutasi + `notifyListeners`) -> rebuild otomatis.

---

## 5. Bukti pengujian dan tooling

```bash
# Tempel output `flutter analyze` di sini (atau ringkas: "No issues found!")
$ flutter analyze
<output>

# Tempel ringkasan `flutter test`
$ flutter test
<output, mis. "All tests passed!">
```

Known warnings/info dari `flutter analyze` (bila ada) dan alasannya dibiarkan:

| Warning/info | Lokasi | Alasan dibiarkan |
|---|---|---|
| `<mis. unused_element>` | `<file:baris>` | `<alasan teknis>` |

---

## 6. Bukti visual

| Bukti | File / link |
|---|---|
| Screenshot portrait | `<screenshots/portrait.png>` |
| Screenshot landscape | `<screenshots/landscape.png>` |
| Screenshot CRUD / toggle / search+filter | `<screenshots/crud.png>` |
| Screenshot empty/filter kosong | `<screenshots/empty.png>` |
| Screenshot state error + Retry (Assignment 2 / Proyek Akhir) | `<screenshots/error.png>` |
| Screenshot device attachment + denied (Proyek Akhir) | `<screenshots/device.png>` |
| Screenshot bukti restart (hanya jalur B) | `<screenshots/restart.png>` |
| APK rilis (hanya Proyek Akhir) | `<build/app/.../app-release.apk>` |

---

## 7. Narasi Pemanfaatan AI (WAJIB)

**Pemakaian AI:** `<Ya / Tidak>`

**Panjang wajib:** Assignment 1 & 2 = **800-1200 kata**; Proyek Akhir = **1000-1500 kata**. Bila tidak memakai AI sama sekali: 500-800 kata (Assignment) / 600-1000 kata (Proyek Akhir), tanpa penalti.

> Tulis dengan kalimatmu sendiri dan **sebut nama file, class, atau variabel milikmu**. Narasi yang berisi kalimat umum seperti "AI sangat membantu saya" tanpa detail proyek dinilai rendah. Rincian poin wajib ada di brief tugas §5.1.

### 7.1 Strategi pemanfaatan AI
`<Di bagian mana kamu memakai AI, di bagian mana sengaja tidak, dan bagaimana kamu menyusun prompt. Sertakan minimal satu contoh prompt konkret milikmu.>`

### 7.2 Keputusan menerima dan menolak saran AI
`<Minimal dua kasus (Proyek Akhir: tiga), sekurangnya satu penolakan + alasan teknis.>`

| # | Saran AI | Diterima / Ditolak | Alasan teknis |
|---|---|---|---|
| 1 | `<mis. pakai setState di list screen>` | Ditolak | `<state harus lewat Provider agar konsisten lintas layar>` |
| 2 | `<...>` | Diterima | `<...>` |

### 7.3 Cara verifikasi pemahaman
`<Apa yang kamu jalankan untuk membuktikan kode benar: flutter analyze, flutter test, uji manual. Sertakan bukti/output.>`

### 7.4 Penjelasan teknis dengan kata sendiri
`<Sesuaikan dengan tugas:>`
- **Assignment 1:** satu alur end-to-end (search+filter AND **atau** add task): `watch`/`read`, mutasi provider, `notifyListeners()`, rebuild.
- **Assignment 2:** alur data (UI -> provider -> repository -> lokal/remote) **dan** alur exception (status code -> `mapResponseToError` -> `sealed ApiError` -> `_error` -> UI), termasuk kenapa jenis error ditentukan dari status code bukan body. Sebutkan juga jalur lokal (A/B) dan alasannya.
- **Proyek Akhir:** satu jalur end-to-end + dua `sealed` (`ApiError`, `AttachmentResult`) + kenapa subtree `const` menghemat rebuild.

### 7.5 Refleksi kejujuran akademik *(wajib Proyek Akhir, opsional Assignment)*
`<Bagian mana murni analisismu, bagian mana dibantu AI, dan bagaimana kamu memastikan tetap menguasainya.>`

### 7.6 AI Interaction Log
Bila **Ya**, lampirkan file `AI-LOG.md` (salin template `../01-Orientasi/Template-AI-Interaction-Log.md`). Ringkasan:

- Jumlah interaksi tercatat: `<n>`
- Bagian yang dibantu AI: `<mis. diagnosis overflow Row, penjelasan watch vs read>`
- Core logic yang **tidak** dibantu AI (analisis sendiri): `<mis. search+filter AND, validator due date>`
- Saya siap menjelaskan tiap bagian yang dibantu AI bila ditanya: `[Ya]`

> **Peringatan:** tidak melampirkan AI log padahal memakai AI = pelanggaran kebijakan (`Panduan-Mahasiswa.md` §5).

---

## 8. Known limitation

`<Daftar hal yang belum sempurna atau batas implementasi. Jujur lebih baik. Contoh:>`

- Filter priority belum persist saat rotasi.
- Date picker memakai tanggal saja, tidak ada waktu spesifik.
- *(Jalur A)* Data tidak bertahan setelah app di-restart, karena memilih penyimpanan in-memory.
- `<lainnya>`

---

## 9. Referensi

- Materi P01-P07 di `02-Materi/`.
- Starter code di `06-Starter-Code/`.
- Rubrik: `04-Penugasan/Rubrik-Assignment-01.md`, `Rubrik-Assignment-02.md`, `Rubrik-Proyek-Akhir.md`.
- AI log template: `01-Orientasi/Template-AI-Interaction-Log.md`.

---

## 10. Checklist sebelum submit

- [ ] `flutter pub get`, `flutter analyze`, `flutter test` sudah dijalankan di mesin bersih.
- [ ] Semua fitur wajib (sesuai brief tugas) berjalan dan teruji manual.
- [ ] Screenshot lengkap sesuai §6.
- [ ] **Narasi Pemanfaatan AI (§7) ditulis lengkap sesuai panjang wajib.**
- [ ] Jalur lokal (A/B) dinyatakan beserta alasannya (Assignment 2 & Proyek Akhir).
- [ ] AI log dilampirkan bila memakai AI.
- [ ] Tidak ada secret/credential di repo.
- [ ] README ini diisi lengkap (tidak ada `<...>` tersisa).

---

**Template version:** v2.0, 2026-08-10 | **Konsisten untuk:** Assignment 1, Assignment 2, Proyek Akhir | **Sumber kebenaran struktur:** `00-Planning/Peta-Capaian-dan-Assessment.md`.

**Perubahan v2.0:** §7 dirombak jadi Narasi Pemanfaatan AI; ditambah field jalur penyimpanan lokal (A/B) karena SQLite kini opsional; penamaan Tugas 1/2/3 -> Assignment 1/2 + Proyek Akhir.
