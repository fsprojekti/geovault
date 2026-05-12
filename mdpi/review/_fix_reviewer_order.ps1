
$f = 'C:\Users\Marko\Documents\Projects\GeoVault\mdpi\review\replies_submitted.md'
$t = Get-Content $f -Raw -Encoding UTF8

# Find section positions
$r2  = $t.IndexOf('REVIEWER 2')
$r3  = $t.IndexOf('REVIEWER 3')
$su  = $t.IndexOf('SUMMARY OF CHANGES')

# Extract parts
$partA = $t.Substring(0, $r2)                   # header + REVIEWER 1
$partB = $t.Substring($r2, $r3 - $r2)           # old REVIEWER 2: GPS drift / 13 Q&As → becomes new REVIEWER 3
$partD = $t.Substring($su)                      # SUMMARY section (will be replaced below)

# New REVIEWER 3 = old REVIEWER 2, just relabel the header
$newR3 = 'REVIEWER 3' + $partB.Substring(10)   # drop "REVIEWER 2" prefix (10 chars), prepend "REVIEWER 3"

# ---------------------------------------------------------------------------
# New REVIEWER 2 — 5 broad comments from actual Reviewer 2
# ---------------------------------------------------------------------------
$newR2 = @'
REVIEWER 2

Comments 1: Suggest expanding the coverage of security assessment scenarios and threat assumptions, supplementing targeted attack scenario verification, such as constructing a targeted spatial dictionary based on user social network footprints, geolocation history, and public life information, and quantifying the degree of weakening of effective entropy caused by such attacks. Test the attack resistance in extreme hardware environments, such as using multi GPU clusters, dedicated ASIC chips, or near data processing technologies, to see if Argon2id's memory hardness advantage still holds true; Verify the potential threat of quantum computing to the model, analyze the impact of Shor algorithm and Grover algorithm on spatial entropy search and Argon2id hashing process, and evaluate the quantum security boundary. Supplement physical side channel attack protection verification, such as preventing side channel leakage based on user space selection behavior characteristics.

Response 1: Thank you for this comprehensive set of security expansion requests. All four sub-topics have been addressed.

Social-media / targeted spatial dictionary attack. Section 6.4 now contains a fully quantitative example. An attacker who recovers the user's home city from social media (tagged photographs, check-ins) restricts the anchor search to an urban-scale dictionary, collapsing anchor entropy from approx. 45.7 bits to approx. 27.4 bits — a reduction of 18.3 bits. For n = 3 with all points under the urban prior, total spatial entropy = 3 x 27.4 = 82.2 bits. At m = 1,024 MiB, this configuration remains in the Human-Scale Secure zone. The value 27.4 bits/point is established as the formal tight lower bound under full demographic leakage. Section 3.2 also explicitly bounds H_anchor <= H_eff(D_demographic) so that the entropy collapse propagates correctly to all n-point estimates.

Multi-GPU clusters and ASIC adversaries. Section 6.2 extrapolates to a four-card RTX 4090 attacker cluster: the aggregate throughput increase reduces all work factors by at most log2(4) = 2 bits, with no security-zone change for n >= 2 at m = 1,024 MiB. Section 5.2 contains an ASIC resistance paragraph grounded in the formal Argon2id TMTO-resistance proof. Because any Argon2id implementation using less than the nominal memory m incurs an exponential mandatory-recomputation penalty, there is no viable ASIC space-time trade-off. Applying a conservative 10x ASIC throughput advantage shifts all work factors by at most log2(10) approx. 3.3 bits — insufficient to change security zone for any n >= 1 configuration at m = 1,024 MiB.

Quantum adversary (Grover / Shor). Section 6.4 now includes a quantum adversary model paragraph. Grover's algorithm halves effective spatial entropy in bit terms: under a Grover attacker with no demographic knowledge, each point falls from 45.7 bits to approx. 22.9 bits; under the urban prior, from 27.4 to approx. 13.7 bits. For n = 3 with no demographic knowledge, the quantum attacker's effective entropy remains 3 x 22.9 = 68.7 bits — comfortably Human-Scale Secure before any Argon2id hardening. Shor's algorithm targets integer factoring and discrete logarithm problems in asymmetric cryptography; it is entirely irrelevant to the symmetric hash-based construction used by Argon2id. Argon2id has no known quantum speedup beyond Grover.

Physical side-channel attacks. A sentence has been added to the end of Section 6.4 noting that timing analysis, power profiling, and memory-access pattern leakage during Argon2id evaluation are implementation-dependent concerns that fall outside the protocol-level security model of this paper, and are identified as requirements for any future implementation-level security evaluation.


Comments 2: Suggest the author to supplement the adaptation verification of mobile device scenarios, test the key derivation efficiency, energy consumption, and storage requirements of the mobile end, and optimize the parameter configuration and execution logic of the mobile end. Design a fault-tolerant mechanism for spatial point recall errors, such as a fuzzy matching algorithm based on spatial similarity, which allows for a certain recall deviation while avoiding key failure, and quantifies the balance between fault tolerance range and security loss. Verify the complete availability of offline scenarios, ensure that spatial encoding and key derivation can be completed without network connection, and test the reliability of offline maps and local encoding libraries. Supplement adaptability testing for special populations, such as the elderly and those with weaker spatial cognitive abilities, to optimize interaction design and parameter configuration.

Response 2: We thank the reviewer for these four focused deployability and usability requests.

Mobile device latency. tab:argon2_defender_cost_consumer now reports projected defender latency for a consumer laptop (approx. 2.6 s at m = 1,024 MiB, based on approx. 50% of server DDR5 peak bandwidth) and a smartphone (approx. 4.9 s, derived from LPDDR5x bandwidth specifications per JEDEC JESD79-5C). Memory tiers above m = 1,024 MiB may exceed typical smartphone DRAM capacity and are explicitly marked as infeasible in the table.

Fault-tolerant recall / fuzzy matching. Section 6.4 now explicitly quantifies the no-tolerance constraint: a single-cell recall error — selecting any adjacent 3 m x 3 m tile — causes 100% key derivation failure. This is identified as a fundamental usability limitation, not merely a design note. Future mitigation directions — a nearest-cell retry window and a spatially defined cell-equivalence class — are named with the explicit constraint that any such mechanism must not expand the attacker's effective dictionary beyond the security margins established in Section 5.

Offline resolvability. As addressed jointly in response to Reviewer 1, Comment 4, Section 4.3 now explicitly recommends Open Location Code (OLC/Plus Codes, precision level 11, approx. 9 m² footprint) as the open, fully offline-capable reference encoder. The Argon2id derivation step has no network dependency. All quantitative results are stated to be encoder-agnostic.

Special populations / accessibility. The limitation paragraph in Section 6.4 now includes the following explicit acknowledgement: "A dedicated study should further examine accessibility for populations with reduced spatial cognitive ability, including elderly users and individuals with navigation-related impairments, for whom spatial recall may be a less reliable secret substrate."


Comments 3: To make the introduction more comprehensive, it is recommended that the author refer to the following two papers on algorithms. 1) A lightweight model for indoor object detection in unstructured scenes based on joint attention and prior knowledge in the context of home rehabilitation. 2) Human-computer interactive rehabilitation: a 3d graph deep learning method for non-contact gesture recognition in post-epidemic and aging societies.

Response 3: We respectfully decline to add these references. The suggested works concern indoor rehabilitation robotics and 3D gesture recognition in post-epidemic contexts. Neither has a scientific connection to cryptographic key management, spatial entropy modelling, memory-hard functions, or offline adversary analysis. Adding citations that lack thematic relevance to the paper would not serve the scientific scope of the manuscript.


Comments 4: Based on the theory of geocoding and cryptographic security requirements, please deduce why the entropy density of What3Words can meet basic security requirements, and what is its mathematical correlation with encoding accuracy and the surface area of the Earth. How to theoretically design encoding rules to balance availability and entropy preservation in order to mitigate the weakening effect of confusion in quantization encoding systems (such as similar word combinations) on effective entropy. Explain the differences in entropy distribution among different encoding systems and why some encoding systems have lower effective entropy at fixed resolutions.

Response 4: Thank you for this helpful suggestion. Section 3.2 (Nominal Spatial Entropy) now explicitly derives the nominal entropy ceiling from first principles: Earth surface area (5.1 x 10^14 m²) divided by cell area (9 m²) yields approximately N = 5.7 x 10^13 cells, so log2(5.7 x 10^13) approx. 45.7 bits per point. The relationship between cell dimension and entropy is formally stated: halving the linear cell size adds exactly 2 bits per point; doubling it removes 2 bits. The reduction from 45.7 bits to the Omnibus HPZ value of 41.38 bits is attributed to the exclusion of non-habitable cells (oceans, glaciers, polar regions). The resulting entropy ceiling is encoder-agnostic: any encoder that tiles the habitable surface at the same cell granularity achieves the same nominal entropy, and differences between encoders at fixed resolution reflect only their treatment of non-habitable area, not inherent algorithmic differences.


Comments 5: Please deduce the theoretical limit for attackers to construct a semantic first space dictionary, and why the effective entropy can still maintain 41.38 bits even if it includes multiple semantic regions such as habitable land and coastlines. Quantifying the effective area compression ratio of the spatial dictionary after attackers have access to users' personal information (such as social footprints and living areas), and theoretically defining the upper limit of entropy decay for targeted attacks.

Response 5: We agree this entropy bracket was implicit rather than formally stated. Section 5.1 now includes a formal entropy bracket: H_eff(n) in [27.4n, 41.38n] bits. The upper bound (41.38 bits/point) corresponds to a geographically uninformed attacker restricted to the Omnibus HPZ dictionary (habitable land, coastlines, top-100 metropolitan areas); it holds at 41.38 bits because this dictionary subsumes all habitable zones a geographically uninformed adversary can plausibly target. The lower bound (27.4 bits/point) corresponds to a demographically informed attacker with city-level knowledge (Urban dictionary); it is derived from the total cell count of a representative major metropolitan area at 3 m resolution relative to the global HPZ count. A closing statement in Section 5.1 confirms that no evaluated attacker prior contracts below 27.4 bits/point without sub-neighbourhood-scale knowledge of the user's location, establishing this as the formal tight lower bound for entropy decay under targeted attack.


'@

# ---------------------------------------------------------------------------
# New SUMMARY — rebuild R2 and R3 rows
# ---------------------------------------------------------------------------
$oldSummaryRows = @'
| R2.1 | Rev 2 | GPS drift | Map-tap interface clarified in §4.1 |
| R2.2 | Rev 2 | W3W proprietary | Addressed jointly with R1.4 |
| R2.3 | Rev 2 | No fuzzy matching | Failure-mode stated as fundamental limitation in §6.4 |
| R2.4 | Rev 2 | Argon2 parameter justification | Two-constraint derivation in §4.4 |
| R2.5 | Rev 2 | Static salt rainbow table | Addressed jointly with R1.5 |
| R2.6 | Rev 2 | Canonical ordering usability | Acknowledged and future mitigation named in §4.4 |
| R2.7 | Rev 2 | Security zone thresholds not derived | Formal derivation and new equation in §4.5 |
| R2.8 | Rev 2 | ASIC attack analysis | TMTO argument + 10× conservative bound in §5.2 |
| R2.9 | Rev 2 | 41.38 bits "Insecure" misinterpretation | Clarification: spatial entropy ≠ zone; corrected in §5.1 |
| R2.10 | Rev 2 | Consumer hardware timing | Addressed jointly with R1.12 |
| R2.11 | Rev 2 | No standard deviations | \sigma added to tab:argon2_defender_cost and tab:kchain_empirical |
| R2.12 | Rev 2 | Pals2018 malformed DOI | Corrected in references.bib |
| R2.13 | Rev 2 | Tables uncited; "?" reference | tab:attacker_cost cited in text; Bonneau2012a fixed |
| R3.1 | Rev 3 | Social-footprint targeted attack | Addressed jointly with R1.10/R1.11 |
| R3.2 | Rev 3 | Multi-GPU / ASIC | Addressed jointly with R1.12/R2.8 |
| R3.3 | Rev 3 | Quantum threat (Grover / Shor) | Quantum adversary paragraph in §6.4 |
| R3.4 | Rev 3 | Physical side-channel attacks | Scope note added in §6.4 |
| R3.5 | Rev 3 | Mobile device latency | Smartphone column in tab:argon2_defender_cost_consumer |
| R3.6 | Rev 3 | Fuzzy matching quantification | Addressed jointly with R2.3 |
| R3.7 | Rev 3 | W3W offline verification | Addressed jointly with R1.4 |
| R3.8 | Rev 3 | Special populations / elderly | Sentence added in §6.4 |
| R3.9 | Rev 3 | Unrelated citation requests | Politely declined (out of scope) |
| R3.10 | Rev 3 | W3W cell grid entropy derivation | Explicit derivation in §3.2 |
| R3.11 | Rev 3 | Entropy bracket [27.4n, 41.38n] | Formal bracket equation added in §5.1 |
'@

$newSummaryRows = @'
| R2.1 | Rev 2 | Security assessment expansion (social footprint, multi-GPU, ASIC, quantum, side-channel) | §6.4, §6.2, §5.2 |
| R2.2 | Rev 2 | Mobile device, fuzzy matching, offline, special populations | tab:argon2_defender_cost_consumer, §6.4 |
| R2.3 | Rev 2 | Unrelated citation requests | Politely declined (out of scope) |
| R2.4 | Rev 2 | W3W cell grid entropy derivation (geocoding math) | Explicit derivation in §3.2 |
| R2.5 | Rev 2 | Semantic dictionary entropy bracket | Formal bracket equation added in §5.1 |
| R3.1 | Rev 3 | GPS drift | Map-tap interface clarified in §4.1 |
| R3.2 | Rev 3 | W3W proprietary | Addressed jointly with R1.4 |
| R3.3 | Rev 3 | No fuzzy matching | Failure-mode stated as fundamental limitation in §6.4 |
| R3.4 | Rev 3 | Argon2 parameter justification | Two-constraint derivation in §4.4 |
| R3.5 | Rev 3 | Static salt rainbow table | Addressed jointly with R1.5 |
| R3.6 | Rev 3 | Canonical ordering usability | Acknowledged and future mitigation named in §4.4 |
| R3.7 | Rev 3 | Security zone thresholds not derived | Formal derivation and new equation in §4.5 |
| R3.8 | Rev 3 | ASIC attack analysis | TMTO argument + 10x conservative bound in §5.2 |
| R3.9 | Rev 3 | 41.38 bits "Insecure" misinterpretation | Clarification: spatial entropy != zone; corrected in §5.1 |
| R3.10 | Rev 3 | Consumer hardware timing | Addressed jointly with R1.12 |
| R3.11 | Rev 3 | No standard deviations | sigma added to tab:argon2_defender_cost and tab:kchain_empirical |
| R3.12 | Rev 3 | Pals2018 malformed DOI | Corrected in references.bib |
| R3.13 | Rev 3 | Tables uncited; "?" reference | tab:attacker_cost cited in text; Bonneau2012a fixed |
'@

$newD = $partD.Replace($oldSummaryRows, $newSummaryRows)

# ---------------------------------------------------------------------------
# Compose and write
# ---------------------------------------------------------------------------
$sep = "`r`n`r`n`r`n"
$newFile = $partA + $newR2 + $sep + $newR3 + $sep + $newD

Set-Content $f $newFile -NoNewline -Encoding UTF8
Write-Host "Done. New length: $($newFile.Length)"
