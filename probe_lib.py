#!/usr/bin/env python3
"""Koneksi DB Kulino read-only (pola skill: parse config.php)."""
import re
import psycopg2

CFG = "/home/kaqfa/Data-Kerja/mounting/kulino/kulino-v3/config.php"

def _grab(src, key):
    m = re.search(rf"\$CFG->{key}\s*=\s*'([^']*)'", src)
    if m:
        return m.group(1)
    m = re.search(rf"'{key}'\s*=>\s*'?([^'\n,]+)'?", src)
    return m.group(1).strip() if m else None

def connect():
    src = open(CFG).read()
    cfg = {k: _grab(src, k) for k in ("dbhost", "dbname", "dbuser", "dbpass")}
    cfg["dbport"] = int(_grab(src, "dbport") or 5432)
    return psycopg2.connect(host=cfg["dbhost"], port=cfg["dbport"],
                            dbname=cfg["dbname"], user=cfg["dbuser"], password=cfg["dbpass"])

db = connect()
