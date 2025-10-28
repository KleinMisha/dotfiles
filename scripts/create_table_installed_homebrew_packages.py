import subprocess
import json
from typing import Any
import re
from pathlib import Path

README = "./README.md"
FALLBACK = "./brew_table.md"


def main() -> None:
    requests = ["name", "desc", "homepage"]
    installed_packages = get_installed_brew_packages()
    package_info = construct_package_info(installed_packages, requests)
    md_info_table = create_markdown_table(package_info)
    write_to_md(md_info_table)


def get_installed_brew_packages() -> list[str]:
    """Retrieves a list of package names installed via Homebrew (MacOS)"""
    formulae = run_brew_command(
        ["brew", "list", "--formulae", "--installed-on-request"]
    )
    casks = run_brew_command(["brew", "list", "--casks"])
    return formulae + casks


def run_brew_command(cmd: list[str]) -> list[str]:
    """
    Run the command and retrieve the string response
    """
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.stdout.strip().splitlines()


def get_brew_info(package_name: str) -> dict[str, Any]:
    """
    Use `brew info` with the json flag to get a JSON-formatted response that contains the Description field
    """
    result = subprocess.run(
        ["brew", "info", "--json=v2", package_name], capture_output=True, text=True
    )
    brew_info = json.loads(result.stdout)
    return brew_info


def is_formula(brew_info: dict[str, Any]) -> bool:
    if "formulae" in brew_info.keys() and brew_info["formulae"]:
        return True
    return False


def get_package_information(brew_info: dict[str, Any], field: str) -> str:
    """
    Fetch the information from the nested dictionary you get as a response when calling the brew_info.
    description is in "formulae/casks" -> [0] -> 'desc'
    homepage is in "formulae/casks" -> [0] -> 'homepage'
    etc.
    """
    if is_formula(brew_info):
        key = "formulae"
    else:
        key = "casks"
    entry: str | list[str] = brew_info[key][0].get(field, "-")
    if isinstance(entry, list):
        return entry[0]
    # if the entry is None, return a fallback string
    return entry or "-"


def construct_package_info(
    package_names: list[str], requested_info: list[str]
) -> dict[str, dict[str, str]]:
    """Construct a dictionary mapping package names to the description (and other info to be displayed in the README.md)"""

    package_info: dict[str, dict[str, str]] = {}
    for package_name in package_names:
        brew_info = get_brew_info(package_name)
        package_info[package_name] = {
            field: get_package_information(brew_info, field) for field in requested_info
        }
        package_info[package_name].update(
            {
                "formula/cask": "formula" if is_formula(brew_info) else "cask",
            }
        )
    return package_info


def create_markdown_table(package_info: dict[str, dict[str, str]]) -> str:
    """A table in the format that can be added into the README.md"""
    # create the table header. All entry fields are the same for all package, just use the first one to fetch the available names
    pkg_info = package_info[list(package_info.keys())[0]]
    # infer the column names from the supplied dictionary
    column_names = "|" + "|".join([column_name for column_name in pkg_info.keys()])
    # create the |----| line below the column_names. Scale the column width with its header name
    separator_line = "|" + "|".join(
        ["-" * len(column_name) for column_name in pkg_info.keys()]
    )
    header = "\n".join([column_names, separator_line])

    # table body
    # a growing list of content lines
    entries: list[str] = []
    for _, pkg_info in package_info.items():
        # the information for the given package goes in the next line
        try:
            new_entry = "|".join(pkg_info.values())
        except Exception:
            print(pkg_info.values())
            new_entry = ""
        entries.append(new_entry)
    body = "\n".join(entries)

    # build the final table by putting things on new lines
    table = "\n".join([header, body])
    return table


def update_readme_md(
    markdown_table: str,
    readme_path: Path = Path(README),
) -> None:
    """Places the generated markdown table in the README.md"""
    with readme_path.open("r") as old_readme_file:
        content = old_readme_file.read()

    # Search for the section header (group 1), followed by anything until
    # \n## :: A new line + new h2 level header --> A new section
    # \n# :: A new line + new h1 level header --> A new section
    # $ :: The end of file indicator
    pattern = r"(## Installed Software\n).*?(?=\n## |\n# |$)"

    # The \\1 pattern keeps the content of the first group ("## Installed Software")
    replacement = f"\\1\n{markdown_table}\n"
    # re.DOTALL allows for the \n character to also be included when searching for all ".". Otherwise match stops immediately after the header itself
    new_content = re.sub(pattern, replacement, content, flags=re.DOTALL)

    # (over)-write the new contents to the README.md file
    with readme_path.open("w") as new_readme_file:
        new_readme_file.write(new_content)


def write_to_md(
    markdown_table: str,
    readme_path: Path = Path(README),
    fallback_path: Path = Path(FALLBACK),
) -> None:
    """Save the table in a Markdown file. Make sure to always write something, and not crash after doing all these brew info calls"""
    if readme_path.exists():
        update_readme_md(markdown_table, readme_path)
        print(f"Successfully updated {readme_path}")
    else:
        print(f"Cannot find {readme_path}, will write the table into {fallback_path}")
        with fallback_path.open("w") as fallback_file:
            fallback_file.write(markdown_table)
        print(f"Successfully wrote the table into {fallback_path}")


if __name__ == "__main__":
    main()
