# Modul Kelas P02, Widget, Layout, dan Navigasi

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker
**Durasi:** 150 menit (3 × 50) | **Rasio praktik minimal:** 65%
**Pasangan:** `../02-Materi/P02-Widget-Layout-Navigation.md` (materi)
**Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`, `../00-Planning/Runbook-Dosen.md`, `../05-Assessment/Lembar-Observasi.md`

> **Untuk dosen/asisten.** Modul ini panduan menjalankan kelas, bukan handout mahasiswa. `solution-reference/` **jangan dibagikan** sebelum sesi selesai.

---

## BAGIAN 1: Overview

### Tujuan Hari Ini

Mahasiswa mampu:
1. Membaca dan menjelaskan widget tree `TaskCard` reusable + `task_list_screen` stateful.
2. Menyambungkan navigasi list -> detail dan list -> add memakai `Navigator.push`/`pop`, termasuk result balik + `mounted` guard.
3. Menyusun layout responsive `LayoutBuilder` + `ListView`/`GridView` tanpa overflow pada portrait+landscape.

### Rundown Kelas (150 menit)

```
00-10 Retrieval quiz (P01 koleksi/model) + review bug (10 menit)
10-30 Konsep minimum + live demo widget/navigation (20 menit)
30-85 Guided lab + 3 checkpoint (55 menit)
85-125 Praktik individual + observasi dosen (40 menit)
125-140 Demo singkat + challenge reveal (15 menit)
140-150 Exit ticket + instruksi PR / preview (10 menit)
```

> Alokasi mengikuti format tetap (`Runbook-Dosen.md` bagian 3). Bila kelas lemah di widget tree, geser 10 menit dari guided lab ke konsep; jangan kurangi blok observasi (40').

### Yang Harus Sudah Ready (sebelum kelas)

- [ ] Starter `06-Starter-Code/p02-ui-navigation/` lolos `pub get`/`analyze`; `task_card_test.dart` + smoke hijau sebagai baseline.
- [ ] `flutter doctor` bersih di mesin target; versi kelas dipin (catat di compatibility matrix).
- [ ] Peta pita P01 (Dart/Widget) sudah tervalidasi. Mahasiswa pita **merah di widget** wajib duduk di baris depan dan dipasangkan dengan anchor hijau.
- [ ] `Lembar-Observasi.md` (satu per mahasiswa) siap diisi selama blok praktik individual.
- [ ] `solution-reference/` di kanal privat, tidak terlihat mahasiswa.
- [ ] Emulator/ device siap **rotate** (landscape) untuk demo CP3.

---

## BAGIAN 2: Live Coding (Konsep + Demo)

### Demo 1: Membaca widget tree, bukan menebak (10 menit)

_Ikuti dosen, jangan maju sendiri._

Tampilkan `task_card.dart` + `task_list_screen.dart` di proyektor. Tunjukkan:

1. `flutter run` -> 20 task tampil memakai `TaskCard`.
2. Sorot `Card` -> `InkWell(onTap)` -> `Padding` -> `Row` -> `Icon` + `Expanded(Column)`.
3. Tap card -> **tidak terjadi apa-apa** (TODO `_openDetail`). Ini sengaja, bukan bug.

**Penting:**
- `TaskCard` **Stateless** + **dumb**: tidak pegang state, aksi lewat `onTap` callback.
- `Expanded` mencegah overflow; `Wrap` menampung chip dinamis; `maxLines:2`+`ellipsis` pangkas deskripsi.
- `Theme.of(context)` ambil tema global; jangan hardcode `TextStyle`.

**Test live (diskusi):**
- "Kalau saya hapus `Expanded`, apa yang terjadi saat deskripsi panjang?" (jawaban: `RenderFlex overflowed`).
- "Kenapa `TaskCard` tidak boleh langsung `Navigator.push`?" (jawaban: reusable; navigasi urusan layar).

### Demo 2: Navigator sebagai stack + result (10 menit)

Live coding di DartPad atau file `scratch.dart`:

```dart
// Pola result balik
final result = await Navigator.of(context).push<String>(
 MaterialPageRoute<String>(builder: (_) => const SecondScreen()),
);
print('kembali dengan: $result');

// Di SecondScreen, tombol save:
Navigator.of(context).pop<String>('hello');
```

**Penting:**
- `push` menambah layar di stack; `pop` membuang. `pop<T>(value)` membawa hasil.
- Tipe generik `<T>` harus cocok di sisi push dan pop.
- **Wajib** `if (!mounted) return;` setelah `await` di `State` sebelum `setState`/pakai `context`. Ini fondasi anti context-misuse untuk P03.

**Common errors (antisipasi):**
```
'RenderFlex overflowed by N pixels' -> kurang Expanded/Wrap; lihat Demo 1.
'setState() called after dispose()' -> lupa `mounted` guard setelah await.
'type Null is not a subtype of Task' -> tipe generik push/pop tidak cocok.
```

> **Jangan** tunjukkan implementasi `_openDetail`/`_addTask` lengkap di demo. Beri kerangka; biarkan mahasiswa menyambung sendiri.

---

## BAGIAN 3: Guided Lab, 3 Checkpoint (55 menit)

Ikuti materi `../02-Materi/P02-Widget-Layout-Navigation.md`. Tiap checkpoint harus jalan sebelum lanjut (no broken state).

### CHECKPOINT 1: TaskCard + task list (≈20')
- Mahasiswa baca `task_card.dart` + `task_list_screen.dart`; `flutter test test/task_card_test.dart`; `flutter run` tampil 20 task.
- **Gate dosen:** test hijau + mahasiswa bisa menjelaskan peran `Expanded`/`Wrap`/`onTap` callback. Lompat ke CP2 bila lingkungan siap dan pita widget ≥ kuning.

### CHECKPOINT 2: Navigasi list-detail/add (≈20')
- Mahasiswa implementasi `_openDetail` (push `TaskDetailScreen`) dan `_addTask` (push `AddTaskScreen`, pop result, `setState` add). Wajib `if (!mounted) return;`.
- Uji: tap card -> detail; FAB -> add -> "Save (sample)" -> "New Task" muncul.
- **Gate dosen:** navigasi dua arah jalan; TIDAK ada `setState after dispose` di log saat back cepat. Bila ada, tahan mahasiswa, ini fondasi P03.

### CHECKPOINT 3: Responsive (≈15')
- Mahasiswa baca `LayoutBuilder` (breakpoint ≥ 600); perbaiki `mainAxisExtent` bila overflow; uji rotasi.
- **Gate dosen:** portrait 1 kolom, landscape grid, tidak ada overflow. Screenshot kedua orientasi.

> Bila ada mahasiswa buntu > 10 menit di CP2, beri pertanyaan pengarah (bukan jawaban): "Tipe generik apa yang kamu pakai di `push` dan `pop`? Cocok?" Catat bantuan di `Lembar-Observasi.md`.

---

## BAGIAN 4: Praktik Individual + Observasi (40 menit)

**Tujuan:** mengukur kemampuan individu membaca-menyambungkan-membuktikan, **tanpa AI untuk core logic navigasi/layout**.

### Praktik Mandiri (30')

Kerjakan di luar checkpoint wajib: perkaya **UX dan detail widget**.

**Task:**
1. Lengkapi `TaskDetailScreen` menjadi layar detail yang rapi: judul besar, deskripsi penuh (tidak `maxLines`), baris info due/priority/status memakai warna `AppColors`, plus ikon kontekstual.
2. Tambah satu **widget test** baru di `test/`: tap `TaskCard` membuka detail dan judul task terlihat di layar detail.
3. Pastikan `flutter analyze` + `flutter test` tetap hijau; rotasi tetap tidak overflow.

**Checklist progres:**
- [ ] `TaskDetailScreen` menampilkan semua info task tanpa overflow.
- [ ] Widget test baru lulus.
- [ ] `flutter analyze` bersih.
- [ ] Detail screen tidak crash saat task punya deskripsi sangat panjang.

**Expected output (uji manual):**
```
tap card t03 (Physics Lab Report) -> detail tampil: judul, deskripsi penuh,
 due date, HIGH, OVERDUE (warna merah).
rotate landscape -> detail tetap utuh, tidak overflow.
flutter test -> all passed.
```

**Bantuan:**
- Detail overflow vertikal? `ListView` alih-alih `Column` untuk konten panjang.
- Test tidak menemukan detail? Pastikan push pakai `MaterialApp` sebagai ancestor di test; gunakan `NavigatorObserver` bila perlu.
- Warna chip tidak muncul? Pakai `AppColors.statusOverdue`/`priorityHigh`, bukan hardcode.

### Challenge Individual (10')

Pilih satu level, kerjakan sendiri, siapkan bukti screenshot + kode. Dinilai via `Lembar-Observasi.md`.

**Level 1 (Basic):** Tambah widget test: tap `TaskCard` membuka judul detail di layar baru.

**Level 2 (Medium):** Tambah `onToggleComplete` (opsional) ke `TaskCard` + tombol centang; di list, `setState` toggle `isCompleted` via `copyWith`. Strikethrough berubah real-time; `task_card_test.dart` tetap lulus.

**Level 3 (Advanced):** Tiga-kondisi breakpoint di `LayoutBuilder` (`<400`, `400-600`, `≥600`) + satu test yang memverifikasi satu kondisi layout.

**Submit:** screenshot + paste kode + 2-3 kalimat penjelasan pendekatan.

**Kriteria evaluasi:**
- Level 1: test lulus, alur detail tercakup.
- Level 2: toggle reaktif + reusable + test tetap hijau.
- Level 3: tiga layout berbeda teruji, `analyze` bersih.

---

## BAGIAN 5: Take-Home / PR

> P02 **belum membuka tugas formal** (Assignment 1 dibuka setelah P03). PR P02 adalah penguatan dan refleksi.

**PR minggu depan:**
1. Selesaikan kembali CP2 + CP3 bila belum tuntas dalam sesi; kumpulkan screenshot portrait+landscape + satu paragraf refleksi tentang **kenapa `mounted` guard wajib**.
2. Catat **satu konsep widget yang belum jelas** di exit ticket (bawa untuk retrieval quiz P03).
3. Bila pita **widget merah** dari P01, baca ulang `task_card.dart` dan eksplorasi `Row`/`Column`/`Expanded` di DartPad sebelum P03; dosen akan menambah micro-quiz retrieval.

**Persiapan P03:**
- Baca ulang `task_list_screen.dart`; bayangkan `_tasks` pindah dari `State` ke `TaskProvider`.
- Sketsa form tambah task (title/description/date/priority) untuk mengganti stub `AddTaskScreen`.

---

## BAGIAN 6: Exit Ticket (selama 15' terakhir)

Kumpulkan dari tiap mahasiswa:
- **Satu konsep widget yang belum jelas** (spesifik).
- **Satu hal yang sekarang sudah jelas** (bukti pemahaman: mis. "saya tahu kapan pakai `Expanded`").
- Screenshot portrait + landscape + detail screen.
- Pernyataan: apakah memakai AI? Bila ya, lampirkan `Template-AI-Interaction-Log.md`.

Dosen mengisi pita praktik di `Lembar-Observasi.md` (Merah/Kuning/Hijau) dan satu rekomendasi tindak lanjut per mahasiswa. Mahasiswa yang masih broken di CP2 (navigasi belum jalan) wajib selesai sebelum P03 (action dosen).

---

## BAGIAN 7: References

- Materi: `../02-Materi/P02-Widget-Layout-Navigation.md`.
- Diagnosis: `../01-Orientasi/Tes-Diagnostik-Konsep.md`, `../05-Assessment/Lembar-Observasi.md`.
- Starter: `../06-Starter-Code/p02-ui-navigation/` (+ `solution-reference/`, dosen).
- Standar: `../../Standar Tutorial Koding PPB.md`, `../../Standar Pengembangan Materi PPB.md`.

---

## Catatan Dosen (Notes)

- **Penegakan AI (P1-P3):** AI hanya untuk penjelasan widget/diagnosis error. Tolak bila core logic navigasi/layout tempel AI tanpa analisis; minta kerja ulang. Catat di `Lembar-Observasi.md` D7.
- **Broken state = jangan lanjut.** Mahasiswa yang gagal CP2 (navigasi belum nyambung) tidak boleh masuk CP3/P03 tanpa selesai. Ini gate utama P02.
- **`mounted` guard = fondasi P03.** Tekankan. Bila ada `setState after dispose` di log, tahan mahasiswa; context-misuse akan kumat di P03 (async form save).
- **Responsive bukan opsi.** Assignment 1 wajib "tidak overflow pada portrait+landscape". Latih di CP3 sejak sekarang.
- **Anchor pairing.** Mahasiswa pita merah di widget dipasangkan dengan anchor hijau; bila widget masih merah setelah P02, tunda mulai Assignment 1 sampai P03 CP1 lulus.
- **Jangan bagikan solution-reference.** Kunci observasi + rekomendasi saja yang dikembalikan.
- **Pacing.** Observasi 40' tidak boleh dipangkas. Bila waktu mepet, pangkas challenge Level 3, bukan observasi.
- **Versi toolchain.** Catat versi kelas (`flutter --version`); starter memakai `sdk: ^3.4.0`, `flutter: ">=3.22.0"`. Sesuaikan bila berubah.

---

**Kepatuhan produksi:**
- Rundown 150 menit, rasio praktik ≥ 65%.
- 3 checkpoint + validasi testable + troubleshooting (lihat materi).
- Live demo, praktik mandiri, challenge 3 level, exit ticket.
- Notes dosen + penegakan AI + rujuk rubrik/observasi.
- Semua path merujuk starter P02 (`06-Starter-Code/p02-ui-navigation/`).

**Updated:** 2026-08-08
