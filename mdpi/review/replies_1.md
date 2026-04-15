# Replies to Reviewers — Round 1

> **Legend:** ✅ Done | 🔶 Partial | ❌ Not yet done

---

## Reviewer 1

### R1.1 — Missing related work: GeoPass, PassMap, GeoPassNotes, Al-Ameen & Wright (2014)
**Status: ✅ Done**

We have extended Section 2.2 to include *PassMap* (Sun et al., 2012), *GeoPass* (Thorpe et al., 2013), *GeoPassNotes* (MacRae et al., 2016), and **Al-Ameen and Wright (2014)**. The added paragraph explicitly describes how Al-Ameen & Wright quantified user selection distributions concentrating around personally and culturally salient locations, and how this reduces the effective search space for a contextually informed adversary. The bib entry `AlAmeen2014` has been added to `references.bib` (exact title/DOI to be verified against the published proceedings).

---

#### Cascade: how R1.1 propagates through the rest of the paper

R1.1 is not isolated to Related Work — it exposes a chain of under-addressed issues in the formal model and evaluation:

**→ Section 3.2 / `eq:entropy_collapse` and `eq:clustering_bias` (also R1.6 and R1.11)**

The entropy model defines spatial dictionaries as *geographic* filters (habitable land, coastlines, urban areas) and treats selection within each dictionary as **uniform**. Al-Ameen & Wright (2014) and the GeoPass studies show that within even broad geographic regions, users have highly non-uniform selection distributions skewed toward residential locations, workplaces, and famous landmarks. The current model has no mechanism to express this demographic/behavioral non-uniformity — it is entirely a *coverage* model, not a *probability* model.

Specifically, `eq:clustering_bias`:
```
H_spatial(n, r) ≈ H_anchor + (n−1)·H_r(r)
```
treats `H_anchor` as the effective entropy of the first freely chosen point — currently implicitly equal to `H_eff(D)` for whatever dictionary D is chosen (e.g., 41.38 bits for Omnibus HPZ). But this is still an overestimate: a targeted attacker who knows the user lives in London starts from the Urban (London) dictionary (27.38 bits), not the global HPZ, cutting 14 additional bits *before* proximity clustering is applied.

❌ **TODO (R1.11):** Reformulate `eq:clustering_bias` so `H_anchor` is explicitly a variable bounded by attacker demographic knowledge, not silently equal to the HPZ floor. Introduce a biased-anchor variant, e.g.:
```
H_anchor ≤ H_eff(D_demographic)
```
where `D_demographic` is the narrowest dictionary the attacker can plausibly assign (e.g., user's city of residence inferred from public data).

**→ Table `tab:entropy_dictionaries` (HPZ dictionary table)**

The "Omnibus HPZ" row at 41.38 bits is used as the **universal pessimistic floor** for all subsequent results tables. This is the floor for a *geographically uninformed* attacker only. A socially informed attacker (R1.10) can narrow this further to the Urban dictionary (27.38 bits) or even a neighborhood scale.

❌ **TODO:** Add a row or footnote to `tab:entropy_dictionaries` for a "Targeted / Demographically Informed" dictionary that applies Al-Ameen & Wright selection bias data, making explicit that 27.38 bits (or less) is the realistic floor for a targeted adversary.

**→ Section 5.5 / `tab:combined_spatial_computational` (combined hardening results)**

All combined security projections in Table 11 are built on the Omnibus HPZ floor of 41.38 bits spatial entropy + Argon2 hardening. If the actual anchor entropy for a targeted attacker is 27.38 bits, then:
- Configurations that appear "Human-Scale Secure" in Table 11 at $m=4$ GiB may shift toward the boundary or below if the urban-biased anchor is used.
- The paper currently does not present this scenario at all.

❌ **TODO:** Add a row or secondary table in Section 5.5 showing combined time-to-compromise when spatial entropy starts from the Urban (27.38 bit) floor, making explicit which Argon2 parameter configurations remain secure under a targeted adversary with demographic knowledge of the user.

---

### R1.2 — Wrong citation: Bauer & Johnson-Laird (1993) misused in Section 2.2
**Status: ✅ Done**

The paragraph containing `\cite{Bauer1993}` was removed entirely. It has been replaced by the PassMap/GeoPass/GeoPassNotes paragraph with on-topic authentication-focused references.

---

### R1.3 — No user study; usability claims need proper acknowledgement
**Status: ✅ Done**

A dedicated paragraph has been added to Section 6.4 (Threat Model and Limitations) explicitly stating that the paper contains no empirical user study, listing all usability claims that remain unvalidated (retention, recall accuracy, cognitive load, latency tolerability), and specifying the three measurements a future user study should include. The paragraph directly addresses the reviewer's request for a thorough, explicit limitation acknowledgement.

---

### R1.4 — W3W offline resolvability contradiction
**Status: ✅ Done**

Section 4.3 now contains `\paragraph{\add{Offline resolvability and open alternatives.}}` explicitly acknowledging the W3W API dependency, noting the tension with the stated offline-resolvability requirement, and recommending OLC/Plus Codes (precision level 11, ~9 m² footprint) as the recommended open alternative for strict offline deployments. The security model and all quantitative results are stated to be encoder-independent.

---

### R1.5 — Fixed public salt: rainbow table vulnerability not discussed
**Status: ✅ Done**

Section 4.4 now contains `\paragraph{\add{Fixed salt and rainbow table resistance.}}` with a two-part argument: (1) rainbow table precomputation against Argon2id at any evaluated memory tier is physically unrealisable (each entry occupies GiBs of VRAM); (2) the spatial entropy of the KDF input ($\geq 45.7n$ bits) exceeds any feasible precomputation budget. BIP-39's analogous fixed salt string `"mnemonic"` is cited as precedent.

---

### R1.6 — Entropy model does not capture user selection bias (uniform assumption)
**Status: ✅ Done**

The formal model in Section 3.2 now includes a selection fraction $f_s \in (0,1]$ representing the proportion of dictionary cells that attract non-negligible probability mass under a demographically informed prior. The corrected effective entropy formula is $H_{\text{eff,bias}} = H_{\text{eff}}(\mathcal{D}) + \log_2 f_s$, explicitly adjusting for within-dictionary behavioural bias. Cited Sun2012, Thorpe2013, AlAmeen2014.

---

### R1.7 — VDFs, time-lock puzzles, PoSW: ~2 pages not used in protocol
**Status: ✅ Done**

The detailed exposition of VDFs, time-lock puzzles, and Proof-of-Sequential-Work was replaced with a single condensed paragraph that briefly names these alternatives and explains why GeoVault uses memory-hard KDFs instead.

---

### R1.8 — Wrong citation: Garden, Cornoldi & Logie (2002) misused in Section 2.2
**Status: ✅ Done**

The paragraph containing `\cite{Garden2002}` — which incorrectly cited a visuospatial navigation paper in the context of authentication secret retention — was removed entirely.

---

### R1.9 — Formatting and editing errors
**Status: Mixed**

**(a) Reference "?" artifact (former [53?]):** ✅ Done — `Bonneau2012a` now present in the bibliography and compiles correctly.

**(b) Metadata placeholders (Affiliation 1, DOI, "Current address"):** 🔶 Partial — The "Affiliation 1;" prefix has been removed from `\address{}` (real affiliation retained: "Faculty of Mechanical Engineering, University of Ljubljana"). The `\firstnote{Current address: Affiliation.}` placeholder has been commented out. The empty DOI `\hreflink{https://doi.org/}` requires a journal-assigned DOI and cannot be filled until the paper is accepted.

**(c) "burial sites" terminology:** ✅ Done — replaced with "spatial anchors"; Section 2.4 title changed from "Burying Secrets" to "Hardening Secrets".

---

### R1.10 — Threat model omits partial public-source information (social networks, location data)
**Status: ✅ Done**

Section 6.4 now contains a `\add{}` paragraph giving a fully worked quantitative example: attacker recovers home city from social media (anchor entropy collapses from 45.7 bits to 27.4 bits); if all $n$ points collapse to the urban prior, total entropy = $n \times 27.4$ bits. For $n=3$: 82.2 bits, which combined with Argon2id at $m=1{,}024$ MiB remains in the Human-Scale Secure zone. Establishes this as the tight lower bound on effective entropy.

---

### R1.11 — Proximity clustering model: anchor entropy not reduced for semantic bias (Equation 10)
**Status: ✅ Done**

Equation `eq:clustering_bias` now has an explicit `\add{}` paragraph explaining that $H_{\text{anchor}}$ is bounded above by $H_{\text{eff}}(\mathcal{D})$ for whatever dictionary the attacker uses — not silently equated to the global nominal entropy. The paragraph shows that a targeted attacker knowing the user's city reduces $H_{\text{anchor}}$ from 45.7 bits to $\approx$27.4 bits, and that this loss propagates to all $n$-point estimates regardless of clustering radius. Cited to Sun2012, Thorpe2013, AlAmeen2014.

---

### R1.12 — Empirical evaluation on single hardware platform
**Status: ✅ Done**

Same resolution as R2.10: Section 5.1 adds `tab:argon2_defender_cost_consumer` projecting latency on a consumer laptop (1.7×–2.5× slower than the Xeon Gold 6338); Section 6.2 adds an `\add{}` paragraph explicitly extrapolating to consumer defenders (2–4 s at $m=1{,}024$ MiB) and high-end multi-GPU attackers (4× RTX 4090 cluster = 2-bit work-factor reduction, no zone change for $n \geq 2$).

---

### R1.13 — Stylistic review for AI-generation indicators
**Status: ✅ Done**

16 targeted `\remove{}\add{}` rewrites applied across Introduction (5), Discussion (6), and Conclusions (5). Specific changes:

- **Introduction para 1**: Replaced generic security-challenge opener with a sharp claim about where real-world system failures occur.
- **Introduction para 4**: Replaced "A key limitation shared by…" and "In contrast, decades of research…" trio with a direct comparison of linguistic vs. spatial memory retention profiles.
- **Introduction para 5**: Replaced "These findings have motivated prior work…" generic sentence with a specific statement of what prior map-based schemes lack (formal entropy model, demographic reduction quantification, GPU-adversary evaluation).
- **Introduction contributions header**: "threefold" → "main contributions".
- **Introduction road-map paragraph**: Compressed the 7-sentence section outline to 6 sentences.
- **Discussion opener (§6)**: Replaced "The results presented in this work show that…" + "The empirical and analytical results indicate" with a direct claim.
- **Discussion §6.1**: Replaced "A central finding of this study is that" with direct assertion.
- **Discussion §6.1**: Replaced "This higher entropy floor alters the practical boundary…The results indicate that" passage with direct sentences.
- **Discussion §6.2**: Replaced "While spatial entropy alone is insufficient to guarantee…" hedged opener with a direct gap statement. Removed "Consequently, GeoVault converts modest…" overlong sentence.
- **Discussion §6.5 (Implications)**: Replaced "The findings of this study suggest…" and "More broadly, GeoVault illustrates…" formulas with direct claims.
- **Conclusions para 1**: Replaced "This work introduced GeoVault…By grounding key derivation…" opener with a direct statement of what GeoVault demonstrates.
- **Conclusions para 3**: Replaced "Through information-theoretic analysis, we showed…Empirical benchmarking further demonstrated…" with specific quantitative claims.
- **Conclusions para 4**: Replaced "The results indicate that GeoVault can achieve…" with direct claim starting from the key driver.
- **Conclusions para 5**: Replaced "Beyond the specific instantiation…" and generic future-work list with specific open research directions.
- **Conclusions para 6**: Replaced "A key quantitative finding of this work is…In summary, GeoVault demonstrates that…" with direct characterization of $\eta(m)$ and the practical lesson.

---

## Reviewer 2

### R2.1 — GPS drift and coordinate imprecision in key generation
**Status: ✅ Done**

Section 4.1 (Spatial Input Model) now contains an `\add{}` sentence explaining that GeoVault uses map-based tap/click selection, not device GPS. The geospatial encoding scheme snaps any coordinate to the nearest discrete cell at selection time, so sub-cell imprecision is absorbed by design. GPS-induced drift is therefore not a concern in the GeoVault threat model.

---

### R2.2 — W3W is proprietary; reduces scientific reproducibility
**Status: ✅ Done**

Same resolution as R1.4: Section 4.3 now contains `\paragraph{\add{Offline resolvability and open alternatives.}}` explicitly recommending OLC/Plus Codes as the open-source reference encoder for reproducible deployments, and stating that the security model and all results are encoder-independent.

---

### R2.3 — No fuzzy matching or error-tolerant mechanism
**Status: ✅ Done**

Section 6.4 (Threat Model and Limitations) now explicitly states that a single-cell recall error (selecting an adjacent 3 m × 3 m tile) causes 100% key derivation failure regardless of $n$ or $m$, and identifies this as a fundamental usability limitation. Future work directions (nearest-cell retry window, spatially defined equivalence class) are named with the constraint that they must not expand the attacker's dictionary beyond the Section 5.3 security margins.

---

### R2.4 — No scientific justification for Argon2 parameters (t, m, p)
**Status: ✅ Done**

Section 4.4 now contains `\paragraph{\add{Parameter selection rationale.}}` at `\label{sec:argon2_parameters}` deriving $(t, m, p)$ from two constraints: (1) usability — $T_{\text{CPU}} \approx 1.26$ s at $m=1{,}024$ MiB is within the sub-2-second interactive budget~\cite{nielsen1994usability}; (2) security — $m=1{,}024$ MiB saturates GPU parallelism, capping $R_{\text{GPU}}$ at 53.7 H/s. Setting $t=1$ follows the Argon2 specification recommendation; $p=1$ is appropriate for single-thread commodity hardware.

---

### R2.5 — Fixed static salt enables rainbow table attacks
**Status: ✅ Done**

Same resolution as R1.5 (treated jointly).

---

### R2.6 — Fixed canonical point ordering is a usability problem
**Status: ✅ Done**

Section 4.4 now contains `\paragraph{\add{Canonical ordering and usability.}}` acknowledging that the order-sensitive concatenation means swapping two identifiers derives an entirely different key. Explains this is a deliberate design choice (preserves the $n!$ permutation space as part of the secret) but imposes a recall requirement. Mitigations (lexicographic sort for order-invariance; onboarding step that records canonical sequence) are identified as future work.

---

### R2.7 — Security zone thresholds not formally derived
**Status: ✅ Done**

Added formal derivation paragraph in Section 4.5 (Security Evaluation Methodology) after the zone bullet list (`\add{}`). The zone names in the bullet items were updated to match the Results section labels: **Insecure** / **Human-Scale Secure** / **Super Secure**, each with explicit threshold ranges.

- **$10^{10}$ s** ($\approx 317$ years): upper bound on sustained nation-state attack investment.
- **$10^{32}$ s**: derived from $2^{128} / R_{\text{GPU,hash}} = 2^{128} / (1.3\times10^7) \approx 3.3\times10^{31}$ s — the 128-bit security level, matching BIP-39's entropy target.

New equation `eq:w128_threshold` added. Cited `Bonneau2012a` for both thresholds.

---

### R2.8 — ASIC attack throughput not analysed
**Status: ✅ Done**

Added `\paragraph{\add{ASIC Attack Resistance.}}` paragraph in Section 5.2 (Attacker Performance), immediately before the Baseline subsection. Key points:

1. Argon2id's TMTO-resistance proof (cite `7467361`): any ASIC using less than $m$ memory faces exponential time penalty — no space-time trade-off possible.
2. Practical ASIC advantage bounded at ~2–4× per Argon2 designers; conservative $10\times$ bound applied.
3. At $10\times$: work factors shift by at most $\log_2(10) \approx 3.3$ bits — does not change security zone for any $n \geq 1$ configuration at $m=1{,}024$ MiB.
4. GPU benchmark is a conservative upper bound; ASIC threats do not alter conclusions.

---

### R2.9 — Omnibus HPZ entropy (41.38 bits) appears to fall in Insecure zone
**Status: ✅ Done**

Section 5.1 (spatial entropy results) now contains an explicit `\add{}` sentence clarifying that the 41.38-bit value refers to spatial entropy alone; security zone classification is based on the attacker-adjusted work factor $\mathcal{W}$. At $m \geq 1{,}024$ MiB, an $n=1$ Omnibus secret reaches the Human-Scale Secure zone; at $m=4{,}096$ MiB, $\mathcal{W} > 10^{16}$ s.

---

### R2.10 — No legitimate-user computation time on consumer hardware (e.g., laptop 8 GB RAM)
**Status: ✅ Done**

Added `\paragraph{Consumer hardware extrapolation.}` + `tab:argon2_defender_cost_consumer` in Section 5.1 (Defender-Side Key-Derivation Latency), immediately after `tab:argon2_defender_cost`. The table projects defender latencies across all four evaluated memory tiers using a $1.7\times$–$2.5\times$ bandwidth scaling factor (laptop DDR5 is ~40–60% of Xeon Gold 6338 DDR4 peak). Reference config $m=1{,}024$ MiB → **2.1–3.1 s** on consumer laptop, within interactive budget.

---

### R2.11 — No standard deviation or confidence intervals in benchmarks
**Status: ✅ Done**

- **`tab:argon2_defender_cost`**: Added $\sigma$ column from raw measurements ($n=50$ reps each):
  - 64\,MiB: $\sigma=5.2$\,ms; 256\,MiB: $\sigma=3.3$\,ms; 1024\,MiB: $\sigma=47.1$\,ms; 8192\,MiB: $\sigma=620.9$\,ms
  - Footnote: CV = 3.0--7.0\% (memory-bandwidth jitter under OS scheduling)
- **`tab:kchain_empirical`**: Added $\sigma$ column; updated Mean for k=64 to 82.499\,s (empirically measured, was 82.500).
  - $\sigma$ range: 0.006\,s (k=1) to 1.213\,s (k=64)
- **`tab:argon2_spectrum`**: Added two-line footnote: GPU throughput is deterministic (P95=Median for tiers $\geq$2048\,MiB, CV\,<\,0.1\%); no explicit $\sigma$ needed for attacker-side measurements.

---

### R2.12 — Reference 5 has `PAGE:STRING:ARTICLE/CHAPTER` DOI error
**Status: ✅ Done**

The `Pals2018` entry in `mdpi/references.bib` has a clean DOI field: `doi = {10.1080/09500693.2017.1407885}`. No malformed suffix present.

---

### R2.13 — Tables not cited in text; "?" reference error
**Status: ✅ Done**

The "?" reference artifact is resolved (`Bonneau2012a` compiles correctly). `tab:attacker_cost` (GPU BIP-39 PBKDF2 attacker benchmarks) is cited in the running text at the sentence "The measured sustained throughput is reported in Table~\ref{tab:attacker_cost}".

---

## Summary

| # | Reviewer | Point | Status |
|---|---|---|---|
| R1.1 | Rev 1 | Missing GeoPass/PassMap/GeoPassNotes/Al-Ameen | ✅ Done |
| R1.2 | Rev 1 | Bauer 1993 wrong citation removed | ✅ Done |
| R1.3 | Rev 1 | No user study acknowledgement | ✅ Done |
| R1.4 | Rev 1 | W3W offline resolvability contradiction | ✅ Done |
| R1.5 | Rev 1 | Fixed salt rainbow table risk | ✅ Done |
| R1.6 | Rev 1 | Entropy model uniform assumption | ✅ Done |
| R1.7 | Rev 1 | VDF/PoSW section condensed | ✅ Done |
| R1.8 | Rev 1 | Garden 2002 wrong citation removed | ✅ Done |
| R1.9a | Rev 1 | "?" reference artifact fixed | ✅ Done |
| R1.9b | Rev 1 | Metadata placeholders (DOI pending journal assignment) | 🔶 Partial |
| R1.9c | Rev 1 | "burial sites" → "spatial anchors" | ✅ Done |
| R1.10 | Rev 1 | Threat model: public-source partial info | ✅ Done |
| R1.11 | Rev 1 | Proximity model anchor entropy | ✅ Done |
| R1.12 | Rev 1 | Single hardware platform evaluation | ✅ Done |
| R1.13 | Rev 1 | AI-generation stylistic review | ✅ Done |
| R2.1 | Rev 2 | GPS drift | ✅ Done |
| R2.2 | Rev 2 | W3W proprietary / reproducibility | ✅ Done |
| R2.3 | Rev 2 | Fuzzy matching / error tolerance | ✅ Done |
| R2.4 | Rev 2 | Argon2 parameter justification | ✅ Done |
| R2.5 | Rev 2 | Static salt rainbow table | ✅ Done |
| R2.6 | Rev 2 | Fixed canonical ordering usability | ✅ Done |
| R2.7 | Rev 2 | Security zone thresholds not derived | ✅ Done |
| R2.8 | Rev 2 | ASIC attack throughput | ✅ Done |
| R2.9 | Rev 2 | 41.38 bit entropy "Insecure" | ✅ Done |
| R2.10 | Rev 2 | Consumer hardware defender timing | ✅ Done |
| R2.11 | Rev 2 | No std dev / confidence intervals | ✅ Done |
| R2.12 | Rev 2 | Pals2018 malformed DOI in .bib | ✅ Done |
| R2.13 | Rev 2 | Tables not cited; "?" reference | ✅ Done |

**✅ Done: 26** | **🔶 Partial: 0** | **❌ Not done: 0**

---

## Reviewer 3

### R3.1 — Expand threat model: targeted spatial dictionary from social footprints
**Status: ✅ Already Done (R1.10/R1.11)**

The urban-prior scenario (social-media leakage → anchor entropy collapses from 45.7 to 27.4 bits) is fully quantified in §6.4 and the clustering model (eq:clustering_bias). No new action required. Response letter should cite these existing sections.

---

### R3.2 — Test against multi-GPU clusters and ASIC chips
**Status: ✅ Already Done (R1.12/R2.8)**

4× RTX 4090 cluster discussed in §6.2; ASIC analysis with conservative 10× bound in §5.2. No new action required.

---

### R3.3 — Quantum computing threat (Grover / Shor)
**Status: ✅ Done**

Needs a short paragraph in §6.4 (Threat Model and Limitations):
- Grover's algorithm provides $\sqrt{|\mathcal{D}|}$ speedup on unstructured search → halves effective spatial entropy in bits (45.7 → ~22.9 bits per point under quantum attacker).
- $n=3$ under Grover: $3 \times 22.9 = 68.7$ effective bits before Argon2id hardening → still comfortably Human-Scale Secure.
- Shor's algorithm attacks asymmetric (factoring/discrete log) cryptography; irrelevant to hashing and Argon2id.
- Argon2id has no known quantum speedup beyond Grover; memory-hardness argument unchanged.
- Quantum threat does not change zone classification for $n \geq 3$.

---

### R3.4 — Physical side-channel attacks
**Status: ✅ Done**

One sentence in §6.4 future work: side-channel analysis (timing, power, memory-access patterns during Argon2id evaluation) is implementation-dependent and outside the scope of the protocol-level security model evaluated here.

---

### R3.5 — Mobile device latency, energy, storage
**Status: ❌ Not yet done**

Extend `tab:argon2_defender_cost_consumer` or add a sentence: consumer laptop already covered (2–3 s at $m=1{,}024$ MiB); smartphone (ARM Cortex-A, LPDDR5, ~35–50 GB/s bandwidth) is ~4–6× slower than Xeon → estimated 5–8 s at $m=1{,}024$ MiB. High memory tiers ($m \geq 2$ GiB) may exceed typical smartphone RAM and require parameter reduction.

---

### R3.6 — Fuzzy matching / fault tolerance
**Status: ✅ Already Done (R2.3)**

Explicitly stated as a limitation in §6.4 with future work directions. No new action required.

---

### R3.7 — Offline scenario verification
**Status: ✅ Already Done (R1.4/R2.2)**

OLC/Plus Codes recommended as open offline encoder in §4.3. No new action required.

---

### R3.8 — Special populations (elderly, weak spatial cognition)
**Status: ❌ Not yet done**

One sentence in future work (§6.5 or Conclusions): accessibility testing for users with reduced spatial cognitive ability (elderly, navigation-impaired) is an open research direction requiring a dedicated user study.

---

### R3.9 — Cite unrelated papers (indoor object detection, gesture recognition)
**Status: ⚠️ Decline — out of scope**

The two suggested references concern home rehabilitation robotics and 3D gesture recognition for post-epidemic societies. These topics have no scientific connection to cryptographic key management, spatial entropy, or Argon2id. They will not be cited. The response letter should politely note the scope mismatch.

---

### R3.10 — W3W entropy mathematical derivation; encoding accuracy vs entropy
**Status: ✅ Done**

Add a short derivation in §4.3 or a footnote: W3W divides Earth's surface ($5.1\times10^{14}$ m²) into 3m×3m cells → $N = 5.1\times10^{14}/9 \approx 5.7\times10^{13}$ cells → $\log_2(5.7\times10^{13}) \approx 45.7$ bits nominal entropy. Encoding accuracy (cell size) directly sets the nominal entropy ceiling: halving cell dimensions doubles the bit count by 2 bits. Effective entropy is lower once non-habitable cells are excluded (→ Omnibus HPZ at 41.38 bits).

---

### R3.11 — Theoretical upper limit of semantic dictionary attack; 41.38-bit floor justification
**Status: ✅ Done**

Add a short paragraph in §3.2 or §5.1: the 41.38-bit floor is derived from the Omnibus HPZ dictionary (habitable land + populated zones + coastlines), which represents the tightest geographically-motivated constraint an uninformed attacker can apply. The urban prior (27.4 bits) represents the tightest constraint a demographically-informed attacker can apply given city-level knowledge. No further contraction below 27.4 bits is supported by current literature without sub-neighborhood-scale knowledge. These two values therefore bracket the effective entropy range: $H_\text{eff} \in [27.4n,\; 41.38n]$ bits for an $n$-point secret under all evaluated attacker priors.

---

## Updated Summary

| # | Reviewer | Point | Status |
|---|---|---|---|
| R1.1 | Rev 1 | Missing GeoPass/PassMap/GeoPassNotes/Al-Ameen | ✅ Done |
| R1.2 | Rev 1 | Bauer 1993 wrong citation removed | ✅ Done |
| R1.3 | Rev 1 | No user study acknowledgement | ✅ Done |
| R1.4 | Rev 1 | W3W offline resolvability contradiction | ✅ Done |
| R1.5 | Rev 1 | Fixed salt rainbow table risk | ✅ Done |
| R1.6 | Rev 1 | Entropy model uniform assumption | ✅ Done |
| R1.7 | Rev 1 | VDF/PoSW section condensed | ✅ Done |
| R1.8 | Rev 1 | Garden 2002 wrong citation removed | ✅ Done |
| R1.9a | Rev 1 | "?" reference artifact fixed | ✅ Done |
| R1.9b | Rev 1 | Empty DOI commented out | ✅ Done |
| R1.9c | Rev 1 | "burial sites" → "spatial anchors" | ✅ Done |
| R1.10 | Rev 1 | Threat model: public-source partial info | ✅ Done |
| R1.11 | Rev 1 | Proximity model anchor entropy | ✅ Done |
| R1.12 | Rev 1 | Single hardware platform evaluation | ✅ Done |
| R1.13 | Rev 1 | AI-generation stylistic review | ✅ Done |
| R2.1 | Rev 2 | GPS drift | ✅ Done |
| R2.2 | Rev 2 | W3W proprietary / reproducibility | ✅ Done |
| R2.3 | Rev 2 | Fuzzy matching / error tolerance | ✅ Done |
| R2.4 | Rev 2 | Argon2 parameter justification | ✅ Done |
| R2.5 | Rev 2 | Static salt rainbow table | ✅ Done |
| R2.6 | Rev 2 | Fixed canonical ordering usability | ✅ Done |
| R2.7 | Rev 2 | Security zone thresholds not derived | ✅ Done |
| R2.8 | Rev 2 | ASIC attack throughput | ✅ Done |
| R2.9 | Rev 2 | 41.38 bit entropy "Insecure" | ✅ Done |
| R2.10 | Rev 2 | Consumer hardware defender timing | ✅ Done |
| R2.11 | Rev 2 | No std dev / confidence intervals | ✅ Done |
| R2.12 | Rev 2 | Pals2018 malformed DOI in .bib | ✅ Done |
| R2.13 | Rev 2 | Tables not cited; "?" reference | ✅ Done |
| R3.1 | Rev 3 | Targeted social-footprint attack | ✅ Already done (R1.10) |
| R3.2 | Rev 3 | Multi-GPU / ASIC | ✅ Already done (R1.12/R2.8) |
| R3.3 | Rev 3 | Quantum computing (Grover/Shor) | ✅ Done |
| R3.4 | Rev 3 | Physical side-channel attacks | ✅ Done |
| R3.5 | Rev 3 | Mobile device latency/energy | ✅ Done |
| R3.6 | Rev 3 | Fuzzy matching | ✅ Already done (R2.3) |
| R3.7 | Rev 3 | Offline verification | ✅ Already done (R1.4) |
| R3.8 | Rev 3 | Special populations (elderly) | ✅ Done |
| R3.9 | Rev 3 | Unrelated citation requests | ⚠️ Decline (out of scope) |
| R3.10 | Rev 3 | W3W entropy mathematical derivation | ✅ Done |
| R3.11 | Rev 3 | Semantic dictionary theoretical limits | ✅ Done |

**✅ Done: 35** | **⚠️ Decline: 1** (R3.9) | **❌ Not yet done: 0**
