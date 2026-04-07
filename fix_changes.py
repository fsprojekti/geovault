
import os

file_path = r"c:\Users\Marko\Documents\Projects\GeoVault\mdpi\main_track_changes.tex"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Locate Red block start
start_red = content.find("{\\color{red}")
if start_red == -1:
    print("Could not find start of red block")
    exit(1)

# Locate Blue block start (which marks end of Red block)
start_blue_marker = "}\n\n{\\color{blue}"
start_blue = content.find(start_blue_marker)
if start_blue == -1:
    print("Could not find start of blue block marker")
    # Try alternative spacing
    start_blue_marker = "}\n{\\color{blue}"
    start_blue = content.find(start_blue_marker)
    if start_blue == -1:
        print("Could not find start of blue block marker (alt)")
        exit(1)

# Content before Red block
pre_red = content[:start_red]

# Locate Blue block end
end_blue_marker = "}\n\n\\section{Theoretical Background}"
end_blue = content.find(end_blue_marker)
if end_blue == -1:
    print("Could not find end of blue block marker")
    exit(1)

# content inside blue block (after the {\color{blue} wrapper)
# The start of blue content is after "{\color{blue}\n" ? No, just after the marker.
# start_blue points to "}\n\n{\color{blue}".
# So the blue block start is start_blue + len(start_blue_marker) + maybe a newline
blue_block_start_index = start_blue + len(start_blue_marker)
# Check if there is a newline after {\color{blue}
if content[blue_block_start_index] == '\n':
    blue_block_start_index += 1

# Extract Blue content
# From blue_block_start_index to end_blue
blue_content = content[blue_block_start_index:end_blue]

# Content after Blue block (including the section header)
# end_blue points to "}\n\n\section{Theoretical Background}".
# We want to keep "\n\n\section{Theoretical Background}" but without the "}"
post_blue = content[end_blue + 1:] # Skip only the '}' char

new_content = pre_red + blue_content + post_blue

with open(file_path, "w", encoding="utf-8") as f:
    f.write(new_content)

print("Successfully updated main_track_changes.tex")
