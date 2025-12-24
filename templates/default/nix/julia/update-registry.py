import json
import subprocess
from pathlib import Path

import nima


def update_github_src(src):
    print("Updating Julia registry...")
    owner = src.argument["owner"].value
    repo = src.argument["repo"].value

    result = json.loads(
        subprocess.run(
            [
                "nix-prefetch-git",
                "--url",
                f"https://github.com/{owner}/{repo}",
                "--quiet",
            ],
            capture_output=True,
            text=True,
            check=True,
        ).stdout
    )

    src.argument["rev"].value = result["rev"]
    src.argument["hash"].value = result["hash"]


def main():
    registry = Path("_registry.nix")
    code = nima.parse(registry.read_bytes())

    src = code.value[0].output
    update_github_src(src)
    registry.write_text(code.rebuild())


if __name__ == "__main__":
    main()
