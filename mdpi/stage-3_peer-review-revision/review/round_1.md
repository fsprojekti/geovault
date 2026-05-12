
# Reviwer 1

The paper is part of the research area of ​​user-centered cryptography, specifically in the subfield of cryptographic key management based on human-memorable secrets. The paper proposes the integration of human spatial memory as a source of entropy for cryptographic key derivation, a field that lies at the intersection of computer security, cognitive psychology, and geospatial coding.

The authors investigate a framework called GeoVault, which derives cryptographic keys from user-selected geographic locations, deterministically encoded, and reinforced by memory-hard key derivation functions (memory-hard KDFs), in particular Argon2id. The main stated contribution consists of a formal entropy model for spatially anchored secrets, an empirical analysis of the defender-attacker asymmetry, and an evaluation of attacker-adjusted work factors for different spatial configurations.

In order to strengthen the scientific rigor, the completeness of the analysis and the clarity of the exposition, the following aspects that require attention from the authors are reported:

1. The Related Work section (Section 2) completely omits the existing literature on authentication schemes based on geographic locations on digital maps. The fundamental works in this subfield, such as GeoPass (Thorpe, MacRae and Salehi-Abari, 2013, SOUPS), PassMap (Sun et al., 2012), GeoPassNotes (MacRae et al., 2016) and the subsequent comprehensive evaluation studies (Al-Ameen and Wright, 2014), are not mentioned. These works directly address the issue of using geographic locations as authentication secrets and contain security and usability analyses relevant to GeoVault. The absence of these references raises questions about the knowledge of the state of the art in the addressed subfield. It is recommended to complete the Related Work section with a comparative analysis of GeoVault compared to these previous schemes, explicitly highlighting the proposed differences and advantages.

**Author's Response:** GeoPass (Thorpe et al., 2013), PassMap (Sun et al., 2012), GeoPassNotes (MacRae et al., 2016), and Al-Ameen & Wright (2014) have been added to Section 2.2 with an explicit comparative paragraph. Their selection-distribution findings (users concentrate choices around home, workplace, and culturally salient sites) motivate the selection-fraction bias parameter $f_s$ introduced in the formal entropy model in Section 3.2.

2. Reference [11] (Bauer and Johnson-Laird, 1993, "How Diagrams Can Improve Reasoning") is cited in Section 2.2 (line 181) in the context of proposed spatial interfaces in password systems and digital authentication. Checking this reference indicates that the original work addresses logical reasoning assisted by diagrams, not authentication based on spatial locations or graphical password systems. This constitutes an erroneous attribution. It is recommended to replace this reference with works that actually address authentication based on geographical locations or, if one wants to support the argument regarding spatial memory, to reformulate the citation context.

**Author's Response:** The paragraph containing the Bauer & Johnson-Laird (1993) citation was removed entirely. The claim it was intended to support is now substantiated by the newly added geographic authentication references (GeoPass, PassMap, GeoPassNotes).

3. The article does not contain any studies with real users. All claims regarding the usability of spatial memory as a cryptographic input (long-term retention, recall accuracy, cognitive load) remain at the level of hypothesis supported by references to the cognitive psychology literature, without proper empirical validation. The central claim of the article (that spatially anchored secrets offer a practical advantage over linguistic passwords) cannot be verified in the absence of usability data. It is recommended to include a pilot study with users or, in its absence, to explicitly and thoroughly acknowledge this limitation in the Discussion section.

**Author's Response:** A dedicated paragraph has been added to Section 6.4 explicitly acknowledging the absence of a user study. It lists all unvalidated usability claims (long-term retention, recall accuracy, cognitive load, latency tolerability) and specifies three minimum measurements a future controlled study must include. A sentence on accessibility for elderly and navigation-impaired users was also added.

4. The reference implementation uses What3Words as the geospatial encoding scheme (Section 4.3). The article states that the encoding scheme must be offline resolvable ("offline resolvability", line 472), but What3Words is a proprietary system that requires access to its commercial API for code resolution. This is a contradiction between the stated requirement and the chosen implementation. It is recommended to clarify how the offline resolvability property is satisfied in practice, or to select an open-source encoder (e.g., Open Location Code) as the reference implementation.

**Author's Response:** Section 4.3 now contains a paragraph acknowledging the W3W API dependency and recommending Open Location Code (OLC/Plus Codes, precision level 11, ~9 m² cell footprint) as the recommended open offline alternative. All security results and the entropy model are explicitly stated to be encoder-agnostic.

5. The GeoVault protocol uses a fixed and public hop (Section 4.4.3, lines 515-516). Although the authors justify this choice by Kerckhoffs' principle, using a fixed hop eliminates the protection provided by the hop against rainbow table attacks. In standard Argon2 practice, the hop must be unique per user. An explicit discussion of the security implications of fixed hopping, including vulnerability to table-based attacks, and a formal justification for this design decision are recommended.

**Author's Response:** Section 4.4 now contains a fixed-salt justification paragraph with a two-part argument: (1) precomputing Argon2id at any evaluated GiB-scale memory tier is physically unrealisable — each table entry would require GiBs of GPU VRAM; (2) the spatial KDF input has ≥45.7n bits of entropy, making exhaustive precomputation infeasible. BIP-39's analogous fixed public salt ("mnemonic") is cited as established precedent.

6. The entropy model in Section 3.2 assumes uniform selection within spatial dictionaries (equation 7). This assumption is not empirically supported. Existing research on GeoPass (Al-Ameen and Wright, 2014) has shown that users have a strong tendency to select personally meaningful locations (home, work, vacation locations), which introduces an additional bias not captured by the spatial dictionaries proposed in Table 3. The formal effective entropy model should explicitly include this type of user-centered bias, not just global geographic restrictions.

**Author's Response:** Section 3.2 now includes a selection fraction $f_s \in (0,1]$ representing the proportion of dictionary cells attracting non-negligible probability mass under a behaviourally informed prior. The corrected entropy formula $H_{\text{eff,biased}} = H_{\text{eff}}(\mathcal{D}) + \log_2 f_s$ is added as a new equation, with Sun et al. (2012), Thorpe et al. (2013), and Al-Ameen & Wright (2014) as supporting empirical citations.

7. Section 2.4 presents four cryptographic mechanisms (VDFs, time-lock puzzles, PoSW, memory-hard KDFs), but only the latter is actually used in the GeoVault protocol. The detailed presentation of VDFs, time-lock puzzles and PoSW takes up about two pages (Section 2.4), without these being integrated into the design or evaluation of the proposed protocol. It is recommended to either substantially reduce this section to a brief mention of the alternatives, or to integrate them into the comparative analysis or in proposals for future work.

**Author's Response:** The detailed exposition of VDFs, time-lock puzzles, and Proof-of-Sequential-Work has been condensed to a single paragraph that briefly names these alternatives and explains why memory-hard KDFs are selected for GeoVault instead.

8. Reference [29] (Garden, Cornoldi and Logie, 2002, "Visuo-spatial working memory in navigation") is cited in Section 2.2 (line 184) in the context of retaining spatially based authentication secrets for longer durations and with fewer errors compared to textual passwords. Checking the reference indicates that the original paper addresses visuospatial working memory in the context of navigation, not the retention of authentication secrets. It is recommended that this reference be checked and replaced with a source that directly supports the claim made.

**Author's Response:** The paragraph containing the Garden et al. (2002) citation was removed entirely; the unsupported claim it backed was dropped from Section 2.2.

9. The article has formatting and editing errors that affect the quality of the presentation. In particular: (a) reference [53] on page 15 (line 608) contains a formatting artifact: "[53? ]" with a question mark and incorrect space, indicating an incomplete reference or an error in the bibliographic management system; (b) the article metadata contains incomplete placeholder information ("Journal Not Specified", "Affiliation 1", "Current address: Affiliation", DOI placeholder); (c) in Section 2.3, line 234, the term "burial sites" appears, which is inconsistent with the technical terminology used in the rest of the article. It is recommended to correct these errors before resubmitting.

**Author's Response:** (a) The `Bonneau2012a` entry has been added to the bibliography; the `[?]` compilation artifact no longer appears. (b) The "Affiliation 1;" prefix has been removed from the address field and the "Current address: Affiliation." placeholder commented out; the DOI field awaits journal assignment. (c) "burial sites" has been replaced with "spatial anchors" throughout and the subsection title changed from "Burying Secrets" to "Hardening Secrets".

10. The threat model (Section 6.4) does not address the scenario where the attacker has partial information about the user obtained from public sources (social networks, location data from applications, travel history). Given that personally significant locations are information frequently shared online, this attack vector could significantly reduce the effective entropy below the levels estimated in Table 3. It is recommended to extend the threat model to explicitly include this scenario and quantify its impact on the effective entropy.

**Author's Response:** Section 6.4 now contains a fully worked quantitative example: an attacker who recovers the user's home city from social media reduces the anchor's effective entropy from 45.7 bits to ~27.4 bits. For $n=3$ with all points collapsing to the urban prior, total entropy = 82.2 bits, which at $m=1{,}024$ MiB remains in the Human-Scale Secure zone. This establishes 27.4 bits/point as the tight lower bound under full demographic leakage.

11. The proximity clustering model (Section 3.2.3, equation 10) assumes that the first point (anchor) is freely selected, and subsequent points are constrained within a radius r. This model does not capture the realistic scenario in which all points are selected from the same semantic context (e.g., locations from a single vacation or from the same city), without the first point having a global uniform distribution. The anchor in equation 10 should reflect the entropy collapse caused by semantic biases, not the global nominal entropy. A reformulation of the model that also allows the anchor to be subject to entropy collapse is recommended.

**Author's Response:** Section 3.2 now contains an explicit paragraph stating that $H_{\text{anchor}} \leq H_{\text{eff}}(\mathcal{D}_{\text{demographic}})$ for whatever dictionary the attacker applies. A targeted attacker knowing the user's city sets $H_{\text{anchor}} \approx 27.4$ bits; this collapse propagates to all $n$-point entropy estimates independently of clustering radius.

12. The empirical evaluation is limited to a single GPU (NVIDIA RTX A6000) and a single CPU (Intel Xeon Gold 6338). There is no evaluation on typical consumer hardware (e.g., a laptop with integrated GPU) that would be more representative of the defender scenario, nor on multi-GPU or cluster configurations that would be more representative of well-equipped attackers. It is recommended to extend the benchmarks or, at least, an explicit discussion of how the results extrapolate to other hardware configurations.

**Author's Response:** A consumer hardware table (tab:argon2_defender_cost_consumer) has been added projecting Argon2id defender latency on a consumer laptop (~2× bandwidth scaling, ~2.6 s at $m=1{,}024$ MiB) and a smartphone (~4× scaling, ~4.9 s, LPDDR5x spec cited). Section 6.2 discusses a 4× RTX 4090 attacker cluster, which reduces the work factor by ≤2 bits and does not change security zone for $n \geq 2$.

13. Rework the parts that have a high degree of probability, according to specialized detectors, to have been produced with generative AI methods. In particular, certain sections of the article show a pronounced stylistic uniformity, repetitive generic formulations and a rhetorical structure that shows indicators compatible with the production assisted by language models. It is recommended to review and reformulate the affected sections to ensure the authenticity of the authors' academic voic

**Author's Response:** Sixteen targeted rewrites using `\remove{}\add{}` track changes were applied across the Introduction, Discussion, and Conclusions. Affected passages include the Introduction opener and contributions list, the Discussion §6.1 central finding, the §6.5 implications paragraph, and all six Conclusions paragraphs, replacing genericformulations with direct quantitative or mechanistic claims.

# Reviewer 2

This review examines the GeoVault protocol, which aims to leverage human spatial memory for cryptographic key management. The authors propose a new approach based on a combination of geographic coordinates and the Argon2id algorithm, which is more user-friendly and secure than traditional mnemonics (BIP-39). I would like to ask for a reasoned response to the following suggestions and shortcomings in the article:

How is GPS drift eliminated in key generation?

**Author's Response:** Section 4.1 now states that GeoVault uses a map-based tap/click interface — not device GPS. The geospatial encoding scheme snaps any selected coordinate to the nearest discrete 3 m × 3 m cell at selection time, so sub-cell positional imprecision is absorbed by design. GPS-induced drift is therefore not a concern in the GeoVault threat model.

2. "What3Words" (W3W) is a proprietary system. Doesn't relying on a closed-source commercial system in scientific work reduce the reliability of the methodology? Justify your opinion.

**Author's Response:** Section 4.3 now contains a dedicated paragraph acknowledging the W3W API dependency, noting the tension with the offline-resolvability requirement, and recommending Open Location Code (OLC/Plus Codes, precision level 11) as the fully open offline encoder. The security model and all quantitative results are stated to be encoder-agnostic.

3. If the user makes a slight mistake in choosing a 3-meter square on the map, a completely different key is generated. The methodology does not provide "fuzzy matching" or error-tolerant algorithms.

**Author's Response:** Section 6.4 now explicitly states that a single-cell recall error (selecting an adjacent 3 m × 3 m tile) causes 100% key derivation failure regardless of $n$ or $m$, identifying this as a fundamental usability limitation. Future work directions — a nearest-cell retry window and a spatially defined cell-equivalence class — are named with the constraint that they must not expand the attacker's effective dictionary beyond the security margins of Section 5.3.

4. There is no scientific justification for choosing the exact parameters t, m, p (it is simply stated for "commodity CPU").

**Author's Response:** Section 4.4 now contains a parameter-selection rationale paragraph deriving $(t=1, m=1{,}024\,\text{MiB}, p=1)$ from two constraints: (1) usability — $T_{\text{CPU}} \approx 1.26$ s is within the sub-2-second interactive budget (Nielsen, 1994); (2) security — $m=1{,}024$ MiB saturates GPU parallelism, capping attacker throughput at 53.7 H/s. Setting $t=1$ follows the Argon2 specification's recommendation; $p=1$ is appropriate for single-thread commodity hardware.

5. The article says that the salt is "fixed and public". Has the methodology taken into account that the use of static salts in cryptography opens the way to "rainbow table" attacks?

**Author's Response:** Addressed jointly with R1.5. Section 4.4 now contains a fixed-salt justification paragraph demonstrating why rainbow tables are infeasible: each Argon2id table entry requires GiBs of GPU VRAM, and the spatial KDF input has ≥45.7n bits of entropy. BIP-39's fixed public salt ("mnemonic") is cited as established precedent.

6. It says that the points are combined in a "fixed canonical order". If the user remembers 3 places and swaps their sequence, the key will not work. This is a serious drawback for usability.

**Author's Response:** Section 4.4 now contains a canonical-ordering usability paragraph acknowledging the recall requirement, explaining its role in preserving the full $n!$ permutation space as part of the secret, and identifying order-invariant lexicographic sorting as a future extension at the cost of $\log_2 n!$ bits of permutation entropy.

7. The criteria for determining the "Insecure", "Human-Scale Secure" and "Super Secure" zones in Figure 2 are not scientifically explained.

**Author's Response:** Section 4.5 now contains a formal threshold derivation paragraph with Equation (eq:w128_threshold). The $10^{10}$ s lower boundary represents the upper bound on a sustained nation-state brute-force campaign; the $10^{32}$ s upper boundary is anchored to the 128-bit security level via $2^{128}/R_{\text{GPU,hash}} \approx 3.3 \times 10^{31}$ s, matching BIP-39's entropy target. Both thresholds cite Bonneau et al. (2012).

8. Attacker throughput was measured using Hashcat, but how do specially designed ASIC attacks affect the results? Justify your opinion, with facts.

**Author's Response:** Section 5.2 now contains an ASIC resistance paragraph. Argon2id's TMTO-resistance proof establishes that any ASIC using less than $m$ memory incurs an exponential time penalty. The Argon2 designers bound the practical ASIC advantage at ≤2–4×; applying a conservative 10× shifts work factors by ≈3.3 bits, which does not change security zone for any evaluated $m=1{,}024$ MiB configuration.

9. The "Omnibus HPZ" dictionary entropy is shown as 41.38 bits. Isn't this too low (Insecure) for modern offline attacks?

**Author's Response:** Section 5.1 now clarifies that 41.38 bits is spatial entropy alone — security zone membership is based on the attacker-adjusted work factor $\mathcal{W}$, which incorporates Argon2id hardening. At $m \geq 1{,}024$ MiB, an $n=1$ Omnibus-prior secret reaches the Human-Scale Secure zone; at $m=4{,}096$ MiB, $\mathcal{W} > 10^{16}$ s — more than six orders of magnitude above the Insecure boundary.

10. Argon2id's 16-32 GiB memory requirement stops the attacker, but the results do not reveal how long it would take a legitimate user's device (e.g. a laptop with 8GB RAM) to calculate this key.

**Author's Response:** Addressed jointly with R1.12. The consumer hardware table (tab:argon2_defender_cost_consumer) reports projected latency for server, laptop, and smartphone across all four memory tiers. At the reference $m=1{,}024$ MiB tier, estimated laptop latency is ~2.6 s and smartphone latency is ~4.9 s — both within a tolerable range for infrequent cold-storage key derivation.

11. No standard deviation or confidence intervals are provided for the benchmarking results.

**Author's Response:** Standard deviations from $n=50$ repeated measurements have been added to tab:argon2_defender_cost (CV = 3.0–7.0%) and tab:kchain_empirical ($\sigma$ range: 0.006–1.213 s at $k=1$–$64$). A footnote on GPU benchmark determinism (CV < 0.1%) was added to tab:argon2_spectrum.

12. Reference 5 has an error like `PAGE:STRING:ARTICLE/CHAPTER`.

**Author's Response:** The `Pals2018` entry in `references.bib` has been corrected; the DOI field now reads `10.1080/09500693.2017.1407885` with no malformed suffix.

13. In 7 tables are not cited in the text. There is an error in citing the article on page 15, line 609. The reference number is replaced by "?"

**Author's Response:** The `[?]` artifact is resolved — `Bonneau2012a` compiles correctly and the reference appears as expected. `tab:attacker_cost` is now explicitly cited in the running text at the sentence reporting $R_{2048}$ in Section 5.2.

# Reviewer 3

The paper presents a well-structured study on using human spatial memory as a cryptographic key management asset. The combination of spatial mnemonics with memory-hard key derivation is interesting and the security analysis is generally thorough. The following points require attention before the paper can be accepted:

1. The threat model in Section 6.4 should be expanded to explicitly address the scenario where an attacker reconstructs a targeted spatial dictionary from the user's social-network footprint (tagged photographs, check-ins, location history). This attack vector can reduce effective entropy significantly below the Omnibus HPZ level.

**Author's Response:** Already addressed via R1.10 and R1.11. Section 6.4 contains a quantitative leakage example (home-city recovery collapses anchor entropy from 45.7 to 27.4 bits; $n=3$ under full urban leakage yields 82.2 bits spatial entropy, remaining Human-Scale Secure at $m=1{,}024$ MiB). Section 3.2 reformulates $H_{\text{anchor}}$ as bounded by the attacker's demographic prior.

2. The hardware evaluation is limited to a single GPU. The paper should discuss or evaluate how multi-GPU clusters and ASIC adversaries affect the attacker-adjusted work factors.

**Author's Response:** Already addressed via R1.12 and R2.8. Tab:argon2_defender_cost_consumer covers consumer and mobile hardware; Section 6.2 extrapolates to a 4× RTX 4090 attacker cluster (≤2-bit work-factor reduction, no zone change for $n \geq 2$); Section 5.2 analyses ASIC adversaries with a conservative 10× bound.

3. The paper does not address the quantum computing threat. Grover's algorithm provides a quadratic speedup on unstructured search, effectively halving the bit security of the spatial search space. The discussion should include at least a short analysis of how GeoVault's security margins hold (or not) under a Grover attacker, and clarify that Shor's algorithm is irrelevant to symmetric hash-based constructions.

**Author's Response:** Section 6.4 now contains a *Quantum adversary model* paragraph. Grover's algorithm halves effective spatial entropy in bits (~22.9 bits/point under no demographic knowledge); for $n=3$ the quantum-attacker total is 68.7 bits, remaining comfortably Human-Scale Secure before any Argon2id hardening. Shor's algorithm affects asymmetric cryptography only and is irrelevant to Argon2id. A full QRAM-model analysis is identified as an open research problem.

4. Physical side-channel attacks (timing, power, memory-access pattern leakage during Argon2id evaluation) are not mentioned. A brief discussion of their relevance and scope should be included.

**Author's Response:** A sentence on physical side-channel attacks has been added at the end of Section 6.4, noting that timing analysis, power profiling, and memory-access pattern leakage during Argon2id evaluation are implementation-dependent concerns outside the protocol-level security model and are left for future implementation-level analysis.

5. The paper evaluates defender latency only on server and laptop hardware. Mobile devices (smartphones, tablets) represent a realistic deployment platform. The authors should provide projected latency estimates for a typical ARM SoC and discuss whether high memory tiers remain feasible on devices with limited DRAM.

**Author's Response:** Tab:argon2_defender_cost_consumer has been extended with a smartphone column. Latency estimates use a ~4× bandwidth scaling factor derived from LPDDR5x bandwidth specifications (JEDEC JESD79-5C, cited). At $m=1{,}024$ MiB, estimated smartphone latency is ~4.9 s. The $m=8{,}192$ MiB tier is marked as infeasible (exceeds typical smartphone DRAM capacity of 8–12 GiB).

6. The fuzzy matching / error tolerance limitation is acknowledged but only briefly. The Discussion should more explicitly quantify the impact: a single-cell miss causes 100% key derivation failure, which is a severe usability constraint.

**Author's Response:** Already addressed via R2.3. Section 6.4 now explicitly states that a single-cell recall error causes 100% key derivation failure and identifies this as a fundamental usability limitation, with future work directions proposed.

7. The offline resolvability requirement for What3Words is contradicted by its proprietary API dependency. The paper should either justify this or recommend an open alternative such as Open Location Code (Plus Codes).

**Author's Response:** Already addressed via R1.4. Section 4.3 now explicitly recommends OLC/Plus Codes (precision level 11, ~9 m² footprint) as the open offline alternative and states that all security results are encoder-agnostic.

8. The paper does not discuss accessibility for special populations—in particular, elderly users or individuals with reduced spatial cognitive ability, for whom spatial recall may be a less reliable secret substrate than for the general population.

**Author's Response:** The user study limitation paragraph in Section 6.4 now includes an explicit sentence: *"A dedicated study should further examine accessibility for populations with reduced spatial cognitive ability, including elderly users and individuals with navigation-related impairments, for whom spatial recall may be a less reliable secret substrate."*

9. Please additionally cite the following works in the Related Work section: [reviewer suggested two papers on indoor robotic rehabilitation and 3D gesture recognition].

**Author's Response:** The two suggested references concern indoor robotic rehabilitation and 3D gesture recognition for post-epidemic scenarios. These topics have no scientific connection to cryptographic key management, spatial entropy modelling, or Argon2id benchmarking. They have not been added to the paper.

10. Section 4.3 (Geospatial Encoding) would benefit from a more explicit mathematical derivation showing how the W3W cell grid translates into nominal entropy. Specifically: Earth surface area ÷ cell area = total cell count → log₂(cell count) = nominal bits. The relationship between encoding accuracy (cell size) and the entropy ceiling should also be stated explicitly.

**Author's Response:** Section 3.2 (Nominal Spatial Entropy) now explicitly states the cell count $N = 5.1\times10^{14}/9 \approx 5.7\times10^{13}$, notes that halving linear cell dimension adds exactly 2 bits while doubling it removes 2 bits, and refers to the Omnibus HPZ result (41.38 bits after excluding non-habitable cells) in Table 3.

11. The 41.38-bit Omnibus HPZ value is used as a lower bound throughout the paper, but its derivation and meaning as a theoretical floor are not formally stated. A concise paragraph should clarify that 41.38 bits and 27.4 bits (urban prior) bracket the effective entropy across all evaluated attacker priors, and that no evaluated prior contracts below 27.4 bits/point without sub-neighbourhood knowledge.

**Author's Response:** Section 5.1 now includes a formal entropy bracket as Equation (eq:entropy_bracket): $H_{\text{eff}}(n) \in [27.4n,\; 41.38n]$ bits. The lower bound is attributed to the Urban (city-scale) prior and the upper bound to the Omnibus HPZ prior. A closing statement confirms that no evaluated attacker prior contracts below 27.4 bits/point without sub-neighbourhood-scale knowledge of the user's location.