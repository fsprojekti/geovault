
#!/usr/bin/env python3
"""
strip_changes.py — generate main.tex from main_track_changes.tex.

Transforms applied:
  \\remove{...}        removed entirely
  \\add{...}           replaced with content (markup stripped)
  \\change{old}{new}   replaced with new
  \\usepackage{changes} + wrapper \\newcommand lines  removed from preamble

Usage:  python fix_changes.py
Output: mdpi/main.tex  (overwrites existing file)
"""

import re
from pathlib import Path


# ---------------------------------------------------------------------------
# Brace-matching helpers
# ---------------------------------------------------------------------------

def find_end_of_brace(text: str, start: int) -> int:
    """Given text[start] == '{', return index just past the matching '}'."""
    assert text[start] == '{', f"Expected '{{' at position {start}, got {text[start]!r}"
    depth = 1
    i = start + 1
    while i < len(text) and depth > 0:
        c = text[i]
        if c == '\\':
            i += 2          # skip \ and the immediately following char
        elif c == '{':
            depth += 1
            i += 1
        elif c == '}':
            depth -= 1
            i += 1
        else:
            i += 1
    return i                # index just past the closing '}'


def strip_command(text: str, cmd: str, keep_content: bool) -> str:
    """
    Replace every \\cmd{...} occurrence in text.
      keep_content=True  → replace with inner content  (for \\add)
      keep_content=False → replace with ''             (for \\remove)
    Correctly handles arbitrarily nested braces.
    """
    search = '\\' + cmd + '{'
    result: list[str] = []
    i = 0
    while i < len(text):
        idx = text.find(search, i)
        if idx == -1:
            result.append(text[i:])
            break
        result.append(text[i:idx])
        brace_pos = idx + len(search) - 1      # position of the opening '{'
        end_pos = find_end_of_brace(text, brace_pos)
        if keep_content:
            result.append(text[brace_pos + 1 : end_pos - 1])
        i = end_pos
    return ''.join(result)


def strip_change_command(text: str) -> str:
    """Replace \\change{old}{new} with just new."""
    search = '\\change{'
    result: list[str] = []
    i = 0
    while i < len(text):
        idx = text.find(search, i)
        if idx == -1:
            result.append(text[i:])
            break
        result.append(text[i:idx])
        brace1 = idx + len(search) - 1         # opening '{' of first arg
        end1 = find_end_of_brace(text, brace1) # position after first '}'
        j = end1
        # skip optional whitespace before second argument
        while j < len(text) and text[j] in ' \t\n\r':
            j += 1
        assert j < len(text) and text[j] == '{', (
            f"\\change at {idx}: expected second argument '{{' at {j}"
        )
        end2 = find_end_of_brace(text, j)
        result.append(text[j + 1 : end2 - 1])  # keep second (new) arg
        i = end2
    return ''.join(result)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

src = Path('mdpi/main_track_changes.tex')
dst = Path('mdpi/main.tex')

text = src.read_text(encoding='utf-8')

# Step 1: remove \remove{...} first so nested \add inside \remove is also gone
text = strip_command(text, 'remove', keep_content=False)

# Step 2: unwrap \add{...} → content
text = strip_command(text, 'add', keep_content=True)

# Step 3: \change{old}{new} → new  (if any present)
text = strip_change_command(text)

# Step 4: remove \usepackage[...]{changes} line
text = re.sub(
    r'^[ \t]*\\usepackage(?:\[[^\]]*\])?\{changes\}[ \t]*\r?\n',
    '',
    text,
    flags=re.MULTILINE,
)

# Step 5: remove the wrapper \newcommand lines that delegate to
#         \added{}, \deleted{}, \replaced{} from the changes package
text = re.sub(r'^[ \t]*\\newcommand\{\\add\}\[1\]\{\\added\{#1\}\}[ \t]*\r?\n',
              '', text, flags=re.MULTILINE)
text = re.sub(r'^[ \t]*\\newcommand\{\\remove\}\[1\]\{\\deleted\{#1\}\}[ \t]*\r?\n',
              '', text, flags=re.MULTILINE)
text = re.sub(r'^[ \t]*\\newcommand\{\\change\}\[2\]\{\\replaced\{#2\}\{#1\}\}[ \t]*\r?\n',
              '', text, flags=re.MULTILINE)
text = re.sub(r'^[ \t]*\\newcommand\{\\note\}\[2\]\[\]\{\}[ \t]*\r?\n',
              '', text, flags=re.MULTILINE)

dst.write_text(text, encoding='utf-8')
print(f'Written: {dst}')

# Sanity check
remaining_add    = text.count('\\add{')
remaining_remove = text.count('\\remove{')
if remaining_add or remaining_remove:
    print(f'WARNING: {remaining_add} \\add{{  and  {remaining_remove} \\remove{{  still present in output!')
else:
    print('All track-changes markup stripped successfully.')

