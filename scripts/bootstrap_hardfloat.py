#!/usr/bin/env python3
"""
Fetch the Berkeley HardFloat dependency into Blocks/generators.

The script prefers `git clone --depth 1` if git is available. When git
is missing it falls back to downloading a zip archive.
"""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Optional

HF_GIT_URL = "https://github.com/ucb-bar/berkeley-hardfloat.git"
DEFAULT_BRANCH = "master"


def run_git_clone(dest: Path, branch: str) -> bool:
    git = shutil.which("git")
    if not git:
        return False
    cmd = [git, "clone", "--depth", "1", "--branch", branch, HF_GIT_URL, str(dest)]
    print(f"[bootstrap] Running: {' '.join(cmd)}")
    subprocess.run(cmd, check=True)
    return True


def download_zip(dest: Path, branch: str) -> None:
    import urllib.request
    import zipfile

    url = f"https://github.com/ucb-bar/berkeley-hardfloat/archive/refs/heads/{branch}.zip"
    print(f"[bootstrap] Downloading {url}")
    with tempfile.TemporaryDirectory() as tmpdir:
        zip_path = Path(tmpdir) / "hardfloat.zip"
        with urllib.request.urlopen(url) as resp, zip_path.open("wb") as fh:
            shutil.copyfileobj(resp, fh)
        with zipfile.ZipFile(zip_path) as zf:
            zf.extractall(tmpdir)
        extracted = next(Path(tmpdir).glob("berkeley-hardfloat-*"))
        shutil.copytree(extracted, dest)


def main(argv: Optional[list[str]] = None) -> None:
    parser = argparse.ArgumentParser(description="Download Berkeley HardFloat into the expected folder")
    parser.add_argument("--branch", default=DEFAULT_BRANCH, help="HardFloat branch/tag to fetch (default: master)")
    parser.add_argument("--force", action="store_true", help="Overwrite an existing checkout")
    args = parser.parse_args(argv)

    repo_root = Path(__file__).resolve().parents[1]
    target = repo_root / "Blocks" / "generators" / "berkeley-hardfloat"
    if target.exists():
        if not args.force:
            print(f"[bootstrap] {target} already exists. Use --force to recreate.", file=sys.stderr)
            return
        shutil.rmtree(target)

    target.parent.mkdir(parents=True, exist_ok=True)
    try:
        if run_git_clone(target, args.branch):
            return
    except subprocess.CalledProcessError as exc:
        print(f"[bootstrap] git clone failed ({exc}). Falling back to zip download.")
        if target.exists():
            shutil.rmtree(target)
    download_zip(target, args.branch)
    print(f"[bootstrap] Installed HardFloat into {target}")


if __name__ == "__main__":
    main()
