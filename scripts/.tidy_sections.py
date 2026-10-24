#!/usr/bin/env python3
"""Rapikan judul section sesuai RPS + sisip baris 'Bacaan: Bab N' di summary."""
import re, sys, html as H
sys.path.insert(0, "/home/kaqfa/Data-Kerja/Kuliah/materi-mobile")
from kulino_client import form_post, get, refresh_sesskey, ws, COURSE

RENAME = {
    3: "P03 — Flutter Fundamentals: Widget & Navigation",
    10: "P10 — Real-time & Advanced API + Gate G2",
    11: "P11 — Advanced State Management",
}
BACAAN = {
    1: "Bab 01 — Dart Fundamentals",
    2: "Bab 02 — Dart Lanjutan: Pemodelan Data",
    3: "Bab 03 — Flutter Fundamental",
    4: "Bab 04 — Build System dan Struktur Proyek",
    5: "Bab 05 — Material 3 dan Antarmuka yang Adaptif",
    6: "Bab 06 — Custom Widget, Form, dan Animasi",
    7: "Bab 05 — Material 3 dan Antarmuka yang Adaptif (bagian responsif)",
    9: "Bab 09 — REST API dan Autentikasi yang Aman",
    10: "Bab 10 — Offline-First: Sinkronisasi yang Benar",
    11: "Bab 07 — State Management (bagian 'Arah Setelah Provider')",
    12: "Bab 11 — Testing & Quality Assurance",
    13: "Bab 12 — Platform Features & Device Integration",
    14: "Bab 13 — Performance Optimization",
    15: "Bab 14 — Deployment & Distribution",
}

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

def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")

refresh_sesskey()
cur = ws("core_course_get_contents", courseid=COURSE)
by_num = {s["section"]: s for s in cur}

for num in sorted(BACAAN):
    s = by_num[num]
    sid = s["id"]
    summary = H.unescape(s.get("summary") or "")
    # sisip <li> Bacaan di awal daftar aktivitas
    if "Bacaan:" not in summary:
        lis = re.findall(r"<li>.*?</li>", summary, re.S)
        if lis:
            summary = summary.replace(lis[0], f"<li><strong>Bacaan:</strong> {esc(BACAAN[num])}</li>" + lis[0], 1)
    fields = dict(parse_form(sid) or {})
    fields.update({
        "usedefaultname": 0,
        "name": RENAME.get(num, s["name"]),
        "summary_editor[text]": summary,
        "summary_editor[format]": 1,
        "clientvalues": "",
        "availabilityconditionsjson": "",
        "_qf__editsection_form": 1,
        "submitbutton": "Save changes",
    })
    st, loc = form_post("course/editsection.php", fields)
    print(f"sec{num}: {st} → '{RENAME.get(num, s['name'])[:45]}' bacaan={'ya' if 'Bacaan:' in summary else 'GAGAL'}")

# verifikasi
cur2 = ws("core_course_get_contents", courseid=COURSE)
n_bacaan = sum(1 for s in cur2 if "Bacaan:" in (s.get("summary") or ""))
n_nama = sum(1 for s in cur2 if s["section"] in RENAME and H.unescape(s["name"]) == RENAME[s["section"]])
print(f"\nverifikasi: bacaan {n_bacaan}/14 section | rename {n_nama}/{len(RENAME)}")
for s in cur2:
    if s["section"] in RENAME:
        print(f"  sec{s['section']}: {H.unescape(s['name'])[:50]}")
