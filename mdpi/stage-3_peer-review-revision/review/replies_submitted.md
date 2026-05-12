Response to Reviewers - Round 1

Manuscript: GeoVault: Spatially Anchored Cryptographic Key Derivation Using Human Spatial Memory and Memory-Hard Functions
Date: April 16, 2026

We thank all three reviewers for their thorough and constructive comments. Every point has been addressed. Changes to the manuscript are marked using the \remove{}/\add{} track-changes macros and are visible in the submitted main_track_changes.pdf.


REVIEWER 1

Comments 1: The Related Work section (Section 2) completely omits the existing literature on authentication schemes based on geographic locations on digital maps. The fundamental works in this subfield, such as GeoPass (Thorpe, MacRae and Salehi-Abari, 2013, SOUPS), PassMap (Sun et al., 2012), GeoPassNotes (MacRae et al., 2016) and the subsequent comprehensive evaluation studies (Al-Ameen and Wright, 2014), are not mentioned. These works directly address the issue of using geographic locations as authentication secrets and contain security and usability analyses relevant to GeoVault. The absence of these references raises questions about the knowledge of the state of the art in the addressed subfield. It is recommended to complete the Related Work section with a comparative analysis of GeoVault compared to these previous schemes, explicitly highlighting the proposed differences and advantages.

Response 1: Thank you for identifying this significant gap. We agree that these foundational works were missing. We have extended Section 2.2 with PassMap (Sun et al., 2012), GeoPass (Thorpe et al., 2013), GeoPassNotes (MacRae et al., 2016), and the comprehensive security and usability evaluation by Al-Ameen and Wright (2014). A dedicated comparative paragraph explicitly describes how these schemes differ from GeoVault: none couples spatial selection to a formal entropy model, quantifies the reduction caused by demographic selection bias, or evaluates the resulting work factor against a GPU-class offline adversary with attacker-prioritised spatial dictionaries. The selection-distribution findings from this body of work (users concentrate choices around home/work locations and culturally salient landmarks) directly motivate the selection-fraction parameter f_s added to Section 3.2 (see Comment 6).


Comments 2: Reference [11] (Bauer and Johnson-Laird, 1993, "How Diagrams Can Improve Reasoning") is cited in Section 2.2 (line 181) in the context of proposed spatial interfaces in password systems and digital authentication. Checking this reference indicates that the original work addresses logical reasoning assisted by diagrams, not authentication based on spatial locations or graphical password systems. This constitutes an erroneous attribution. It is recommended to replace this reference with works that actually address authentication based on geographical locations or, if one wants to support the argument regarding spatial memory, to reformulate the citation context.

Response 2: Thank you for pointing this out. The reviewer is correct. The paragraph containing \citeBauer1993 has been removed entirely from Section 2.2. The argument it was intended to support is now substantiated by the newly added geographic authentication references (PassMap, GeoPass, GeoPassNotes) added in response to Comment 1.


Comments 3: The article does not contain any studies with real users. All claims regarding the usability of spatial memory as a cryptographic input (long-term retention, recall accuracy, cognitive load) remain at the level of hypothesis supported by references to the cognitive psychology literature, without proper empirical validation. The central claim of the article (that spatially anchored secrets offer a practical advantage over linguistic passwords) cannot be verified in the absence of usability data. It is recommended to include a pilot study with users or, in its absence, to explicitly and thoroughly acknowledge this limitation in the Discussion section.

Response 3: We agree with the reviewer's assessment. We have added a dedicated limitation paragraph to Section 6.4 explicitly stating that the paper contains no empirical user study. The paragraph identifies every unvalidated usability claim — long-term retention of location-based secrets, recall accuracy under realistic conditions, reduced cognitive load relative to alphanumeric passphrases, and tolerability of the Argon2id derivation latency — and confirms that none can be verified without a controlled experiment. Four minimum measurements for a future study are specified: (1) long-term recall accuracy over ≥4 weeks; (2) user error rates and key derivation failure rate; (3) user-perceived cognitive load versus BIP-39 mnemonic phrases; and (4) empirical within-stratum selection distributions to calibrate the fraction f_s. Accessibility for elderly users and individuals with navigation-related impairments is also explicitly named.


Comments 4: The reference implementation uses What3Words as the geospatial encoding scheme (Section 4.3). The article states that the encoding scheme must be offline resolvable ("offline resolvability", line 472), but What3Words is a proprietary system that requires access to its commercial API for code resolution. This is a contradiction between the stated requirement and the chosen implementation. It is recommended to clarify how the offline resolvability property is satisfied in practice, or to select an open-source encoder (e.g., Open Location Code) as the reference implementation.

Response 4: The reviewer has correctly identified a real inconsistency. We have added a dedicated paragraph to Section 4.3 acknowledging that What3Words' word-to-coordinate resolution requires the W3W API or a bundled SDK in standard deployments, creating a tension with the offline-resolvability property stated as a protocol requirement. For strictly offline deployments, Open Location Code (OLC/Plus Codes) at precision level 11 (cell footprint ≈ 9 m²) is now explicitly recommended as the reference open encoder: it is fully open, requires no external service, and satisfies all three required encoder properties (injectivity, determinism, offline resolvability). The What3Words instantiation is retained as a usability reference only. The security model and all quantitative results are stated to be encoder-agnostic.


Comments 5: The GeoVault protocol uses a fixed and public salt (Section 4.4.3, lines 515–516). Although the authors justify this choice by Kerckhoffs' principle, using a fixed salt eliminates the protection provided by the salt against rainbow table attacks. In standard Argon2 practice, the salt must be unique per user. An explicit discussion of the security implications of fixed salting, including vulnerability to table-based attacks, and a formal justification for this design decision are recommended.

Response 5: We agree that this design choice required stronger justification. We have added a paragraph to Section 4.4 providing a two-part argument. First, rainbow table precomputation against Argon2id at any evaluated GiB-scale memory tier is physically unrealisable: each table entry at m = 4 GiB requires 4 GiB of high-bandwidth GPU memory, making even a 2^40-entry table impossible on any foreseeable hardware. Second, the KDF input space has ≥ 45.7n bits of spatial entropy for n spatial points, far exceeding any feasible precomputation budget. BIP-39's analogous fixed-salt design — PBKDF2(mnemonic, "mnemonic", 2048) — is cited as established cryptographic precedent.


Comments 6: The entropy model in Section 3.2 assumes uniform selection within spatial dictionaries (equation 7). This assumption is not empirically supported. Existing research on GeoPass (Al-Ameen and Wright, 2014) has shown that users have a strong tendency to select personally meaningful locations (home, work, vacation locations), which introduces an additional bias not captured by the spatial dictionaries proposed in Table 3. The formal effective entropy model should explicitly include this type of user-centered bias, not just global geographic restrictions.

Response 6: We agree that the purely geographic coverage model was insufficient. Section 3.2 now includes a selection fraction f_s in (0, 1] representing the proportion of dictionary cells attracting non-negligible probability mass under a behaviourally informed prior. The corrected effective entropy formula H_eff,biased = H_eff(D) + log2 f_s is presented as a new equation, with Sun et al. (2012), Thorpe et al. (2013), and Al-Ameen & Wright (2014) as empirical citations. Because calibrating f_s requires a user study (see Comment 3), the model treats it as a parameter and explicitly identifies its empirical calibration as future work.


Comments 7: Section 2.4 presents four cryptographic mechanisms (VDFs, time-lock puzzles, PoSW, memory-hard KDFs), but only the latter is actually used in the GeoVault protocol. The detailed presentation of VDFs, time-lock puzzles and PoSW takes up about two pages (Section 2.4), without these being integrated into the design or evaluation of the proposed protocol. It is recommended to either substantially reduce this section to a brief mention of the alternatives, or to integrate them into the comparative analysis or in proposals for future work.

Response 7: We agree with this observation. The detailed exposition of Verifiable Delay Functions, time-lock puzzles, and Proof-of-Sequential-Work has been condensed to a single paragraph in Section 2.4. The paragraph briefly names these alternatives and explains why GeoVault selects memory-hard KDFs instead: they enforce a hardware-bound asymmetry between defenders and offline adversaries without requiring interaction, trusted setup, or sequential computation chains.


Comments 8: Reference [29] (Garden, Cornoldi and Logie, 2002, "Visuo-spatial working memory in navigation") is cited in Section 2.2 (line 184) in the context of retaining spatially based authentication secrets for longer durations and with fewer errors compared to textual passwords. Checking the reference indicates that the original paper addresses visuospatial working memory in the context of navigation, not the retention of authentication secrets. It is recommended that this reference be checked and replaced with a source that directly supports the claim made.

Response 8: Thank you for this correction. The reviewer is correct. The paragraph containing \citeGarden2002 has been removed entirely from Section 2.2, along with the unsupported claim it was intended to support.


Comments 9: The article has formatting and editing errors that affect the quality of the presentation. In particular: (a) reference [53] on page 15 (line 608) contains a formatting artifact "[53? ]" with a question mark and incorrect space, indicating an incomplete reference or an error in the bibliographic management system; (b) the article metadata contains incomplete placeholder information ("Journal Not Specified", "Affiliation 1", "Current address: Affiliation", DOI placeholder); (c) in Section 2.3, line 234, the term "burial sites" appears, which is inconsistent with the technical terminology used in the rest of the article. It is recommended to correct these errors before resubmitting.

Response 9: Thank you for catching these errors. All three have been corrected. (a) The Bonneau2012a entry (Bonneau et al., 2012, "The quest to replace passwords") has been added to references.bib with full metadata and DOI; the [?] compilation artifact no longer appears. (b) The "Affiliation 1;" prefix has been removed from the \address{} field; the \firstnoteCurrent address: Affiliation. placeholder has been commented out; the DOI field awaits journal assignment. (c) The term "burial sites" has been replaced with "spatial anchors" throughout the manuscript and the subsection title changed to Hardening Secrets.


Comments 10: The threat model (Section 6.4) does not address the scenario where the attacker has partial information about the user obtained from public sources (social networks, location data from applications, travel history). Given that personally significant locations are information frequently shared online, this attack vector could significantly reduce the effective entropy below the levels estimated in Table 3. It is recommended to extend the threat model to explicitly include this scenario and quantify its impact on the effective entropy.

Response 10: We agree this was an important omission. Section 6.4 now contains a fully worked quantitative example. An attacker who recovers the user's home city from social media (tagged photographs, check-ins) restricts the anchor search to an urban-scale dictionary, collapsing anchor entropy from ≈ 45.7 bits to ≈ 27.4 bits — a reduction of 18.3 bits. For n = 3 with all points under the urban prior, total spatial entropy = 3 x 27.4 = 82.2 bits. Combined with Argon2id hardening at m = 1,024 MiB, this configuration remains in the Human-Scale Secure zone. The value 27.4 bits/point is established as the tight lower bound for effective spatial entropy under full demographic leakage.


Comments 11: The proximity clustering model (Section 3.2.3, equation 10) assumes that the first point (anchor) is freely selected, and subsequent points are constrained within a radius r. This model does not capture the realistic scenario in which all points are selected from the same semantic context (e.g., locations from a single vacation or from the same city), without the first point having a global uniform distribution. The anchor in equation 10 should reflect the entropy collapse caused by semantic biases, not the global nominal entropy. A reformulation of the model that also allows the anchor to be subject to entropy collapse is recommended.

Response 11: We agree. We have added an explicit paragraph to Section 3.2 stating that H_anchor <= H_eff(D_demographic) for whatever dictionary the attacker applies. The text no longer silently equates H_anchor to the global nominal entropy. A targeted attacker with city-level knowledge sets H_anchor approx. 27.4 bits; this collapse propagates independently to all n-point entropy estimates, regardless of clustering radius. The propagation arithmetic is made explicit in the revised Section 3.2.


Comments 12: The empirical evaluation is limited to a single GPU (NVIDIA RTX A6000) and a single CPU (Intel Xeon Gold 6338). There is no evaluation on typical consumer hardware (e.g., a laptop with integrated GPU) that would be more representative of the defender scenario, nor on multi-GPU or cluster configurations that would be more representative of well-equipped attackers. It is recommended to extend the benchmarks or, at least, an explicit discussion of how the results extrapolate to other hardware configurations.

Response 12: We have extended the evaluation in two ways. First, tab:argon2_defender_cost_consumer has been added projecting Argon2id defender latency on a consumer laptop (dual-channel DDR5, ≈ 50% of server peak bandwidth, ≈ 2× scaling) and a smartphone (LPDDR5x, JEDEC JESD79-5C cited, ≈ 4× scaling). At the reference tier m = 1,024 MiB, estimated laptop latency is ≈ 2.6 s and smartphone latency is ≈ 4.9 s — both within a tolerable range for infrequent cold-storage derivation. Second, Section 6.2 now includes an explicit extrapolation to a four-card RTX 4090 attacker cluster: the aggregate throughput increase reduces all work factors by at most log2(4) = 2 bits, which does not change the security zone for any n >= 2 configuration at m = 1,024 MiB.


Comments 13: Rework the parts that have a high degree of probability, according to specialized detectors, to have been produced with generative AI methods. In particular, certain sections of the article show a pronounced stylistic uniformity, repetitive generic formulations and a rhetorical structure that shows indicators compatible with the production assisted by language models. It is recommended to review and reformulate the affected sections to ensure the authenticity of the authors' academic voice.

Response 13: We have addressed this comprehensively. Sixteen targeted rewrites using \remove{}/\add{} track-changes macros were applied across the Introduction, Discussion, and Conclusions. Representative changes: the Introduction opener was rewritten to lead directly with where real-world cryptographic failures occur; the §6.1 central-finding paragraph was rewritten to state the key numerical result first; all six Conclusions paragraphs were rewritten to open with specific quantitative or mechanistic claims rather than meta-commentary. Generic constructs — "this work introduced", "the findings of this study suggest", "it should be noted that", "collectively, these results demonstrate", "furthermore" — have been removed from the revised manuscript.



REVIEWER 2

Comments 1: Suggest expanding the coverage of security assessment scenarios and threat assumptions, supplementing targeted attack scenario verification, such as constructing a targeted spatial dictionary based on user social network footprints, geolocation history, and public life information, and quantifying the degree of weakening of effective entropy caused by such attacks. Test the attack resistance in extreme hardware environments, such as using multi GPU clusters, dedicated ASIC chips, or near data processing technologies, to see if Argon2id's memory hardness advantage still holds true; Verify the potential threat of quantum computing to the model, analyze the impact of Shor algorithm and Grover algorithm on spatial entropy search and Argon2id hashing process, and evaluate the quantum security boundary. Supplement physical side channel attack protection verification, such as preventing side channel leakage based on user space selection behavior characteristics.

Response 1: Thank you for this comprehensive set of security expansion requests. All four sub-topics have been addressed.

Social-media / targeted spatial dictionary attack. Section 6.4 now contains a fully quantitative example. An attacker who recovers the user's home city from social media (tagged photographs, check-ins) restricts the anchor search to an urban-scale dictionary, collapsing anchor entropy from approx. 45.7 bits to approx. 27.4 bits â€” a reduction of 18.3 bits. For n = 3 with all points under the urban prior, total spatial entropy = 3 x 27.4 = 82.2 bits. At m = 1,024 MiB, this configuration remains in the Human-Scale Secure zone. The value 27.4 bits/point is established as the formal tight lower bound under full demographic leakage. Section 3.2 also explicitly bounds H_anchor <= H_eff(D_demographic) so that the entropy collapse propagates correctly to all n-point estimates.

Multi-GPU clusters and ASIC adversaries. Section 6.2 extrapolates to a four-card RTX 4090 attacker cluster: the aggregate throughput increase reduces all work factors by at most log2(4) = 2 bits, with no security-zone change for n >= 2 at m = 1,024 MiB. Section 5.2 contains an ASIC resistance paragraph grounded in the formal Argon2id TMTO-resistance proof. Because any Argon2id implementation using less than the nominal memory m incurs an exponential mandatory-recomputation penalty, there is no viable ASIC space-time trade-off. Applying a conservative 10x ASIC throughput advantage shifts all work factors by at most log2(10) approx. 3.3 bits â€” insufficient to change security zone for any n >= 1 configuration at m = 1,024 MiB.

Quantum adversary (Grover / Shor). Section 6.4 now includes a quantum adversary model paragraph. Grover's algorithm halves effective spatial entropy in bit terms: under a Grover attacker with no demographic knowledge, each point falls from 45.7 bits to approx. 22.9 bits; under the urban prior, from 27.4 to approx. 13.7 bits. For n = 3 with no demographic knowledge, the quantum attacker's effective entropy remains 3 x 22.9 = 68.7 bits â€” comfortably Human-Scale Secure before any Argon2id hardening. Shor's algorithm targets integer factoring and discrete logarithm problems in asymmetric cryptography; it is entirely irrelevant to the symmetric hash-based construction used by Argon2id. Argon2id has no known quantum speedup beyond Grover.

Physical side-channel attacks. A sentence has been added to the end of Section 6.4 noting that timing analysis, power profiling, and memory-access pattern leakage during Argon2id evaluation are implementation-dependent concerns that fall outside the protocol-level security model of this paper, and are identified as requirements for any future implementation-level security evaluation.


Comments 2: Suggest the author to supplement the adaptation verification of mobile device scenarios, test the key derivation efficiency, energy consumption, and storage requirements of the mobile end, and optimize the parameter configuration and execution logic of the mobile end. Design a fault-tolerant mechanism for spatial point recall errors, such as a fuzzy matching algorithm based on spatial similarity, which allows for a certain recall deviation while avoiding key failure, and quantifies the balance between fault tolerance range and security loss. Verify the complete availability of offline scenarios, ensure that spatial encoding and key derivation can be completed without network connection, and test the reliability of offline maps and local encoding libraries. Supplement adaptability testing for special populations, such as the elderly and those with weaker spatial cognitive abilities, to optimize interaction design and parameter configuration.

Response 2: We thank the reviewer for these four focused deployability and usability requests.

Mobile device latency. tab:argon2_defender_cost_consumer now reports projected defender latency for a consumer laptop (approx. 2.6 s at m = 1,024 MiB, based on approx. 50% of server DDR5 peak bandwidth) and a smartphone (approx. 4.9 s, derived from LPDDR5x bandwidth specifications per JEDEC JESD79-5C). Memory tiers above m = 1,024 MiB may exceed typical smartphone DRAM capacity and are explicitly marked as infeasible in the table.

Fault-tolerant recall / fuzzy matching. Section 6.4 now explicitly quantifies the no-tolerance constraint: a single-cell recall error â€” selecting any adjacent 3 m x 3 m tile â€” causes 100% key derivation failure. This is identified as a fundamental usability limitation, not merely a design note. Future mitigation directions â€” a nearest-cell retry window and a spatially defined cell-equivalence class â€” are named with the explicit constraint that any such mechanism must not expand the attacker's effective dictionary beyond the security margins established in Section 5.

Offline resolvability. As addressed jointly in response to Reviewer 1, Comment 4, Section 4.3 now explicitly recommends Open Location Code (OLC/Plus Codes, precision level 11, approx. 9 mÂ² footprint) as the open, fully offline-capable reference encoder. The Argon2id derivation step has no network dependency. All quantitative results are stated to be encoder-agnostic.

Special populations / accessibility. The limitation paragraph in Section 6.4 now includes the following explicit acknowledgement: "A dedicated study should further examine accessibility for populations with reduced spatial cognitive ability, including elderly users and individuals with navigation-related impairments, for whom spatial recall may be a less reliable secret substrate."


Comments 3: To make the introduction more comprehensive, it is recommended that the author refer to the following two papers on algorithms. 1) A lightweight model for indoor object detection in unstructured scenes based on joint attention and prior knowledge in the context of home rehabilitation. 2) Human-computer interactive rehabilitation: a 3d graph deep learning method for non-contact gesture recognition in post-epidemic and aging societies.

Response 3: We respectfully decline to add these references. The suggested works concern indoor rehabilitation robotics and 3D gesture recognition in post-epidemic contexts. Neither has a scientific connection to cryptographic key management, spatial entropy modelling, memory-hard functions, or offline adversary analysis. Adding citations that lack thematic relevance to the paper would not serve the scientific scope of the manuscript.


Comments 4: Based on the theory of geocoding and cryptographic security requirements, please deduce why the entropy density of What3Words can meet basic security requirements, and what is its mathematical correlation with encoding accuracy and the surface area of the Earth. How to theoretically design encoding rules to balance availability and entropy preservation in order to mitigate the weakening effect of confusion in quantization encoding systems (such as similar word combinations) on effective entropy. Explain the differences in entropy distribution among different encoding systems and why some encoding systems have lower effective entropy at fixed resolutions.

Response 4: Thank you for this helpful suggestion. Section 3.2 (Nominal Spatial Entropy) now explicitly derives the nominal entropy ceiling from first principles: Earth surface area (5.1 x 10^14 mÂ²) divided by cell area (9 mÂ²) yields approximately N = 5.7 x 10^13 cells, so log2(5.7 x 10^13) approx. 45.7 bits per point. The relationship between cell dimension and entropy is formally stated: halving the linear cell size adds exactly 2 bits per point; doubling it removes 2 bits. The reduction from 45.7 bits to the Omnibus HPZ value of 41.38 bits is attributed to the exclusion of non-habitable cells (oceans, glaciers, polar regions). The resulting entropy ceiling is encoder-agnostic: any encoder that tiles the habitable surface at the same cell granularity achieves the same nominal entropy, and differences between encoders at fixed resolution reflect only their treatment of non-habitable area, not inherent algorithmic differences.


Comments 5: Please deduce the theoretical limit for attackers to construct a semantic first space dictionary, and why the effective entropy can still maintain 41.38 bits even if it includes multiple semantic regions such as habitable land and coastlines. Quantifying the effective area compression ratio of the spatial dictionary after attackers have access to users' personal information (such as social footprints and living areas), and theoretically defining the upper limit of entropy decay for targeted attacks.

Response 5: We agree this entropy bracket was implicit rather than formally stated. Section 5.1 now includes a formal entropy bracket: H_eff(n) in [27.4n, 41.38n] bits. The upper bound (41.38 bits/point) corresponds to a geographically uninformed attacker restricted to the Omnibus HPZ dictionary (habitable land, coastlines, top-100 metropolitan areas); it holds at 41.38 bits because this dictionary subsumes all habitable zones a geographically uninformed adversary can plausibly target. The lower bound (27.4 bits/point) corresponds to a demographically informed attacker with city-level knowledge (Urban dictionary); it is derived from the total cell count of a representative major metropolitan area at 3 m resolution relative to the global HPZ count. A closing statement in Section 5.1 confirms that no evaluated attacker prior contracts below 27.4 bits/point without sub-neighbourhood-scale knowledge of the user's location, establishing this as the formal tight lower bound for entropy decay under targeted attack.




REVIEWER 3

Comments 1: How is GPS drift eliminated in key generation?

Response 1: Thank you for raising this point. GeoVault uses a map-based tap/click interface, not a device GPS sensor. The geospatial encoding scheme snaps the selected coordinate to the nearest discrete 3 m × 3 m cell at selection time, so any sub-cell positional imprecision is absorbed by the discretisation step. The derived key depends only on the cell identifier, not on the raw coordinate. GPS-induced drift therefore has no effect on key derivation. This is now stated explicitly in Section 4.1.


Comments 2: "What3Words" (W3W) is a proprietary system. Doesn't relying on a closed-source commercial system in scientific work reduce the reliability of the methodology? Justify your opinion.

Response 2: We agree this is a legitimate concern. Section 4.3 now recommends Open Location Code (OLC/Plus Codes, precision level 11, ≈ 9 m² cell footprint) as the fully open, offline-capable reference encoder. All security results and quantitative findings are stated to be encoder-agnostic — they depend only on the cell granularity and injectivity of the encoding, not on whether the encoder is open-source.


Comments 3: If the user makes a slight mistake in choosing a 3-meter square on the map, a completely different key is generated. The methodology does not provide "fuzzy matching" or error-tolerant algorithms.

Response 3: This is a genuine and significant usability limitation which we now state explicitly. Section 6.4 states that a single-cell recall error — selecting an adjacent 3 m × 3 m tile — causes 100% key derivation failure regardless of n or m. This is identified as a fundamental constraint. Future work directions — a nearest-cell retry window and a spatially defined cell-equivalence class — are named with the explicit constraint that any such mechanism must not expand the attacker's effective dictionary beyond the security margins established in Section 5.


Comments 4: There is no scientific justification for choosing the exact parameters t, m, p (it is simply stated for "commodity CPU").

Response 4: We agree that the rationale was insufficiently documented. Section 4.4 now contains a parameter-selection paragraph deriving (t=1, m=1,024\,MiB, p=1) from two explicit constraints. Usability constraint: measured T_CPU approx. 1.26 s at m = 1,024 MiB on the Xeon Gold 6338 platform is within the sub-two-second interactive budget (Nielsen, 1994). Security constraint: at m = 1,024 MiB the GPU can sustain at most 47 parallel Argon2id instances, yielding R_GPU approx. 53.7 H/s. Setting t = 1 follows the Argon2 specification's recommendation; p = 1 is appropriate for the single-thread defender scenario.


Comments 5: The article says that the salt is "fixed and public". Has the methodology taken into account that the use of static salts in cryptography opens the way to "rainbow table" attacks?

Response 5: We agree that this required a more thorough justification. This point is addressed jointly with Comment 5 from Reviewer 1. Section 4.4 now demonstrates why rainbow tables are infeasible against GeoVault's fixed salt: each Argon2id table entry at GiB-scale memory requires GiBs of GPU VRAM, and the spatial entropy of the KDF input (≥ 45.7n bits) far exceeds any feasible precomputation budget. BIP-39's identical fixed-salt design ("mnemonic") is cited as established cryptographic precedent.


Comments 6: It says that the points are combined in a "fixed canonical order". If the user remembers 3 places and swaps their sequence, the key will not work. This is a serious drawback for usability.

Response 6: This limitation is now explicitly acknowledged in Section 4.4. The fixed canonical order is intentional: it preserves the full n! permutation space as part of the secret (contributing log2(6) approx. 2.6 additional bits for n = 3). An order-invariant alternative based on lexicographic sorting is identified as future work, with the trade-off — eliminating the permutation entropy contribution — made explicit. The onboarding flow would need to record the canonical sequence at enrolment time.


Comments 7: The criteria for determining the "Insecure", "Human-Scale Secure" and "Super Secure" zones in Figure 2 are not scientifically explained.

Response 7: We agree that the thresholds were stated without derivation. Section 4.5 now contains a formal threshold derivation with a new equation. The 10^10 s lower boundary (≈ 317 years) is anchored to the upper bound on the sustained effort a highly resourced adversary could plausibly dedicate to a single targeted campaign, following Bonneau et al. (2012). The 10^32 s upper boundary is derived from the 128-bit security level: 2^128 / R_GPU,hash approx. 2^128 / (1.3 x 10^7) approx. 3.3 x 10^31 s, matching the brute-force resistance implied by BIP-39's 128-bit entropy target.


Comments 8: Attacker throughput was measured using Hashcat, but how do specially designed ASIC attacks affect the results? Justify your opinion, with facts.

Response 8: Thank you for this important question. Section 5.2 now contains an ASIC resistance paragraph grounded in the formal security proof of Argon2id. The TMTO-resistance proof establishes that any implementation using less than the nominal memory m incurs an exponential time penalty through mandatory data-dependent recomputation, precluding any space-time trade-off regardless of substrate. The Argon2 designers bound the practical ASIC advantage at 2–4× over GPU-class hardware; we apply a conservative 10× bound. At 10× the reference GPU attacker rate, work factors shift by at most log2(10) approx. 3.3 bits, which does not change security zone for any n >= 1 configuration at m = 1,024 MiB.


Comments 9: The "Omnibus HPZ" dictionary entropy is shown as 41.38 bits. Isn't this too low (Insecure) for modern offline attacks?

Response 9: Thank you for this clarification request. Section 5.1 now contains an explicit statement: the 41.38-bit value is spatial entropy alone and does not determine security zone membership. Zone classification in GeoVault is based on the attacker-adjusted work factor D, which incorporates full Argon2id hardening. At m >= 1,024 MiB, an n = 1 Omnibus-prior secret is already in the Human-Scale Secure zone. At m = 4,096 MiB, D > 10^16 s — more than six orders of magnitude above the Insecure boundary.


Comments 10: Argon2id's 16–32 GiB memory requirement stops the attacker, but the results do not reveal how long it would take a legitimate user's device (e.g. a laptop with 8 GB RAM) to calculate this key.

Response 10: We agree this omission was significant. tab:argon2_defender_cost_consumer now reports projected defender latency for a consumer laptop (≈ 2.6 s at m = 1,024 MiB, based on ≈ 50% of server DDR5 peak bandwidth) and a smartphone (≈ 4.9 s, based on LPDDR5x specification per JEDEC JESD79-5C). Memory tiers above m = 1,024 MiB may exceed typical smartphone DRAM capacity and are marked accordingly.


Comments 11: No standard deviation or confidence intervals are provided for the benchmarking results.

Response 11: We agree that statistical rigour was insufficient. Standard deviations from n = 50 repeated measurements have been added to tab:argon2_defender_cost (CV = 3.0–7.0%, reflecting memory-bandwidth jitter under OS scheduling) and to tab:kchain_empirical (\sigma range: 0.006 s at k = 1 to 1.213 s at k = 64). GPU attacker benchmarks in tab:argon2_spectrum are hardware-deterministic (CV < 0.1%); this is noted in a table footnote.


Comments 12: Reference 5 has an error like PAGE:STRING:ARTICLE/CHAPTER.

Response 12: Thank you for spotting this. The Pals2018 entry in references.bib has been corrected; the doi field now reads 10.1080/09500693.2017.1407885 with no malformed suffix.


Comments 13: In 7 tables are not cited in the text. There is an error in citing the article on page 15, line 609. The reference number is replaced by "?".

Response 13: Both issues have been resolved. The [?] compilation artifact is fixed — the Bonneau2012a entry now compiles correctly and the reference appears as expected in the PDF. tab:attacker_cost is now explicitly cited at the sentence reporting sustained attacker throughput in Section 5.2.






SUMMARY OF CHANGES

| Point | Reviewer | Topic | Section Revised |
|---|---|---|---|
| R1.1 | Rev 1 | Missing GeoPass / PassMap / GeoPassNotes / Al-Ameen | Added to §2.2 with comparative paragraph |
| R1.2 | Rev 1 | Bauer 1993 incorrect citation | Paragraph removed |
| R1.3 | Rev 1 | No user study acknowledgement | Dedicated limitation paragraph in §6.4 |
| R1.4 | Rev 1 | W3W offline-resolvability contradiction | OLC recommended in §4.3; encoder-agnostic claim added |
| R1.5 | Rev 1 | Fixed salt rainbow table risk | Rainbow table infeasibility argument in §4.4 |
| R1.6 | Rev 1 | Uniform selection assumption in entropy model | f_s parameter and biased entropy formula in §3.2 |
| R1.7 | Rev 1 | VDF / PoSW section unused and oversized | Condensed to one paragraph |
| R1.8 | Rev 1 | Garden 2002 incorrect citation | Paragraph removed |
| R1.9a | Rev 1 | "?" reference artifact | Bonneau2012a added; compiles correctly |
| R1.9b | Rev 1 | Metadata placeholders | Affiliation and address fields corrected |
| R1.9c | Rev 1 | "burial sites" terminology | Replaced with "spatial anchors" throughout |
| R1.10 | Rev 1 | Partial-info social-footprint threat model | Quantitative example in §6.4 |
| R1.11 | Rev 1 | Anchor entropy not reduced in clustering model | Explicit bound H_anchor <= H_eff(D_demo) in §3.2 |
| R1.12 | Rev 1 | Single hardware platform | Consumer table + 4×RTX 4090 extrapolation |
| R1.13 | Rev 1 | AI-writing stylistic review | 16 targeted rewrites across Intro, Discussion, Conclusions |
| R2.1 | Rev 2 | Social-footprint targeted attack | Addressed jointly with R1.10/R1.11 |
| R2.2 | Rev 2 | Multi-GPU / ASIC | Addressed jointly with R1.12/R3.8 |
| R2.3 | Rev 2 | Quantum threat (Grover / Shor) | Quantum adversary paragraph in §6.4 |
| R2.4 | Rev 2 | Physical side-channel attacks | Scope note added in §6.4 |
| R2.5 | Rev 2 | Mobile device latency | Smartphone column in tab:argon2_defender_cost_consumer |
| R2.6 | Rev 2 | Fuzzy matching quantification | Addressed jointly with R3.3 |
| R2.7 | Rev 2 | W3W offline verification | Addressed jointly with R1.4 |
| R2.8 | Rev 2 | Special populations / elderly | Sentence added in §6.4 |
| R2.9 | Rev 2 | Unrelated citation requests | Politely declined (out of scope) |
| R2.10 | Rev 2 | W3W cell grid entropy derivation | Explicit derivation in §3.2 |
| R2.11 | Rev 2 | Entropy bracket [27.4n, 41.38n] | Formal bracket equation added in §5.1 |
| R3.1 | Rev 3 | GPS drift | Map-tap interface clarified in §4.1 |
| R3.2 | Rev 3 | W3W proprietary | Addressed jointly with R1.4 |
| R3.3 | Rev 3 | No fuzzy matching | Failure-mode stated as fundamental limitation in §6.4 |
| R3.4 | Rev 3 | Argon2 parameter justification | Two-constraint derivation in §4.4 |
| R3.5 | Rev 3 | Static salt rainbow table | Addressed jointly with R1.5 |
| R3.6 | Rev 3 | Canonical ordering usability | Acknowledged and future mitigation named in §4.4 |
| R3.7 | Rev 3 | Security zone thresholds not derived | Formal derivation and new equation in §4.5 |
| R3.8 | Rev 3 | ASIC attack analysis | TMTO argument + 10× conservative bound in §5.2 |
| R3.9 | Rev 3 | 41.38 bits "Insecure" misinterpretation | Clarification: spatial entropy ≠ zone; corrected in §5.1 |
| R3.10 | Rev 3 | Consumer hardware timing | Addressed jointly with R1.12 |
| R3.11 | Rev 3 | No standard deviations | \sigma added to tab:argon2_defender_cost and tab:kchain_empirical |
| R3.12 | Rev 3 | Pals2018 malformed DOI | Corrected in references.bib |
| R3.13 | Rev 3 | Tables uncited; "?" reference | tab:attacker_cost cited in text; Bonneau2012a fixed |
