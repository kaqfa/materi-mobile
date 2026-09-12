# Solution Reference, p07-release (Khusus Dosen)

> **JANGAN dibagikan ke mahasiswa sebelum sesi P07 + demo selesai.**

## Tujuan starter

Bukan mengajari fitur baru, melainkan:
1. Membuktikan quality gate (`analyze` + `test` + `build`) hijau.
2. Mendemokan `const`/rebuild lewat `PerfDemoScreen`.
3. Menyediakan checklist rilis tanpa signing secret.

## Catatan untuk dosen

- Mahasiswa **tidak menulis kode inti baru** di P07 starter. Aktivitas: merapikan, menganalisis, membangun APK, menjelaskan, live modification dari bank soal.
- `analysis_options.yaml` memakai `strict-casts: true` + const lints ketat. Bila seorang mahasiswa gagal analyze, itu sinyal code smell, bukan alasan menurunkan standar.
- `RELEASE-CHECKLIST.md` adalah rubrik operasional Proyek Akhir bagian rilis. Cocokkan dengan `04-Penugasan/Rubrik-Proyek-Akhir.md`.
- Live modification: tarik soal dari `05-Assessment/Bank-Live-Coding.md`; jangan menerima "saya sudah commit" sebagai pengganti.

## Verifikasi signing-absent

```bash
# Repo harus bersih dari material signing:
git ls-files | grep -iE '\.(jks|keystore|p12|pem)$|key\.properties|\.env$|secrets\.json'
# Output kosong = LULUS acceptance "tidak menyimpan signed key/release secret".
```

## Lokasi solusi lengkap

Repo/tag privat: `solution-reference/p07-release@v1.0` (lihat `.agents/kanban/` / channel dosen).
