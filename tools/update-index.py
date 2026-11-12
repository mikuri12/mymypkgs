#!/usr/bin/env python3
"""Utilidades del index.toml del Release rodante packages (mymypkgs).

Modos:
  merge <index.toml> <tarball>...   -> index con la(s) entrada(s) del paquete
  haspkg <index.toml> <pkg>           -> exit 0 si el paquete esta en el index
  check <index.toml> <repo> <rel>     -> lista assets (mas recientes por paquete)
                                   que NO aparecen en el index
"""
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.request

HDR_RE = re.compile(r"\A(.*?)(?=\[\[pkg\]\])", re.S)
ENTRY_RE = re.compile(r"\[\[pkg\]\]\n(.*?)(?=\n\[\[pkg\]\]|\Z)", re.S)


def api_assets(repo, release):
    req = urllib.request.Request(
        "https://api.github.com/repos/%s/releases/tags/%s" % (repo, release),
        headers={"User-Agent": "mymypkgs-index",
                 "Authorization": "token " + os.environ.get("GH_TOKEN", "")})
    with urllib.request.urlopen(req) as r:
        data = json.load(r)
    out = []
    for a in data.get("assets", []):
        if not a["name"].endswith(".tar.zst"):
            continue
        base = a["name"][:-len(".tar.zst")]
        parts = base.rsplit("-", 2)
        if len(parts) != 3:
            continue
        out.append((parts[0], a["name"], a.get("updated_at") or ""))
    return out


def parse_index(text):
    entries = []
    for m in ENTRY_RE.finditer(text):
        body = "[[pkg]]\n" + m.group(1).rstrip() + "\n"
        nm = re.search(r"name = \"([^\"]+)\"", body)
        entries.append([nm.group(1) if nm else "", body])
    return entries


def block_for(tarball):
    here = os.path.dirname(os.path.abspath(__file__))
    tmp = tempfile.mkdtemp()
    try:
        shutil.copy(tarball, tmp)
        out = subprocess.run(["bash", os.path.join(here, "make-index.sh"), tmp],
                             capture_output=True, text=True, check=True).stdout
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    return ["[[pkg]]\n" + p.rstrip() + "\n" for p in out.split("[[pkg]]")[1:]]


def merge(text, tarballs):
    entries = parse_index(text)
    for tb in tarballs:
        pkgname = os.path.basename(tb)[:-len(".tar.zst")].rsplit("-", 2)[0]
        for blk in block_for(tb):
            entries = [e for e in entries if e[0] != pkgname]
            entries.append([pkgname, blk])
    m = HDR_RE.match(text)
    header = m.group(1) if m else ""
    return header + "".join(b for _, b in entries)


def newest_missing(text, repo, release):
    listed = set(re.findall(r"filename = \"([^\"]+)\"", text))
    best = {}
    for pkg, fname, upd in api_assets(repo, release):
        if pkg not in best or upd > best[pkg][1]:
            best[pkg] = (fname, upd)
    miss = []
    for pkg, (fname, upd) in sorted(best.items()):
        if fname not in listed:
            miss.append(fname)
    return miss


def cmd_merge(argv):
    text = open(argv[0]).read() if os.path.exists(argv[0]) else ""
    sys.stdout.write(merge(text, argv[1:]))


def cmd_haspkg(argv):
    text = open(argv[0]).read() if os.path.exists(argv[0]) else ""
    names = [n for n, _ in parse_index(text)]
    sys.exit(0 if argv[1] in names else 1)


def cmd_check(argv):
    text = open(argv[0]).read() if os.path.exists(argv[0]) else ""
    miss = newest_missing(text, argv[1], argv[2])
    for m in miss:
        print(m)
    sys.exit(1 if miss else 0)


if __name__ == "__main__":
    cmds = {"merge": cmd_merge, "haspkg": cmd_haspkg, "check": cmd_check}
    if sys.argv[1] not in cmds or len(sys.argv) < 3:
        raise SystemExit("uso: update-index.py {merge|haspkg|check} ...")
    cmds[sys.argv[1]](sys.argv[2:])
