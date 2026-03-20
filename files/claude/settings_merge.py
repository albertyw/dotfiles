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

IGNORED_KEYS = frozenset({"model", "effortLevel"})

# Each change is (path, personal_value, settings_value)
Change = tuple[str, str, str]


def _join_path(path: str, key: str) -> str:
    return f"{path}.{key}" if path else key


def merge(base: object, override: object, path: str = "") -> object:
    if isinstance(base, dict) and isinstance(override, dict):
        merged = dict(base)
        for key, over_val in override.items():
            if key in merged:
                merged[key] = merge(merged[key], over_val, _join_path(path, key))
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


def collect_changes(base: object, personal: object, path: str = "") -> list[Change]:
    """Diff base and personal, returning (path, personal_value, settings_value) tuples."""
    changes: list[Change] = []
    if isinstance(base, dict) and isinstance(personal, dict):
        for key, val in personal.items():
            child_path = _join_path(path, key)
            if key not in base:
                changes.append((child_path, json.dumps(val), ""))
            else:
                changes.extend(collect_changes(base[key], val, child_path))
        for key, val in base.items():
            if key in IGNORED_KEYS:
                continue
            child_path = _join_path(path, key)
            if key not in personal:
                changes.append((child_path, "", json.dumps(val)))
    elif isinstance(base, list) and isinstance(personal, list):
        for item in personal:
            if item not in base:
                changes.append((f"{path}[]", json.dumps(item), ""))
        for item in base:
            if item not in personal:
                changes.append((f"{path}[]", "", json.dumps(item)))
    elif base != personal:
        changes.append((path, json.dumps(personal), json.dumps(base)))
    return changes


def print_table(rows: list[Change]) -> None:
    col1 = max(len(r[0]) for r in rows)
    col2 = max(len(r[1]) for r in rows)
    header = ("setting", "settings_personal.json", "settings.json")
    col1 = max(col1, len(header[0]))
    col2 = max(col2, len(header[1]))
    print(f"  {header[0]:<{col1}}  {header[1]:<{col2}}  {header[2]}")
    print(f"  {'-' * col1}  {'-' * col2}  {'-' * len(header[2])}")
    for path, personal_val, settings_val in rows:
        print(f"  {path:<{col1}}  {personal_val:<{col2}}  {settings_val or '(added)'}")


def main() -> None:
    parent = Path(__file__).parent
    base_path = parent / "settings.json"
    personal_path = parent / "settings_personal.json"

    if not personal_path.exists():
        sys.exit(f"Error: {personal_path} not found")

    original_text = base_path.read_text() if base_path.exists() else ""
    base = json.loads(original_text) if original_text else {}
    personal = json.loads(personal_path.read_text())

    changes = collect_changes(base, personal)

    merged = merge(base, personal)
    base_path.write_text(json.dumps(merged, indent=2) + "\n")
    format_settings(base_path)
    file_changed = base_path.read_text() != original_text

    if changes or file_changed:
        print("claude settings:")
        if changes:
            print_table(changes)


if __name__ == "__main__":
    main()
