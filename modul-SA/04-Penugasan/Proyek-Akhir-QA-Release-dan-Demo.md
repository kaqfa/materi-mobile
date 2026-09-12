# Proyek Akhir, Aplikasi Kuliner "Resto Terdekat", QA, Release, dan Demo Individual

## 1. Tujuan tugas

Membuktikan secara individu bahwa kamu menguasai **kualitas, integrasi platform, dan pemahaman atas kode yang kamu tulis/bantu-AI**. Semua teknik dari P02-P07 (widget/state, Provider, REST + `sealed ApiError`, device feature, testing, release) kamu terapkan pada aplikasi kuliner NearBite.

Karena domainnya baru, yang terukur adalah **transfer kemampuan**: apakah kamu bisa memodelkan entitas baru, merancang state, dan menangani error pada masalah yang berbeda.

Proyek Akhir adalah area utama bukti **Sub-CPMK 92.2 (device, testing, dokumentasi)** plus indikator pendukung 53.2 (APK rilis). Nilai aplikasi saja **tidak cukup**; demo individual + live modification **tidak dapat digantikan source code** (`Rubrik-Remedial.md` §4-§5).

Proyek Akhir dirancang agar **dapat dinilai penuh tanpa Play Store, signing key, atau akun berbayar**: release cukup `flutter build apk --release` (debug-sign/unsigned) + install manual via `adb`/perangkat.

> **Penjelasan kode** disampaikan lewat **narasi tertulis** (§6.1) + **demo tatap muka** (§4.11); bukti visual berupa **screenshot**.

---

## 2. Deskripsi aplikasi, NearBite

Aplikasi kuliner dengan **dua mode pemakaian**. Bedanya bukan pada "login sebagai apa", melainkan **perlu login atau tidak**.

### 2.1 Mode Pencari (tanpa login, langsung pakai)

Pencari adalah **tamu (guest)**. Membuka app → **langsung** ke daftar resto, **tanpa register, tanpa login, tanpa layar perantara apa pun**.

1. Membuka app → langsung disuguhi **daftar resto terdekat** dari posisi pengguna, terurut dari yang paling dekat.
2. **Mencari** resto berdasarkan nama resto **atau nama menu** yang diinginkan.
3. **Mengetuk resto** → melihat **detail lengkap resto** (foto, alamat, jarak, jam buka) **beserta seluruh menunya**.

> **Ini keputusan desain yang dinilai.** Memaksa pencari mendaftar hanya untuk melihat daftar resto adalah hambatan yang tidak perlu; aplikasi pencarian tempat makan di dunia nyata pun dapat dipakai tanpa akun. Karena itu **membaca data resto/menu tidak boleh menuntut autentikasi**, baik di UI maupun di backend (lihat RLS pada `ERD-dan-API-NearBite.md` §3.2).

### 2.2 Mode Pemilik Resto (perlu register & login)

Login hanya dibutuhkan saat pengguna hendak **mengelola datanya sendiri**.

1. **Register & login** sebagai pemilik usaha kuliner.
2. **Melengkapi profil resto**: nama, deskripsi, alamat, jam buka, **foto resto**, dan **posisi GPS** (latitude/longitude).
3. **Mengelola menu**: menambah/mengubah/menghapus item menu, masing-masing dengan **nama, foto, deskripsi, dan harga**.

### 2.3 Alur layar minimum

```
[Home = List Resto Terdekat]        <- layar pertama, TANPA login
   │  (sort by jarak, search resto/menu)
   │
   ├─> [Detail Resto + Menu]        <- tetap tanpa login
   │
   └─> tombol "Masuk sebagai Pemilik"
          ↓
       [Login] <-> [Register]
          ↓ (setelah login)
       [Profil Restoku]             <- form + foto + ambil GPS
          ↓
       [Kelola Menu] -> [Form Menu] <- tambah / edit / hapus
```

Minimum **6 layar**: List Resto Terdekat (Home), Detail Resto, Login, Register, Profil Resto, Kelola/Form Menu.

> **Tidak perlu flag `role` yang rumit.** Yang membedakan hanyalah **ada tidaknya sesi login**: belum login → mode pencari; sudah login → tambahan akses ke layar pemilik. Tidak perlu RBAC berlapis, tidak perlu memilih peran saat register (setiap akun yang mendaftar adalah pemilik resto).

---

## 3. Starting point

Yang **wajib kamu bawa** dari paket sebelumnya adalah **pola arsitektur**, diterapkan ulang untuk entitas kuliner:
- Pola `Provider -> Repository -> Datasource` (P03, P05).
- `sealed ApiError` + mapping status HTTP → subtype + state UI loading/success/empty/error + retry (P05).
- Pola device feature dengan hasil `sealed` (P06), kini untuk **GPS atau kamera**.
- Struktur testing (unit + widget) dan lint/`const` discipline (P06, P07).

Yang **baru** kamu buat: model `User`/`Restaurant`/`MenuItem`, autentikasi ringan, perhitungan jarak, dan layar-layar kuliner.

Starter `p06-testing-device/` dan `p07-release/` berguna sebagai **rujukan pola** (`AttachmentResult`, `PerfDemoScreen`, `.gitignore` no-secret, lint config).

> **Boleh memakai package tambahan** yang relevan domain ini: `geolocator`/`location` (GPS), `image_picker` (kamera/galeri), `http`/`dio` atau `supabase_flutter`, `provider`, `cached_network_image`, `intl`. Package di luar daftar ini → izin dosen lebih dulu.

---

## 4. Requirement (wajib)

Semua butir **wajib** kecuali ditandai opsional/bonus. Rubrik menilai indikator observable.

### 4.1 Autentikasi (ringan, hanya untuk pemilik)
- [ ] **Pencari dapat memakai app tanpa akun.** Membuka app → langsung daftar resto terdekat. **Tidak ada** layar login/register yang menghadang, dan **tidak ada** paksaan mendaftar untuk melihat daftar maupun detail resto + menu.
- [ ] **Register** pemilik resto: email + password + nama (validasi form: email berformat, password ≥6 karakter).
- [ ] **Login** menghasilkan token/sesi yang **disimpan** (mis. `SharedPreferences`/secure storage/sesi Supabase), sehingga tidak perlu login ulang tiap buka app.
- [ ] Token dikirim **hanya pada request yang mengubah data pemilik** (mis. header `Authorization: Bearer <token>`). Request baca daftar/detail resto **tidak memerlukan** token.
- [ ] Layar pemilik (profil resto, kelola menu) **hanya dapat diakses setelah login**; saat belum login, aksinya mengarahkan ke layar login.
- [ ] **Logout** tersedia dan benar-benar menghapus sesi tersimpan, lalu mengembalikan pengguna ke mode pencari (**bukan** ke layar login yang mengunci app).
- [ ] Kredensial salah → **pesan error jelas**, bukan crash dan bukan diam.

> **Di luar scope:** refresh token, reset password, verifikasi email, OAuth/social login, RBAC berlapis, akun untuk pencari. Tidak dinilai dan tidak menambah poin wajib.

### 4.2 Profil resto (owner) + upload foto
- [ ] Pemilik dapat **membuat dan mengubah** profil restonya: nama, deskripsi, alamat, jam buka.
- [ ] **Foto resto** terpasang, dari kamera atau galeri (bila memilih device feature kamera), atau URL/upload storage bila memilih GPS sebagai device feature.
- [ ] **Posisi GPS resto** tersimpan (latitude, longitude). Boleh diambil dari lokasi perangkat saat itu ("Gunakan lokasi saya") atau input manual koordinat.
- [ ] Validasi form: nama resto wajib (≥3 karakter), koordinat wajib terisi sebelum simpan.

### 4.3 CRUD menu (owner)
- [ ] **Create**: tambah item menu (nama, deskripsi, **harga**, foto).
- [ ] **Read**: daftar menu milik resto tampil.
- [ ] **Update**: ubah item menu.
- [ ] **Delete**: hapus item menu dengan konfirmasi.
- [ ] Validasi: nama menu wajib, **harga wajib numerik ≥ 0** (tolak input non-numerik/negatif).
- [ ] Harga ditampilkan terformat sebagai rupiah (mis. `Rp25.000`).

### 4.4 Pencarian & resto terdekat (mode pencari, tanpa login)
- [ ] Home menampilkan **daftar resto terurut dari yang terdekat** terhadap posisi pengguna.
- [ ] **Jarak dihitung di sisi aplikasi** memakai **rumus Haversine** dan **ditampilkan** pada tiap kartu resto (mis. "1,2 km").
- [ ] Fungsi jarak ditulis sebagai **fungsi pure-Dart terpisah** (bukan di dalam `build()`), agar dapat di-unit-test. **Ini sumber utama unit test dimensi B.**
- [ ] **Search**: mencari resto berdasarkan **nama resto atau nama menu**, case-insensitive substring, real-time.
- [ ] **Detail resto**: mengetuk kartu → tampil detail resto lengkap + **seluruh menu** resto tersebut.
- [ ] **Izin lokasi ditolak** → app tetap berjalan: tampilkan daftar tanpa urutan jarak (atau urut nama) + pesan penjelas. **Tidak boleh crash.**

### 4.5 Device feature, GPS **atau** kamera (pilih salah satu, wajib satu)
- [ ] **Minimal satu** fitur device terintegrasi:
  - **Opsi GPS** (`geolocator`/`location`): ambil posisi pengguna untuk menghitung resto terdekat dan/atau menandai koordinat resto.
  - **Opsi Kamera/Galeri** (`image_picker`): ambil foto resto dan/atau foto menu.
- [ ] Hasil akses device dipetakan ke **tipe hasil `sealed`** buatanmu (mis. `sealed LocationResult` dengan `LocationSuccess`/`LocationDenied`/`LocationUnavailable`, atau `AttachmentResult` untuk kamera), sehingga penanganannya **exhaustive**.
- [ ] **Permission branch terbukti di UI**: izin diberikan → fitur jalan; izin **ditolak** → banner/pesan pemulihan (**bukan crash**); layanan tidak tersedia (GPS mati / emulator tanpa kamera) → pesan fallback yang jelas.
- [ ] Fitur device terbukti bekerja **pada APK rilis**, bukan hanya debug.

> **Mengerjakan keduanya (GPS + kamera) adalah bonus**, membuka skor 4 pada indikator bertanda **(bonus D)** di rubrik. Satu fitur saja tetap dapat skor 3 penuh.

### 4.6 Data online via REST API
- [ ] Seluruh data (user, resto, menu) **tersimpan di backend online**: **Supabase** atau **backend buatan sendiri** (Express/Laravel/FastAPI/dll.). Skema acuan: `ERD-dan-API-NearBite.md`.
- [ ] Operasi jaringan melewati **repository/datasource**, bukan `http.get` langsung di widget.
- [ ] **`sealed ApiError`** memetakan kondisi: `401` (belum/gagal auth), `404` (resto/menu tak ditemukan), `4xx` lain (validasi), `5xx` (server), dan kegagalan konektivitas (`NetworkError`).
- [ ] **State UI lengkap** pada layar yang memuat data: **loading, success, empty, error + tombol retry** yang benar-benar memanggil ulang.
- [ ] **Base URL & API key via `--dart-define`**, tidak di-hardcode, tidak di-commit.
- [ ] **SQLite/cache lokal opsional** (bonus C3): bila dipakai, tunjukkan data tetap tampil setelah restart dalam kondisi offline.

> **Server harus hidup saat demo.** Sesuai keputusan pengampu, mock/fixture fallback **tidak diwajibkan**. Konsekuensinya ada pada dirimu, lihat peringatan §4.6.1.

#### 4.6.1 Peringatan: kesiapan demo tanpa fallback

Karena tidak ada mock wajib, **kegagalan jaringan saat demo = kegagalan demo**. Lindungi dirimu:

- Uji app dari **jaringan yang akan kamu pakai saat demo** (hotspot sendiri lebih aman daripada WiFi kampus).
- Pastikan backend **tidak tidur** (Supabase free tier dapat mem-pause project yang idle; layanan hosting gratis sering cold-start lambat). Buka/ping backend sebelum sesi.
- Siapkan **data seed** minimal 8 resto dengan koordinat tersebar dan beberapa menu per resto, supaya urutan jarak dan search benar-benar terlihat.
- **Sangat disarankan (bukan syarat):** simpan respons terakhir ke cache lokal atau sediakan fixture darurat. Ini tidak dinilai, tetapi menyelamatkan demomu bila jaringan mati.

> Bila server mati saat demo dan tidak ada cara menampilkan data, dosen menilai dari apa yang dapat ditunjukkan saat itu. Siapkan screenshot lengkap sebagai bukti cadangan (§5).

### 4.7 Testing (gate perilaku)
- [ ] **Minimal 3 unit test** lulus, menguji logika murni. Kandidat kuat di domain ini:
  - **Haversine/jarak** (mis. dua koordinat diketahui → jarak sesuai toleransi; jarak ke titik yang sama = 0).
  - **Sorting resto terdekat** (urutan benar berdasarkan jarak).
  - **Search resto/menu** (case-insensitive substring; query kosong → semua).
  - **Mapper JSON** `Restaurant.fromJson`/`MenuItem.fromJson` (round-trip, harga & koordinat bertipe benar).
  - **Mapping `ApiError`** dari status code.
  - **Validator harga/nama menu.**
- [ ] **Minimal 2 widget test** lulus: mis. validasi form menu (nama kosong → error, harga non-numerik → error) + state UI list resto (empty / error+retry / list terisi).
- [ ] `flutter test` → **All tests passed!**; tidak ada test di-skip/`// ignore:` tanpa alasan tertulis.
- [ ] Test **tidak bergantung jaringan**: pakai fake/stub datasource untuk test, bukan memanggil server sungguhan.

### 4.8 Quality gate, analyze
- [ ] `flutter analyze` → **No issues found!** atau setiap warning tersisa dijelaskan di README beserta alasannya.
- [ ] Tidak ada `// ignore:` tanpa alasan tertulis; tidak menonaktifkan linter untuk "memaksa hijau".
- [ ] Subtree immutable ditandai `const`; bisa menjelaskan kenapa `const` menghemat rebuild.

### 4.9 Release APK
- [ ] `flutter build apk --release` berhasil; APK di `build/app/outputs/flutter-apk/app-release.apk`.
- [ ] APK terinstall tanpa `INSTALL_FAILED_*`; app launch tanpa crash.
- [ ] **Uji fungsional pada APK rilis:** buka app **tanpa login** → list resto terdekat + jarak tampil → search → detail resto + menu → lalu login sebagai pemilik → tambah/ubah menu → device feature (GPS/kamera) → state error + retry.
- [ ] **Permission runtime diuji pada APK rilis** (lokasi/kamera), karena perilaku izin berbeda dari mode debug.
- [ ] **No-secret rule:** tidak ada API key/`anon key`/keystore/`key.properties`/`.env` rahasia di repo; `.gitignore` mengecualikannya; `git status` bersih. Base URL & key hanya via `--dart-define`.
- [ ] Permission dideklarasikan di `AndroidManifest.xml` sesuai fitur (`ACCESS_FINE_LOCATION` dan/atau `CAMERA`, `INTERNET`).

### 4.10 README final (dokumentasi)
- [ ] Pakai `Template-Submission-README.md`. Memuat minimal:
  - **Cara run**, termasuk perintah `--dart-define` lengkap (dengan **nilai contoh/placeholder**, bukan key asli).
  - **Backend yang dipakai** (Supabase / buatan sendiri) + **cara menyiapkannya** (skema tabel/SQL atau link repo backend), merujuk `ERD-dan-API-NearBite.md`.
  - **Arsitektur singkat**: `Provider -> Repository -> Datasource`; `sealed ApiError`; `sealed` hasil device.
  - **Device feature yang dipilih** (GPS/kamera/keduanya) + alasannya.
  - **Known limitation** (mis. "butuh koneksi, tanpa cache offline"; "akurasi GPS di emulator terbatas"; "harga belum mendukung multi-currency").
  - **Bukti test** (`flutter analyze` + `flutter test` output; jumlah kasus; ukuran APK `du -h`).
  - **Narasi Pemanfaatan AI** (§6.1) + AI log bila memakai AI.

### 4.11 Demo individual + live modification (final P07)
- [ ] **Demo 7-10 menit (tatap muka)**: walkthrough dua mode (**pencari tanpa login**: list terdekat + search + detail; **pemilik setelah login**: profil + CRUD menu) + code walkthrough satu jalur end-to-end + `sealed ApiError` + `sealed` hasil device.
- [ ] **Live modification 20-25 menit**: dosen menarik satu soal dari `../05-Assessment/Bank-Live-Coding.md` **yang diadaptasi ke domain kuliner** (mis. urutkan menu berdasarkan harga, filter resto dalam radius 3 km, empty state khusus pencarian menu, tambah field pada mapper). Gate `analyze` + `test` tetap hijau.
- [ ] **Q&A**: menjawab "mengapa" dengan alasan teknis (mis. "kenapa jarak dihitung di fungsi terpisah?", "kenapa error ditentukan dari status code?", "apa yang terjadi bila izin lokasi ditolak?").
- [ ] **Penjelasan kode berbantuan AI**: menjelaskan bagian yang dibantu AI. Tidak bisa menjelaskan → poin indikator terkait dapat dibatalkan meski source baik (`Rubrik-Proyek-Akhir.md` gate E).


---

## 6. Deliverable (yang dikumpulkan)

| # | Artefak | Wajib | Catatan |
|---|---|:---:|---|
| 1 | Source code (ZIP) + repo URL bila ada | wajib | Dapat di-build di mesin bersih. |
| 2 | **Release APK** (`app-release.apk`) | wajib | Hasil `flutter build apk --release`; catat ukuran (`du -h`). |
| 3 | **Skema backend** | wajib | SQL/skema tabel Supabase atau repo backend sendiri + cara seed data. Acuan: `ERD-dan-API-NearBite.md`. |
| 4 | **Narasi Pemanfaatan AI** (1000-1500 kata) | wajib | Lihat §6.1. |
| 5 | Screenshot | wajib | **List resto + jarak dalam keadaan belum login**, search, detail resto + menu, login/register, form menu (validasi harga), device feature (izin diberikan **dan** ditolak), state error + retry, output `analyze`+`test`. |
| 6 | `README.md` | wajib | Template `Template-Submission-README.md`; lihat §4.10. |
| 7 | AI Interaction Log | bila pakai AI | `../01-Orientasi/Template-AI-Interaction-Log.md`. **Tidak melampirkan padahal memakai AI = pelanggaran.** |
| 8 | **Demo individual + live modification** (final P07) | wajib | **Tatap muka.** 7-10 menit demo + 20-25 menit live mod + Q&A. |

### 6.1 Narasi Pemanfaatan AI (final)

Tulis **1000-1500 kata** bahasa Indonesia di README §7 (atau `NARASI-AI.md`). Wajib memuat:

1. **Evolusi strategi AI lintas paket**, dari sesi-sesi awal (syntax/widget) ke data layer hingga Proyek Akhir (auth, GPS, upload foto, testing, release). Apa yang berubah ketika kamu harus memodelkan domain baru.
2. **Keputusan menerima/menolak saran AI**, minimal **tiga kasus konkret**, sekurangnya satu **penolakan** + alasan teknis. Contoh khas di proyek ini: AI menyarankan menaruh API key langsung di kode, menyarankan menghitung jarak di dalam `build()`, menyarankan menyimpan password plain, atau membuat test yang memanggil server sungguhan.
3. **Cara verifikasi pemahaman**: `flutter analyze`, `flutter test` (≥3 unit + ≥2 widget), uji fungsional pada APK rilis termasuk **uji izin ditolak**.
4. **Penjelasan teknis dengan kata sendiri** (persis yang ditanyakan saat demo):
   - Satu **jalur end-to-end** (UI → provider → repository → datasource → API).
   - **`sealed ApiError`**: kenapa jenis error ditentukan dari **status code**, dan bagaimana 401 diperlakukan berbeda dari 404/500.
   - **`sealed` hasil device**: kenapa izin ditolak ditangani sebagai **nilai**, bukan exception.
   - **Kenapa fungsi jarak dipisah** dari UI, dan bagaimana itu membuatnya dapat diuji.
5. **Refleksi kejujuran akademik**: bagian mana murni analisismu, bagian mana dibantu AI.

> **Bila tidak memakai AI sama sekali:** narasi tetap wajib (600-1000 kata), kerjakan poin 3, 4, 5. Tidak ada penalti.

---

## 7. Aturan AI (Proyek Akhir)

Berlaku kebijakan AI **P6-P7**:

| Aspek | Boleh | Tidak boleh |
|---|:---:|:---:|
| Brainstorming skema tabel/ERD, ide optimasi `const`/rebuild | ✅ | |
| Debugging build/gradle/permission, penjelasan konsep `sealed`, sintaks Haversine | ✅ | |
| **Menyelesaikan soal live modification tanpa analisis sendiri** | | ❌ |
| Menonaktifkan `flutter analyze`/skip test agar "hijau" | | ❌ |
| Menulis README/narasi tanpa pemahaman sendiri | | ❌ |
| Menempel seluruh arsitektur app tanpa bisa menjelaskan alurnya | | ❌ |

**Wajib bila memakai AI:** isi `../01-Orientasi/Template-AI-Interaction-Log.md` tiap interaksi (tujuan, prompt, ringkasan respons, diterima/ditolak, verifikasi pemahaman) + tulis narasi §6.1. **Narasi yang tidak sejalan dengan jawaban lisan saat Q&A adalah temuan serius** → poin indikator terkait dapat dibatalkan (`Rubrik-Proyek-Akhir.md` gate E).

---

## 8. Command verifikasi (jalankan sebelum kumpul)

```bash
# 1. Dari folder proyek NearBite:
flutter create --platforms=android .   # bila folder android/ belum ada
flutter pub get
flutter analyze                        # No issues found! (atau catat warning di README)
flutter test                           # >=3 unit + >=2 widget -> All tests passed!

# 2. Jalankan dengan konfigurasi (contoh, ganti nilaimu sendiri):
flutter run \
  --dart-define=API_BASE_URL=https://xxxx.supabase.co \
  --dart-define=API_KEY=<anon-key>

# 3. Build release APK + catat ukuran:
flutter build apk --release \
  --dart-define=API_BASE_URL=https://xxxx.supabase.co \
  --dart-define=API_KEY=<anon-key>
du -h build/app/outputs/flutter-apk/app-release.apk

# 4. Install + uji fungsional pada APK rilis:
adb install build/app/outputs/flutter-apk/app-release.apk
# Uji: buka app TANPA login -> list resto terdekat + jarak tampil; search nama resto & nama menu;
# detail resto + menu (semua tanpa login); lalu login -> tambah/ubah/hapus menu + validasi harga; logout -> kembali ke mode pencari;
# device feature (GPS/kamera); TOLAK izin -> pesan, bukan crash;
# matikan jaringan -> state error + tombol retry berfungsi.

# 5. Verifikasi no-secret & repo bersih:
git status
git ls-files | grep -Ei '\.(jks|keystore|p12|pem)$|key\.properties|google-services\.json|\.env$'  # harus kosong
grep -rnE "supabase\.co|Bearer [A-Za-z0-9]|anon.*key" lib/ | grep -v "String.fromEnvironment"      # harus kosong
```

**Checklist sebelum submit + demo:**
- [ ] **App dapat dipakai penuh sebagai pencari tanpa login** (list, search, detail + menu).
- [ ] Register + login + logout bekerja; sesi tersimpan; logout kembali ke mode pencari.
- [ ] Profil resto tersimpan lengkap dengan foto dan koordinat.
- [ ] CRUD menu lengkap + validasi harga numerik.
- [ ] List resto terurut jarak, jarak tampil, search resto & menu bekerja.
- [ ] Detail resto menampilkan seluruh menu.
- [ ] Device feature (GPS/kamera) bekerja **dan** cabang izin-ditolak terbukti tanpa crash.
- [ ] `flutter analyze` bersih; `flutter test` lulus (≥3 unit + ≥2 widget).
- [ ] APK rilis terinstall & diuji fungsional (termasuk permission runtime).
- [ ] Tidak ada API key/secret di repo; `git status` bersih.
- [ ] README + skema backend + narasi AI 1000-1500 kata lengkap.
- [ ] Screenshot lengkap (termasuk izin ditolak & state error/retry).
- [ ] **Backend hidup & sudah diuji dari jaringan yang akan dipakai saat demo** (§4.6.1).
- [ ] Siap menyelesaikan satu soal live modification dengan gate tetap hijau.

---

## 9. Rubrik dan bobot

Penilaian memakai `Rubrik-Proyek-Akhir.md` (5 dimensi, total 100 poin):

| Dimensi | Bobot | Inti penilaian |
|---|---:|---|
| A, Fitur inti & domain kuliner | 20 | auth ringan, profil resto, CRUD menu, resto terdekat + search + detail |
| B, Testing | 20 | unit ≥3 (jarak/search/mapper), widget ≥2, gate hijau, edge case |
| C, Data online & error handling | 20 | REST/Supabase via repository, `sealed ApiError`, state lengkap + retry, no-secret |
| D, Device feature & release APK | 25 | GPS/kamera + permission branch, `analyze` + `const`, build & uji APK rilis |
| E, Dokumentasi, narasi AI & kesiapan demo | 15 | README + skema backend, narasi 5 poin, rehearsal live mod |

Skala 0-4 per indikator. Indikator **gate** yang gagal membatalkan poin turunan. Demo + live modification dinilai terpisah di `../05-Assessment/Rubrik-Demo-dan-Wawancara.md`.

---

## 10. Deadline (placeholder, diisi dosen)

| Item | Tanggal |
|---|---|
| Proyek Akhir dibuka | `[diisi dosen, default: akhir sesi P06]` |
| Proyek Akhir dikumpulkan (source + APK + README + narasi) | `[diisi dosen, default: sebelum sesi P07]` |
| Demo individual + live modification (final P07) | `[diisi dosen, sesi P07]` |

---

## 11. Tips pendekatan (saran, bukan syarat)

1. **Backend dulu, hari pertama.** Buat tabel + seed 8 resto & menunya sebelum menulis UI. Skema siap pakai ada di `ERD-dan-API-NearBite.md`. Supabase adalah jalur tercepat: tabel + REST otomatis, tanpa menulis server.
2. **Urutan aman:** auth → list resto (data seed) → detail + menu → owner CRUD menu → profil resto + GPS/foto → testing → release. Pastikan tiap tahap jalan sebelum lanjut.
3. **Tulis fungsi jarak paling awal** dan langsung buat unit test-nya. Fungsi ini kecil, murni, dan menyumbang ke dimensi B tanpa bergantung UI atau jaringan.
4. **Uji izin ditolak sejak awal**, jangan di akhir. Cabang izin-ditolak adalah indikator yang paling sering gagal dan paling mudah dinilai dosen.
5. **Emulator bisa memalsukan GPS** (Extended controls → Location). Manfaatkan untuk menguji urutan jarak tanpa berpindah tempat; sebutkan di README bila kamu memakainya.
6. **Jangan tergoda peta.** Menampilkan Google Maps memakan waktu (API key, billing, marker) dan **tidak dinilai**. Koordinat + jarak sudah cukup.
7. **Satu device feature saja sudah penuh nilainya.** Pilih **GPS** bila kamu ingin fokus ke fitur "terdekat"; pilih **kamera** bila kamu lebih nyaman dengan `image_picker` dari P06.
8. **Foto: simpan URL, bukan blob.** Upload ke storage (Supabase Storage/Cloudinary) lalu simpan URL-nya di tabel. Menyimpan base64 di kolom teks akan memperlambat list dan menyulitkan demo.
9. **Siapkan jaring pengaman demo** (§4.6.1). Tanpa mock wajib, jaringan yang mati saat demo menjadi risikomu sendiri.
10. **Jangan menambah SQLite di menit terakhir.** Itu bonus. Gate wajib hijau jauh lebih bernilai.


