data = open(r'C:\Users\Marko\Documents\Projects\GeoVault\mdpi\main_track_changes.tex', 'rb').read()

old = b"All parameters $(t,m,p)$ are assumed to be known to the attacker, consistent with Kerckhoffs\xe2\x80\x99 principle. Security arises from the enforced memory footprint of Equation~\\ref{eq:argon2}, which bounds attacker parallelism by available high-bandwidth memory. The resulting defender-attacker asymmetry and its impact on offline brute-force resistance are quantified empirically in Section~5."

add_para = (
    b"\r\n\r\n"
    b"\\add{\\paragraph{Fixed salt and rainbow table resistance.} "
    b"The use of a fixed, public salt is an intentional design decision consistent with established practice. "
    b"Notably, the BIP-39 standard employs the same approach: wallet keys are derived via "
    b"$\\mathsf{PBKDF2}(\\textit{mnemonic},\\,\\texttt{\"mnemonic\"},\\,2048)$, "
    b"where the salt is the fixed public string \\texttt{\"mnemonic\"} (optionally appended with a user passphrase). "
    b"Rainbow table attacks are infeasible against GeoVault for two independent reasons. "
    b"First, constructing a rainbow table requires precomputing $\\mathsf{Argon2id}$ over the full input space; "
    b"at the reference memory parameter ($m = 4\\,\\mathrm{GiB}$), each evaluation occupies $4\\,\\mathrm{GiB}$ "
    b"of high-bandwidth memory, making a table covering even $2^{40}$ entries physically unrealizable with current hardware. "
    b"Second, the nominal spatial entropy of the KDF input reaches $45.7n$ bits for $n$ selected points (Section~3.2), "
    b"yielding $2^{45.7}$ candidates per additional point---a space orders of magnitude beyond any feasible precomputation budget. "
    b"The fixed salt therefore introduces no exploitable weakness beyond what the spatial entropy model "
    b"and the KDF cost parameters already account for.}"
)

print('old found:', old in data)
if old in data:
    data2 = data.replace(old, old + add_para, 1)
    open(r'C:\Users\Marko\Documents\Projects\GeoVault\mdpi\main_track_changes.tex', 'wb').write(data2)
    print('done, new size:', len(data2))
else:
    print('NOT FOUND')
