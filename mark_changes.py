
import re

def wrap_paragraphs(text, command):
    # Split by double newlines to get paragraphs
    # Use re.split to handle multiple newlines
    paras = re.split(r'\n\s*\n', text.strip())
    wrapped = []
    for p in paras:
        if p.strip():
            wrapped.append(f"\\{command}{{{p.strip()}}}")
    return "\n\n".join(wrapped)

def process_section_2_2(orig, new):
    start_marker = "More recently, spatial interfaces"
    # End before 2.3
    end_marker = "\\subsection{Geospatial Encoding Systems}"
    
    # OLD
    start_idx_old = orig.find(start_marker)
    if start_idx_old == -1: return None, None, "Old 2.2 start not found"
    end_idx_old = orig.find(end_marker)
    if end_idx_old == -1: return None, None, "Old 2.2 end not found"
    old_text = orig[start_idx_old:end_idx_old].strip()
    
    # NEW
    start_idx_new = new.find(start_marker)
    if start_idx_new == -1: return None, None, "New 2.2 start not found"
    end_idx_new = new.find(end_marker)
    if end_idx_new == -1: return None, None, "New 2.2 end not found"
    new_text = new[start_idx_new:end_idx_new].strip()
    
    markup = wrap_paragraphs(old_text, "remove") + "\n\n" + wrap_paragraphs(new_text, "add")
    return new_text, markup, None

def process_section_2_4(orig, new):
    # Titles are different!
    title_old = "\\subsection{Encryption Techniques for Burying Secrets}"
    title_new = "\\subsection{Encryption Techniques for Hardening Secrets}"
    
    end_marker = "\\section{Theoretical Background}"
    
    # OLD body
    # Find title
    t_idx_old = orig.find(title_old)
    if t_idx_old == -1: return None, None, "Old 2.4 title not found"
    # Content starts after title
    content_start_old = t_idx_old + len(title_old)
    end_idx_old = orig.find(end_marker)
    if end_idx_old == -1: return None, None, "Old 2.4 end not found"
    
    old_body = orig[content_start_old:end_idx_old].strip()
    
    # NEW body
    t_idx_new = new.find(title_new)
    if t_idx_new == -1: return None, None, "New 2.4 title not found"
    content_start_new = t_idx_new + len(title_new)
    end_idx_new = new.find(end_marker)
    if end_idx_new == -1: return None, None, "New 2.4 end not found"
    
    new_body = new[content_start_new:end_idx_new].strip()
    
    # Construct replacement block
    # We want to replace the whole subsection command + body in 'new'
    # with: \subsection{\remove{Old Title}\add{New Title}} \n \remove{old body} \add{new body}
    
    # Extract raw titles content
    raw_title_old = "Encryption Techniques for Burying Secrets"
    raw_title_new = "Encryption Techniques for Hardening Secrets"
    
    new_block = f"\\subsection{{\\remove{{{raw_title_old}}} \\add{{{raw_title_new}}}}}"
    new_block += "\n\n" + wrap_paragraphs(old_body, "remove")
    new_block += "\n\n" + wrap_paragraphs(new_body, "add")
    
    # The text we are replacing in 'new' is everything from title start to end marker
    target_text = new[t_idx_new:end_idx_new]
    
    return target_text, new_block, None


def main():
    with open("mdpi/main_original.tex", "r", encoding="utf-8") as f:
        orig = f.read()
    with open("mdpi/main_track_changes.tex", "r", encoding="utf-8") as f:
        new = f.read()

    # 2.2
    target_22, markup_22, err = process_section_2_2(orig, new)
    if err:
        print(f"Error 2.2: {err}")
    else:
        new = new.replace(target_22, markup_22)
        print("Processed 2.2")

    # 2.4
    target_24, markup_24, err = process_section_2_4(orig, new)
    if err:
        print(f"Error 2.4: {err}")
    else:
        new = new.replace(target_24, markup_24)
        print("Processed 2.4")

    # Add package
    pkg_str = "\\usepackage[margins]{trackchanges}\n\\addeditor{MC}\n"
    if "\\usepackage{xcolor}" in new:
        new = new.replace("\\usepackage{xcolor}", "\\usepackage{xcolor}\n" + pkg_str)
    else:
        # Fallback if xcolor not found (unlikely)
        new = new.replace("\\begin{document}", pkg_str + "\\begin{document}")

    with open("mdpi/main_track_changes.tex", "w", encoding="utf-8") as f:
        f.write(new)
    print("Saved main_track_changes.tex")

if __name__ == "__main__":
    main()
