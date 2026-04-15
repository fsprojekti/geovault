import re, zipfile
from pathlib import Path

src = Path("mdpi")
out = Path("geovault_overleaf.zip")

tex = (src / "main.tex").read_text(encoding="utf-8")
tex = re.sub(r'(?m)^[ \t]*\\usepackage\{svg\}[ \t]*\r?\n', '', tex)

out.unlink(missing_ok=True)
with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
    z.writestr("main.tex", tex.encode("utf-8"))
    z.write(src / "references.bib", "references.bib")
    for f in sorted((src / "Definitions").iterdir()):
        z.write(f, "Definitions/" + f.name)
    for name in ["w3w_entropy_vs_radius.pdf", "resultsNoKDF_II.pdf", "Hardening_Spectrum_No16G.pdf"]:
        z.write(src / "img" / name, "img/" + name)

print("svg package removed:", r"\usepackage{svg}" not in tex)
print("Size:", round(out.stat().st_size / 1024, 1), "KB")
print("Zip contents:")
with zipfile.ZipFile(out) as z:
    for e in z.infolist():
        print(f"  {e.filename:<55} {e.file_size//1024:5d} KB")
