# Prosedur Edit Konten Moodle — PPB 20251 (Kulino, course id=21)

> Runbook untuk mengubah konten course setelah deployment awal (2026-09-13).
> Semua contoh memakai tooling di repo ini: `kulino_client.py` (WS read-only + form POST)
> dan Playwright dengan session admin `~/.kulino-admin/session.txt`.
> Prinsip: **mutasi via UI/form (Playwright) atau WS resmi, JANGAN akses DB langsung**;
> DB hanya untuk audit read-only (`probe_lib.py`).

## Persiapan (sekali per sesi edit)

```bash
cd /home/kaqfa/Data-Kerja/Kuliah/materi-mobile
# cek session masih hidup — kalau redirect ke login, minta session baru ke dosen
python3 -c "
import sys; sys.path.insert(0,'.')
from kulino_client import ws
print(ws('core_course_get_contents', courseid=21)[0]['name'])"
```

## Peta lokasi konten

| Yang diubah | Sumber kebenaran | Tempat di Moodle |
|---|---|---|
| Teks soal quiz | `moodle/bank_soal.py` | Question bank kategori `PPB/P01..P15` |
| Intro/deskripsi aktivitas | `moodle/activities/PXX-*.md` | modedit tiap cmid |
| Restriction starter (gate) | `moodle/README.md` + activities | modedit → Restrict access |
| Ringkasan section | `moodle/activities/PXX-*.md` | editsection.php |
| File starter zip | `starter-code/` + `moodle/pack_starters.py` | modul File starter |

## 1. Ubah teks soal (satu-dua soal)

Paling cepat langsung di UI — tanpa rebuild:

```
https://kulino.dinus.ac.id/question/bank/qbank_.../question.php?cmid=2180 + edit soal
```
via browser biasa (session admin). Simpan → otomatis terpakai quiz yang mereferensikannya
(semua quiz memakai referensi bank, bukan salinan).

## 2. Ubah banyak soal / regenerasi bank

```bash
# 1) edit sumber
$EDITOR moodle/bank_soal.py
# 2) rebuild XML (validasi otomatis: kunci = opsi pertama, panjang kunci ≤ distraktor)
python3 moodle/build_moodle_xml.py
```

Lalu **hapus soal lama kategori terkait** (bulk delete UI) dan **import ulang** XML:

- Import: `question/bank/importquestions/import.php?cmid=2180&cat=<cat>,19270`
  wajib field `format=xml` + `catfromfile=1` + `contextfromfile=1` (tanpa ini soal jatuh ke kategori default).
- Upload file via draft area `repository/repository_ajax.php?action=upload` (repo_id=5) — atau lewat UI.
- Bulk delete: centang `q<questionid>` per soal → header `#qbheadercheckbox` → `#bulkactionsui-selector` → Delete.
  Tabel render AJAX — tunggu selector konkret, JANGAN `networkidle`.

## 3. Ubah intro/deskripsi aktivitas (assign, forum, dll)

Editor teks = TinyMCE 6 di iframe `id_introeditor_ifr`. Via UI Playwright:

```python
page.goto(f"{BASE}/course/modedit.php?update={cmid}")
page.wait_for_selector("#id_introeditor", state="attached")
page.wait_for_timeout(1800)   # tunggu iframe editor init
page.evaluate("""([html]) => {
    const fr = document.querySelector('iframe[id$="introeditor_ifr"]');
    fr.contentDocument.body.innerHTML = html;        // tampilan editor
    const ta = document.querySelector('#id_introeditor');
    ta.value = html;                                  // nilai yang disubmit
    ta.dispatchEvent(new Event('change', {bubbles: true}));
}""", [html_baru])
page.click("#id_submitbutton")   # WAJIB klik tombol asli; JS form.submit() TIDAK menyimpan editor
```

Konversi Markdown→HTML: `markdown-it-py` (`MarkdownIt("commonmark")`), subset yang dipakai
(bold/italic/link/list/inline-code/blockquote) aman untuk TinyMCE. Sumber kebenaran tetap
Markdown di repo; konversi satu arah saat push ke Moodle.

## 4. Ubah konfigurasi quiz (review options, attempts, dll)

Form modedit quiz punya **rantai disabledIf**:

- Feedback apa pun (correctness/marks/generalfeedback/…) hanya aktif jika **"The attempt"** dicentang dulu di kolom yang sama; `marks` juga butuh `maxmarks`.
- Kolom "After quiz closes" **disabled selamanya** untuk quiz tanpa close date (quiz unlock memang tanpa jadwal) — jangan dipaksakan.
- Standar course ini: feedback setelah submit = `attempt+maxmarks+marks+correctness+generalfeedback` ON kolom *Immediately after the attempt*; `rightanswer`/`specificfeedback` never (anti salin kunci).
- Checkbox plain: centang = kirim `=1`; meng-uncheck = JANGAN kirim field (kirim `=0` ditolak form).

## 5. Ubah gate starter (restriction ≥80% quiz)

Via modedit → Restrict access, atau JSON di form. Perubahan massal:

```python
page.goto(f"{BASE}/course/modedit.php?update={cmid}")
# set availabilityconditionsjson: {"op":"&","c":[{"op":"graderestriction" … "min":80}],"showc":[true]}
```

- Pitfall: `minval` input disabled sampai checkbox `name="min"` dicentang sungguhan; dialog = YUI `.moodle-dialogue-wrap`, timing flaky → poll + re-click.
- Mapping grade item quiz: lihat WS `gradepreport_grade...` atau evidence task-004 (`ws-gradeitems.json`).

## 6. Show/hide modul & section

```python
ws("core_course_edit_module", id=cmid, action="show")   # atau "hide"
ws("core_courseformat_update_course", courseid=21, action="section_show", ids=[section_id])
ws("core_courseformat_update_course", courseid=21, action="section_delete", ids=[section_id])
```

Pitfall: modul baru di section hidden otomatis `visible=0` — set eksplisit setelah buat.
Hapus section = `section_delete` dengan **course_sections.id** (bukan nomor).

## 7. Tambah aktivitas baru

Form `modedit.php` — **assign WAJIB via UI Playwright** (raw POST kena bug server
`save_editor_draft_files(): null returned`). Modul lain (label/url/forum/quiz) bisa raw POST
dengan hidden fields wajib: `pageurl`, `context`, `summary_editor[itemid]`, plus
`clientvalues` & `availabilityconditionsjson` kosong — tanpa itu 404.

## 7b. Geser due date assignment / tanggal course

- **Assignment**: modedit → set `id_duedate_{day,month,year}` (pastikan `id_duedate_enabled`
  tercentang). **Pitfall**: bila `gradingduedate` lama > due baru, form reject **diam-diam**
  (tampilan sukses, DB tak berubah) — matikan `id_gradingduedate_enabled` dulu.
- **Tanggal course**: `course/edit.php?id=<id>` (bukan editsettings.php), tombol submit =
  `#id_saveanddisplay` (bukan `#id_submitbutton`).

## 8. Upload ulang starter zip

```bash
python3 moodle/pack_starters.py   # rebuild zip dari starter-code/
```
Lalu ganti file di modul File terkait via UI (manage files), atau buat ulang modul.

## Verifikasi bawaan (setiap operasi)

- Re-read WS `core_course_get_contents` / `mod_quiz_get_quizzes_by_courses` / `mod_assign_get_assignments` — pastikan state pasca-save sesuai.
- Audit DB read-only hanya bila WS tak menyediakan datanya (contoh: referensi bank per quiz) — `probe_lib.py connect()`.
- Evidence screenshot → `.kanban-evidence/` (gitignored).

## Yang masih manual (non-script)

Kalender course, bobot gradebook, buka section mingguan, `git push` — lihat
`moodle/README.md` → "Status deployment Kulino".
