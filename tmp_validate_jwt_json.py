import re, json, pathlib
path = pathlib.Path(r'c:\Users\buzzl\projects\documentation\content\waf\policies\jwt-protection.md')
text = path.read_text(encoding='utf-8')
blocks = re.split(r'```(?:json|shell)\n', text)
# the first element is text before first fence
offset = 1
errors = []
for idx, part in enumerate(blocks[1:], start=1):
    # find end fence
    end = part.find('```')
    if end == -1:
        continue
    block = part[:end]
    # decide if fence is json or shell by checking preceding text
    # naive: use regex findall of fences to get exact type

print('done')
