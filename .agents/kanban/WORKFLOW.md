# WORKFLOW — Sinkronisasi Moodle Kulino × Rancangan PPB 20251

## Aturan Keras (semua task)
1. **NO DIRECT DB ACCESS.** Jangan pakai psycopg2/psql/SQL/DB-insert ke Kulino
   apa pun alasannya (audit boleh via UI/WS read-only; eksekusi via UI).
2. **Playwright + session admin** dari `~/.kulino-admin/session.txt`
   (format `MoodleSession=<value>`). Course: `https://kulino.dinus.ac.id/course/view.php?id=21`.
3. Session bisa basi → jika redirect ke login, tulis blocker di task, jangan
   minta/pakai kredensial lain.
4. **WS REST token** boleh untuk aksi READ-ONLY (core_course_get_contents) —
   token di `~/.kulino-admin/ws_token` (user dosen-admin). Tidak untuk mutasi.
   Bila ragu, pakai Playwright saja.
5. Verifikasi selalu via re-read (UI/WS read-only) + screenshot di
   `<repo>/.kanban-evidence/<task-id>/`.
6. Sumber kebenaran konten: `moodle/activities/P01..P16.md` + `moodle/README.md`.
7. Jangan commit secret/token/screenshot berisi data mahasiswa.

## Known-good teknis (terbukti jalan di sesi 2026-09-13)
- Form POST modedit.php perlu hidden fields (pageurl, context, itemid) +
  `clientvalues` & `availabilityconditionsjson` kosong; tanpa itu → 404 error page.
- Import XML wajib `format=xml` + `catfromfile=1` + `contextfromfile=1`.
- Upload file ke draft area: `repository/repository_ajax.php?action=upload`
  dengan repo_id=5 (upload), itemid dari form (alternatif: lewat UI Playwright).
- Bulk delete soal: checkbox `q<id>`, header `#qbheadercheckbox`, toolbar
  `#bulkactionsui-selector` → Delete (tabel render via AJAX; JANGAN pakai
  wait_for networkidle — tunggu selector konkret).
- Playwright sync API ada di venv `~/.hermes-webui/.venv` (python3 sistem juga bisa).
- Halaman error Redis transient (~1.3KB, `<title>Error`) → retry 2-3x.
- **Param `section` di `modedit.php` = NOMOR section (P07=7), BUKAN course_sections.id (957).** Pakai id → `invalidrecordunknown` "Can't find data record in database" — baik add via URL maupun POST.
- Raw POST `modedit.php` untuk **assign** gagal (bug server `assign::save_editor_draft_files(): Return value must be of type string, null returned`) — assign dibuat/diubah via form UI Playwright (goto modedit → fill → klik submit).
- Upload lampiran intro assignment: `repository/repository_ajax.php?action=upload` — **field file wajib `repo_upload_file`** (bukan `content`), `env=filemanager`, `itemid` = nilai input `introattachments` di form.
- Module baru di section hidden otomatis `visible=0` → set `visible=1` eksplisit (form update) bila harus aktif saat section dibuka nanti.
- Date picker mform: set via select `duedate[year|month|day|hour|minute]` + checkbox `duedate[enabled]`; matikan `cutoffdate[enabled]` & `gradingduedate[enabled]` untuk hindari validasi konflik.

## Status panggung (selesai 2026-09-13, jangan diulang)
- Struktur section P01–P16 + summary + visibility (P01-02 visible) — DONE.
- 13 section duplikat terhapus — DONE.
- Import 140 soal versi TANPA tag — DONE (perlu re-import versi ber-tag:
  hapus dulu yang lama via UI bulk delete).
