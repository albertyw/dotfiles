#!/usr/bin/env python3
# This script is used to format the claude settings.json files for better version control.
# Changes include:
# 1.  Sorting all values by alphabetical order
# 2.  Enforcing a two-space indentation
# 3.  Ensuring an end-of-file newline

import json
from pathlib import Path


def sort_json(obj: object) -> object:
    if isinstance(obj, dict):
        return {k: sort_json(v) for k, v in sorted(obj.items())}
    if isinstance(obj, list):
        items = [sort_json(item) for item in obj]
        try:
            return sorted(items)  # type: ignore[type-var]
        except TypeError:
            return items
    return obj


def format_settings(path: Path) -> None:
    data = json.loads(path.read_text())
    sorted_data = sort_json(data)
    formatted = json.dumps(sorted_data, indent=2)
    path.write_text(formatted + "\n")


def main() -> None:
    parent = Path(__file__).parent
    format_settings(parent / "settings.json")
    local_path = parent / "settings.local.json"
    if local_path.exists():
        format_settings(local_path)


if __name__ == "__main__":
    main()
