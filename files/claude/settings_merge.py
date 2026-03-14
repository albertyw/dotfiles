#!/usr/bin/env python3
# Merge settings_personal.json into settings.json.
# - Lists are merged (union, preserving order).
# - Dicts are merged recursively.
# - Conflicting scalar values prompt the user to choose.

import importlib.util
import json
import sys
from pathlib import Path

_spec = importlib.util.spec_from_file_location(
    "settings_format", Path(__file__).parent / "settings_format.py"
)
assert _spec and _spec.loader
_mod = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_mod)
format_settings = _mod.format_settings


def merge(base: object, override: object, path: str = "") -> object:
    if isinstance(base, dict) and isinstance(override, dict):
        merged = dict(base)
        for key, over_val in override.items():
            if key in merged:
                merged[key] = merge(merged[key], over_val, f"{path}.{key}")
            else:
                merged[key] = over_val
        return merged

    if isinstance(base, list) and isinstance(override, list):
        merged = list(base)
        for item in override:
            if item not in merged:
                merged.append(item)
        return merged

    if base == override:
        return base

    # Conflicting scalar values – ask the user.
    print(f"\nConflict at {path or 'root'}:")
    print(f"  [1] settings.json:          {json.dumps(base)}")
    print(f"  [2] settings_personal.json: {json.dumps(override)}")
    while True:
        choice = input("Keep which value? (1/2): ").strip()
        if choice == "1":
            return base
        if choice == "2":
            return override
        print("Please enter 1 or 2.")


def find_extras(base: object, personal: object, path: str = "") -> list[str]:
    """Return paths present in base but not in personal."""
    extras: list[str] = []
    if isinstance(base, dict) and isinstance(personal, dict):
        for key, val in base.items():
            child_path = f"{path}.{key}" if path else key
            if key not in personal:
                extras.append(f"{child_path}: {json.dumps(val)}")
            else:
                extras.extend(find_extras(val, personal[key], child_path))
    elif isinstance(base, list) and isinstance(personal, list):
        for item in base:
            if item not in personal:
                extras.append(f"{path}[]: {json.dumps(item)}")
    return extras


def main() -> None:
    parent = Path(__file__).parent
    base_path = parent / "settings.json"
    personal_path = parent / "settings_personal.json"

    if not base_path.exists():
        sys.exit(f"Error: {base_path} not found")
    if not personal_path.exists():
        sys.exit(f"Error: {personal_path} not found")

    base = json.loads(base_path.read_text())
    personal = json.loads(personal_path.read_text())

    extras = find_extras(base, personal)
    if extras:
        print("Settings in settings.json but not in settings_personal.json:")
        for entry in extras:
            print(f"  {entry}")
    else:
        print("No settings in settings.json are missing from settings_personal.json.")

    merged = merge(base, personal)
    base_path.write_text(json.dumps(merged, indent=2) + "\n")
    format_settings(base_path)
    print(f"\nMerged result written to {base_path}")


if __name__ == "__main__":
    main()
