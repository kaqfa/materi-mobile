#!/usr/bin/env python3
"""Pre-render blok ```mermaid di deck menjadi SVG statis di `diagrams/`.

Kenapa tidak dirender di browser saat slide ditayangkan:
mermaid menghitung ukuran kotak node dengan mengukur lebar teks. Label node
berada di dalam <foreignObject>, sehingga mewarisi CSS halaman — termasuk
font-size 21px dari theme. Mermaid mengukur pada ukurannya sendiri (16px),
jadi kotak dihitung ~30% lebih sempit daripada teks yang akhirnya dirender,
dan labelnya terpotong. Gejalanya paling parah di ekspor PDF.

Dengan merender di halaman kosong tanpa theme, pengukuran dan render memakai
font yang sama, sehingga SVG konsisten secara internal. SVG itu lalu dipasang
sebagai <img>, dan CSS halaman tidak bisa lagi bocor ke dalamnya.

Label memakai <text> SVG native (htmlLabels: false), bukan foreignObject:
teks dalam foreignObject diletakkan ulang saat Chrome mencetak SVG ke PDF dan
pernah terpotong dari kotak nodenya; <text> diukur dan digambar oleh mesin
yang sama sehingga tidak bisa bergeser.

Pemakaian: python3 tools/render_diagrams.py [deck.md ...]
Tanpa argumen: semua P*.md.
"""

import glob
import hashlib
import http.server
import os
import re
import shutil
import subprocess
import sys
import tempfile
import threading
import xml.dom.minidom

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DIAGRAMS = os.path.join(HERE, 'diagrams')
CHROME = os.environ.get('CHROME_PATH', '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome')
FENCE = re.compile(r'^```mermaid\n(.*?)^```', re.M | re.S)

PAGE = """<!DOCTYPE html>
<html><head><meta charset="utf-8">
<style>
  /* Halaman sengaja polos: tidak ada yang boleh memengaruhi pengukuran teks. */
  body {{ font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 16px; margin: 0; }}
</style></head>
<body>
{bodies}
<script src="mermaid.min.js"></script>
<script>
  mermaid.initialize({{
    startOnLoad: false,
    theme: 'base',
    fontFamily: 'Helvetica Neue, Arial, sans-serif',
    flowchart: {{ useMaxWidth: false, padding: 14, htmlLabels: false }},
    themeVariables: {{
      primaryColor: '#e8f0fa',
      primaryBorderColor: '#14529c',
      primaryTextColor: '#1a1a1a',
      lineColor: '#14529c',
      fontFamily: 'Helvetica Neue, Arial, sans-serif',
      fontSize: '14px',
    }},
  }});
  mermaid.run({{ querySelector: '.d' }}).then(function () {{
    document.title = 'SIAP';
  }});
</script></body></html>"""


def digest(source: str) -> str:
    return hashlib.sha1(source.strip().encode()).hexdigest()[:12]


def collect(files):
    """Kembalikan {hash: definisi} untuk semua diagram di deck yang diberikan."""
    found = {}
    for path in files:
        for match in FENCE.finditer(open(path).read()):
            body = match.group(1).strip()
            found[digest(body)] = body
    return found


def serve(directory):
    handler = lambda *a, **kw: http.server.SimpleHTTPRequestHandler(
        *a, directory=directory, **kw)
    server = http.server.ThreadingHTTPServer(('127.0.0.1', 0), handler)
    threading.Thread(target=server.serve_forever, daemon=True).start()
    return server, server.server_address[1]


def render(pending):
    """Render definisi yang belum punya SVG, tulis ke diagrams/<hash>.svg."""
    workdir = tempfile.mkdtemp(prefix='mermaid-')
    try:
        shutil.copy(os.path.join(HERE, 'vendor', 'mermaid.min.js'), workdir)
        bodies = '\n'.join(
            f'<pre class="d" id="d{key}">{body}</pre>' for key, body in pending.items())
        with open(os.path.join(workdir, 'index.html'), 'w') as handle:
            handle.write(PAGE.format(bodies=bodies))

        server, port = serve(workdir)
        try:
            dom = subprocess.run(
                [CHROME, '--headless', '--disable-gpu', '--no-sandbox',
                 '--virtual-time-budget=20000', '--dump-dom',
                 f'http://127.0.0.1:{port}/index.html'],
                capture_output=True, text=True, timeout=180).stdout
        finally:
            server.shutdown()

        os.makedirs(DIAGRAMS, exist_ok=True)
        written = 0
        for key in pending:
            match = re.search(
                r'id="d%s"[^>]*>(<svg.*?</svg>)' % key, dom, re.S)
            if not match:
                print(f'  GAGAL merender {key}', file=sys.stderr)
                continue
            svg = match.group(1)
            # Label edge mermaid memuat <br> tanpa penutup; sebagai file .svg
            # (XML ketat) Chrome menolak keseluruhan gambar dan menampilkan
            # alt text. Tutup sendiri sebelum divalidasi.
            svg = re.sub(r'<br\s*>', '<br/>', svg)
            try:
                xml.dom.minidom.parseString(svg)
            except Exception as e:
                print(f'  GAGAL validasi XML {key}: {e}', file=sys.stderr)
                continue
            with open(os.path.join(DIAGRAMS, f'{key}.svg'), 'w') as handle:
                handle.write('<?xml version="1.0" encoding="UTF-8"?>\n')
                handle.write(svg)
            written += 1
        return written
    finally:
        shutil.rmtree(workdir, ignore_errors=True)


def main():
    files = sys.argv[1:] or sorted(glob.glob(os.path.join(HERE, 'P*.md')))
    if not os.path.exists(CHROME):
        sys.exit(f'Google Chrome tidak ditemukan di {CHROME}')

    diagrams = collect(files)
    pending = {
        key: body for key, body in diagrams.items()
        if not os.path.exists(os.path.join(DIAGRAMS, f'{key}.svg'))
    }
    if not pending:
        print(f'{len(diagrams)} diagram, semuanya sudah ter-render.')
        return
    print(f'{len(diagrams)} diagram, {len(pending)} perlu dirender...')
    print(f'  {render(pending)} SVG ditulis ke diagrams/')


if __name__ == '__main__':
    main()
