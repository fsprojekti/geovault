# GeoVault — MDPI Paper Submission

**Journal:** *Mathematics* (MDPI) · **Article type:** Research Article  
**Title:** GeoVault: Spatially Anchored Key Management Using Human Spatial Memory and Memory-Hard Key Derivation

---

## Paper Stages

All five stages are stored in this folder. Stages 1–3 share the `Definitions/`, `img/`, and `references.bib` assets at this level. Stages 4–5 are fully self-contained with their own copies.

| # | Stage | Location | Date | PDF | Description |
|---|-------|----------|------|-----|-------------|
| 1 | **Initial Draft** | `main_original.tex` | Mar 2026 | — | First complete draft |
| 2 | **Developed Version** | `main.tex` / `main.pdf` | Apr 2026 | ✅ 484 KB | Full manuscript, all sections |
| 3 | **Peer Review Revision** | `main_track_changes.tex` / `main_track_changes.pdf` | Apr 2026 | ✅ 470 KB | Tracked changes for reviewer |
| — | **Peer Review Responses** | `review/` | Apr 2026 | — | Reviewer comments & author replies (Round 1) |
| 4 | **MDPI Submitted Original** | `stage-4_mdpi-submitted/` | May 2026 | ✅ 553 KB | As received from MDPI (pre-English editing) |
| 5 | **English Proofread Final** | `stage-5_english-proofread/` | May 2026 | ✅ 665 KB | Clean, proofread — ready for resubmission |

---

## Detailed Stage Descriptions

### Stage 1 — Initial Draft
**File:** `main_original.tex` (118 KB, Mar 11, 2026)

The initial complete draft of the manuscript. Uses shared `Definitions/`, `img/`, and `references.bib` at this level.

---

### Stage 2 — Developed Version
**Files:** `main.tex` (149 KB), `main.pdf` (484 KB)  
**Date:** Apr 14, 2026 (source) · Apr 9, 2026 (PDF)

Fully developed manuscript with all sections, tables, figures, and benchmarks complete. Uses shared assets at this level.

---

### Stage 3 — Peer Review Revision
**Files:** `main_track_changes.tex` (178 KB), `main_track_changes.pdf` (470 KB)  
**Date:** Apr 16, 2026 (source) · Mar 26, 2026 (PDF)

Revised manuscript with all peer reviewer changes visibly tracked using LaTeX change-markup. Submitted to MDPI for the Round 1 revision.

**Review materials → `review/`:**
| File | Description |
|------|-------------|
| `round_1.md` | Peer reviewer comments, Round 1 |
| `replies_1.md` | Draft author replies |
| `replies_submitted.md` | Final submitted author replies |
| `editor_response.txt` | Editor decision letter |

---

### Stage 4 — MDPI Submitted Original
**Folder:** `stage-4_mdpi-submitted/mathematics-4223233/`  
**Date:** May 2026 (submitted to MDPI)

The manuscript exactly as prepared and returned by MDPI after initial submission — before English language editing. Contains MDPI's editorial annotations (`\hl{}` highlights, `%MDPI:` comment lines). Preserves the pre-editing state for reference.

**Key files:**
```
mathematics-4223233.tex    203 KB — source with MDPI annotations intact
mathematics-4223233.pdf    553 KB — pre-editing PDF
references.bib             208 KB
Definitions/               MDPI class files (self-contained copy)
img/                       Figures (self-contained copy)
```

> **Note:** This folder is read-only reference. Do not modify.

---

### Stage 5 — English Proofread Final ✅
**Folder:** `stage-5_english-proofread/mathematics-4223233/`  
**Date:** May 12, 2026

The final clean manuscript after all 14 MDPI English editor comments have been resolved. All `\hl{}` wrappers removed, all `%MDPI:` and `%English Editor:` comment lines removed, duplicate bibliography entries cleaned, admin fields completed.

**Key files:**
```
mathematics-4223233.tex    194 KB — clean, fully proofread source
mathematics-4223233.pdf    665 KB — freshly compiled (0 errors, 2 passes)
references.bib             201 KB — cleaned (duplicates removed)
attrib.sty                 stub   — required for MDPI class compilation
Definitions/               MDPI class files (self-contained copy)
img/                       Figures (self-contained copy)
```

**English editing review → `stage-5_english-proofread/review/`:**
| File | Description |
|------|-------------|
| `comments.md` | All 14 MDPI English editor comments |
| `replies.md` | Author replies to each comment |

**Resolved changes (summary):**
- All 14 MDPI editor comments addressed
- All `\hl{}` highlight wrappers removed
- Italics, bold formatting, variable consistency corrected
- Equation formatting, MSC codes, table citation order fixed
- 5 duplicate bibliography entries removed
- Admin fields completed (author contributions, data availability May 12 2026, conflicts of interest)

---

## Shared Assets (used by Stages 1–3)

| Asset | Description |
|-------|-------------|
| `Definitions/` | MDPI LaTeX class files (`mdpi.cls`, `.bst`, logos) |
| `img/` | All figures (SVG sources + compiled PDFs) |
| `references.bib` | Full bibliography (208 KB) |

Stages 4 and 5 each carry their own self-contained copies inside their `mathematics-4223233/` subfolder.

---

## Compiling

### Stages 1–3 (shared assets)
```
cd C:\...\GeoVault\mdpi
pdflatex main.tex          # or main_original.tex / main_track_changes.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

### Stages 4–5 (self-contained)
```
cd stage-5_english-proofread\mathematics-4223233
pdflatex mathematics-4223233.tex
bibtex mathematics-4223233
pdflatex mathematics-4223233.tex
pdflatex mathematics-4223233.tex
```
Requires `attrib.sty` stub (already included) and MiKTeX / TeX Live with MDPI packages installed.

---

## Utility Scripts

| Script | Purpose |
|--------|---------|
| `extract_cites.py` | Extract citation keys |
| `fix_salt.py` | Fix salt-related content |
| `_fix_math.py` | Math notation fixes |
| `review/_fix_reviewer_order.ps1` | Reorder reviewer responses |
| `review/_strip_md.py` | Strip Markdown formatting |
