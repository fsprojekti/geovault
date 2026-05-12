import re
with open('main_track_changes.tex', encoding='utf-8') as f:
    tex = f.read()
keys = set()
for m in re.finditer(r'\\cite\{([^}]+)\}', tex):
    for k in m.group(1).split(','):
        keys.add(k.strip())
for k in sorted(keys):
    print(k)
