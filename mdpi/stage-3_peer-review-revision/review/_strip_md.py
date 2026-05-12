import re, pathlib

src = pathlib.Path(__file__).parent / "replies_submitted.md"
txt = src.read_text(encoding="utf-8")

# Remove markdown headings (#, ##, ###)
txt = re.sub(r"^#{1,3} +", "", txt, flags=re.MULTILINE)
# Remove bold (**text**)
txt = re.sub(r"\*\*(.+?)\*\*", r"\1", txt)
# Remove italic (*text*)
txt = re.sub(r"\*(.+?)\*", r"\1", txt)
# Remove inline code (`text`)
txt = re.sub(r"`([^`]+)`", r"\1", txt)
# Remove horizontal rules (---)
txt = re.sub(r"^-{3,}\s*$", "", txt, flags=re.MULTILINE)
# Remove markdown table pipes and alignment rows
txt = re.sub(r"^\|[-:| ]+\|$", "", txt, flags=re.MULTILINE)
txt = re.sub(r"^\| *(.+?) *\|$", lambda m: "  ".join(c.strip() for c in m.group(1).split("|")), txt, flags=re.MULTILINE)
# Collapse 3+ blank lines to 2
txt = re.sub(r"\n{3,}", "\n\n", txt)

src.write_text(txt.strip() + "\n", encoding="utf-8")
print("done")
