
import os

original_path = r"c:\Users\Marko\Documents\Projects\GeoVault\mdpi\main_original.tex"
track_changes_path = r"c:\Users\Marko\Documents\Projects\GeoVault\mdpi\main_track_changes.tex"

# Read original content
with open(original_path, "r", encoding="utf-8") as f:
    original_content = f.read()

# Define split point marker (the last sentence in track_changes_path)
marker = "altering the security model or attacker assumptions."

# Find the marker in original content
split_index = original_content.find(marker)

if split_index == -1:
    print(f"Error: Marker '{marker}' not found in original file.")
    exit(1)

# The content to append starts after the marker
# We might need to handle potential newline differences or spacing
content_to_append = original_content[split_index + len(marker):]

# Read current track changes content to ensure we append correctly
with open(track_changes_path, "r", encoding="utf-8") as f:
    current_track_content = f.read()

# Check if the file already ends with the marker (it should)
if not current_track_content.strip().endswith(marker):
    print("Warning: track_changes file does not end with the expected marker. Appending anyway, but check for duplication.")
    # In case the file has some trailing newlines, we strip and check
    # But broadly we just want to append the missing part.

# Append the content
with open(track_changes_path, "a", encoding="utf-8") as f:
    f.write(content_to_append)

print("Successfully appended missing content to main_track_changes.tex")
