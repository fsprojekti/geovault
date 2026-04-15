with open('main_track_changes.tex', 'r', encoding='utf-8') as f:
    content = f.read()

old = r'upper-bounded by \{\max} = \lfloor M_{\text{GPU}}/m \rfloor\$.'
new = r'upper-bounded by $P_{\max} = \lfloor M_{\text{GPU}}/m \rfloor$.'

if old in content:
    content = content.replace(old, new, 1)
    with open('main_track_changes.tex', 'w', encoding='utf-8') as f:
        f.write(content)
    print('Fixed')
else:
    idx = content.find('lfloor M_')
    print('NOT FOUND - context:', repr(content[max(0,idx-50):idx+100]))
