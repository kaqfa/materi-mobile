# Audit Gap Modul vs RPS — PPB 20251

Dokumen kerja untuk menutup todo AGENTS.md §10 butir 1. Ruang lingkup: 14 bab `modul-buku/` diuji terhadap `RPS PPB - 20251.md` (P01–P16, Sub-CPMK, kolom AI Integration) dan terhadap gate penilaian di `penugasan/README.md`.

Metode: penelusuran konten per bab (heading, kata kunci teknis, frontmatter), bukan pembacaan kesan. Setiap temuan menyebut lokasi buktinya.

**Ringkasan**: dari 5 gap yang tercatat di README, **1 sudah beres** (Supabase), **2 ternyata sebagian tertutup** (responsive, realtime), **1 adalah gap struktural yang lebih besar dari yang tertulis** (P11), dan **1 benar-benar kosong** (blok AI). Ditambah 2 temuan baru soal konsistensi RPS.

---

## Peta Pemetaan RPS ↔ Bab (akar banyak masalah)

Tabel ini tidak ada di dokumen mana pun, dan ketiadaannya yang membuat gap sulit dilacak.

| Pertemuan RPS | Topik | Bab pendamping | Status |
|---|---|---|---|
| P01 | Intro & Dart fundamentals | 01 | ✅ |
| P02 | Dart deep dive (OOP, async, null safety) | 02 | ✅ |
| P03 | Flutter fundamentals & widget | 03 | ✅ |
| P04 | Build system & project structure | 04 | ✅ |
| P05 | Material Design | 05 (CP 1) | ✅ |
| P06 | Custom widget & animasi | 06 | ✅ |
| P07 | **Responsive & adaptive layout** | 05 (CP 2) | ⚠️ sebagian |
| UTS | — | — | soal ada di `Ujian/UTS/` |
| P09 | API integration (Supabase) | 09 | ✅ |
| P10 | **Real-time & advanced API** | 10 | ⚠️ sebagian |
| P11 | **Advanced state management** | **— tidak ada** | ❌ |
| P12 | Testing & QA | 11 | ✅ |
| P13 | Platform features | 12 | ✅ |
| P14 | Performance optimization | 13 | ✅ |
| P15 | Deployment | 14 | ✅ |

Sejak P11 penomoran bergeser satu langkah (P12→bab 11, P13→bab 12, dst). Pergeseran ini sendiri tidak masalah — AGENTS.md §2 memang menolak pemetaan 1:1 — tetapi konsekuensinya: **P11 adalah satu-satunya pertemuan tanpa bab pendamping sama sekali**, dan P11 punya graded gate (capstone M5).

---

## Gap 1 — P07 Responsive & Adaptive Layouts

**Status: sebagian tertutup.** Catatan README ("tidak ada bab khusus") tidak akurat.

**Sudah ada** — bab 05 Checkpoint 2 "Layout yang Mengikuti Ruang" (baris 352–441), tiga halaman yang justru salah satu bagian terkuat buku:

- model constraints turun / ukuran naik, dengan argumen eksplisit menolak `screenWidth * 0.045`
- breakpoint **berbasis ruang tersedia**, bukan jenis perangkat, lewat `LayoutBuilder`
- `Center` + `ConstrainedBox(maxWidth: 600)` sebagai pola readable-width, dengan rujukan window size class M3
- text scaling: `MediaQuery.textScalerOf`, larangan menonaktifkan scaler, `Expanded`/`Wrap`/`maxLines`
- frontmatter sudah membawa tag `responsive-design` dan objective adaptif

**Yang belum ada** dan diminta RPS P07 serta gate M2 ("3 konfigurasi layar"):

| Kekurangan | Bukti | Dampak |
|---|---|---|
| Tidak ada perubahan **struktur** layout saat ruang melebar | seluruh bab 05 hanya menyesuaikan margin dan lebar maksimum | mahasiswa mengira "responsif = atur padding"; gate M2 menuntut lebih |
| `NavigationRail`, dua kolom, master-detail | 0 kemunculan di 14 bab | pola tablet paling kanonik di Material 3 tidak pernah muncul |
| `OrientationBuilder` / penanganan landscape | 0 kemunculan | RPS menyebut phone landscape sebagai satu dari 3 konfigurasi wajib |
| `AspectRatio` | 0 kemunculan | disebut eksplisit di praktikum P07 |
| Prosedur uji multi-konfigurasi | tidak ada | gate M2 menilai pengujian 3 konfigurasi, tanpa panduan cara mengujinya |

Catatan lingkup: "adaptive" dalam arti *platform* (Cupertino, `.adaptive` constructor) juga nol. Ini menurut saya **layak di-descope secara sadar**, bukan ditambal — RPS P07 bicara ukuran layar, bukan platform, dan buku sudah Android-first sampai bab deployment. Yang perlu dilakukan hanya menyatakan batas itu secara tertulis.

### Rekomendasi 1 — perluas bab 05, jangan buat bab baru

Tambahkan **Checkpoint 3 baru** di bab 05 (menggeser "Interaksi dan Aksesibilitas" menjadi Checkpoint 4), judul usulan: **"Struktur yang Berubah, Bukan Sekadar Margin"**, estimasi 40 menit, isi:

1. `LayoutBuilder` dengan dua cabang tata letak nyata: `< 600 dp` → daftar penuh + `BottomNavigationBar`; `≥ 600 dp` → `Row` dua kolom (daftar + detail) dengan `NavigationRail` menggantikan bottom nav.
2. Konsekuensi state yang jarang dibahas tutorial lain, dan cocok dengan gaya buku: pada layar sempit "pilih tugas" berarti `Navigator.push`, pada layar lebar berarti mengganti `selectedId` di panel kanan. Satu controller, dua cara menampilkan — ini pelajaran arsitekturnya, bukan sekadar widget.
3. `OrientationBuilder` untuk kasus ponsel landscape, dengan catatan kapan orientasi *bukan* sinyal yang benar (ponsel landscape ≈ tablet potret dalam hal ruang).
4. Penutup: checklist verifikasi 3 konfigurasi (ponsel potret, ponsel landscape, tablet) yang bisa dipakai ulang sebagai lampiran brief M2.

Tambahkan satu paragraf "Batas bab ini" yang menyatakan buku memilih responsif-berbasis-ruang dan tidak membahas adaptasi per-platform, dengan alasannya. Bab 12 sudah punya pola "Batas Bab Ini" (baris 53) — ikuti gayanya.

**Biaya**: ±180 baris, satu bab tersentuh. **Tidak** perlu mengubah penomoran bab.

---

## Gap 2 — P09 Supabase

**Status: sudah beres. Baris ini harus dihapus dari tabel gap README.**

Bab 09 sudah sepenuhnya Supabase, bukan backend generik: 22 kemunculan, endpoint `/rest/v1` PostgREST, alur `signUp`/`signIn`/refresh token, `flutter_secure_storage` untuk sesi, kunci lewat `--dart-define`, satu bagian penuh tentang **Row Level Security** (baris 1076), dan referensi lanjutan ke dokumentasi Supabase Auth serta PostgREST. Bab 10 (8 kemunculan) dan bab 14 (17) melanjutkan backend yang sama.

Satu selisih kecil yang tersisa: RPS P09 menyebut **Postman** untuk menguji API, buku memakai `MockClient` dari `http/testing.dart` (bab 09 baris 984, "Menguji Tanpa Server"). Pendekatan buku lebih baik untuk otomatisasi, tetapi Postman berguna saat mahasiswa memverifikasi Supabase project miliknya sendiri sebelum menulis kode.

### Rekomendasi 2

1. Hapus baris Supabase dari tabel gap di `README.md`.
2. Sisipkan satu paragraf di bab 09 Checkpoint 1 (setelah "Dua Kunci, Satu Rahasia"): verifikasi endpoint dan `anon key` lewat Postman/`curl` sebelum baris Dart pertama ditulis — supaya kegagalan konfigurasi Supabase tidak terbaca sebagai bug kode. Cukup 1 paragraf + 1 blok `curl`.

---

## Gap 3 — P10 Real-time Features

**Status: gap nyata, tetapi lebih kecil dari kesan README, dan sebagian layak ditolak.**

Bab 10 justru **melampaui** RPS pada bagian yang penting: transactional outbox, tombstone, push-sebelum-pull, kebijakan konflik eksplisit yang dibuktikan test, pemetaan kegagalan ke `SyncStatus`, backoff eksponensial. Ini materi tingkat produksi.

Yang kurang, diukur terhadap kalimat RPS P10:

| Diminta RPS | Kondisi bab 10 |
|---|---|
| WebSocket / replikasi real-time | hanya 1 tautan di "Referensi Lanjutan" (baris 900), tanpa kode maupun penjelasan |
| Pemicu sinkronisasi (koneksi pulih) | disebut 1 paragraf naratif (baris 744), tanpa kode `connectivity_plus` |
| Background sync (WorkManager) | tidak ada |
| Firebase services | tidak ada, dan memang seharusnya tidak ada |

### Rekomendasi 3 — tambal dua, tolak satu, dan koreksi RPS

**3a. Tambahkan sub-bab "Pemicu Sinkronisasi" di bab 10** (sebelum "Ringkasan"), ±60 baris: kode nyata `connectivity_plus` listener + tombol manual di app bar + `Timer.periodic` sebagai jaring pengaman, ketiganya memanggil `sync()` yang sama. Poinnya sudah ditulis di baris 744 sebagai narasi — tinggal diberi kode.

**3b. Tambahkan penutup "Dari Menarik Menjadi Didorong"** ±40 baris: satu contoh `stream()` Supabase Realtime yang memicu `sync()` ketika server berubah, dijelaskan sebagai *pemicu tambahan*, bukan pengganti arsitektur outbox. Ini menutup kata "real-time" di RPS tanpa merusak alur bab.

**3c. Tolak WorkManager, dan katakan alasannya di bab.** Background execution Android modern (Doze, batasan target API 36 yang sudah dianut bab 14) terlalu mahal untuk satu pertemuan, tidak dinilai di rubrik mana pun, dan gagal diam-diam di banyak perangkat — mahasiswa akan menghabiskan sesi praktikum mengejar hantu OEM. Cukup satu paragraf "Batas Bab Ini" yang menyebut background sync sebagai arah lanjutan.

**3d. Keputusan Bapak diperlukan**: RPS P10 menyebut **Firebase** dua kali (materi dan tugas) padahal seluruh buku memakai Supabase. Ini inkonsistensi di dokumen resmi, bukan di modul. Pilihan: (i) revisi RPS P10 → "Supabase Realtime" dan hapus Firebase dari Media Pembelajaran, atau (ii) biarkan sebagai alternatif tak-diajarkan. Saya menyarankan (i) — mencampur dua backend dalam satu mata kuliah 16 minggu hanya menambah beban setup, bukan pemahaman. Tapi RPS kemungkinan sudah tervalidasi prodi, jadi saya tidak menyentuhnya tanpa perintah.

---

## Gap 4 — P11 BLoC/Riverpod (gap terbesar)

**Status: gap struktural, dan rumusan di README meremehkannya.**

Masalahnya bukan sekadar "index buku bilang tidak dibahas". Masalahnya: **P11 tidak punya bab pendamping sama sekali**, sementara P11 memegang gate bernilai (capstone M5 "refactor state management", ditandai ✅ gate di `penugasan/README.md`). Mahasiswa diminta mengambil keputusan arsitektur yang dinilai, tanpa bahan bacaan di modul.

Yang sebenarnya sudah tersedia, tersebar:

- bab 07: `ChangeNotifier`, state layar sebagai sealed class, `MultiProvider`, dependency injection lewat constructor, mendengar secara granular
- bab 13 Checkpoint 3: `Consumer` vs `Selector` vs `context.select` menurut cakupan rebuild
- bab 07 baris 72: satu paragraf pembanding Riverpod/BLoC — argumennya bagus ("keduanya dibangun di atas keputusan yang sama"), tapi satu paragraf tanpa kode tidak cukup menopang gate bernilai

Yang benar-benar tidak ada: kode pembanding Riverpod atau BLoC, kriteria pemilihan, state restoration lintas siklus hidup, undo/redo (disebut RPS P11).

Ada pula **inkonsistensi internal**: `index.md` baris 35 menyatakan Riverpod dan BLoC "tidak dibahas sebagai materi inti", sementara AGENTS.md §6 menyatakan "BLoC/Riverpod hanya pembanding, sesuai RPS P11" — dua kalimat yang mengaku sepakat tetapi memberi ekspektasi berbeda ke pembaca. (Kalimat di `index.md` juga cacat kecil: "keduanya" dipakai untuk empat item.)

### Rekomendasi 4 — Opsi A: perluas bab 07 (rekomendasi saya)

Tambahkan bagian **"Arah Setelah Provider"** di bab 07, setelah Checkpoint 2, ±200 baris:

1. Ambil satu unit yang sudah dikenal pembaca — `TaskListController` — dan tulis ulang berdampingan dalam tiga bentuk: Provider (yang sudah ada), Riverpod `Notifier`, BLoC `event → state`. Kode pendek, fitur identik, jadi yang terlihat adalah perbedaan *bentuknya*, bukan perbedaan fiturnya.
2. Tabel perbandingan jujur: boilerplate, keterujian, DI, cakupan rebuild, kurva belajar, kematangan ekosistem.
3. Kriteria pindah yang bisa dikutip mahasiswa di dokumen keputusan arsitektur M5 — misalnya: lebih dari satu sumber state yang saling bergantung, kebutuhan riwayat event (undo/redo, audit), tim besar yang butuh konvensi kaku.
4. Satu paragraf state restoration setelah proses dimatikan sistem.

Ini cukup karena gate M5 menilai **keputusan arsitektur yang terdokumentasi**, bukan penguasaan BLoC. Perbaiki juga kalimat `index.md` baris 35 agar berbunyi "dibahas sebagai pembanding, bukan materi inti".

**Opsi B — bab 15 baru "Advanced State Management".** Paling selaras RPS, tetapi mahal: `chapters: 14` → 15 di index, rantai `nextChapter`/`prevChapter` bab 14, klaim "14 bab" di README dan AGENTS.md, dan menabrak kebijakan revisi inkremental AGENTS.md §2. Ambil hanya bila M5 kelak dinaikkan bobotnya.

**Opsi C — turunkan target RPS P11** menjadi "Provider lanjutan + perbandingan arsitektur". Paling murah, tapi menurunkan capaian dan menyentuh dokumen resmi. Tidak disarankan bila Opsi A bisa dikerjakan.

---

## Gap 5 — Blok AI Integration per bab

**Status: kosong sepenuhnya.** Nol kemunculan "AI Integration", "Generate-Analyze-Improve", maupun "Error-First" di 14 bab. Sementara RPS memberi kolom AI Integration di **setiap** pertemuan, mengalokasikan **5%** nilai untuk AI Integration Portfolio, dan AGENTS.md §8 mewajibkan materi mencerminkan fase AI.

Tetapi ada jebakan desain yang perlu disebut sebelum menambal: **fase AI terikat minggu, bab tidak terikat minggu.** Menempelkan "Minggu 5–8: AI hanya untuk debugging" di bab 05 akan salah begitu ada mahasiswa yang membaca bab 05 di minggu 3, atau mengulang di minggu 12 — dan buku ini secara eksplisit dirancang untuk belajar mandiri (`index.md`: "Baca secara berurutan pada penjelajahan pertama").

### Rekomendasi 5 — pisahkan dua lapis

**Lapis 1 — di buku, bebas-minggu.** Blok pendek di akhir tiap bab sebelum "Referensi Lanjutan", judul tetap **`## Bekerja dengan AI di Bab Ini`**, tiga butir saja:

- apa yang wajar didelegasikan ke AI untuk topik bab ini (mis. bab 09: menyusun kerangka mapping JSON)
- apa yang harus ditulis manual agar konsepnya benar-benar menempel (mis. bab 09: hierarki error dan keputusan refresh-lalu-ulang)
- satu latihan konkret dari kode bab itu — Generate-Analyze-Improve atau Error-First, dipilih sesuai sifat materi

Tanpa menyebut nomor minggu, tanpa menyebut kebijakan penilaian. Sekitar 15–20 baris per bab.

**Lapis 2 — di `penugasan/`, terikat minggu.** Kebijakan fase (1–4 / 5–8 / 9–12 / 13–16) dan kewajiban interaction log hidup di brief tugas dan `penugasan/README.md` — tempat yang memang tahu minggu keberapa artefak dikerjakan. `penugasan/README.md` sudah menyebut fase ini di Filosofi butir 5; tinggal dijadikan blok baku di tiap brief.

**Urutan pengerjaan** (14 bab sekaligus terlalu besar untuk satu putaran): dahulukan bab yang menopang gate bernilai — 05, 06, 09, 10, 11, 12, 13, 14 — lalu bab 01–04 dan 07–08 menyusul.

---

## Temuan Tambahan di Luar 5 Gap

**T1 — README tidak punya peta RPS ↔ bab.** Tabel gap yang ada sekarang menyebut gejala ("P07 tidak ada bab khusus") tanpa menampilkan pergeseran pemetaan pasca-UTS yang menjadi penyebabnya. Rekomendasi: ganti tabel gap README dengan tabel pemetaan di bagian atas dokumen ini, plus kolom status.

**T2 — RPS menyebut tiga alat yang tidak dipakai buku**: Postman (P09 & Media Pembelajaran), Firebase (P10 & Media Pembelajaran), WorkManager (P10). Buku memakai MockClient, Supabase, `connectivity_plus`. Perlu satu keputusan menyeluruh, bukan tambal per kasus. Saran saya: RPS menyesuaikan buku, karena buku lebih matang dan sudah tervalidasi kode. Keputusan ada di Bapak, karena RPS adalah dokumen resmi prodi.

**T3 — README menyebut `penugasan/` berisi brief, kenyataannya baru ada `README.md`.** Sembilan brief capstone (M0–M9) dan dua brief individu masih kosong, sementara M0 dipakai P04. Ini risiko jadwal yang lebih mendesak daripada gap modul mana pun di atas. (Soal UTS sudah ada 5 berkas di `Ujian/UTS/`, jadi sisi ujian aman.)

---

## Prioritas Pengerjaan

Diurutkan menurut risiko terhadap penilaian, bukan menurut besar pekerjaan.

| # | Pekerjaan | Gap | Biaya | Kenapa urutan ini |
|---|---|---|---|---|
| 1 | Brief capstone M0 + individu P02/P03 | T3 | sedang | dipakai P02–P04, tenggatnya paling dekat |
| 2 | Bab 07: "Arah Setelah Provider" | 4 | ±200 baris | satu-satunya gate (M5) tanpa bahan bacaan |
| 3 | Bab 05: Checkpoint struktur adaptif + checklist 3 konfigurasi | 1 | ±180 baris | menopang gate M2 |
| 4 | Bab 10: pemicu sinkronisasi + realtime + batas bab | 3 | ±100 baris | menutup kata "real-time" RPS |
| 5 | Blok AI di 8 bab bergate | 5 | ±20 baris × 8 | menopang 5% AI Portfolio |
| 6 | Perbaiki README (peta RPS↔bab, hapus baris Supabase) + `index.md` baris 35 | 2, T1 | kecil | menghentikan pelacakan gap yang keliru |
| 7 | Blok AI di 6 bab sisanya | 5 | ±20 baris × 6 | kelengkapan |
| 8 | Keputusan konsistensi RPS (Postman/Firebase/WorkManager) | T2, 3d | keputusan | butuh persetujuan, bukan waktu kerja |

Butir 1 tidak menyentuh modul sama sekali, jadi bisa berjalan paralel dengan butir 2–5.
