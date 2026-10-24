#!/usr/bin/env python3
"""Library: klien WS Kulino + form POST admin (cookie) + helper course 21.

Pola: WS utk aksi struktur; form POST (sesskey+cookie) utk settings modul penuh
(modedit.php) karena core WS tidak mengekspos settings modul lengkap.
"""
import json, re, time, urllib.request, urllib.parse, urllib.error, uuid

BASE = "https://kulino.dinus.ac.id"
COURSE = 21

def _tok():
    return open("/home/kaqfa/.kulino-admin/ws_token").read().strip()

def _cookie():
    return open("/home/kaqfa/.kulino-admin/session.txt").read().strip()

def _sesskey():
    return open("/home/kaqfa/.kulino-admin/sesskey").read().strip()

def _flatten(params, prefix=""):
    """Moodle REST: list → idx[0]=.., dict → key[sub]=..; scalar langsung."""
    out = {}
    for k, v in params.items():
        key = f"{prefix}{k}"
        if isinstance(v, list):
            for i, item in enumerate(v):
                if isinstance(item, dict):
                    out.update(_flatten(item, f"{key}[{i}]"))
                else:
                    out[f"{key}[{i}]"] = item
        elif isinstance(v, dict):
            out.update(_flatten(v, f"{key}"))
        else:
            out[key] = v
    return out

def ws(fn, **params):
    data = urllib.parse.urlencode({"wstoken": _tok(), "wsfunction": fn,
                                   "moodlewsrestformat": "json", **_flatten(params)}).encode()
    req = urllib.request.Request(f"{BASE}/webservice/rest/server.php", data=data)
    with urllib.request.urlopen(req, timeout=120) as r:
        out = json.loads(r.read().decode())
    if isinstance(out, dict) and "exception" in out:
        raise RuntimeError(f"WS {fn}: {out.get('message')} ({out.get('debuginfo','')})")
    return out

def form_post(path, fields):
    """POST form admin dengan sesskey; fields dict; return redirect URL."""
    fields = {"sesskey": _sesskey(), **fields}
    data = urllib.parse.urlencode(fields, doseq=True).encode()
    req = urllib.request.Request(f"{BASE}/{path}", data=data,
        headers={"Cookie": _cookie(), "Content-Type": "application/x-www-form-urlencoded"})
    class NoRedirect(urllib.request.HTTPRedirectHandler):
        def redirect_request(self, *a, **k):
            return None
    op = urllib.request.build_opener(NoRedirect)
    try:
        with op.open(req, timeout=120) as r:
            body = r.read().decode("utf-8", "replace")
            return r.status, body[:500]
    except urllib.error.HTTPError as e:
        return e.code, e.headers.get("Location", "") or e.read().decode("utf-8", "replace")[:500]

def get(path):
    req = urllib.request.Request(f"{BASE}/{path}", headers={"Cookie": _cookie()})
    with urllib.request.urlopen(req, timeout=60) as r:
        return r.read().decode("utf-8", "replace")

def multipart_post(path, fields, files):
    """POST multipart (upload). files = [(field, filename, path)]"""
    b = uuid.uuid4().hex
    parts = []
    for k, v in fields.items():
        parts.append(f'--{b}\r\nContent-Disposition: form-data; name="{k}"\r\n\r\n{v}\r\n'.encode())
    for field, fname, path in files:
        content = open(path, "rb").read()
        parts.append(f'--{b}\r\nContent-Disposition: form-data; name="{field}"; filename="{fname}"\r\nContent-Type: application/zip\r\n\r\n'.encode() + content + b"\r\n")
    parts.append(f"--{b}--\r\n".encode())
    body = b"".join(parts)
    req = urllib.request.Request(f"{BASE}/{path}", data=body,
        headers={"Cookie": _cookie(), "Content-Type": f"multipart/form-data; boundary={b}"})
    class NoRedirect(urllib.request.HTTPRedirectHandler):
        def redirect_request(self, *a, **k):
            return None
    op = urllib.request.build_opener(NoRedirect)
    try:
        with op.open(req, timeout=300) as r:
            return r.status, r.geturl()
    except urllib.error.HTTPError as e:
        return e.code, e.headers.get("Location", "") or ""

# ---------- domain helpers ----------

def sections():
    """[(sectionid, num, name, visible)] dari WS contents."""
    out = ws("core_course_get_contents", courseid=COURSE)
    return [(s["id"], s["summary"], s["summaryformat"], s["section"], s["visible"], s["name"])
            for s in out]

def find_section(out=None, num=None, name=None):
    out = out or ws("core_course_get_contents", courseid=COURSE)
    for s in out:
        if (num is not None and s["section"] == num) or (name and s["name"] == name):
            return s
    return None

def refresh_sesskey():
    html = get(f"course/view.php?id={COURSE}")
    m = re.search(r'"sesskey":"(\w+)"', html)
    if m:
        open("/home/kaqfa/.kulino-admin/sesskey", "w").write(m.group(1))
        return m.group(1)
    raise RuntimeError("sesskey tidak ketemu — sesi admin mungkin mati")

if __name__ == "__main__":
    sk = refresh_sesskey()
    info = ws("core_webservice_get_site_info")
    print("READY user:", info["username"], "sesskey OK len", len(sk))
