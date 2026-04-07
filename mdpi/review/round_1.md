
# Reviwer 1

The paper is part of the research area of ​​user-centered cryptography, specifically in the subfield of cryptographic key management based on human-memorable secrets. The paper proposes the integration of human spatial memory as a source of entropy for cryptographic key derivation, a field that lies at the intersection of computer security, cognitive psychology, and geospatial coding.

The authors investigate a framework called GeoVault, which derives cryptographic keys from user-selected geographic locations, deterministically encoded, and reinforced by memory-hard key derivation functions (memory-hard KDFs), in particular Argon2id. The main stated contribution consists of a formal entropy model for spatially anchored secrets, an empirical analysis of the defender-attacker asymmetry, and an evaluation of attacker-adjusted work factors for different spatial configurations.

In order to strengthen the scientific rigor, the completeness of the analysis and the clarity of the exposition, the following aspects that require attention from the authors are reported:

1. The Related Work section (Section 2) completely omits the existing literature on authentication schemes based on geographic locations on digital maps. The fundamental works in this subfield, such as GeoPass (Thorpe, MacRae and Salehi-Abari, 2013, SOUPS), PassMap (Sun et al., 2012), GeoPassNotes (MacRae et al., 2016) and the subsequent comprehensive evaluation studies (Al-Ameen and Wright, 2014), are not mentioned. These works directly address the issue of using geographic locations as authentication secrets and contain security and usability analyses relevant to GeoVault. The absence of these references raises questions about the knowledge of the state of the art in the addressed subfield. It is recommended to complete the Related Work section with a comparative analysis of GeoVault compared to these previous schemes, explicitly highlighting the proposed differences and advantages.

2. Reference [11] (Bauer and Johnson-Laird, 1993, "How Diagrams Can Improve Reasoning") is cited in Section 2.2 (line 181) in the context of proposed spatial interfaces in password systems and digital authentication. Checking this reference indicates that the original work addresses logical reasoning assisted by diagrams, not authentication based on spatial locations or graphical password systems. This constitutes an erroneous attribution. It is recommended to replace this reference with works that actually address authentication based on geographical locations or, if one wants to support the argument regarding spatial memory, to reformulate the citation context.

3. The article does not contain any studies with real users. All claims regarding the usability of spatial memory as a cryptographic input (long-term retention, recall accuracy, cognitive load) remain at the level of hypothesis supported by references to the cognitive psychology literature, without proper empirical validation. The central claim of the article (that spatially anchored secrets offer a practical advantage over linguistic passwords) cannot be verified in the absence of usability data. It is recommended to include a pilot study with users or, in its absence, to explicitly and thoroughly acknowledge this limitation in the Discussion section.

4. The reference implementation uses What3Words as the geospatial encoding scheme (Section 4.3). The article states that the encoding scheme must be offline resolvable ("offline resolvability", line 472), but What3Words is a proprietary system that requires access to its commercial API for code resolution. This is a contradiction between the stated requirement and the chosen implementation. It is recommended to clarify how the offline resolvability property is satisfied in practice, or to select an open-source encoder (e.g., Open Location Code) as the reference implementation.

5. The GeoVault protocol uses a fixed and public hop (Section 4.4.3, lines 515-516). Although the authors justify this choice by Kerckhoffs' principle, using a fixed hop eliminates the protection provided by the hop against rainbow table attacks. In standard Argon2 practice, the hop must be unique per user. An explicit discussion of the security implications of fixed hopping, including vulnerability to table-based attacks, and a formal justification for this design decision are recommended.

6. The entropy model in Section 3.2 assumes uniform selection within spatial dictionaries (equation 7). This assumption is not empirically supported. Existing research on GeoPass (Al-Ameen and Wright, 2014) has shown that users have a strong tendency to select personally meaningful locations (home, work, vacation locations), which introduces an additional bias not captured by the spatial dictionaries proposed in Table 3. The formal effective entropy model should explicitly include this type of user-centered bias, not just global geographic restrictions.

7. Section 2.4 presents four cryptographic mechanisms (VDFs, time-lock puzzles, PoSW, memory-hard KDFs), but only the latter is actually used in the GeoVault protocol. The detailed presentation of VDFs, time-lock puzzles and PoSW takes up about two pages (Section 2.4), without these being integrated into the design or evaluation of the proposed protocol. It is recommended to either substantially reduce this section to a brief mention of the alternatives, or to integrate them into the comparative analysis or in proposals for future work.

8. Reference [29] (Garden, Cornoldi and Logie, 2002, "Visuo-spatial working memory in navigation") is cited in Section 2.2 (line 184) in the context of retaining spatially based authentication secrets for longer durations and with fewer errors compared to textual passwords. Checking the reference indicates that the original paper addresses visuospatial working memory in the context of navigation, not the retention of authentication secrets. It is recommended that this reference be checked and replaced with a source that directly supports the claim made.

9. The article has formatting and editing errors that affect the quality of the presentation. In particular: (a) reference [53] on page 15 (line 608) contains a formatting artifact: "[53? ]" with a question mark and incorrect space, indicating an incomplete reference or an error in the bibliographic management system; (b) the article metadata contains incomplete placeholder information ("Journal Not Specified", "Affiliation 1", "Current address: Affiliation", DOI placeholder); (c) in Section 2.3, line 234, the term "burial sites" appears, which is inconsistent with the technical terminology used in the rest of the article. It is recommended to correct these errors before resubmitting.

10. The threat model (Section 6.4) does not address the scenario where the attacker has partial information about the user obtained from public sources (social networks, location data from applications, travel history). Given that personally significant locations are information frequently shared online, this attack vector could significantly reduce the effective entropy below the levels estimated in Table 3. It is recommended to extend the threat model to explicitly include this scenario and quantify its impact on the effective entropy.

11. The proximity clustering model (Section 3.2.3, equation 10) assumes that the first point (anchor) is freely selected, and subsequent points are constrained within a radius r. This model does not capture the realistic scenario in which all points are selected from the same semantic context (e.g., locations from a single vacation or from the same city), without the first point having a global uniform distribution. The anchor in equation 10 should reflect the entropy collapse caused by semantic biases, not the global nominal entropy. A reformulation of the model that also allows the anchor to be subject to entropy collapse is recommended.

12. The empirical evaluation is limited to a single GPU (NVIDIA RTX A6000) and a single CPU (Intel Xeon Gold 6338). There is no evaluation on typical consumer hardware (e.g., a laptop with integrated GPU) that would be more representative of the defender scenario, nor on multi-GPU or cluster configurations that would be more representative of well-equipped attackers. It is recommended to extend the benchmarks or, at least, an explicit discussion of how the results extrapolate to other hardware configurations.

13. Rework the parts that have a high degree of probability, according to specialized detectors, to have been produced with generative AI methods. In particular, certain sections of the article show a pronounced stylistic uniformity, repetitive generic formulations and a rhetorical structure that shows indicators compatible with the production assisted by language models. It is recommended to review and reformulate the affected sections to ensure the authenticity of the authors' academic voic

# Reviewer 2

This review examines the GeoVault protocol, which aims to leverage human spatial memory for cryptographic key management. The authors propose a new approach based on a combination of geographic coordinates and the Argon2id algorithm, which is more user-friendly and secure than traditional mnemonics (BIP-39). I would like to ask for a reasoned response to the following suggestions and shortcomings in the article:

How is GPS drift eliminated in key generation?

2. "What3Words" (W3W) is a proprietary system. Doesn't relying on a closed-source commercial system in scientific work reduce the reliability of the methodology? Justify your opinion.

3. If the user makes a slight mistake in choosing a 3-meter square on the map, a completely different key is generated. The methodology does not provide "fuzzy matching" or error-tolerant algorithms.

4. There is no scientific justification for choosing the exact parameters t, m, p (it is simply stated for "commodity CPU").

5. The article says that the salt is "fixed and public". Has the methodology taken into account that the use of static salts in cryptography opens the way to "rainbow table" attacks?

6. It says that the points are combined in a "fixed canonical order". If the user remembers 3 places and swaps their sequence, the key will not work. This is a serious drawback for usability.

7. The criteria for determining the "Insecure", "Human-Scale Secure" and "Super Secure" zones in Figure 2 are not scientifically explained.

8. Attacker throughput was measured using Hashcat, but how do specially designed ASIC attacks affect the results? Justify your opinion, with facts.

9. The "Omnibus HPZ" dictionary entropy is shown as 41.38 bits. Isn't this too low (Insecure) for modern offline attacks?

10. Argon2id's 16-32 GiB memory requirement stops the attacker, but the results do not reveal how long it would take a legitimate user's device (e.g. a laptop with 8GB RAM) to calculate this key.

11. No standard deviation or confidence intervals are provided for the benchmarking results.

12. Reference 5 has an error like `PAGE:STRING:ARTICLE/CHAPTER`.

13. In 7 tables are not cited in the text. There is an error in citing the article on page 15, line 609. The reference number is replaced by "?"