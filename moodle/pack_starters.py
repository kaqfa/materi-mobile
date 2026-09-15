#!/usr/bin/env python3
"""Pack tiap starter-code/pNN-* menjadi zip siap unggah ke Moodle.

Output: moodle/build/starter-zips/starter-pNN-<slug>.zip
Pakai nama folder sebagai root di dalam zip supaya hasil ekstrak rapi.

Jalankan: python3 pack_starters.py
"""

import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent
STARTERS = ROOT.parent / "starter-code"
OUT_DIR = ROOT / "build" / "starter-zips"

EXCLUDE_DIRS = {".dart_tool", "build", ".idea", ".git", "__pycache__"}
EXCLUDE_FILE_PREFIXES = (".flutter-plugins", ".DS_Store")
# pubspec.lock di-exclude: starter di-resolve mahasiswa di mesin masing-masing
# (lab pakai Flutter 3.27/Dart 3.6 — lock hasil mesin lain bikin pub get gagal).
EXCLUDE_FILES = {"pubspec.lock", "local.properties"}


def should_include(path: Path) -> bool:
    if any(part in EXCLUDE_DIRS for part in path.parts):
        return False
    if any(path.name.startswith(p) for p in EXCLUDE_FILE_PREFIXES):
        return False
    if path.name in EXCLUDE_FILES:
        return False
    return True


def main() -> int:
    if not STARTERS.is_dir():
        print(f"ERROR: {STARTERS} tidak ditemukan")
        return 1

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    # Bersihkan zip lama agar tidak ada sisa starter yang sudah di-rename
    for old in OUT_DIR.glob("starter-*.zip"):
        old.unlink()

    starters = sorted(p for p in STARTERS.iterdir() if p.is_dir() and p.name[0] == "p")
    if len(starters) != 14:
        print(f"ERROR: harapan 14 starter, ditemukan {len(starters)}")
        return 1

    for src in starters:
        # nama file: p01-hello-flutter -> starter-p01-hello-flutter.zip
        zip_path = OUT_DIR / f"starter-{src.name}.zip"
        with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
            for f in sorted(src.rglob("*")):
                if f.is_dir() or not should_include(f.relative_to(src)):
                    continue
                zf.write(f, f.relative_to(src.parent))
        size_kb = zip_path.stat().st_size // 1024
        print(f"OK: {zip_path.name} ({size_kb} KB)")

    print(f"\nSelesai: {len(starters)} zip di {OUT_DIR}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
