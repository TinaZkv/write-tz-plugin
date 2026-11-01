"""Jira wiki markup TZ -> Markdown with images from the illustrations folder.
Usage: python -I jira2md.py <in.txt> <out.md> <images dir name relative to out.md>"""
import re, sys
from pathlib import Path

src, dst, imgdir = sys.argv[1], sys.argv[2], sys.argv[3]
lines = open(src, encoding="utf-8").read().replace("\r\n", "\n").split("\n")
IMGURL = imgdir.replace(" ", "%20")


def inline(t):
    t = re.sub(r"<([^<>\n]+)>", r"\\<\1\\>", t)                       # placeholders <N> stay visible
    t = re.sub(r"\[([^|\]]+)\|(https?://[^\]]+)\]", r"[\1](\2)", t)  # Jira link -> md link
    t = re.sub(r"(?<![\w*\\])\*([^*\n]+?)\*(?![\w*])", r"**\1**", t)   # *bold* -> **bold**
    return t


out, in_code, num = [], False, 0
for ln in lines:
    if ln.strip() == "{noformat}":
        out.append("```"); in_code = not in_code; continue
    if in_code:
        out.append(ln); continue
    m = re.match(r"^h([1-6])\.\s+(.*)$", ln)
    if m:
        out.append("#" * int(m.group(1)) + " " + inline(m.group(2))); num = 0; continue
    m = re.match(r"^!([^|!]+)(\|[^!]*)?!$", ln.strip())
    if m:
        name = m.group(1)
        out.append(f'<a href="{IMGURL}/{name}"><img src="{IMGURL}/{name}" alt="{Path(name).stem.replace("_", " ")}" width="320"></a>'); continue
    if ln.startswith("||"):
        cells = [c.strip() for c in ln.strip().strip("|").split("||")]
        out.append("| " + " | ".join(inline(c) for c in cells) + " |")
        out.append("|" + "|".join("---" for _ in cells) + "|"); continue
    if ln.startswith("|"):
        cells = [c.strip() for c in ln.strip().strip("|").split("|")]
        out.append("| " + " | ".join(inline(c) for c in cells) + " |"); continue
    m = re.match(r"^(\*+)\s+(.*)$", ln)
    if m:
        out.append("  " * (len(m.group(1)) - 1) + "- " + inline(m.group(2))); continue
    m = re.match(r"^#\s+(.*)$", ln)
    if m:
        num += 1; out.append(f"{num}. " + inline(m.group(1))); continue
    if not ln.strip():
        num = 0 if not (out and re.match(r"^\d+\. ", out[-1])) else num
    out.append(inline(ln))

text = "\n".join(out)
text = re.sub(r"\n{3,}", "\n\n", text)
open(dst, "w", encoding="utf-8").write(text)
from urllib.parse import unquote
srcs = [unquote(x) for x in re.findall(r'<img src="([^"]+)"', text)]
missing = [x for x in srcs if not (Path(dst).parent / x).exists()]
print("images:", len(srcs), "missing:", missing)
