# Author Replies to Editor Comments — mathematics-4223233

---

## Reply to Comment 1 — Author names, affiliations & footnotes

- **1a** Confirmed. Names are correct.
- **1b** Confirmed. One affiliation only; no number needed.
- **1c** Confirmed. Marko Corn is the corresponding author.
- **1d** ORCID iD restored: `0000-0003-1679-5306`. `\orcidA{}` added back after author name.
- **1e** Equal contribution note removed entirely. Neither `†` symbol appears on either author.
- **1f** Confirmed. `1000 Ljubljana, Slovenia` is correct.
- **1g** Confirmed. `primoz.podrzaj@fs.uni-lj.si` is correct.

**Action taken:** All changes applied in the `.tex` file.

---

## Reply to Comment 2 — Italics throughout

Following common practice for academic papers:
- Italics **kept** for *GeoVault* (system name, used consistently throughout).
- Italics **kept** for *PassMap*, *GeoPass*, *GeoPassNotes* (prior work system names).
- Italics **removed** from the long quoted question ("if a user is willing to spend...").

**Action taken:** `\hl{}` wrappers and MDPI comment lines removed; italic decisions applied.

---

## Reply to Comment 3 — Bold formatting in tables and body

Bold formatting removed as requested by the editor from all flagged instances:
- Table section headers (Hardware, Operating System & Drivers, Software Tools, Benchmark Configuration)
- Omnibus HPZ row
- Security zone names in body text (Insecure, Human-Scale Secure, Super Secure)
- Numbered axis headings (1), (2), (3)
- List item labels (Fast hash evaluations, Memory-hard KDF evaluations)

**Action taken:** All `\textbf{\hl{...}}` instances converted to plain text.

---

## Reply to Comment 4 — Equation formatting

- **4a** Confirmed. `\times` (×) retained for "3 m × 3 m".
- **4b** Confirmed. Unit `s` retained in equations.

**Action taken:** `\hl{}` wrappers and MDPI comment lines removed.

---

## Reply to Comment 5 — Variables consistency

Four inconsistencies were found and corrected:

- **A+B** Password length variable renamed from `$w$` to `$L$` in Section 3.1 (Equation and text), resolving both the mismatch with Table 1 header and the collision with buffer width `$w$` used in Section 4.4.
- **C** Number of benchmark runs renamed from `$N$` to `$n_{\text{rep}}$` in Table header (attacker benchmark). Point anchor count in Equation (point_dictionary_area) renamed from `$N$` to `$N_{\text{anc}}$`, avoiding collision with dictionary size `$N$` and candidate count `$N = 2^H$`.
- **D** Local entropy function `$H_r(r)$` renamed to `$H_{\text{local}}(r)$` (Equations local_entropy_bound and clustering_bias) to eliminate the subscript/argument symbol collision.

**Action taken:** All changes applied in the `.tex` file.

---

## Reply to Comment 6 — Table citation order

Three forward references to tables were replaced with section references:

- Section 4.3 (Parameter Selection Rationale): `Table~\ref{tab:argon2_spectrum}` (Table 10) → `Section~\ref{sec:hardware_benchmarks}`
- Section 5.1 (Entropy Floors): `Table~\ref{tab:combined_spatial_computational}` (Table 16) → `Section~\ref{sec:defense_in_depth}`
- Section 5.2 (ASIC Attack Resistance): `Table~\ref{tab:combined_spatial_computational}` (Table 16) → `Section~\ref{sec:defense_in_depth}`

All table citations now appear in sequential numerical order within the main text.

**Action taken:** All changes applied in the `.tex` file.

---

## Reply to Comment 7 — Minus signs in code

The hyphens in `\texttt{-b -m 12100}` are command-line option flags, not mathematical minus signs. The `\hl{}` wrappers were removed and the hyphens kept as-is, which is correct for CLI flag notation.

**Action taken:** `\texttt{\hl{-}b \hl{-}m \hl{12100}}` → `\texttt{-b -m 12100}`

---

## Reply to Comment 8 — Four-digit number commas

Confirmed. MDPI style uses commas only for numbers with five or more digits. The only affected instance was `2048` (PBKDF2 iterations), which had no comma to begin with — the `\hl{}` wrapper was simply removed. Numbers `16,384` and `32,768` (five digits) retain their commas correctly.

**Action taken:** `\hl{2048}` → `2048`

---

## Reply to Comment 9 — MSC classification

MSC codes were already present: `94A17; 94A60; 68P25`. The duplicate braces and trailing spaces were cleaned up.

**Action taken:** `\MSC{{94A17; 94A60; 68P25  }}` → `\MSC{94A17; 94A60; 68P25}`

---

## Reply to Comment 10 — `\paragraph` → `\subsubsection`

Confirmed. All five headings converted from `\paragraph` to `\subsubsection` by MDPI are accepted. The `\highlighting{}` wrappers were removed from all five headings: Baseline, Offline, Radius, Targeted Attacker, Quantum.

**Action taken:** `\highlighting{...}` removed from all five `\subsubsection` headings; MDPI comment lines removed.

---

## Reply to Comment 11 — Capitalisation after equations

The `\hl{This}` was the only instance of a new sentence starting immediately after a displayed equation. The capitalisation was already correct. `\noindent` was added to suppress the paragraph indent per MDPI style. All other post-equation text uses `where`, `which`, or `Here` as continuations, which do not produce an indent.

**Action taken:** `\hl{This}` → `\noindent This`

---

## Reply to Comment 12 — Commas in `\texttt` numbers

The number `12100` inside `\texttt{-b -m 12100}` is a Hashcat mode identifier used as a command-line argument, not a quantity. Adding a comma would break the command. It is left as-is. The mode `34000` in running text is similarly an identifier — kept without comma.

**Action taken:** `\hl{34000}` wrapper removed; no comma added.

---

## Reply to Comment 13 — English editor note

The flagged sentence correctly states that prior map-based authentication work has not been integrated into a full cryptographic KDF framework that mitigates selection bias through memory-hardening and hardware-aware offline threat modeling. The intended meaning is retained — no change needed.

---

## Reply to Comment 14 — Example string

The string `7&y#B9@q!x2$LpZ*5mW1` is exactly 20 characters, matching the equation $L = \lceil 128 / \log_2(94) \rceil = 20$. It is correct. The `\hl{}` wrapper was removed.

**Action taken:** `\texttt{\hl{7\&y\#B9@q!x2\$LpZ*5mW1}}` → `\texttt{7\&y\#B9@q!x2\$LpZ*5mW1}`
