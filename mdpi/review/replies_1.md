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
**Status: 🔶 Partial**

Section 2.3 was updated to explicitly acknowledge the proprietary nature of What3Words and to name Open Location Code (OLC) as a fully offline-resolvable open-source alternative.

**TODO:** Section 4.3 still declares offline resolvability as a mandatory property while using W3W as the reference encoder. A clarification must be added there — either explaining how offline resolution is satisfied in practice (e.g., a local grid file) or redirecting to OLC as the recommended baseline. ❌

---

### R1.5 — Fixed public salt: rainbow table vulnerability not discussed
**Status: ❌ Not yet done**

The fixed public salt and the security implications of deviating from standard per-user Argon2 salt practice (pre-computation / rainbow table risk) have not yet been discussed in the paper. A formal justification is needed in Section 4.4.3.

**TODO:** Add a discussion explaining why the fixed salt does not introduce pre-computation risk given the entropy of the spatial input, or acknowledge it as a design trade-off with explicit security bounds.

---

### R1.6 — Entropy model does not capture user selection bias (uniform assumption)
**Status: 🔶 Partial**

A new paragraph in Section 2.2 qualitatively discusses user selection bias (home, work, famous landmarks) based on GeoPass (Thorpe 2013) and PassMap (Sun 2012) data.

**TODO:** The formal model (Equation 7, Section 3.2) still treats spatial dictionaries as uniform. The reviewer asks for the effective entropy formula to be explicitly adjusted to account for demographic/behavioral selection bias. ❌

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

**(b) Metadata placeholders (Affiliation 1, DOI, "Current address"):** ❌ Not yet done — "Affiliation 1", the empty DOI `https://doi.org/`, and "Current address: Affiliation" remain in the preamble.  
**TODO:** Update with actual journal metadata before resubmission.

**(c) "burial sites" terminology:** ✅ Done — replaced with "spatial anchors"; Section 2.4 title changed from "Burying Secrets" to "Hardening Secrets".

---

### R1.10 — Threat model omits partial public-source information (social networks, location data)
**Status: 🔶 Partial**

Two qualitative sentences were added to Section 6.4 acknowledging that knowledge of a user's habits, routines, or shared location data could reduce the effective search space.

**TODO:** The reviewer requested quantification of the entropy reduction for this attack vector. A worked example or numerical estimate is still needed. ❌

---

### R1.11 — Proximity clustering model: anchor entropy not reduced for semantic bias (Equation 10)
**Status: ✅ Done**

Equation `eq:clustering_bias` now has an explicit `\add{}` paragraph explaining that $H_{\text{anchor}}$ is bounded above by $H_{\text{eff}}(\mathcal{D})$ for whatever dictionary the attacker uses — not silently equated to the global nominal entropy. The paragraph shows that a targeted attacker knowing the user's city reduces $H_{\text{anchor}}$ from 45.7 bits to $\approx$27.4 bits, and that this loss propagates to all $n$-point estimates regardless of clustering radius. Cited to Sun2012, Thorpe2013, AlAmeen2014.

---

### R1.12 — Empirical evaluation on single hardware platform
**Status: ❌ Not yet done**

Benchmarks remain on the Intel Xeon Gold 6338 (defender) and NVIDIA RTX A6000 (attacker). No consumer hardware (e.g., laptop with integrated GPU, 8 GB RAM) or multi-GPU cluster was evaluated.

**TODO:** Either run benchmarks on additional hardware, or add a dedicated paragraph to the Discussion that extrapolates the current results to consumer and high-end attacker scenarios using standard performance scaling assumptions.

---

### R1.13 — Stylistic review for AI-generation indicators
**Status: ❌ Not yet done**

No prose rewrites addressing stylistic uniformity or AI-generation indicators were made in the current revision.

**TODO:** Review Sections 1, 2, and 6 in particular for repetitive generic formulations and reformulate in the authors' authentic academic voice.

---

## Reviewer 2

### R2.1 — GPS drift and coordinate imprecision in key generation
**Status: ❌ Not yet done**

GPS drift and how coordinate imprecision affects key reproducibility are not discussed anywhere in the paper.

**TODO:** Add a paragraph (Section 4.3 or Section 6.4) explaining how GPS-induced coordinate noise interacts with the 3 m W3W cell resolution, and what the expected key failure rate is under typical GPS accuracy (3–5 m CEP for consumer devices).

---

### R2.2 — W3W is proprietary; reduces scientific reproducibility
**Status: 🔶 Partial**

Same change as R1.4 above — Section 2.3 now names OLC as an open alternative.

**TODO:** Section 4.3 still uses W3W as the reference encoder without resolving the reproducibility concern. ❌

---

### R2.3 — No fuzzy matching or error-tolerant mechanism
**Status: 🔶 Partial**

Fuzzy matching and error-correction are mentioned as future work in Section 6.4 and the Conclusions.

**TODO:** The reviewer asked whether the *current methodology* addresses this — it does not. The paper should at minimum quantify the probability of key failure due to a one-cell location error and discuss what tolerance mechanisms would be needed.

---

### R2.4 — No scientific justification for Argon2 parameters (t, m, p)
**Status: ❌ Not yet done**

The cross-reference `\ref{sec:argon2_parameters}` cited in Table `tab:exp_setup` points to a label that does not exist in the document. No parameter derivation or justification section exists.

**TODO:** Either create `\label{sec:argon2_parameters}` with a paragraph deriving the chosen $(t, m, p)$ values from usability latency budgets and threat model requirements, or justify the values inline in Section 4.4.

---

### R2.5 — Fixed static salt enables rainbow table attacks
**Status: ❌ Not yet done**

Same as R1.5. No discussion or justification for the fixed salt deviation from Argon2 best practice has been added.

---

### R2.6 — Fixed canonical point ordering is a usability problem
**Status: ❌ Not yet done**

Section 4.4 still describes concatenation in a fixed canonical order without discussing the usability risk: a user who recalls the same locations in a different sequence will derive an entirely different key.

**TODO:** Acknowledge this limitation explicitly and discuss potential mitigations — e.g., sorting W3W word triples lexicographically to produce an order-invariant input, or a user onboarding step that records the canonical order.

---

### R2.7 — Security zone thresholds not formally derived
**Status: 🔶 Partial**

The zones are now cited to Bonneau et al. (2012) and described as interpretive reference points rather than strict guarantees.

**TODO:** Formally state why $10^{10}$ seconds (≈ 317 years) demarcates Insecure from Human-Scale, and why $10^{32}$ seconds demarcates Human-Scale from Super Secure. Cite the derivation or computational model used.

---

### R2.8 — ASIC attack throughput not analysed
**Status: ❌ Not yet done**

ASIC resistance is cited as a design motivation for Argon2 but no throughput estimate or comparison with GPU results is given.

**TODO:** Add a discussion in Section 5 or Section 6 citing known ASIC throughput bounds for memory-hard functions (e.g., from Biryukov & Khovratovich 2016, or the Argon2 specification) and explain quantitatively why current ASIC designs cannot exceed the GPU benchmark by more than a small constant factor due to the memory bandwidth bottleneck.

---

### R2.9 — Omnibus HPZ entropy (41.38 bits) appears to fall in Insecure zone
**Status: 🔶 Partial**

The paper already addresses this implicitly: Table 4 shows that 41.38 bits of spatial entropy, when combined with Argon2id at $m = 4$ GiB, yields an attacker work factor of $> 10^{16}$ seconds on the A6000, which places it firmly in the Human-Scale Secure zone. No new text was needed beyond what is already in Section 5.

---

### R2.10 — No legitimate-user computation time on consumer hardware (e.g., laptop 8 GB RAM)
**Status: ❌ Not yet done**

All defender-side timing data is from the Intel Xeon Gold 6338 workstation. No consumer hardware results are given.

**TODO:** Add a defender latency table or paragraph reporting estimated completion times on a typical laptop (e.g., estimated from the Xeon results using memory bandwidth scaling), or run actual benchmarks on a laptop.

---

### R2.11 — No standard deviation or confidence intervals in benchmarks
**Status: 🔶 Partial**

Tables report Median, P95, and P99 percentiles, which partially capture dispersion. Standard deviation and formal 95% confidence intervals are not reported.

**TODO:** Add a standard deviation column to the benchmark tables, or state explicitly that variance is negligible and provide a single supporting measurement.

---

### R2.12 — Reference 5 has `PAGE:STRING:ARTICLE/CHAPTER` DOI error
**Status: ❌ Not yet done**

The `Pals2018` entry in `references.bib` still contains the malformed DOI field:
```
doi = {10.1080/09500693.2017.1407885;PAGE:STRING:ARTICLE/CHAPTER},
```
**TODO:** Fix the DOI field to `doi = {10.1080/09500693.2017.1407885}`.

---

### R2.13 — Tables not cited in text; "?" reference error
**Status: 🔶 Partial**

The "?" reference artifact is resolved (`Bonneau2012a` now compiles correctly).

**TODO:** Table `tab:attacker_cost` (GPU BIP-39 PBKDF2 attacker benchmarks) has no `\ref{}` in the running text — add a citation to it. Verify all other tables have in-text references.

---

## Summary

| # | Reviewer | Point | Status |
|---|---|---|---|
| R1.1 | Rev 1 | Missing GeoPass/PassMap/GeoPassNotes/Al-Ameen | ✅ Done |
| R1.2 | Rev 1 | Bauer 1993 wrong citation removed | ✅ Done |
| R1.3 | Rev 1 | No user study acknowledgement | ✅ Done |
| R1.4 | Rev 1 | W3W offline resolvability contradiction | 🔶 Partial |
| R1.5 | Rev 1 | Fixed salt rainbow table risk | ❌ Not done |
| R1.6 | Rev 1 | Entropy model uniform assumption | 🔶 Partial |
| R1.7 | Rev 1 | VDF/PoSW section condensed | ✅ Done |
| R1.8 | Rev 1 | Garden 2002 wrong citation removed | ✅ Done |
| R1.9a | Rev 1 | "?" reference artifact fixed | ✅ Done |
| R1.9b | Rev 1 | Metadata placeholders still present | ❌ Not done |
| R1.9c | Rev 1 | "burial sites" → "spatial anchors" | ✅ Done |
| R1.10 | Rev 1 | Threat model: public-source partial info | 🔶 Partial |
| R1.11 | Rev 1 | Proximity model anchor entropy | ✅ Done |
| R1.12 | Rev 1 | Single hardware platform evaluation | ❌ Not done |
| R1.13 | Rev 1 | AI-generation stylistic review | ❌ Not done |
| R2.1 | Rev 2 | GPS drift | ❌ Not done |
| R2.2 | Rev 2 | W3W proprietary / reproducibility | 🔶 Partial |
| R2.3 | Rev 2 | Fuzzy matching / error tolerance | 🔶 Partial |
| R2.4 | Rev 2 | Argon2 parameter justification | ❌ Not done |
| R2.5 | Rev 2 | Static salt rainbow table | ❌ Not done |
| R2.6 | Rev 2 | Fixed canonical ordering usability | ❌ Not done |
| R2.7 | Rev 2 | Security zone thresholds not derived | 🔶 Partial |
| R2.8 | Rev 2 | ASIC attack throughput | ❌ Not done |
| R2.9 | Rev 2 | 41.38 bit entropy "Insecure" | 🔶 Partial |
| R2.10 | Rev 2 | Consumer hardware defender timing | ❌ Not done |
| R2.11 | Rev 2 | No std dev / confidence intervals | 🔶 Partial |
| R2.12 | Rev 2 | Pals2018 malformed DOI in .bib | ❌ Not done |
| R2.13 | Rev 2 | Tables not cited; "?" reference | 🔶 Partial |

**✅ Done: 8** | **🔶 Partial: 9** | **❌ Not done: 11**
