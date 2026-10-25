import secrets
from pathlib import Path

from pypdf import PdfReader, PdfWriter
from pypdf.constants import UserAccessPermissions
from weasyprint import HTML

ROOT = Path(__file__).resolve().parent
SOURCE_DIR = ROOT / "src"
OWNER_PASSWORD = secrets.token_urlsafe(16)

for source in sorted(SOURCE_DIR.glob("UJIAN_*.html")):
    output = ROOT / f"{source.stem}.pdf"
    HTML(filename=str(source)).write_pdf(str(output))

    # Dibuka tanpa password, tetapi copy teks dan edit diblokir; hanya boleh dicetak.
    writer = PdfWriter(clone_from=PdfReader(str(output)))
    writer.encrypt(
        user_password="",
        owner_password=OWNER_PASSWORD,
        permissions_flag=UserAccessPermissions.PRINT | UserAccessPermissions.PRINT_TO_REPRESENTATION,
        algorithm="AES-256",
    )
    with open(output, "wb") as file:
        writer.write(file)
    print(f"{source.name} -> {output.name}")

print(f"Owner password: {OWNER_PASSWORD}")
