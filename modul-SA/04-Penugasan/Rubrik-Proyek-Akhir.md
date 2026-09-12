# Rubrik Proyek Akhir, NearBite (Kuliner), QA, Release, dan Demo

**Pemrograman Mobile Flutter, Remidi 7 Pertemuan | Aplikasi:** **NearBite** (kuliner, resto terdekat) | **Beban tugas:** 40%
**Mengukur brief:** `Proyek-Akhir-QA-Release-dan-Demo.md` | **Skema data:** `ERD-dan-API-NearBite.md`
**Sumber kebenaran asesmen:** `../00-Planning/Peta-Capaian-dan-Assessment.md`, `../00-Planning/Rubrik-Remedial.md`

> **Aturan:** rubrik menilai **indikator observable**, bukan niat. Aplikasi saja tidak cukup; **narasi tertulis** + demo tatap muka + live modification + bukti visual wajib. Indikator bertanda **(gate)** yang gagal membatalkan poin indikator turunan. Seluruh gate dapat dinilai **tanpa Play Store / signing key / akun berbayar**.

> **Bukti visual = screenshot**; penjelasan kode = **narasi tertulis** (brief §6.1) + **demo tatap muka**.

> **Topik: aplikasi kuliner NearBite.** **Mahasiswa yang menyerahkan aplikasi bertopik lain tidak memenuhi brief** → dimensi A dinilai berdasarkan fitur kuliner yang benar-benar ada.

> **Dua hal yang OPSIONAL dan tidak boleh mengurangi nilai:**
> 1. **SQLite/cache lokal** → opsional; hanya membuka skor 4 pada indikator **(bonus C)**. Menurunkan nilai karena tidak memakai SQLite adalah **kesalahan penilaian**.
> 2. **Device feature kedua** → cukup **salah satu** (GPS **atau** kamera). Mengerjakan keduanya hanya membuka skor 4 pada indikator **(bonus D)**. Menuntut keduanya adalah **kesalahan penilaian**.

> **Mock/fixture fallback tidak diwajibkan** (keputusan pengampu). Jangan menilai ketiadaan mock sebagai kekurangan. Namun bila server mati saat demo, indikator yang tidak dapat ditunjukkan dinilai apa adanya, lihat §5.

---

## 1. Cara pakai rubrik

1. Tiap indikator dinilai skala **0-4** (tabel di bawah).
2. Konversi: `poin dimensi = (rata-rata skor indikator dimensi / 4) × bobot dimensi`.
3. Total = **100 poin**.
4. Indikator **gate** yang dapat skor 0 → semua indikator turunan di dimensi itu dipaksa 0.
5. Penilaian final memperhitungkan **narasi tertulis** (dimensi E) dan **demo + live modification** yang dinilai terpisah di `../05-Assessment/Rubrik-Demo-dan-Wawancara.md`.

### Skala 0-4

| Skor | Label | Definisi |
|---:|---|---|
| 4 | Sangat Baik | Semua kriteria tercapai, konsisten, plus bukti tambahan (edge case, test tambahan, dokumentasi tajam, **atau** bonus terbukti pada indikator bertanda (bonus C)/(bonus D)). |
| 3 | Baik | Seluruh kriteria inti tercapai; catatan minor saja. |
| 2 | Cukup | Sebagian kriteria inti tercapai; ada kekurangan yang dapat diperbaiki dalam sesi. |
| 1 | Kurang | Hanya sebagian kecil tercapai; banyak kerentanan/broken state. |
| 0 | Tidak ada / tidak jujur | Indikator tidak ada, atau ditemukan plagiarisme/tidak menguasai kode sendiri. |

---

## 2. Dimensi dan indikator (total 100 poin)

### Dimensi A, Fitur Inti & Domain Kuliner (20 poin)
*Mengukur: akses tanpa login bagi pencari, auth ringan pemilik, profil resto, CRUD menu, resto terdekat + search + detail. Area RPS 53.1 (widget/state/CRUD).*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| A1 | **Pencari dapat memakai app tanpa login** | Buka app (belum login) → **langsung** daftar resto terdekat; search + detail resto & menu dapat diakses **tanpa akun**; tidak ada layar login/register yang menghadang | gate |
| A2 | **Auth ringan pemilik bekerja** | Register + login berhasil; sesi tersimpan (tidak login ulang tiap buka); layar pemilik terkunci sebelum login; logout menghapus sesi dan kembali ke mode pencari; kredensial salah → pesan jelas, bukan crash | |
| A3 | **Profil resto lengkap** | Owner menyimpan/mengubah nama, deskripsi, alamat, jam buka, **foto**, dan **koordinat** (lat/long terisi); validasi nama ≥3 karakter | |
| A4 | **CRUD menu lengkap** | Tambah, tampil, ubah, hapus menu berfungsi; validasi **harga numerik ≥0** menolak input salah; harga tampil terformat (mis. `Rp25.000`) | gate |
| A5 | **List resto terdekat + jarak** | Home menampilkan resto **terurut jarak**; jarak tampil di kartu (mis. "1,2 km"); urutan berubah masuk akal saat posisi berubah/di-mock | gate |
| A6 | **Search resto & menu** | Pencarian cocok pada **nama resto atau nama menu**; case-insensitive substring; real-time; query kosong → semua | |
| A7 | **Detail resto + seluruh menu** | Ketuk kartu → detail resto (foto, alamat, jarak, jam buka) **beserta daftar menunya** | |

**Konversi:** `poin A = (rata2 A1-A7 / 4) × 20`.

> **Gate A1:** bila pencari **dipaksa login/register** untuk sekadar melihat daftar atau detail resto, A1 = 0. Ini melanggar requirement §4.1 brief, bukan sekadar pilihan desain.

> **Gate A4/A5:** CRUD menu dan daftar terdekat adalah inti aplikasi ini. Bila salah satu tidak berfungsi sama sekali, dimensi A turun drastis.

> **Menyerahkan topik lama (Task Tracker):** A1-A7 dinilai 0 karena fitur yang diminta tidak ada. Ini bukan penalti tambahan, melainkan konsekuensi tidak memenuhi brief.

### Dimensi B, Testing (20 poin)
*Mengukur: unit ≥3, widget ≥2, gate hijau, edge case. Area RPS 92.2 (utama).*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| B1 | **Unit test ≥3 lulus** | Menguji logika murni domain ini: **jarak/Haversine**, **sorting terdekat**, **search resto/menu**, mapper JSON (`Restaurant`/`MenuItem`), mapping `ApiError`, atau validator harga | gate |
| B2 | **Widget test ≥2 lulus** | Mis. validasi form menu (nama kosong → error; harga non-numerik → error) + state UI list resto (empty / error+retry / list) | gate |
| B3 | **`flutter test` gate** | Output **All tests passed!**; tidak ada test di-skip/`// ignore:` tanpa alasan tertulis | gate |
| B4 | **Test tidak bergantung jaringan** | Test memakai fake/stub datasource, **bukan** memanggil server sungguhan; test tetap hijau saat offline | |
| B5 | **Edge case teruji** | Minimal satu: jarak titik identik = 0, list kosong, search tanpa hasil, harga `0`, `menu_items` tidak ada di JSON, koordinat `int` vs `double` | |

**Konversi:** `poin B = (rata2 B1-B5 / 4) × 20`.

> **Cara cepat memeriksa B4:** matikan WiFi lalu jalankan `flutter test`. Bila merah, test bergantung jaringan → B4 ≤ 1.

### Dimensi C, Data Online & Error Handling (20 poin)
*Mengukur: REST/Supabase via repository, `sealed ApiError`, state UI lengkap, no-secret. Area RPS 53.2 + 92.2.*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| C1 | **Data tersimpan online** | Data resto/menu benar-benar dari backend (Supabase/sendiri); perubahan dari app **terlihat di dashboard/DB**; data tetap ada setelah app di-uninstall/install ulang | gate |
| C2 | **Arsitektur berlapis** | Panggilan jaringan lewat **repository/datasource**, bukan `http.get` di widget; provider hanya bicara ke repository | |
| C3 | **`sealed ApiError` + state UI lengkap** | Error dipetakan dari **status code** (401/404/4xx/5xx/network); UI menampilkan **loading, success, empty, error + retry** yang benar-benar memanggil ulang. **(bonus C)** skor 4 bila cache/SQLite lokal terbukti menampilkan data saat offline | gate |
| C4 | **Skema backend sesuai ERD** | Tiga entitas (`users`, `restaurants`, `menu_items`) + relasi benar; skema/SQL dilampirkan; seed ≥8 resto tersebar | |
| C5 | **No-secret rule** | Tidak ada API key/anon key/`.env`/keystore di repo; `.gitignore` benar; `git status` bersih; base URL & key via `--dart-define` | gate |
| C6 | **Otorisasi dasar** | Data yang butuh auth memakai token; owner **tidak dapat** mengubah menu milik owner lain (RLS/otorisasi backend) | |

**Konversi:** `poin C = (rata2 C1-C6 / 4) × 20`.

> **Gate C5:** menemukan API key/anon key ter-commit → C5 = 0, **dan** wajib diperlakukan sebagai temuan hygiene (mahasiswa diminta me-rotasi key). Anon key Supabase memang dirancang publik, tetapi **service_role key tidak**; menemukan `service_role` di repo adalah pelanggaran serius.

### Dimensi D, Device Feature & Release APK (25 poin)
*Mengukur: GPS/kamera + permission branch, analyze + const, build & uji APK rilis. Area RPS 92.2 (device) + 53.2 (APK).*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| D1 | **Device feature aktif (GPS atau kamera)** | Minimal **satu** terintegrasi dan berfungsi: GPS mengambil posisi, atau kamera/galeri mengambil foto. **(bonus D)** skor 4 bila **keduanya** terintegrasi dengan baik | gate |
| D2 | **Hasil device dipetakan `sealed`** | Ada tipe hasil `sealed` (mis. `LocationResult`/`AttachmentResult`) dengan cabang success/denied/unavailable; penanganan **exhaustive** | |
| D3 | **Permission branch terbukti di UI** | Izin diberikan → fitur jalan; **izin ditolak → pesan/banner pemulihan, bukan crash**; layanan mati (GPS off / emulator tanpa kamera) → pesan fallback | gate |
| D4 | **`flutter build apk --release` sukses** | APK terbentuk di `build/app/outputs/flutter-apk/app-release.apk`; ukuran dicatat (`du -h`) | gate |
| D5 | **APK terinstall + uji fungsional** | Install tanpa `INSTALL_FAILED_*`; launch tanpa crash; **uji pada rilis**: login → list terdekat → search → detail+menu → CRUD menu → device feature → error+retry | gate |
| D6 | **Permission runtime diuji pada rilis** | Cabang izin diuji pada **APK rilis** (bukan hanya debug); manifest mendeklarasikan permission yang dipakai (`INTERNET`, `ACCESS_FINE_LOCATION` dan/atau `CAMERA`) | |
| D7 | **`analyze` bersih + `const`** | **No issues found!** atau warning dijelaskan di README; subtree immutable `const`; tidak ada `// ignore:` tanpa alasan | |

**Konversi:** `poin D = (rata2 D1-D7 / 4) × 25`.

> **Syarat bukti D3:** wajib ada **screenshot** kondisi izin diberikan **dan** izin ditolak (boleh diperagakan langsung saat demo). Tanpa bukti, D3 maksimal skor 2.

> **Gate D4/D5:** APK gagal build/install atau uji fungsional gagal → demo ditunda (planning §9: gate hijau = prasyarat penilaian).

### Dimensi E, Dokumentasi, Narasi AI & Kesiapan Demo (15 poin)
*Mengukur: README + skema backend, narasi tertulis, kesiapan live mod, AI log. Area RPS 92.2 + 53.1.*

| # | Indikator (observable) | Bukti yang dilihat | Gate |
|---:|---|---|:---:|
| E1 | **README lengkap + skema backend** | Cara run (termasuk `--dart-define` dengan placeholder), backend yang dipakai + cara menyiapkannya, arsitektur, device feature yang dipilih + alasan, known limitation, bukti `analyze`+`test`, ukuran APK | |
| E2 | **Narasi: evolusi & keputusan AI** | 1000-1500 kata; evolusi pemakaian AI lintas paket + **minimal tiga kasus** konkret, sekurangnya satu **penolakan** + alasan teknis | gate |
| E3 | **Narasi: penjelasan teknis** | Dengan kata sendiri: satu jalur end-to-end; `sealed ApiError` (error dari **status**, 401 vs 404/500); `sealed` hasil device (izin sebagai **nilai**, bukan exception); **kenapa fungsi jarak dipisah** dan bagaimana itu membuatnya dapat diuji. Penjelasan **cocok dengan source** | gate |
| E4 | **Rehearsal live modification** | Bukti ≥2 kategori soal bank di-rehearsal (screenshot gate hijau/catatan); siap ditarik soal di sesi final | |
| E5 | **Verifikasi + refleksi + AI log** | Narasi menyebut `analyze`/`test`/uji APK sebagai bukti + menyatakan bagian mana dibantu AI. AI log lengkap bila memakai AI; bila tidak memakai AI dan narasi 600-1000 kata konsisten → skor penuh (N/A, bukan nol) | |

**Konversi:** `poin E = (rata2 E1-E5 / 4) × 15`.

> **Gate E2/E3:** gagal (skor 0) karena narasi generik tanpa detail spesifik proyek, **tidak cocok dengan source**, **bertentangan dengan jawaban lisan saat Q&A**, atau plagiarisme → poin dimensi **A, B, C, D juga dipaksa 0** (`Rubrik-Remedial.md` §4-§5: nilai aplikasi saja tidak cukup).

> **Narasi vs Q&A (panduan dosen):** dimensi E menilai **narasi tertulis**; demo lisan dinilai di `Rubrik-Demo-dan-Wawancara.md`. Bila narasi tajam tetapi mahasiswa tidak dapat menjawab hal yang **ia tulis sendiri**, tangani sebagai temuan integritas, bukan sekadar skor rendah.

---

## 3. Lembar skor

| Dimensi | Bobot | Indikator (skor 0-4) | Rata-rata | Poin |
|---|---:|---|---:|---:|
| A, Fitur inti & domain kuliner | 20 | A1 A2 A3 A4 A5 A6 A7 = _ _ _ _ _ _ _ | __ | __ / 20 |
| B, Testing | 20 | B1 B2 B3 B4 B5 = _ _ _ _ _ | __ | __ / 20 |
| C, Data online & error handling | 20 | C1 C2 C3 C4 C5 C6 = _ _ _ _ _ _ | __ | __ / 20 |
| D, Device feature & release APK | 25 | D1 D2 D3 D4 D5 D6 D7 = _ _ _ _ _ _ _ | __ | __ / 25 |
| E, Dokumentasi, narasi AI & demo | 15 | E1 E2 E3 E4 E5 = _ _ _ _ _ | __ | __ / 15 |
| **Total** | **100** | | | **__ / 100** |

**Dicatat dari README:**
- Backend: `[ ] Supabase`  `[ ] Backend sendiri` → _____________
- Device feature: `[ ] GPS`  `[ ] Kamera`  `[ ] Keduanya (bonus D)`
- Cache/SQLite lokal: `[ ] Tidak (sah)`  `[ ] Ya (bonus C)`

---

## 4. Bukti wajib

- **Source/ZIP** + repo URL bila ada, dapat di-build di mesin bersih.
- **Release APK** (`app-release.apk`) + ukuran (`du -h`).
- **Skema backend** (SQL/DDL Supabase atau repo backend) + cara seed data.
- **Narasi Pemanfaatan AI 1000-1500 kata** (brief §6.1).
- **Screenshot**: login, list resto + jarak, search (resto & menu), detail resto + menu, form menu dengan validasi harga, device feature **izin diberikan** + **izin ditolak**, state error + retry, output `analyze`+`test`.
- **README** memakai `Template-Submission-README.md`.
- **AI Interaction Log**, wajib bila memakai AI.
- **Demo individual + live modification tatap muka**, dinilai via `../05-Assessment/Rubrik-Demo-dan-Wawancara.md`.

---

## 5. Panduan bila server mati saat demo

Karena mock fallback tidak diwajibkan, kegagalan jaringan mungkin terjadi. Pedoman agar penilaian tetap adil dan konsisten:

1. **Beri kesempatan pemulihan singkat** (maksimal 5 menit): ganti jaringan/hotspot, bangunkan backend yang tidur.
2. Bila pulih → nilai normal, **tanpa pengurangan**.
3. Bila tidak pulih:
   - Indikator yang **dapat** dibuktikan dari **screenshot submission** (A1-A7, C1, D3) dinilai dari bukti tersebut, **maksimal skor 3** (karena tidak terverifikasi langsung).
   - Indikator yang **menuntut app berjalan** (D5 uji fungsional rilis) dinilai dari rekaman bukti submission; bila tidak ada bukti sama sekali → skor sesuai keadaan (dapat 0).
   - **Live modification tetap dijalankan**, karena mengubah kode + `analyze`/`test` **tidak butuh jaringan**. Ini melindungi mahasiswa: kemampuan inti tetap terukur.
4. Catat kejadian di `Lembar-Observasi.md`. **Jangan** menjadwal ulang demo hanya karena jaringan, kecuali dosen menilai kegagalan murni bersumber dari infrastruktur kampus.

> Mahasiswa sudah diperingatkan di brief §4.6.1. Kesiapan backend adalah bagian dari tanggung jawab rilis, tetapi jangan menghukum dua kali (sekali lewat indikator yang gagal, sekali lewat penalti tambahan).

---

## 6. Quick reference: red flags (skor rendah otomatis)

- **Pencari dipaksa login/register** untuk melihat daftar atau detail resto → A1 = 0 (gate).
- **Menyerahkan Task Tracker** (topik lama), bukan aplikasi kuliner → A1-A7 = 0.
- CRUD menu tidak berfungsi / harga menerima teks & nilai negatif → A4 = 0 (gate).
- Daftar resto tidak terurut jarak atau jarak tidak ditampilkan → A5 ≤ 1.
- Jarak dihitung di dalam `build()`/tidak dapat di-unit-test → A5 ≤ 2 dan B1 ≤ 2.
- Test kurang dari 3 unit / 2 widget, atau `flutter test` merah → B1/B2/B3 = 0 (gate).
- Test memanggil server sungguhan (merah saat offline) → B4 ≤ 1.
- Data hanya di memori/lokal, tidak benar-benar tersimpan online → C1 = 0 (gate).
- Backend menolak baca tanpa token (RLS/otorisasi menuntut login untuk `select`) sehingga pencari melihat daftar kosong → A1 = 0 + C6 ≤ 2.
- `http` dipanggil langsung di widget tanpa repository → C2 ≤ 1.
- Tidak ada state error/retry (error hanya `print`/layar kosong) → C3 ≤ 1.
- **API key/anon key/`service_role`/`.env` ter-commit** → C5 = 0 + minta rotasi key.
- **Izin ditolak → app crash** (bukan pesan) → D3 ≤ 1.
- Tidak ada bukti visual izin diberikan + ditolak → D3 maksimal 2.
- APK gagal build/install → D4/D5 = 0 (gate).
- `// ignore:` tanpa alasan / linter dimatikan agar "hijau" → D7 = 0.
- Narasi generik tanpa detail proyek → E2 ≤ 1; tanpa satu pun saran AI yang ditolak → E2 ≤ 2.
- Narasi tidak menjelaskan `sealed`/jalur end-to-end/alasan fungsi jarak dipisah, atau tidak cocok dengan source → E3 = 0 (gate) → dimensi A, B, C, D juga 0.
- Tidak ada rehearsal live mod → E4 ≤ 1.

> **Bukan red flag** (jangan dikurangi nilainya):
> - Tidak memakai SQLite/cache lokal (opsional, bonus C).
> - Hanya mengerjakan **satu** device feature, GPS **atau** kamera (sesuai brief).
> - Tidak menyediakan mock/fixture fallback (tidak diwajibkan).
> - Tidak menampilkan peta interaktif (di luar scope; koordinat + jarak sudah cukup).
> - Memakai lokasi palsu emulator untuk menguji urutan jarak, selama dicatat di README.

---

## 7. Konversi nilai akhir

1. Skor mentah rubrik = 0-100.
2. Proyek Akhir berkontribusi ke **area RPS 92.2 (device/testing/dokumentasi) sebagai bukti utama**, plus 53.1 (widget/state/CRUD via fitur kuliner) dan 53.2 (REST + APK rilis). Demo + live modification berkontribusi ke 53.1 + 92.2. Pemetaan di `../00-Planning/Peta-Capaian-dan-Assessment.md` §6.
3. Konversi nilai remidi final mengikuti aturan prodi/dosen (`Rubrik-Remedial.md` §6).

---

**Status rubrik:** v3.0, 2026-08-10 | **Konsistensi:** jika ada pertentangan angka dengan `Peta-Capaian-dan-Assessment.md`, dokumen tersebut yang menang.

**Perubahan v3.0:** Topik menjadi **aplikasi kuliner NearBite** (pencari tanpa login; pemilik login untuk mengelola). Dimensi disusun ulang: A (fitur kuliner, 7 indikator) 20, B (testing) 20, C (data online & error) 20, D (device + release) 25, E (dokumentasi/narasi) 15. Persistensi online jadi gate (C1); SQLite jadi bonus C. Device feature GPS **atau** kamera, keduanya jadi bonus D. Ditambah §5 panduan bila server mati saat demo (karena mock tidak diwajibkan).
