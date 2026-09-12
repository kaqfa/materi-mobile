# QA Checklist Paket, PPB Remidi 7 Pertemuan

> **Status:** v1.0 (audit 2026-08-08) — **PERLU AUDIT ULANG per 2026-08-10**
>
> ⚠️ **Paket direstrukturisasi v2.0 (2026-08-10):** 3 tugas -> **2 assignment + 1 proyek akhir**; **video presentasi dihapus** (diganti Narasi Pemanfaatan AI + screenshot); **SQLite jadi opsional/bonus**; assignment berhenti di **testing** (release + demo hanya di Proyek Akhir); bobot tugas 35/35/30 -> **30/30/40**.
>
> Hasil "Verified" di bawah berasal dari audit **sebelum** restrukturisasi. Path dan angka di command sudah diperbarui, tetapi **status verifikasi harus dijalankan ulang** sebelum distribusi.
> **Aplikasi jangkar:Remedial Task Tracker**
> **Tujuan:** audit konsistensi seluruh paket sebelum distribusi. Mencatat **verified** (bukti nyata) vs **blocked** (blocker, tidak dipalsukan) dengan command yang dapat dijalankan ulang.
> **Sumber:** `Rencana-Modul-PPB-Remedial-7-Pertemuan.md` §9 & §12 (DoD), `Peta-Capaian-dan-Assessment.md` §7, `Runbook-Dosen.md` §11.
> **Lingkup audit:** link/path/nama aplikasi, 7 materi, 7 modul, 2 assignment + 1 proyek akhir + rubrik, starter directory, assessment, AI policy.

## 0. Ringkasan

| Area | Status | Catatan |
|---|:---:|---|
| Struktur artefak (7/7/3, starter p01-p07, assessment, AI) | **Perlu audit ulang** | nama file tugas berubah di v2.0 |
| Konsistensi nama aplikasi jangkar | Verified (37 file) | minor: starter README belum sebut nama anchor (catatan §3, non-blocking) |
| Bobot tugas + area RPS = 100 | **Perlu audit ulang** | v2.0: 30+30+40=100 tugas; 30/25/20/25=100 area |
| Rubrik total 100 poin (3 rubrik + demo) | **Perlu audit ulang** | Rubrik-Assignment-02 kini 4 dimensi (35/30/20/15) |
| Materi Progressive Checkpoint (≥2-3 tiap materi) | Verified | 7/7 materi punya 3 checkpoint |
| Modul rundown 150 menit | Verified | 7/7 modul sebut `150 menit`/`3 × 50` |
| Cross-link antar-artefak | **Perlu audit ulang** | 6 file tugas/rubrik di-rename di v2.0 |
| Build/lint/test starter (`flutter analyze`/`test`/`build apk`) | Blocked | toolchain Flutter/Dart tidak tersedia di mesin audit (§7) |

## 1. Struktur artefak (Definition of Done)

**Command audit:**
```bash
cd "Handout-SA"
ls 02-Materi/P*.md | wc -l # expect 7
ls 03-Modul-Kelas/Modul-P*.md | wc -l # expect 7
ls 04-Penugasan/Assignment-*.md 04-Penugasan/Proyek-Akhir-*.md # expect 3
ls 04-Penugasan/Rubrik-Assignment-*.md 04-Penugasan/Rubrik-Proyek-Akhir.md # expect 3
# v2.0: pastikan tidak ada sisa penamaan lama & tuntutan video
! grep -rln "Tugas-0[123]" 04-Penugasan/ 00-Planning/ 01-Orientasi/ 05-Assessment/
! grep -rlnE "video [0-9]|Video demo" 04-Penugasan/ 00-Planning/ 01-Orientasi/ 05-Assessment/
ls 05-Assessment/ # Bank-Live-Coding + Rubrik-Demo + Kunci + Lembar
ls -d 06-Starter-Code/p0*-* # expect p01..p07
```

**Hasil: Verified**
- 7 materi (P01-P07), 7 modul kelas (Modul-P01…P07).
- 3 brief: Assignment-01-Task-Tracker-Core / Assignment-02-Serialization-dan-API / Proyek-Akhir-QA-Release-dan-Demo.
- 3 rubrik: Rubrik-Assignment-01 / Rubrik-Assignment-02 / Rubrik-Proyek-Akhir.
- 5-Assessment: Bank-Live-Coding (baru), Rubrik-Demo-dan-Wawancara (baru), Kunci-Diagnostik, Lembar-Observasi.
- Starter: p01-diagnosis … p07-release (7 folder, masing-masing `pubspec.yaml` + `analysis_options.yaml`).

## 2. Bobot & konsistensi asesmen

**Command audit:**
```bash
grep -nE "Beban tugas" 04-Penugasan/Assignment-0*.md 04-Penugasan/Proyek-Akhir-*.md
grep -nE "\*\*30%\*\*|\*\*25%\*\*|\*\*20%\*\*|\*\*100%\*\*" 00-Planning/Peta-Capaian-dan-Assessment.md
grep -nE "Dimensi. -.*\(.* poin\)" 04-Penugasan/Rubrik-Proyek-Akhir.md 05-Assessment/Rubrik-Demo-dan-Wawancara.md
grep -n "Total" 04-Penugasan/Rubrik-Assignment-0*.md 04-Penugasan/Rubrik-Proyek-Akhir.md 05-Assessment/Rubrik-Demo-dan-Wawancara.md
```

**Hasil: perlu audit ulang (angka v2.0 di bawah belum diverifikasi ulang lewat command)**
- Beban tugas v2.0: 30% + 30% + **40%** = **100%** (Proyek Akhir = 40%, sesuai planning & Peta §3/§5).
- Area RPS bobot: 30% (53.1) + 25% (92.1) + 20% (53.2) + 25% (92.2) = **100%**.
- Rubrik-Assignment-01 dimensi: A25 + B25 + C20 + D15 + E15 = **100**.
- Rubrik-Assignment-02 dimensi (**4 dimensi**): A35 + B30 + C20 + D15 = **100**.
- Rubrik-Proyek-Akhir dimensi (**v3.0, topik kuliner NearBite**): A20 + B20 + C20 + D25 + E15 = **100**.
- Rubrik-Demo-Wawancara dimensi: A15 + B20 + C35 + D15 + E15 = **100**.
- Konsistensi rubrik -> Peta: setiap rubrik merujuk `Peta-Capaian-dan-Assessment.md` sebagai sumber kebenaran; Rubrik-Remedial §4-§6 jadi payung.

## 3. Konsistensi nama aplikasi jangkar

**Command audit:**
```bash
grep -rl "Remedial Task Tracker" --include=*.md. | grep -v.agents | grep -v.pi-status | wc -l # 37 file
for f in $(find. -name '*.md' -not -path './.agents/*' -not -path './.pi-status/*'); do
 grep -q "Remedial Task Tracker" "$f" || echo "MISSING: $f"; done
```

**Hasil: Verified (37 file), minor non-blocking.**
- Nama anchor **Remedial Task Tracker** konsisten di seluruh planning, materi, modul, tugas, rubrik, assessment, dan `06-Starter-Code/README.md`.
- **Pengecualian disengaja (sejak 2026-08-10, Proyek Akhir v3.0):** `04-Penugasan/Proyek-Akhir-QA-Release-dan-Demo.md`, `04-Penugasan/Rubrik-Proyek-Akhir.md`, dan `04-Penugasan/ERD-dan-API-NearBite.md` memakai anchor **NearBite** (aplikasi kuliner), **bukan** Remedial Task Tracker. Ini **by design**: Proyek Akhir sengaja berganti domain agar mengukur transfer kemampuan, bukan pengulangan Assignment 1/2. Audit anchor di atas harus mengecualikan ketiga berkas ini, jangan diperlakukan sebagai inkonsistensi.
- **Minor (non-blocking):** 15 starter README (`06-Starter-Code/p0*/README.md` + `solution-reference/` + `p06/PERMISSIONS.md`) memakai frasa generik "aplikasi jalan/build" tanpa menyebut nama anchor. Tidak ada **nama lain** yang bertentangan (tidak ada inkonsistensi, hanya ketiadaan). Rekomendasi: tambah satu baris "Aplikasi jangkar: Remedial Task Tracker" di tiap starter README pada siklus QA berikutnya (di luar scope task-012; bukan blocker distribusi).

## 4. Materi & modul (Progressive Checkpoint + rundown)

**Command audit:**
```bash
for f in 02-Materi/P*.md; do n=$(grep -cE "CHECKPOINT" "$f"); echo "$f: $n"; done # expect 2-3 each
grep -lE "150 menit|3 × 50" 03-Modul-Kelas/Modul-P*.md | wc -l # expect 7
```

**Hasil: Verified**
- 7/7 materi punya **3 checkpoint** (memenuhi Progressive Checkpoint Pattern, `../Standar Tutorial Koding PPB.md`).
- 7/7 modul kelas sebut durasi **150 menit / 3 × 50** (rundown sesuai format tetap).
- Catatan: gate lint/test per-snippet termasuk gate `flutter analyze`/`test` starter, **blocked** pada toolchain (§7).

## 5. Tugas, rubrik, assessment, AI policy

**Command audit:**
```bash
ls 04-Penugasan/Tugas-*.md 04-Penugasan/Rubrik-Tugas-*.md 04-Penugasan/Template-Submission-README.md
ls 05-Assessment/Bank-Live-Coding.md 05-Assessment/Rubrik-Demo-dan-Wawancara.md
ls 01-Orientasi/Template-AI-Interaction-Log.md 01-Orientasi/Panduan-Mahasiswa.md
ls 00-Planning/Rubrik-Remedial.md 00-Planning/Runbook-Dosen.md
```

**Hasil: Verified**
- 2 assignment + 1 proyek akhir + 3 rubrik + template submission konsisten (tiap brief sebut rubriknya; tiap rubrik sebut brief-nya).
- Bank-Live-Coding: **12 variasi** setara (≥ ambang 10), 6 kategori (sorting/filter/search/tanggal/empty/mapper/immutability), kesulitan Basic 5 / Medium 7, tiap soal punya prompt + 3-5 kriteria sukses + kunci singkat (dosen) + referensi materi.
- Rubrik-Demo-Wawancara: app walkthrough + code walkthrough + live modification + penjelasan AI + Q&A; gate C2/C4/C6 membatalkan poin bila live mod gagal.
- AI policy bertingkat tersebar di Panduan-Mahasiswa, Runbook-Dosen, tiap brief Assignment 1/2 + Proyek Akhir, materi P07; template AI log + Narasi Pemanfaatan AI tersedia.
- Rubrik-Remedial §4-§6 jadi payung konversi nilai.

## 6. Cross-link integrity (link-lint)

**Command audit:**
```bash
# Ekstrak path relatif dari 4 artefak baru, verifikasi target ada:
for f in 04-Penugasan/Proyek-Akhir-QA-Release-dan-Demo.md \
 04-Penugasan/Rubrik-Proyek-Akhir.md \
 05-Assessment/Bank-Live-Coding.md \
 05-Assessment/Rubrik-Demo-dan-Wawancara.md; do
 echo "--- $f ---"
 grep -oE '\(\.\.?/[^)]+\)' "$f" | sed 's/[()]//g' | sort -u | while read p; do
 test -e "$p" || echo " BROKEN: $p"
 done
done
```

**Hasil: Verified**, semua referensi relatif dari 4 artefak baru menunjuk ke file/folder yang ada (materi P06/P07, modul P06/P07, starter p06/p07 + RELEASE-CHECKLIST, Bank-Live-Coding, Rubrik-Demo, Rubrik-Remedial, Peta-Capaian, Template-AI-Interaction-Log, Template-Submission-README, standar tutorial).

## 7. Build / lint / test starter, BLOCKED (toolchain)

**Status: Blocked, TIDAK dipalsukan.**

Toolchain **Flutter/Dart tidak tersedia** di mesin audit:
```bash
which flutter dart # (no output)
flutter --version # command not found
dart --version # command not found
```

Oleh karena itu gate berikut **belum dapat diverifikasi** pada audit ini. Bukan kegagalan artefak; blocker lingkungan. Command berikut adalah yang **harus** dijalankan pada mesin dengan Flutter terpasang sebelum distribusi (DoD `Rencana-Modul-PPB-Remedial-7-Pertemuan.md` §12):

| Gate | Command (jalankan di mesin dengan Flutter) | Status |
|---|---|:---:|
| Per starter p01-p07 | `cd 06-Starter-Code/p0X-... && flutter pub get && flutter analyze && flutter test` | Blocked |
| Proyek Akhir release | `flutter build apk --release` (di proyek mahasiswa) | Blocked |
| No-secret lint | `git ls-files \| grep -Ei '\.(jks\|keystore\|p12\|pem)$\|key\.properties\|google-services\.json\|\.env$'` (harus kosong) | Verified (repo tidak lacak material signing, `.gitignore` tiap starter mengecualikannya) |
| Dependency pin | `grep -E "provider\|sqflite\|path\|http\|image_picker" 06-Starter-Code/p0*/pubspec.yaml` | Blocked (pinning menunggu `flutter --version` mesin kelas, planning §11) |

**Eskalasi:** jalankan gate di atas pada environment target (`Checklist-Environment.md`) sebelum distribusi paket. Catat hasil (hijau/merah + versi Flutter/Dart) di bagian ini saat tersedia. Jangan menandai "verified" tanpa output nyata.

## 8. Sign-off QA

- Pengaudit: Pi (task-012) | Tanggal: 2026-08-08
- Static audit (§1-§6): Verified
- Toolchain gate (§7): Blocked (Flutter/Dart tidak terpasang di mesin audit), eskalasi ke mesin target.
- Minor follow-up (§3): tambah nama anchor di starter README pada siklus QA berikutnya (non-blocking).

> **DoD paket (`Rencana-Modul-PPB-Remedial-7-Pertemuan.md` §12):** terpenuhi untuk seluruh artefak dokumen & struktur. Gate build/lint/test starter menunggu toolchain (§7) sebelum paket benar-benar didistribusikan.

---

**Status QA:** v1.0, 2026-08-08 | **Konsistensi:** rujuk `Peta-Capaian-dan-Assessment.md` bila ada pertentangan angka.
