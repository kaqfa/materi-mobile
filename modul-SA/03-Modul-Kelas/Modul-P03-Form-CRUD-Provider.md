# Modul Kelas P03, Form, CRUD, dan Provider

**Pemrograman Mobile Flutter, Remidi 7 PertemuanAplikasi jangkar:** Remedial Task Tracker
**Durasi:** 150 menit (3 × 50) | **Rasio praktik minimal:** 65%
**Pasangan:** `../02-Materi/P03-Form-CRUD-Provider.md` (materi)
**Sumber:** `../00-Planning/Peta-Capaian-dan-Assessment.md`, `../00-Planning/Runbook-Dosen.md`, `../05-Assessment/Lembar-Observasi.md`

> **Untuk dosen/asisten.** Modul ini panduan menjalankan kelas, bukan handout mahasiswa. `solution-reference/` **jangan dibagikan** sebelum sesi selesai. **Assignment 1 dibuka di akhir sesi**, brief `04-Penugasan/Assignment-01-Task-Tracker-Core.md` + `Rubrik-Assignment-01.md` siap sebelum kelas.

---

## BAGIAN 1: Overview

### Tujuan Hari Ini

Mahasiswa mampu:
1. Menjelaskan wiring Provider (`ChangeNotifierProvider`, `watch`/`read`) dan empat state UI (loading/error/empty/list).
2. Mengimplementasikan CRUD inti sampai seluruh `test/task_provider_test.dart` hijau dan UI reaktif.
3. Mengisi validator form + menjaga lifecycle controller (`dispose`).
4. **Memulai Assignment 1** dari fondasi starter P03 (sisa sesi + belajar mandiri).

### Rundown Kelas (150 menit)

```
00-10 Retrieval quiz (P02 widget/navigation) + review bug (10 menit)
10-30 Konsep Provider + live demo (20 menit)
30-85 Guided lab + 3 checkpoint (55 menit)
85-125 Praktik individual + observasi dosen (40 menit)
125-140 Challenge reveal + TUGAS 1 BRIEFING + mulai scaffold (15 menit)
140-150 Exit ticket + persiapan P04 (10 menit)
```

> Alokasi mengikuti format tetap (`Runbook-Dosen.md` bagian 3) dengan blok 5 dialokasikan untuk **pembukaan Assignment 1**, fondasi P01-P03 sudah lengkap, mahasiswa siap memulai. Bila kelas lemah di Provider, geser 5 menit dari blok 5 ke guided lab; **tugas tetap dibuka** (brief bisa ringkas). Jangan kurangi blok observasi (40').

### Yang Harus Sudah Ready (sebelum kelas)

- [ ] Starter `06-Starter-Code/p03-provider-crud/` lolos `pub get`/`analyze`; smoke hijau, `task_provider_test.dart` sebagian merah (baseline TODO CRUD terkonfirmasi).
- [ ] `flutter doctor` bersih; versi kelas dipin; dependency `provider ^6.1.2` terkunci.
- [ ] Peta pita P02 (widget/navigation) tervalidasi. Mahasiswa pita merah di navigasi/state dipasangkan dengan anchor hijau.
- [ ] `Lembar-Observasi.md` (satu per mahasiswa) siap diisi.
- [ ] **Assignment 1 dibuka:** `04-Penugasan/Assignment-01-Task-Tracker-Core.md` + `Rubrik-Assignment-01.md` + `Template-Submission-README.md` siap dibagikan di blok 5.
- [ ] `solution-reference/` di kanal privat, tidak terlihat mahasiswa.

---

## BAGIAN 2: Live Coding (Konsep + Demo)

### Demo 1: Provider, state pindah ke ChangeNotifier (10 menit)

_Ikuti dosen, jangan maju sendiri._

Tampilkan `main.dart` + `task_list_screen.dart` + `task_provider.dart` di proyektor. Tunjukkan:

1. `main.dart` -> `ChangeNotifierProvider(create: TaskProvider()..loadTasks())`.
2. `task_list_screen.dart` -> `context.watch<TaskProvider>()` di `build`, `context.read` di handler.
3. `flutter run` -> loading 300ms -> 20 task. Tap centang -> **tidak berubah** (TODO).

**Penting:**
- Sumber kebenaran `_tasks` pindah dari `State` (P02) ke `TaskProvider` (P03). Layar jadi `StatelessWidget`.
- `notifyListeners()` = kontrak reaktif; lupa satu -> UI diam walau data benar.
- Empat state UI berurutan: `isLoading` -> `error` -> `isEmpty` -> list.

**Test live (diskusi):**
- "Kalau saya `context.read` di `build`, apa yang terjadi?" (jawaban: tidak rebuild; UI diam).
- "Kenapa `tasks` getter pakai `List.unmodifiable`?" (jawaban: anti mutasi diam-diam dari luar).

### Demo 2: CRUD + notifyListeners + lifecycle (10 menit)

Live coding di DartPad atau file `scratch.dart`:

```dart
class Counter extends ChangeNotifier {
 int _count = 0;
 int get count => _count;

 void increment() {
 _count = _count + 1;
 notifyListeners(); // <- tanpa ini, UI tak rebuild
 }
}

// Konsumen:
final c = context.watch<Counter>();
// atau Consumer<Counter>(builder:...)
```

Dan pola controller + dispose:

```dart
late final TextEditingController _c;
@override
void initState() { super.initState(); _c = TextEditingController(); }
@override
void dispose() { _c.dispose(); super.dispose(); } // cegah leak
```

**Penting:**
- Setiap controller/node yang dibuat di state -> wajib `dispose`. Leak -> warning devtools, performa turun.
- Immutability: ubah `Task` lewat `copyWith`, bukan reassign field. `_tasks` boleh reassign (mutasi provider).
- Context misuse: simpan provider **sebelum** `await`, cek `mounted` setelahnya sebelum `context`/`setState`.

**Common errors (antisipasi):**
```
'UI tidak update walau data benar' -> lupa notifyListeners / pakai read di build.
'TextEditingController leak' -> lupa dispose.
'Looking up a deactivated widget's ancestor' -> context dipakai setelah await tanpa mounted guard.
```

> **Jangan** tunjukkan implementasi `addTask`/`updateTask`/`toggleComplete` lengkap di demo. Beri pola (counter); biarkan mahasiswa menerjemahkan ke `Task`.

---

## BAGIAN 3: Guided Lab, 3 Checkpoint (55 menit)

Ikuti materi `../02-Materi/P03-Form-CRUD-Provider.md`. Tiap checkpoint harus jalan sebelum lanjut (no broken state).

### CHECKPOINT 1: Provider + State UI (≈20')
- Mahasiswa baca `main.dart`/`task_list_screen.dart`/`task_provider.dart`; `flutter test test/widget_test.dart`; `flutter run` tampil loading->list.
- **Gate dosen:** wiring dipahami (watch vs read), loading+list terlihat. Mahasiswa bisa menjelaskan empat state UI.

### CHECKPOINT 2: CRUD Inti (≈25')
- Mahasiswa implementasi `addTask`/`updateTask`/`deleteTask`/`toggleComplete` + `notifyListeners`. Jalankan `flutter test test/task_provider_test.dart` -> semua hijau. Uji CRUD end-to-end.
- **Gate dosen:** seluruh test hijau + CRUD reaktif (UI update tanpa setState manual). Ini gate utama P03, tahan mahasiswa sampai lulus.

### CHECKPOINT 3: Validasi Form (≈10')
- Mahasiswa isi `_validateTitle` (`errTitleRequired`, `errTitleTooShort`) + pastikan `dispose` controller. Uji title kosong/pendek/valid.
- **Gate dosen:** form menolak input tidak valid; valid -> CRUD jalan; `dispose` utuh.

> Bila ada mahasiswa buntu > 10 menit di CP2, beri pertanyaan pengarah (bukan jawaban): "Method ini mutasi `_tasks` lalu apa yang kamu lupa panggil?" / "Immutability: pakai copyWith atau reassign field?" Catat bantuan di `Lembar-Observasi.md`.

---

## BAGIAN 4: Praktik Individual + Observasi (40 menit)

**Tujuan:** mengukur kemampuan individu mengimplementasikan-membuktikan, **tanpa AI untuk core logic CRUD/validator**.

### Praktik Mandiri (30')

Kerjakan di luar checkpoint wajib: perkaya **reaktivitas dan keandalan form**.

**Task:**
1. Tambah **unit test** edge case di `task_provider_test.dart`: `updateTask` pada id tidak ada tidak menambah jumlah (idempotent); `deleteTask` pada id tidak ada tidak crash.
2. Tambah validator **due date tidak di masa lalu** saat add (boleh masa lalu saat edit); tambah konstanta `AppStrings.errDueDateInPast`.
3. Pastikan `flutter analyze` + `flutter test` tetap hijau.

**Checklist progres:**
- [ ] 2 edge case test baru lulus.
- [ ] Validator due date bekerja + konstanta di `AppStrings`.
- [ ] `flutter analyze` bersih.
- [ ] Controller baru (bila ada) ter-`dispose`.

**Expected output (uji manual):**
```
form add: due date kemarin -> "Due date cannot be in the past.", tidak submit.
form add: due date besok -> valid -> save -> muncul di list.
provider.updateTask(id-tak-ada) -> count tetap (tidak +1).
```

**Bantuan:**
- Validator due date: bandingkan `_dueDate` dengan `DateTime.now()`; ingat komponen waktu (pakai `DateTime.date` bila perlu abaikan jam).
- Test idempotent: pakai `initialTasks` berbeda di `setUp` lokal atau instance provider baru di test body.
- `dispose` controller baru (mis. bila tambah field date terpisah) wajib.

### Challenge Individual (10')

Pilih satu level, kerjakan sendiri, siapkan bukti. Dinilai via `Lembar-Observasi.md`.

**Level 1 (Basic):** Unit test idempotent `updateTask` id tak ada (tidak menambah jumlah).

**Level 2 (Medium):** Validator due date tidak di masa lalu + konstanta `errDueDateInPast`.

**Level 3 (Advanced):** `filterByStatus` reaktif di provider (field `_statusFilter` + `notifyListeners`) yang AND dengan search; 2 unit test kombinasi.

**Submit:** screenshot + paste kode + 2-3 kalimat penjelasan.

> Challenge Level 2/3 = **bagian langsung dari Assignment 1** (search + filter status/category wajib). Mahasiswa yang selesaikan = semakin siap scaffolding tugas.

---

## BAGIAN 5: Pembukaan Assignment 1, Kickoff (selama blok 5, 15 menit)

**Pada menit 125, hentikan praktik individual.** Bagikan `Assignment-01-Task-Tracker-Core.md` + `Rubrik-Assignment-01.md` + `Template-Submission-README.md`. Brief singkat:

1. **Apa yang sudah dimiliki** (titik mulai = starter P03 yang sudah dikerjakan):
 - `Task` model + enum (P01) 
 - UI responsive, `TaskCard` reusable, navigation, layout (P02) 
 - Provider CRUD + loading/error/empty state + form validation (P03) 

2. **Apa yang harus ditambah sendiri di Assignment 1**:
 - Search title **dan** filter status/category (reaktif via provider/selector).
 - Detail screen penuh; delete confirmation (sudah ada `Dismissible`, perkuat).
 - Konsistensi state lintas layar; Material 3 rapi portrait+landscape.
 - `flutter analyze` bersih atau warning dijelaskan.

3. **Aturan AI Assignment 1**: mengikuti `Panduan-Mahasiswa.md` (P1-P3: AI untuk penjelasan/diagnosis, bukan core logic tanpa analisis). AI Interaction Log wajib bila memakai AI.

4. **Tenggat: sebelum P04.** Bukti: source/ZIP, **Narasi Pemanfaatan AI 800-1200 kata**, screenshot dua orientasi + flow utama, README, AI log. Lingkup berhenti di testing (`analyze` + `test` hijau), tanpa release APK.

5. **Mulai sekarang (sisa blok 5):** minta mahasiswa membuka brief, mencatat pertanyaan, dan menyusun **langkah pertama** (mis. "tambah `_searchQuery` + `_statusFilter` ke provider"). Dosen keliling menjawab hambatan awal. Ini menjamin mahasiswa pulang dengan arah jelas.

> **Bila waktu mepet:** ringkas brief ke 5 menit; sisa untuk Q&A langkah pertama. **Jangan menunda pembukaan**, Assignment 1 butuh waktu belajar mandiri yang cukup sebelum P04.

---

## BAGIAN 6: Take-Home / PR + Exit Ticket (10 menit terakhir)

**PR minggu depan (menuju P04):**
1. **Mulai Assignment 1**, selesaikan minimal search + satu filter sebelum P04.
2. Selesaikan ulang CP2 bila `task_provider_test.dart` belum semua hijau; kumpulkan diff + screenshot CRUD end-to-end.
3. Catat **satu konsep Provider yang belum jelas** untuk retrieval quiz P04 (mis. `notifyListeners`, `Consumer` vs `watch`).

**Persiapan P04:**
- Baca ulang `loadTasks()` di `task_provider.dart`; bayangkan sumbernya berganti dari `Task.getDummyTasks()` ke query SQLite.
- `addTask`/`updateTask`/`deleteTask` di P04 akan menulis ke DB lalu `notifyListeners`.

**Exit ticket:** satu konsep belum jelas + satu hal sudah jelas + screenshot CRUD + pernyataan pemakaian AI (lampirkan log bila ya).

Dosen mengisi pita praktik di `Lembar-Observasi.md` (Merah/Kuning/Hijau) + satu rekomendasi per mahasiswa. Mahasiswa yang `task_provider_test.dart` belum hijau wajib selesai sebelum mulai Assignment 1 sungguhan (action dosen).

---

## BAGIAN 7: References

- Materi: `../02-Materi/P03-Form-CRUD-Provider.md`.
- Diagnosis: `../01-Orientasi/Tes-Diagnostik-Konsep.md`, `../05-Assessment/Lembar-Observasi.md`.
- Tugas: `../04-Penugasan/Assignment-01-Task-Tracker-Core.md`, `../04-Penugasan/Rubrik-Assignment-01.md`, `../04-Penugasan/Template-Submission-README.md`.
- Starter: `../06-Starter-Code/p03-provider-crud/` (+ `solution-reference/`, dosen).
- Standar: `../../Standar Tutorial Koding PPB.md`, `../../Standar Pengembangan Materi PPB.md`.

---

## Catatan Dosen (Notes)

- **Penegakan AI (P1-P3):** AI hanya untuk penjelasan/diagnosis. Tolak bila core CRUD/validator tempel AI tanpa analisis; minta kerja ulang. Catat di `Lembar-Observasi.md` D7. Berlaku juga untuk Assignment 1.
- **Broken state = jangan lanjut.** `task_provider_test.dart` merah = belum lulus P03. Mahasiswa yang broken di CP2 wajib selesai sebelum mulai Assignment 1 sungguhan; Assignment 1 dibangun di atas CRUD yang sudah hijau.
- **`notifyListeners` = gate utama.** Bila UI diam walau data benar, hampir pasti lupa panggil. Latih mahasiswa membaca gejala ini (sambungan mindset debug P01).
- **Controller lifecycle.** Tekankan `dispose`; ini dipakai terus di P04+ (DB handle, stream). Memory leak = penalti performa di Proyek Akhir.
- **Context misuse.** Pastikan pola "simpan provider sebelum await + `mounted` guard" tertanam; akan kritis di P04 (async DB).
- **Pembukaan Assignment 1 wajib hari ini.** Jangan tunda ke P04, tenggat sebelum P04, mahasiswa butuh waktu. Blok 5 dilindungi; bila mepet, ringkas, jangan skip.
- **Anchor pairing.** Mahasiswa pita merah di state dipasangkan anchor hijau; bila Provider masih merah setelah P03, tunda mulai Assignment 1 sampai lulus (action dosen, catat tenggat individual).
- **Jangan bagikan solution-reference.** Peta pita + rekomendasi saja yang dikembalikan.
- **Pacing.** Observasi 40' tidak boleh dipangkas. Bila mepet, pangkas challenge Level 3, bukan observasi maupun blok 5.
- **Versi toolchain.** Catat versi kelas; starter memakai `sdk: ^3.4.0`, `flutter: ">=3.22.0"`, `provider: ^6.1.2`. Sesuaikan bila berubah.

---

**Kepatuhan produksi:**
- Rundown 150 menit, rasio praktik ≥ 65%, **blok khusus pembukaan Assignment 1** (menyisakan waktu memulai).
- 3 checkpoint + validasi testable + troubleshooting (lihat materi: dispose controller, notifyListeners, context misuse).
- Live demo, praktik mandiri, challenge 3 level, exit ticket.
- Notes dosen + penegakan AI + rujuk rubrik/observasi/tugas.
- Semua path merujuk starter P03 (`06-Starter-Code/p03-provider-crud/`) dan Assignment 1 (`04-Penugasan/`).

**Updated:** 2026-08-08
