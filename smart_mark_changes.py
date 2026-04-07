
import re
import difflib

def split_paras(text):
    return re.split(r'\n\s*\n', text.strip())

def reconstruct_paras(diffs):
    # diffs is list of (tag, i1, i2, j1, j2) from SequenceMatcher
    # on lists of paragraphs.
    output = []
    
    # We need the source lists to access content
    # stored in closure or passed?
    # Let's assume we pass lists of paragraphs
    pass

def mark_changes(old_text, new_text):
    old_paras = [p.strip() for p in split_paras(old_text) if p.strip()]
    new_paras = [p.strip() for p in split_paras(new_text) if p.strip()]
    
    matcher = difflib.SequenceMatcher(None, old_paras, new_paras)
    
    result = []
    
    for tag, i1, i2, j1, j2 in matcher.get_opcodes():
        if tag == 'equal':
            for k in range(i1, i2):
                result.append(old_paras[k])
        elif tag == 'replace':
            for k in range(i1, i2):
                result.append(f"\\remove{{{old_paras[k]}}}")
            for k in range(j1, j2):
                result.append(f"\\add{{{new_paras[k]}}}")
        elif tag == 'delete':
            for k in range(i1, i2):
                result.append(f"\\remove{{{old_paras[k]}}}")
        elif tag == 'insert':
            for k in range(j1, j2):
                result.append(f"\\add{{{new_paras[k]}}}")
                
    return "\n\n".join(result)

def main():
    with open("mdpi/main_original.tex", "r", encoding="utf-8") as f:
        orig = f.read()
    with open("mdpi/main_track_changes.tex", "r", encoding="utf-8") as f:
        new = f.read()

    # --- Section 2.2 ---
    header_22 = "\\subsection{Human Spatial Memory as a Cryptographic Asset}"
    next_header_22 = "\\subsection{Geospatial Encoding Systems}"
    
    idx_orig_start = orig.find(header_22) + len(header_22)
    idx_orig_end = orig.find(next_header_22)
    old_body_22 = orig[idx_orig_start:idx_orig_end].strip()
    
    idx_new_start = new.find(header_22) + len(header_22)
    idx_new_end = new.find(next_header_22)
    new_body_22 = new[idx_new_start:idx_new_end].strip()
    
    marked_22 = mark_changes(old_body_22, new_body_22)
    
    # Replace in `new`
    # We replace from new_start to new_end with the marked content
    # BUT we need to be careful with string slicing since indices change if we modify `new` in place.
    # Better to construct `new` piece by piece or calculate offsets.
    
    # Let's construct `final_new`
    
    # --- Section 2.4 ---
    header_24_old = "\\subsection{Encryption Techniques for Burying Secrets}"
    header_24_new = "\\subsection{Encryption Techniques for Hardening Secrets}"
    next_header_24 = "\\section{Theoretical Background}"
    
    idx_orig_start_24 = orig.find(header_24_old) + len(header_24_old)
    idx_orig_end_24 = orig.find(next_header_24)
    old_body_24 = orig[idx_orig_start_24:idx_orig_end_24].strip()
    
    idx_new_start_24 = new.find(header_24_new) + len(header_24_new)
    idx_new_end_24 = new.find(next_header_24)
    new_body_24 = new[idx_new_start_24:idx_new_end_24].strip()
    
    marked_24 = mark_changes(old_body_24, new_body_24)
    
    # Construct Title Replacement for 2.4
    marked_title_24 = "\\subsection{\\remove{Encryption Techniques for Burying Secrets} \\add{Encryption Techniques for Hardening Secrets}}"
    
    # --- Assemble ---
    # We will build the file from `new` by replacing the sections.
    # To avoid index shifting issues, we'll replace the *text content* using replace() 
    # but that might be risky if content is not unique.
    # Given the content is likely unique enough (whole paragraphs), replace() should be safe 
    # IF we replace the specific extracted block.
    
    # Section 2.2
    # The block we extracted from `new` was `new[idx_new_start:idx_new_end]`.
    # But `strip()` removed whitespace. We should replace the exact slice.
    
    # Slice 2.2
    part1 = new[:idx_new_start] # Upto end of header 2.2
    part2 = "\n\n" + marked_22 + "\n\n" # The new body
    part3 = new[idx_new_end:idx_new_start_24 - len(header_24_new)] # From 2.3 start to 2.4 start
    
    # Section 2.4
    # part3 ends just before `\subsection{Encryption...Hardening...}`
    part4 = marked_title_24 + "\n\n" + marked_24 + "\n\n"
    part5 = new[idx_new_end_24:] # From Section 3 start onwards
    
    final_content = part1 + part2 + part3 + part4 + part5
    
    # Add Package
    pkg_str = "\\usepackage[margins]{trackchanges}\n\\addeditor{MC}\n"
    if "\\usepackage{xcolor}" in final_content:
        final_content = final_content.replace("\\usepackage{xcolor}", "\\usepackage{xcolor}\n" + pkg_str)
    else:
        final_content = final_content.replace("\\begin{document}", pkg_str + "\\begin{document}")

    with open("mdpi/main_track_changes.tex", "w", encoding="utf-8") as f:
        f.write(final_content)
    print("Applied smart changes.")

if __name__ == "__main__":
    main()
