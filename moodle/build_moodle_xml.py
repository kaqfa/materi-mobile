#!/usr/bin/env python3
"""Generator bank soal Moodle — PPB 20251.

Sumber teks soal: bank_soal.py (jangan edit XML hasil build).
Output:
  build/Moodle-Question-Bank.xml  (140 soal, 14 kategori PPB/PXX) — gitignored
  Kunci-Jawaban.md                (dokumen dosen) — di-commit

Validasi ketat sebelum build:
  - tepat 10 soal per pertemuan, 4 opsi per soal;
  - panjang teks kunci <= panjang SETIAP distraktor (anti terka-dari-panjang);
  - tidak ada opsi duplikat dalam satu soal.

Jalankan:  python3 build_moodle_xml.py
"""
from __future__ import annotations

import html
import re
import sys
from pathlib import Path

from bank_soal import BANK, JUDUL

BASE = Path(__file__).parent
OUT_DIR = BASE / "build"
XML_PATH = OUT_DIR / "Moodle-Question-Bank.xml"
KUNCI_PATH = BASE / "Kunci-Jawaban.md"


def validate() -> None:
    masalah: list[str] = []
    for kode, soal_list in BANK.items():
        if len(soal_list) != 10:
            masalah.append(f"{kode}: {len(soal_list)} soal (harus 10)")
        for i, (pertanyaan, opsi, _) in enumerate(soal_list, 1):
            if len(opsi) != 4:
                masalah.append(f"{kode} Q{i}: {len(opsi)} opsi")
                continue
            kunci, *salah = opsi
            if len(set(opsi)) != 4:
                masalah.append(f"{kode} Q{i}: ada opsi duplikat")
            panjang = [len(o) for o in salah]
            if len(kunci) > min(panjang):
                masalah.append(
                    f"{kode} Q{i}: kunci ({len(kunci)}) lebih panjang dari distraktor terpendek ({min(panjang)})"
                )
    if masalah:
        print("VALIDASI GAGAL:")
        for m in masalah:
            print(" -", m)
        sys.exit(1)


def fmt(text: str) -> str:
    """Markdown ringan -> HTML: ```blok``` -> <pre><code>, `x` -> <code>, \\n -> <br>."""
    bagian: list[str] = []
    for potongan in re.split(r"```[a-z]*\n(.*?)```", text, flags=re.S):
        if len(bagian) % 2 == 0:  # teks biasa
            t = html.escape(potongan, quote=False)
            t = re.sub(r"`([^`]+)`", r"<code>\1</code>", t)
            t = t.replace("\n", "<br>")
        else:  # dalam blok kode
            t = f"<pre><code>{html.escape(potongan, quote=False)}</code></pre>"
        bagian.append(t)
    return "".join(bagian)


def slug_judul(judul: str) -> str:
    """Tag topik dari judul pertemuan: lowercase, kebab-case, <=40 char."""
    s = judul.lower()
    s = re.sub(r"[^a-z0-9]+", "-", s).strip("-")
    return s[:40].rstrip("-")


def question_xml(kode: str, nomor: int, pertanyaan: str, opsi: tuple[str, ...], umpan: str) -> str:
    kunci, *salah = opsi
    jawaban = "".join(
        (
            f'<answer fraction="100" format="html"><text><![CDATA[<p><code>{html.escape(kunci, quote=False)}</code></p>]]></text>'
            f'<feedback format="html"><text><![CDATA[<p>Benar. {html.escape(umpan, quote=False)}</p>]]></text></feedback></answer>',
            *(
                f'<answer fraction="0" format="html"><text><![CDATA[<p><code>{html.escape(w, quote=False)}</code></p>]]></text>'
                f"<feedback format=\"html\"><text><![CDATA[<p>Tidak tepat. {html.escape(umpan, quote=False)}</p>]]></text></feedback></answer>"
                for w in salah
            ),
        )
    )
    return (
        "  <question type=\"multichoice\">\n"
        f"    <name><text>{kode}-Q{nomor:02d}</text></name>\n"
        f"    <questiontext format=\"html\"><text><![CDATA[{fmt(pertanyaan)}]]></text></questiontext>\n"
        f"    <generalfeedback format=\"html\"><text><![CDATA[<p>{html.escape(umpan, quote=False)}</p>]]></text></generalfeedback>\n"
        "    <defaultgrade>1.0000000</defaultgrade>\n"
        "    <penalty>0.0000000</penalty>\n"
        "    <hidden>0</hidden>\n"
        "    <single>true</single>\n"
        "    <shuffleanswers>true</shuffleanswers>\n"
        "    <answernumbering>abc</answernumbering>\n"
        f"    {jawaban}\n"
        "    <tags>\n"
        f"      <tag><text>{html.escape(kode.lower())}</text></tag>\n"
        f"      <tag><text>{html.escape(slug_judul(JUDUL[kode]))}</text></tag>\n"
        f"      <tag><text>ppb-20251</text></tag>\n"
        "    </tags>\n"
        "  </question>\n"
    )


def build() -> None:
    validate()
    baris = [
        '<?xml version="1.0" encoding="UTF-8"?>',
        "<quiz>",
        "  <!-- Bank soal quiz unlock PPB 20251. Digenerate: jangan edit manual. -->",
    ]
    for kode in sorted(BANK):
        baris.append(
            f'  <question type="category"><category><text>$course$/PPB/{kode}</text></category>'
            f"<info format=\"html\"><text>{html.escape(JUDUL[kode], quote=False)}</text></info></question>"
        )
        for i, (pertanyaan, opsi, umpan) in enumerate(BANK[kode], 1):
            baris.append(question_xml(kode, i, pertanyaan, opsi, umpan))
    baris.append("</quiz>")
    OUT_DIR.mkdir(exist_ok=True)
    XML_PATH.write_text("\n".join(baris), encoding="utf-8")

    kunci_md = [
        "# Kunci Jawaban — Quiz Unlock PPB 20251",
        "",
        "> **Dokumen dosen.** Jangan diunggah ke ruang mahasiswa.",
        "> Kunci selalu opsi pertama pada tabel di bawah; Moodle tetap mengacak urutan opsi saat attempt.",
        "",
    ]
    for kode in sorted(BANK):
        kunci_md += [f"## {kode} — {JUDUL[kode]}", "", "| # | Kunci | Penjelasan |", "|---|---|---|"]
        for i, (_, opsi, umpan) in enumerate(BANK[kode], 1):
            kunci_md.append(f"| {i} | **{opsi[0]}** | {umpan} |")
        kunci_md.append("")
    KUNCI_PATH.write_text("\n".join(kunci_md), encoding="utf-8")

    total = sum(len(v) for v in BANK.values())
    print(f"OK: {total} soal, {len(BANK)} kategori -> {XML_PATH.relative_to(BASE)}")
    print(f"OK: kunci dosen -> {KUNCI_PATH.relative_to(BASE)}")


if __name__ == "__main__":
    build()
