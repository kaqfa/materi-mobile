from pathlib import Path

from weasyprint import HTML

ROOT = Path(__file__).resolve().parent
SOURCE_DIR = ROOT / "src"

for source in sorted(SOURCE_DIR.glob("UJIAN_*.html")):
    output = ROOT / f"{source.stem}.pdf"
    HTML(filename=str(source)).write_pdf(str(output))
    print(f"{source.name} -> {output.name}")
