#!/usr/bin/env python3
"""Upload 14 PDF slide ke Kulino course 21 per pertemuan.
Ada resource slide (cm20129/cm20130) -> REPLACE file via filemanager draft.
Belum ada -> CREATE resource baru via modedit form POST (pola t006 create resource).
"""
import json as J
import mimetypes
import os
import re
import sys
import time
import urllib.parse

sys.path.insert(0, "/home/kaqfa/Data-Kerja/Kuliah/materi-mobile")
from kulino_client import BASE, _cookie, refresh_sesskey, get

from playwright.sync_api import sync_playwright

SLIDES = "/home/kaqfa/Data-Kerja/Kuliah/materi-mobile/slides/build"
COURSE = 21

# pertemuan -> (file pdf, cmid resource slide existing atau None)
PLAN = {
    "P01": ("P01-dart-fundamentals.pdf", 20129),
    "P02": ("P02-dart-deep-dive.pdf", 20380),
    "P03": ("P03-flutter-fundamentals.pdf", 20130),
    "P04": ("P04-build-system-project-structure.pdf", 20381),
    "P05": ("P05-material-design.pdf", 20382),
    "P06": ("P06-custom-widgets.pdf", 20383),
    "P07": ("P07-responsive-design.pdf", 20384),
    "P09": ("P09-rest-api.pdf", 20385),
    "P10": ("P10-offline-sync.pdf", 20386),
    "P11": ("P11-state-management.pdf", 20387),
    "P12": ("P12-testing.pdf", 20388),
    "P13": ("P13-platform-features.pdf", 20389),
    "P14": ("P14-performance.pdf", 20390),
    "P15": ("P15-deployment.pdf", 20391),
}

# section id dari course_get_contents
from kulino_client import ws
cur = ws("core_course_get_contents", courseid=COURSE)
SECTION = {}
for s in cur:
    m = re.match(r"(P\d\d)", s["name"])
    if m:
        SECTION[m.group(1)] = s["id"]
print("sections:", len(SECTION), flush=True)
assert len(SECTION) >= 14

# perbaiki nama file salah ketik di PLAN (P04)
PLAN["P04"] = ("P04-build-system-project-structure.pdf", PLAN["P04"][1])

results = []
sk = refresh_sesskey()
print("sesskey ok", flush=True)

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    ctx = browser.new_context()
    ctx.add_cookies([{"name": "MoodleSession", "value": _cookie().split("=", 1)[1], "url": BASE}])
    page = ctx.new_page()

    for pnum, (fname, cmid) in PLAN.items():
        fpath = os.path.join(SLIDES, fname)
        if not os.path.exists(fpath):
            results.append((pnum, "file hilang", False))
            continue
        try:
            if cmid:
                # REPLACE: modedit -> itemid -> delete old -> upload -> save
                page.goto(f"{BASE}/course/modedit.php?update={cmid}")
                page.wait_for_selector("[name=files]", state="attached")
                itemid = page.eval_on_selector("[name=files]", "el => el.value")
                sk = page.evaluate("() => M.cfg.sesskey")
                # delete existing pdf
                r2 = ctx.request.post(f"{BASE}/repository/draftfiles_ajax.php",
                    form={"action": "list", "itemid": itemid, "filepath": "/", "filename": "", "sesskey": sk},
                    headers={"X-Requested-With": "XMLHttpRequest"})
                lst = J.loads(r2.text())
                for f in (lst.get("list") or []):
                    if f.get("filename", "").endswith(".pdf"):
                        ctx.request.post(f"{BASE}/repository/draftfiles_ajax.php",
                            form={"action": "delete", "itemid": itemid, "filepath": "/",
                                  "filename": f["filename"], "sesskey": sk},
                            headers={"X-Requested-With": "XMLHttpRequest"})
                        print(f"{pnum}: hapus {f['filename']}", flush=True)
                # upload
                with open(fpath, "rb") as f:
                    content = f.read()
                r = ctx.request.post(f"{BASE}/repository/repository_ajax.php",
                    multipart={"action": "upload", "repo_id": "5", "p": "", "env": "filemanager",
                               "sesskey": sk, "client_id": itemid, "itemid": itemid,
                               "repo_upload_file": {"name": fname, "mimeType": "application/pdf", "buffer": content}},
                    headers={"X-Requested-With": "XMLHttpRequest"})
                J.loads(r.text())
                page.click("#id_submitbutton")
                page.wait_for_load_state("domcontentloaded")
                results.append((pnum, f"replace cm{cmid}", True))
                print(f"{pnum}: replace cm{cmid} OK", flush=True)
            else:
                # CREATE: mod -> resource -> form
                sec = SECTION[pnum]
                page.goto(f"{BASE}/course/modedit.php?add=resource&type&course={COURSE}&sectionid={sec}&return=0&beforemod=0")
                page.wait_for_selector("[name=files]", state="attached")
                itemid = page.eval_on_selector("[name=files]", "el => el.value")
                sk2 = page.evaluate("() => M.cfg.sesskey")
                # isi nama
                page.fill("#id_name", f"Slide {pnum}")
                with open(fpath, "rb") as f:
                    content = f.read()
                r = ctx.request.post(f"{BASE}/repository/repository_ajax.php",
                    multipart={"action": "upload", "repo_id": "5", "p": "", "env": "filemanager",
                               "sesskey": sk2, "client_id": itemid, "itemid": itemid,
                               "repo_upload_file": {"name": fname, "mimeType": "application/pdf", "buffer": content}},
                    headers={"X-Requested-With": "XMLHttpRequest"})
                J.loads(r.text())
                page.click("#id_submitbutton")
                page.wait_for_load_state("domcontentloaded")
                # cmid baru dari redirect URL
                url = page.url
                results.append((pnum, f"create {url}", True))
                print(f"{pnum}: create OK -> {url[:80]}", flush=True)
        except Exception as e:
            results.append((pnum, f"ERROR {e}", False))
            print(f"{pnum}: ERROR {e}", flush=True)
    browser.close()

ok = sum(1 for r in results if r[2])
print(f"\nHASIL: {ok}/{len(results)}")
for r in results:
    print(("OK " if r[2] else "ERR") + f" {r[0]} {r[1][:70]}")
