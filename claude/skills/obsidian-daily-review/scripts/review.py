#!/usr/bin/env python3
"""
Obsidian Daily Review Script
Carries over incomplete tasks and context from yesterday to today.
"""

import os
import re
import sys
from datetime import datetime, timedelta
from pathlib import Path
from typing import List, Tuple


TASKS_SECTION = "## Tasks"


def get_vault_path() -> Path:
    """Get Obsidian vault path from environment variable."""
    vault_path = os.getenv("OBSIDIAN_VAULT_PATH")
    if not vault_path:
        print("Error: OBSIDIAN_VAULT_PATH not set", file=sys.stderr)
        print("Please set it in ~/.zshrc:", file=sys.stderr)
        print('  export OBSIDIAN_VAULT_PATH="/path/to/vault"', file=sys.stderr)
        sys.exit(1)

    path = Path(vault_path).expanduser()
    if not path.exists():
        print(f"Error: Vault path does not exist: {path}", file=sys.stderr)
        sys.exit(1)

    return path


def get_daily_note_path(vault: Path, date: datetime) -> Path:
    """Get path to daily note for given date."""
    filename = date.strftime("%Y-%m-%d.md")
    return vault / filename


def read_note(path: Path) -> str:
    """Read note content."""
    if not path.exists():
        return ""

    with open(path, "r", encoding="utf-8") as f:
        return f.read()


def extract_incomplete_tasks(content: str) -> List[str]:
    """Extract incomplete tasks from note content."""
    tasks = []
    for line in content.split("\n"):
        # Match unchecked checkbox tasks
        if re.match(r"^\s*-\s+\[\s+\]", line):
            tasks.append(line.strip())

    return tasks


def extract_context(content: str) -> List[str]:
    """Extract ongoing project/context information."""
    context = []

    # Look for lines with wiki links (ongoing projects)
    for line in content.split("\n"):
        # Match lines containing [[links]] but not task checkboxes
        if "[[" in line and not re.match(r"^\s*-\s+\[[ x]\]", line):
            # Skip section headers
            if not line.strip().startswith("#"):
                context.append(line.strip())

    return context


def find_tasks_section(content: str) -> Tuple[int, int]:
    """
    Find the ## Tasks section in content.
    Returns (start_line_index, end_line_index).
    end_line_index is the line before the next ## section or end of file.
    """
    lines = content.split("\n")
    start_idx = None
    end_idx = len(lines)

    for i, line in enumerate(lines):
        if line.strip() == TASKS_SECTION:
            start_idx = i
        elif start_idx is not None and line.strip().startswith("## "):
            # Found next section
            end_idx = i
            break

    if start_idx is None:
        return (-1, -1)

    return (start_idx, end_idx)


def insert_carried_over_content(content: str, tasks: List[str], context: List[str], yesterday_date: str) -> str:
    """Insert carried over tasks and context into today's note."""
    if not tasks and not context:
        return content

    lines = content.split("\n")
    start_idx, end_idx = find_tasks_section(content)

    if start_idx == -1:
        print(f"Error: {TASKS_SECTION} section not found in today's note", file=sys.stderr)
        sys.exit(1)

    # Build insertion content
    insertion = [f"<!-- Carried over from {yesterday_date} -->"]

    # Add tasks
    for task in tasks:
        insertion.append(task)

    # Convert context to tasks
    for ctx in context:
        insertion.append(f"- [ ] {ctx}")

    insertion.append("")  # Empty line after carried over content

    # Insert after ## Tasks line
    lines = lines[:start_idx + 1] + insertion + lines[start_idx + 1:]

    return "\n".join(lines)


def main():
    """Main execution."""
    vault = get_vault_path()

    today = datetime.now()
    yesterday = today - timedelta(days=1)

    yesterday_path = get_daily_note_path(vault, yesterday)
    today_path = get_daily_note_path(vault, today)

    # Check if today's note exists
    if not today_path.exists():
        print(f"Error: Today's note not found: {today_path}", file=sys.stderr)
        print("Please create today's note first", file=sys.stderr)
        sys.exit(1)

    # Read yesterday's note
    yesterday_content = read_note(yesterday_path)
    if not yesterday_content:
        print(f"Info: Yesterday's note not found or empty: {yesterday_path}")
        print("Nothing to carry over")
        sys.exit(0)

    # Extract content to carry over
    tasks = extract_incomplete_tasks(yesterday_content)
    context = extract_context(yesterday_content)

    if not tasks and not context:
        print("Info: No incomplete tasks or context to carry over")
        sys.exit(0)

    # Read today's note
    today_content = read_note(today_path)

    # Insert carried over content
    yesterday_date = yesterday.strftime("%Y-%m-%d")
    updated_content = insert_carried_over_content(today_content, tasks, context, yesterday_date)

    # Write back to today's note
    with open(today_path, "w", encoding="utf-8") as f:
        f.write(updated_content)

    print(f"✓ Carried over {len(tasks)} tasks and {len(context)} context items")
    print(f"  From: {yesterday_path.name}")
    print(f"  To:   {today_path.name}")


if __name__ == "__main__":
    main()
