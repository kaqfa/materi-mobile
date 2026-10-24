#!/usr/bin/env python3
"""Re-upload 14 starter zip (versi lab) ke modul File Moodle — v2.
Urutan benar: modedit → list draft → DELETE semua zip draft → upload zip baru
→ save. (v1 upload dulu → Moodle buat duplikat '(1)' → delete != zname malah
menghapus file baru.)"""
import sys, time, glob, os, re, json as J
sys.path.insert(0, "/home/kaqfa/Data-Kerja/Kuliah/materi-mobile")
from playwright.sync_api import sync_playwright

BASE = "https://kulino.dinus.ac.id"
ZIPS = {os.path.basename(z).split("-")[1]: z for z in glob.glob(
    "/home/kaqfa/Data-Kerja/Kuliah/materi-mobile/moodle/build/starter-zips/starter-p*.zip")}
assert len(ZIPS) == 14, sorted(ZIPS)

raw = open("/home/kaqfa/.kulino-admin/session.txt").read().strip()
cname, cval = (raw.split("=", 1) + [""])[:2] if "=" in raw else ("MoodleSession", raw)

# cmid per nomor starter (dari audit sebelumnya)
MODS = {
    "p01": 16586, "p02": 16587, "p03": 16588, "p04": 16589, "p05": 16590, "p06": 16591,
    "p07": 16592, "p09": 16594, "p10": 16597, "p11": 16600, "p12": 16603, "p13": 16607,
    "p14": 16610, "p15": 16613,
}

with sync_playwright() as pw:
    b = pw.chromium.launch(headless=True)
    ctx = b.new_context(locale="en")
    ctx.add_cookies([{"name": cname, "value": cval, "domain": "kulino.dinus.ac.id", "path": "/"}])
    page = ctx.new_page()
    page.goto(f"{BASE}/course/view.php?id=21", wait_until="domcontentloaded")
    if "login" in page.url:
        print("sesi mati"); sys.exit(1)

    ok, fail = 0, []
    for num, cmid in sorted(MODS.items()):
        zpath = ZIPS[num]
        zname = os.path.basename(zpath)
        try:
            page.goto(f"{BASE}/course/modedit.php?update={cmid}", wait_until="domcontentloaded")
            page.wait_for_selector("form.mform", timeout=20000)
            time.sleep(1.5)
            info = page.evaluate(
                "() => document.querySelector('[name=files]')?.value")
            if not info:
                fail.append((num, "itemid?")); continue
            sk = page.evaluate("() => M.cfg.sesskey")

            # 1) hapus SEMUA zip di draft area dulu
            r2 = ctx.request.post(
                f"{BASE}/repository/draftfiles_ajax.php",
                form={"action": "list", "itemid": str(info), "filepath": "/",
                      "filename": "", "sesskey": sk},
                headers={"X-Requested-With": "XMLHttpRequest"},
            )
            listing = J.loads(r2.text())
            olds = [f["filename"] for f in (listing.get("list") or [])
                    if f.get("filename", "").endswith(".zip")]
            for lt in olds:
                ctx.request.post(
                    f"{BASE}/repository/draftfiles_ajax.php",
                    form={"action": "delete", "itemid": str(info),
                          "filepath": "/", "filename": lt, "sesskey": sk},
                    headers={"X-Requested-With": "XMLHttpRequest"},
                )

            # 2) upload zip baru
            with open(zpath, "rb") as f:
                content = f.read()
            r = ctx.request.post(
                f"{BASE}/repository/repository_ajax.php",
                multipart={
                    "action": "upload", "repo_id": "5", "p": "", "env": "filemanager",
                    "sesskey": sk,
                    "client_id": str(info), "itemid": str(info), "savepath": "/",
                    "title": zname,
                    "repo_upload_file": {"name": zname, "mimeType": "application/zip", "buffer": content},
                },
                headers={"X-Requested-With": "XMLHttpRequest"},
            )
            resp = J.loads(r.text())
            if resp.get("error"):
                fail.append((num, resp["error"][:60])); continue

            # 3) save
            page.click("#id_submitbutton")
            page.wait_for_timeout(1800)
            ok += 1
            print(f"P{num}: hapus {len(olds)} lama, upload {zname} OK")
        except Exception as e:
            fail.append((num, str(e)[:70]))
    b.close()

print(f"\nOK {ok}/14 | gagal: {fail if fail else 'tidak ada'}")
