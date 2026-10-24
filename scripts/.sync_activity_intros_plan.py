#!/usr/bin/env python3
"""Batch 3: sinkron intro/deskripsi aktivitas dari moodle/activities/PXX.md.

Sumber: blok "Deskripsi:" (blockquote) tiap aktivitas di activities/PXX.md.
Konversi: markdown-it-py (subset: bold/italic/code/link/list) → HTML untuk TinyMCE.
Update: modedit.php via Playwright — set iframe introeditor + KLIK #id_submitbutton.
Escape: HTML unescape dulu (sumber aktivitas mengandung &amp; hasil audit).
"""
import re, html as htmlmod, glob
from playwright.sync_api import sync_playwright
from markdown_it import MarkdownIt

REPO = "/home/kaqfa/Data-Kerja/Kuliah/materi-mobile"
BASE = "https://kulino.dinus.ac.id"
raw = open("/home/kaqfa/.kulino-admin/session.txt").read().strip()
cname, cval = (raw.split("=", 1) + [""])[:2] if "=" in raw else ("MoodleSession", raw)
md = MarkdownIt("commonmark").enable("strikethrough")

def html_escape(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")

def md2html(text):
    # activities files berisi &amp; artefak — normalisasi
    return md.render(htmlmod.unescape(text)).strip()

# parse activities → {judul aktivitas: html intro}
PLAN = {}  # (section_num, aktivitas_label) -> html
for f in sorted(glob.glob(f"{REPO}/moodle/activities/P*.md")):
    num = int(re.match(r".*/P(\d+)", f).group(1))
    txt = open(f, encoding="utf-8").read()
    txt = htmlmod.unescape(txt)
    # blok aktivitas: **N. Nama** (Jenis ...) lalu baris "Deskripsi:" langsung diikuti blockquote
    for m in re.finditer(r"\*\*\d+\. (.+?)\*\*[^()\n]*\(([^)]+)\)[^\n]*\nDeskripsi:\s*\n\n?>\s*(.+?)(?:\n\n|$)", txt):
        nama, jenis, desc = m.group(1).strip(), m.group(2).strip(), m.group(3).strip()
        PLAN.setdefault(num, []).append((nama, jenis, md2html(desc)))

for num in sorted(PLAN):
    print(f"P{num:02d}:")
    for nama, jenis, h in PLAN[num]:
        print(f"  [{jenis[:20]:20}] {nama[:38]:38} → {len(h)} char")

# ekspor rencana tanpa eksekusi bila --dry
import sys
if "--dry" in sys.argv:
    sys.exit(0)

# pasangkan cmid via WS
sys.path.insert(0, REPO)
from kulino_client import ws
cur = ws("core_course_get_contents", courseid=21)
by_num = {s["section"]: s for s in cur}

def match_cm(num, nama):
    import html as _h
    mods = by_num[num]["modules"]
    nama_n = re.sub(r"[^a-z0-9]", "", _h.unescape(nama).lower())
    for m in mods:
        m_n = re.sub(r"[^a-z0-9]", "", _h.unescape(m["name"]).lower())
        if nama_n in m_n or m_n in nama_n:
            return m["id"]
    return None

updates = []  # (cmid, nama, html)
for num in sorted(PLAN):
    for nama, jenis, h in PLAN[num]:
        cm = match_cm(num, nama)
        if cm:
            updates.append((cm, nama, h))
        else:
            print(f"  !! tak ketemu: P{num:02d} '{nama}'")

print(f"\n{len(updates)} aktivitas akan diupdate")
import json
json.dump([{"cm": c, "nama": n, "html": h} for c, n, h in updates],
          open("/tmp/intro_plan.json", "w"), ensure_ascii=False, indent=1)
print("plan → /tmp/intro_plan.json (review dulu, eksekusi script kedua)")

# ---- intro generatif Materi (URL) & Starter (File) ----
RPS = open(f"{REPO}/RPS PPB - 20251.md", encoding="utf-8").read()
pert = {}
for b in re.split(r"### \*\*Pertemuan ", RPS)[1:]:
    n = int(re.match(r"(\d+):", b).group(1))
    mt = re.search(r"\*\*Materi\*\*: (.+)", b)
    tugas = re.search(r"\*\*Tugas\*\*: (.+)", b)
    pert[n] = {"materi": htmlmod.unescape(mt.group(1)) if mt else "",
               "tugas": htmlmod.unescape(tugas.group(1)) if tugas else ""}

gen = []  # (cmid, nama, html)
for num in sorted(by_num):
    if num in (0, 8, 16):
        continue
    for m in by_num[num]["modules"]:
        if not m.get("visible", 1):
            continue
        if m["modname"] == "url" and m["name"].startswith("Materi —"):
            judul_bab = m["name"].replace("Materi — ", "")
            h = (f"<p>Bacaan utama pekan ini: <strong>{html_escape(m['name'])}</strong> "
                 f"(bab buku <em>Pemrograman Mobile dengan Flutter</em>).</p>"
                 f"<p>Cakupan RPS: {html_escape(pert[num]['materi'])}.</p>"
                 f"<p>Baca sebelum mengerjakan quiz; starter code pekan ini menemani topik yang sama.</p>")
            gen.append((m["id"], m["name"], h))
        elif m["modname"] == "resource" and m["name"].startswith("Starter"):
            prev = num - 1 if num <= 8 else num - 1  # P09←P07 khusus
            gate_txt = "Terbuka sejak awal — tanpa syarat." if num == 1 else \
                       f"Terbuka setelah lulus Quiz minggu sebelumnya (≥80%)."
            h = (f"<p>Starter code pekan {num:02d}: project Flutter berisi struktur dan TODO "
                 f"yang akan dikerjakan di kelas/praktikum.</p>"
                 f"<p>{gate_txt.replace('Quiz minggu sebelumnya', 'Quiz P' + format(num-1 if num != 9 else 7, '02d'))}</p>"
                 f"<p>Unduh, ekstrak, jalankan <code>flutter pub get</code> lalu <code>flutter run</code>.</p>")
            gen.append((m["id"], m["name"], h))

print(f"\n+ {len(gen)} intro generatif (Materi/Starter)")
json.dump([{"cm": c, "nama": n, "html": h} for c, n, h in gen],
          open("/tmp/intro_gen.json", "w"), ensure_ascii=False, indent=1)
total = len(updates) + len(gen)
print(f"total rencana update: {total}")
