# Kunci Diagnostik, PPB Remidi 7 Pertemuan (Khusus Dosen)

> **Status:** v2.0, 2026-08-10 (menyesuaikan tes diagnostik format pilihan ganda penuh)
> **Klasifikasi:DOSEN/ASISTEN SAJA, JANGAN DIBAGIKAN KE MAHASISWA.**
> **Aplikasi jangkar:Remedial Task Tracker**
> **Berisi:** kunci jawaban tes konsep + praktik, pembagian **Merah/Kuning/Hijau**, dan **action dosen** per pita.
> **Sumber:** `../01-Orientasi/Tes-Diagnostik-Konsep.md` (25 MC), `../01-Orientasi/Tes-Diagnostik-Praktik.md` (20 MC), `../00-Planning/Peta-Capaian-dan-Assessment.md`, `../00-Planning/Rubrik-Remedial.md`.
> **Versi Moodle:** `Moodle-Question-Bank.xml` (kategori `Diagnostik/Konsep` & `Diagnostik/Praktik`). Bila dijalankan di Moodle, penskoran otomatis dan bagian 2-3 dipakai sebagai rujukan pembahasan.
> **Penyimpanan:** folder `05-Assessment/`. Sertakan di repo privat/`solution-reference`; jangan letakkan di saluran distribusi mahasiswa.

---

## 1. Cara pakai

1. **Tes konsep (25 MC).** Skor 1 poin per soal, dikelompokkan per area (Dart / Widget-state / Async-error / Data-API / Testing), masing-masing 5 soal. Persen area = `benar / 5 × 100`.
2. **Tes praktik (20 MC).** Skor 1 poin per soal → `SkorPraktik = benar / 20 × 100`. Kelompok soal: filter (2.1-2.5), search (3.1-3.5), kombinasi/kualitas (4.1-4.5), verifikasi/debug (5.1-5.5).
3. Gabungkan ke pita **Merah/Kuning/Hijau** per area (bagian 4) dan pita **keseluruhan** (bagian 5).
4. Jalankan **action dosen** di bagian 6. Catat hasil di `Lembar-Observasi.md`.
5. **Jangan** mengembalikan kunci ke mahasiswa. Kembalikan hanya peta pita + rekomendasi, bukan jawaban.

> **Catatan format.** Sejak v2.0 kedua tes berbentuk pilihan ganda penuh sehingga penskoran objektif dan dapat diotomasi Moodle. Konsekuensinya, kualitas penalaran tidak lagi terbaca dari lembar jawaban: gali lewat **pertanyaan lisan singkat** saat praktik individual (bagian 6) dan `Lembar-Observasi.md`. Pola *distractor* yang dipilih mahasiswa adalah sinyal diagnosis paling berguna, lihat bagian 3.2.

---

## 2. Kunci tes konsep (`Tes-Diagnostik-Konsep.md`)

### 2.1 Dart

| Soal | Kunci ringkas | Bahan pembahasan / miskonsepsi umum |
|---|---|---|
| 1.1 | **C**, `final` + `const Task(this.title)` paling konsisten dengan null safety (field non-nullable terdefinisi). | A salah karena field non-null tanpa init/`late`/`required`; B salah (`String? title` + `Task(this.title)` tidak match tipe); D salah (`= null` ilegal pada non-null). |
| 1.2 | Cetak `[low, medium, high]`; comparator membandingkan `index`, sehingga urutan kembali ke urutan deklarasi enum; `name` adalah nama enum. | Terima bila keluaran benar dan alasan menyebut comparator/index atau urutan enum. |
| 1.3 | (a) `Task(title);` tidak menginisialisasi field; gunakan `Task(this.title);`. (b) `Task()` tanpa argumen ilegal -> beri argumen `Task('x')`. | Terima alternatif constructor dengan named `required this.title` + const. Distractor A/C/D masing-masing hanya menyentuh satu masalah. |
| 1.4 | `1` lalu `A, B, C`. | `where().length == 1`; `map().join` menghasilkan "A, B, C". |
| 1.5 | `Task(title ?? this.title, done: done ?? this.done);` | Terima `done: done ?? this.done`. Distractor A memakai `!` yang gagal saat argumen null. |

### 2.2 Widget dan state

| Soal | Kunci ringkas | Bahan pembahasan / miskonsepsi umum |
|---|---|---|
| 2.1 | **C**, ada state lokal yang berubah dan harus memicu rebuild pada widget itu. | Tolak A/B/D. |
| 2.2 | Layar **tidak berubah** walau `count` naik di memori (1, 2, …), `build` tidak dipanggil ulang. | Miskonsepsi umum: mengira nilai tidak bertambah sama sekali. |
| 2.3 | Bungkus kenaikan dengan `setState(() => count += 1);` | Terima ekuivalen (ValueNotifier/Provider) sepanjang jelas. |
| 2.4 | **B**, `notifyListeners()` memicu rebuild widget yang `listen`. | A salah (bukan seluruh app); C/D salah. |
| 2.5 | `Column(children: [Wrap/Row chips, Expanded(child: ListView...)])`. Tanpa `Expanded`, `ListView` ingin tinggi tak terbatas dalam `Column` tinggi terbatas -> overflow kuning. | Terima `CustomScrollView`/`ListView.builder` dengan header. Miskonsepsi umum: menyalahkan chips, bukan constraint `ListView`. |

### 2.3 Async, error, dan Future

| Soal | Kunci ringkas | Bahan pembahasan / miskonsepsi umum |
|---|---|---|
| 3.1 | **B**, Future satu nilai/kesalahan di masa depan; Stream banyak nilai seiring waktu. | |
| 3.2 | `A`, lalu `B`, lalu `C`, lalu `D`. `await Future.delayed(10ms)` menahan `main` sampai B tercetak; setelah itu `fetchAndPrint()` tidak di-`await`, maka C tercetak sebelum D. | Terima "A,B,C,D" beserta alasan `await` pertama dan pemanggilan kedua tanpa `await`. Distractor B/C menjebak yang mengira `fetchAndPrint()` ikut di-`await`. |
| 3.3 | Bungkus dengan `try {... } on Exception catch (e) { return (ok:false, error:e); }` atau lempar tipe spesifik yang ditangkap pemanggil; pemanggil menampilkan state error. | Distractor A (`return []`) menyamarkan error sebagai empty state, kesalahan paling sering. |
| 3.4 | Risiko: `setState` dipanggil setelah widget unmount -> "setState after dispose". Pencegahan: `if (!mounted) return;` / `CancelToken`/flag dibatalkan di `dispose()`. | Terima `mounted` check atau pembatalan. |
| 3.5 | JSON `{"id":"1","title":"A","completed":false}`; akses aman: `final m = jsonDecode(s) as Map<String,dynamic>; final t = m['title'] as String?;`. | Distractor A mengakses properti pada `dynamic`, gagal saat runtime. |

### 2.4 Data, API, state jaringan

| Soal | Kunci ringkas | Bahan pembahasan / miskonsepsi umum |
|---|---|---|
| 4.1 | **B**, tetap berfungsi offline + data bertahan setelah restart. | |
| 4.2 | Urutan wajib: loading -> (success / empty / error). Contoh konkret bebas; mis. loading = `CircularProgressIndicator`; error = pesan + tombol "Coba lagi". | Miskonsepsi umum: menganggap empty cukup ditampilkan sebagai list kosong. |
| 4.3 | 1=GET, 2=POST, 3=PATCH (atau PUT), 4=DELETE. | Terima PUT untuk #3 bila dijelaskan (full vs partial). |
| 4.4 | `--dart-define=API_BASE_URL=...` / `.env.example`; jangan hardcode secret karena ikut ke repo/version control -> kebocoran walau tugas kelas. | Terima penjelasan privasi/kebocoran. |
| 4.5 | Pemisahan = UI tidak tahu sumber data; beralih remote->mock hanya ganti implementasi repository, UI tetap. | Distractor B adalah kebalikan manfaat repository. |

### 2.5 Testing dan kualitas

| Soal | Kunci ringkas | Bahan pembahasan / miskonsepsi umum |
|---|---|---|
| 5.1 | **B**, unit: logika murni; widget: interaksi & render. | |
| 5.2 | Test: siapkan list campuran status, panggil `filterByStatus`, `expect(result, everyElement((t)=>t.status==status))` / cek panjang; edge = list kosong / status tak ada tugas. | Distractor A hanya menguji "tidak kosong", tidak menegaskan kontrak. |
| 5.3 | Dua penyebab: (a) `searchTasks` salah (mis. bandingkan case-sensitif atau `==` bukan `contains`); (b) ekspektasi matcher salah `[hasLength(1)]` untuk list hasil. Bukti: cetak hasil aktual / perbaiki matcher. | Terima (a) logika search, (b) matcher, (c) tipe data. |
| 5.4 | `analyze` = analisis statis (lint/typing), `test` = verifikasi perilaku runtime. Lulus analyze ≠ benar perilaku. | Miskonsepsi umum: menganggap analyze bersih = perilaku benar. |
| 5.5 | Contoh urutan: (1) cek isi sumber data (cetak list); (2) cek filter/search aktif (kosongkan/kondisikan); (3) cek render/empty-state. | Terima urutan ekuivalen yang mempersempit dari sumber->logika->render. |

### 2.6 Skor konsep

- Tiap area (Dart, Widget-state, Async-error, Data-API, Testing) dinormalkan ke 0-100.
- Bobot area seragam 20% -> `SkorKonsep = rata-rata 5 area`.

---

## 3. Kunci tes praktik (`Tes-Diagnostik-Praktik.md`, 20 MC)

### 3.1 Kunci jawaban

| Soal | Kunci | Kompetensi yang diukur |
|---|---|---|
| 2.1 | Operator `!=` terbalik, seharusnya `==` | Membaca predikat `where` |
| 2.2 | `if (selected == null) return tasks;` | Menangani kasus "All" |
| 2.3 | Bug ada di konsumen getter, bukan model | Menghormati batas perubahan |
| 2.4 | `completed`, karena `isCompleted` dicek lebih dulu | Urutan `if` pada getter turunan |
| 2.5 | `FilterChip`/`ChoiceChip` dengan properti `selected` | Widget standar, tanpa dependency baru |
| 3.1 | `startsWith` hanya awal + case-sensitive | Diagnosis bug search |
| 3.2 | Guard query kosong + `toLowerCase().contains()` | Implementasi R2 lengkap |
| 3.3 | Guard query kosong/whitespace tidak ada | Membaca gejala -> penyebab |
| 3.4 | `onChanged` + `setState` | Input reaktif real-time |
| 3.5 | `controller.dispose()` di `dispose()` | Lifecycle controller |
| 4.1 | `searchByTitle(filterByStatus(...), query)` | Komposisi AND (R3) |
| 4.2 | `where().toList()` mempertahankan urutan | Order-preserving |
| 4.3 | "Tidak ada tugas yang cocok dengan 'zzz'" | Empty state kontekstual (R4) |
| 4.4 | Agar dapat di-unit test + tidak duplikat | Pemisahan domain/UI |
| 4.5 | State ganda basi (stale) | Derived state |
| 5.1 | Jalankan `flutter test`, baca nama test gagal | Sikap debug: baca spesifikasi |
| 5.2 | Test menyatakan ekspektasi benar; aktual memuat status lain | Membaca kegagalan test |
| 5.3 | `flutter test` hijau + uji manual per chip | Bukti verifikasi |
| 5.4 | Analyze statis; bug logika runtime tetap lolos | Batas alat |
| 5.5 | Sumber data -> filter/query -> render | Urutan investigasi |

`SkorPraktik = (jumlah benar / 20) × 100`.

### 3.2 Membaca pola distractor (diagnosis, bukan sekadar skor)

Karena format MC menyembunyikan penalaran, **pola salah** adalah sinyal utama. Gunakan tabel ini untuk menentukan intervensi:

| Pola salah dominan | Dugaan akar masalah | Tindakan |
|---|---|---|
| Banyak salah di 2.1-2.5 | Belum lancar membaca predikat/kondisi Dart | Ulang P01 CP2 (koleksi + getter `status`) sebelum P02 |
| Banyak salah di 3.1-3.5 | Lemah manipulasi `String` + lifecycle controller | Latihan `toLowerCase().contains()` + review `dispose` di P03 |
| Salah di 4.1-4.2 | Belum paham komposisi fungsi (AND) & order-preserving | Bimbing menulis ulang helper filter+search berantai |
| Salah di 4.4-4.5 | Belum paham pemisahan logika/UI & derived state | Tekankan saat P03 (Provider) dan P06 (testability) |
| Salah di 5.1-5.5 | **Sikap debug lemah**, ini yang paling merah | Prioritas 1:1; wajibkan verbalisasi langkah debug tiap checkpoint |
| Memilih 2.3 opsi "ubah getter" | Cenderung melanggar batasan saat buntu | Ingatkan aturan batasan sebelum Assignment 1 |
| Memilih 5.4 opsi "analyze pasti keliru" | Salah paham fungsi tooling | Jelaskan statis vs runtime di awal P06 |

> Bila `SkorPraktik` tinggi tetapi mahasiswa tidak dapat menjelaskan alasannya secara lisan, perlakukan sebagai **Kuning**, bukan Hijau, dan catat di `Lembar-Observasi.md`.

## 4. Pembagian pita per area (konsep) dan keseluruhan (praktik)

Pita ditentukan untuk **tiap area konsep** dan untuk **skor praktik** secara terpisah, agar dosen tahu titik lemah spesifik.

| Pita | Rentang | Arti |
|---|---|---|
| Hijau Hijau | ≥ 70 | Konsep/praktik kuat; siap advance sebagai *anchor* teman di lab. |
| Kuning Kuning | 40-69 | Paham sebagian; butuh penguatan area ini saat sesi terkait. |
| Merah Merah | < 40 | Fundamental retak; butuh intervensi dulu sebelum lanjut sesi inti. |

Pemetaan area -> sesi prioritas (untuk action dosen):

| Area lemah | Sesi yang paling relevan |
|---|---|
| Dart (model/enum/null-safety) | P01, P03 (model + Provider) |
| Widget/state/layout | P02, P03 |
| Async/error | P05 (REST), P03 (state UX) |
| Data/API/state jaringan | P04 (SQLite), P05 (REST) |
| Testing/kualitas | P06, P07 |
| Praktik filter/search (P01) | P01 (debug), P02-P03 (UI/state) |

---

## 5. Pita keseluruhan (gabungan konsep + praktik)

`SkorGabungan = 0,5·SkorKonsep + 0,5·SkorPraktik` (bila kedua tes dikerjakan; bila hanya salah satu, pakai itu dan catat).

| Pita gabungan | Rekomendasi ringkas |
|---|---|
| Hijau Hijau (≥70) | Fungsikan sebagai *peer anchor*; tetap ikut sesi penuh. |
| Kuning Kuning (40-69) | Fokus pada area pita merah spesifik selama lab terkait. |
| Merah Merah (<40) | Sesi 1:1 lebih awal sebelum P02; review ulang Dart/widget. |

---

## 6. Action dosen per pita

### Merah Merah (satu area atau gabungan)
- Pasangkan dengan *anchor* hijau di lab sesi terkait.
- Wajibkan ulang checkpoint pertama sesi terkait sebelum lanjut (no broken state, lihat `Runbook-Dosen.md` bagian 6).
- Tambah satu micro-quiz retrieval di awal sesi berikut pada area merah.
- Bila Dart+widget merah -> jangan izinkan mulai Assignment 1 sampai P02 checkpoint-1 lulus.

### Kuning Kuning
- Beri *exit ticket* bertarget pada area kuning.
- Saat praktik individual, observasi ekstra pada area ini (`Lembar-Observasi.md`).
- Cek ulang di retrieval quiz sesi berikutnya.

### Hijau Hijau
- Manfaatkan sebagai demonstrasi/demo singkat (15' block) di sesi terkait.
- Tetap divalidasi via `flutter analyze`/`test`; hijau bukan bebas dari gate.

### Pelanggaran kebijakan
- Konsep/praktik dikerjakan AI, mencontek, atau mengubah model/batasan -> **tidak membatalkan keikutsertaan**, tetapi:
 - catat di `Lembar-Observasi.md`;
 - pita praktik diturunkan satu tingkat (Hijau->Kuning, Kuning->Merah);
 - jadwalkan wajib bimbingan AI policy sebelum sesi berikut (`../01-Orientasi/Panduan-Mahasiswa.md` bagian 5).

---

## 7. Catatan kunci & variasi setara

- Soal praktik filter/search mengikuti variasi `../UTS/UJIAN_01` & `UJIAN_02` tetapi **distel ke 30 menit dalam format 20 MC**. Untuk semester berikutnya, buat variasi setara: ganti field filter (prioritas), tukar posisi bug, atau ubah gejala, namun **jaga cakupan R1-R4 + verifikasi** dan jumlah soal per kelompok (5/5/5/5) agar pemetaan pita tetap sebanding antar angkatan.
- Bila format kembali ke hands-on (mis. untuk ujian susulan), rubrik 100 versi lama masih tersedia di riwayat git berkas ini (`v1.0`, commit sebelum 2026-08-10).
- Bila starter berubah (mis. enum `TaskStatus` berbeda), sesuaikan kunci 1.2/4.3/5.2 dan ekspektasi R1 tanpa mengubah struktur dokumen.
- Kunci ini hanya untuk dosen. Setiap kebocoran (kunci dibagikan, soal diposting) merusak fungsi diagnosis, simpan di kanal privat.

---

## 8. Sign-off dosen

- Pengoreksi: ____________________
- Tanggal koreksi: ____________________
- Jumlah mahasiswa merah/kuning/hijau: Merah ____ / Kuning ____ / Hijau ____
- Rencana intervensi prioritas: ____________________
