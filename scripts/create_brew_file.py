"""
Create a BrewFile: A list of all packages installed via Homebrew that can be used to redo this in batch mode on a new machine
"""

import subprocess
from pathlib import Path


# by convention, it is placed at the top level of this repository
BREWFILE = "./BrewFile"


def main() -> None:
    formulae, casks = get_installed_brew_packages()
    create_brew_file(formulae, casks)


def get_installed_brew_packages() -> tuple[list[str], list[str]]:
    """Retrieves a list of package names installed via Homebrew (MacOS)"""
    formulae = run_brew_command(
        ["brew", "list", "--formulae", "--installed-on-request"]
    )
    casks = run_brew_command(["brew", "list", "--casks"])
    return formulae, casks


def run_brew_command(cmd: list[str]) -> list[str]:
    """
    Run the command and retrieve the string response
    """
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.stdout.strip().splitlines()


def create_brew_file(
    formulae: list[str], casks: list[str], brewfile_path: Path = Path(BREWFILE)
) -> None:
    with open(brewfile_path, "w") as brew_file:
        for formula in formulae:
            brew_file.write(f"brew {formula}\n")
        for cask in casks:
            brew_file.write(f"cask {cask}\n")

    print(f"Successfully wrote only the installed packages into: {brewfile_path}")


if __name__ == "__main__":
    main()
