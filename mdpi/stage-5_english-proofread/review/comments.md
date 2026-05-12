# MDPI Editor Comments — mathematics-4223233

---

## Comment 1 — Author names, affiliations & footnotes

- **1a** Please carefully check the accuracy of names and affiliations.
- **1b** Only one affiliation present — editor removed the affiliation number. Please confirm.
- **1c** Corresponding author (`*`) moved to Marko Corn based on the submission system. Please confirm.
- **1d** Empty `\orcidA{}` was removed. Please confirm (or provide ORCID iD).
- **1e** Equal contribution footnote: `‡` changed to `†` for Primož so both authors share one `†` note ("These authors contributed equally to this work."). Please confirm.
- **1f** City, postcode and country (`1000 Ljubljana, Slovenia`) added to affiliation. Please confirm.
- **1g** Email addresses added to affiliation block from submitting system (`primoz.podrzaj@fs.uni-lj.si`). Please confirm.

---

## Comment 2 — Italics throughout

Please confirm if italics are necessary; if not, please remove them. Check all italic text in this article.

Flagged instances:
- `\textit{GeoVault}` (used throughout)
- `\textit{PassMap}`, `\textit{GeoPass}`, `\textit{GeoPassNotes}` (prior work system names)
- `\emph{...}` around long quoted question ("if a user is willing to spend...")

---

## Comment 3 — Bold formatting in tables and body

Please confirm if bold formatting is necessary; if not, please remove it. If yes, please add an explanation.

Flagged instances:
- Table section headers: **Hardware**, **Operating System & Drivers**, **Software Tools**, **Benchmark Configuration**
- **Omnibus HPZ** row in entropy dictionaries table
- Security zone names in body text: **Insecure**, **Human-Scale Secure**, **Super Secure**
- Numbered security axis headings: **(1) Number of spatial points...**, **(2) Memory parameter...**, **(3) KDF chaining depth...**
- List item labels: **Fast hash evaluations**, **Memory-hard KDF evaluations**

---

## Comment 4 — Equation formatting

- **4a** `x` revised to `\times` (×, U+00D7) in "3 m × 3 m". Please confirm.
- **4b** Unit `seconds` in equations revised to `s`. Please confirm.

---

## Comment 5 — Variables consistency

Please confirm whether the variables in the text are consistent with the variables in the equations (italics or not, bold or not, subscript or not, superscript or not). Please check all variables in this manuscript.

---

## Comment 6 — Table citation order

Tables are cited out of numerical order:
- Table 10 is cited before Table 4 (in Section 4.2, parameter selection rationale).
- Table 16 is cited before Table 4 (in Section 5.1, entropy floors discussion).

Please confirm and modify so all table citations appear in numerical order.

---

## Comment 7 — Minus signs in code (`\texttt`)

In the table row `\texttt{-b -m 12100}`, should the `-` characters be proper minus signs (`$-$`, U+2212)? Please confirm.

---

## Comment 8 — Four-digit number commas

Commas removed from four-digit numbers (e.g., `2048` not `2,048`). Commas are only used for numbers with five or more digits. Please confirm throughout the article.

---

## Comment 9 — MSC classification

MSC field is necessary for the *Mathematics* journal. Editor added: `94A17; 94A60; 68P25`. Please confirm.

---

## Comment 10 — `\paragraph` → `\subsubsection`

`\paragraph` is only allowed for level-4 headings and is not permitted below a level-2 heading. Several `\paragraph` headings were converted to `\subsubsection` with section numbers added:
- "Baseline Encoder (What3Words)"
- "Offline Resolvability and Open Alternatives"
- "Radius Constraints on Multi-Point Selection"

Please confirm.

---

## Comment 11 — Capitalisation after equations

After Equation (2), "This" is capitalised. Editor asks: should there be an indent for this paragraph? Please check and apply the same format throughout the article.

---

## Comment 12 — Commas in `\texttt` numbers (Table 1)

`\texttt{-b -m 12100}` — should `12100` have a comma (`12,100`)? See also Comment 8.

---

## Comment 13 — English editor note (Section 2.2)

> "Please check that intended meaning has been retained."

Flagged at the end of the paragraph about map-based authentication not being integrated into a cryptographic key derivation framework.

---

## Comment 14 — Example string in Section 5

`\texttt{7&y#B9@q!x2$LpZ*5mW1}` — editor asks: "Please check if this is correct?"
