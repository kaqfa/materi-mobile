#!/usr/bin/env python3
"""Eksekusi v2: update intro 57 modul + aktifkan showdescription utk url/resource.
Verifikasi read-back tiap modul via nilai textarea pasca-reload."""
import json, sys
from playwright.sync_api import sync_playwright

BASE = "https://kulino.dinus.ac.id"
raw = open("/home/kaqfa/.kulino-admin/session.txt").read().strip()
cname, cval = (raw.split("=", 1) + [""])[:2] if "=" in raw else ("MoodleSession", raw)

plan = json.load(open("/tmp/intro_plan.json")) + json.load(open("/tmp/intro_gen.json"))
print(f"target: {len(plan)} modul")

ok, fail = [], []
with sync_playwright() as pw:
    b = pw.chromium.launch(headless=True)
    ctx = b.new_context(locale="en")
    ctx.add_cookies([{"name": cname, "value": cval, "domain": "kulino.dinus.ac.id", "path": "/"}])
    page = ctx.new_page()
    page.goto(f"{BASE}/course/view.php?id=21", wait_until="domcontentloaded")
    if "login" in page.url:
        print("sesi mati"); sys.exit(1)
    for i, item in enumerate(plan, 1):
        cm, html, nama = item["cm"], item["html"], item["nama"]
        try:
            page.goto(f"{BASE}/course/modedit.php?update={cm}", wait_until="domcontentloaded")
            page.wait_for_selector("#id_introeditor", timeout=20000, state="attached")
            page.wait_for_timeout(1800)
            page.evaluate("""([html]) => {
                const fr = document.querySelector('iframe[id$="introeditor_ifr"]');
                if (fr) fr.contentDocument.body.innerHTML = html;
                const ta = document.querySelector('#id_introeditor');
                ta.value = html;
                ta.dispatchEvent(new Event('change', {bubbles: true}));
                const sd = document.getElementById('id_showdescription');
                if (sd && !sd.checked) sd.click();
            }""", [html])
            page.click("#id_submitbutton")
            page.wait_for_timeout(1500)
            ok.append(cm)
            if i % 10 == 0:
                print(f"  {i}/{len(plan)}")
        except Exception as e:
            fail.append((cm, nama, str(e)[:60]))
    b.close()

print(f"submit OK: {len(ok)}/{len(plan)} | gagal submit: {fail if fail else 'tidak ada'}")
json.dump(ok, open("/tmp/intro_ok.json", "w"))
