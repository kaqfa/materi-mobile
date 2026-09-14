#!/usr/bin/env python3
"""Batch 2: update summary 16 section dari RPS (Sub-CPMK + deskripsi + aktivitas).

Sumber: RPS PPB - 20251.md (Pertemuan 1-16), activities/PXX (nama aktivitas aktual).
Pola form: .stage1b_rename.py (hidden fields + summary_editor[text] format=1).
"""
import re, sys
sys.path.insert(0, "/home/kaqfa/Data-Kerja/Kuliah/materi-mobile")
from kulino_client import form_post, get, refresh_sesskey, ws, COURSE

RPS = open("/home/kaqfa/Data-Kerja/Kuliah/materi-mobile/RPS PPB - 20251.md", encoding="utf-8").read()

# parse pertemuan: Materi, Sub-CPMK, Kemampuan Akhir, Indikator
pert = {}
blocks = re.split(r"### \*\*Pertemuan ", RPS)
for b in blocks[1:]:
    num = int(re.match(r"(\d+):", b).group(1))
    d = {}
    for key in ("Materi", "Sub-CPMK", "Kemampuan Akhir", "Indikator"):
        m = re.search(rf"\*\*{key}\*\*: (.+)", b)
        d[key] = m.group(1).strip() if m else ""
    pert[num] = d

# teks lengkap Sub-CPMK
subcpmk = {}
for m in re.finditer(r"\*\*(Sub-CPMK\d+\.\d+)\*\*: (.+?)\.?\n", RPS):
    subcpmk[m.group(1)] = m.group(2).strip().rstrip(".")

def html_escape(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")

# aktivitas aktual per section (dari WS — post-hapus forum)
cur = ws("core_course_get_contents", courseid=COURSE)
by_num = {s["section"]: s for s in cur}

LABELS = {8: "UTS", 16: "UAS"}  # section 8 & 16 tanpa pertemuan RPS biasa
DESC = {
    8: "Ujian Tengah Semester berupa live coding dan demo aplikasi — pengujian langsung kemampuan praktis.",
    16: "Presentasi final capstone project: video demo produk, dokumentasi, dan responsi.",
}

def summary_html(num):
    if num in (8, 16):
        akt = "".join(f"<li>{html_escape(m['name'])}</li>" for m in by_num[num]["modules"] if m.get("visible", 1))
        return (f"<p>{DESC[num]}</p>"
                f"<p><strong>Aktivitas:</strong></p><ul>{akt}</ul>")
    d = pert.get(num, {})
    kode = d.get("Sub-CPMK", "")
    full = subcpmk.get(kode, "")
    materi = d.get("Materi", "")
    ka = d.get("Kemampuan Akhir", "")
    ind = d.get("Indikator", "")
    akt = "".join(f"<li>{html_escape(m['name'])}</li>" for m in by_num[num]["modules"] if m.get("visible", 1))
    return (f"<p>{html_escape(ka)}.</p>"
            f"<p><strong>Materi:</strong> {html_escape(materi)}.</p>"
            f"<p><strong>{kode}</strong> — {html_escape(full)}.</p>"
            f"<p><em>Indikator: {html_escape(ind)}.</em></p>"
            f"<p><strong>Aktivitas:</strong></p><ul>{akt}</ul>")

def parse_form(sid):
    html = get(f"course/editsection.php?id={sid}")
    hid = {}
    for m in re.finditer(r'<input[^>]*type="hidden"[^>]*>', html):
        tag = m.group(0)
        nm = re.search(r'name="([^"]+)"', tag)
        vl = re.search(r'value="([^"]*)"', tag)
        if nm and nm.group(1) not in hid:
            hid[nm.group(1)] = vl.group(1) if vl else ""
    return hid

refresh_sesskey()
ok, fail = [], []
for num in sorted(by_num):
    if num == 0:
        continue
    s = by_num[num]
    sid = s["id"]
    try:
        hid = parse_form(sid)
        fields = dict(hid)
        fields.update({
            "usedefaultname": 0,
            "name": s["name"],
            "summary_editor[text]": summary_html(num),
            "summary_editor[format]": 1,
            "clientvalues": "",
            "availabilityconditionsjson": "",
            "_qf__editsection_form": 1,
            "submitbutton": "Save changes",
        })
        st, loc = form_post("course/editsection.php", fields)
        (ok if st in (200, 303) else fail).append((num, st))
        print(num, st)
    except Exception as e:
        fail.append((num, str(e)[:60]))
        print(num, "ERR", str(e)[:60])

# verifikasi: summary berisi Sub-CPMK / deskripsi baru
cur2 = ws("core_course_get_contents", courseid=COURSE)
n_ok = 0
for s in cur2:
    if s["section"] == 0:
        continue
    good = "Sub-CPMK" in (s.get("summary") or "") or "UTS" in s["name"] and "live coding" in (s.get("summary") or "").lower()
    n_ok += good
    if not good:
        print("SUMMARY BELUM:", s["section"], (s.get("summary") or "")[:80])
print(f"\nverifikasi summary: {n_ok}/16")
