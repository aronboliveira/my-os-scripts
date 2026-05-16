#!/usr/bin/env python3
"""
Consolidate CSS for index.html. Adds Ps1 variants to ID selectors
and merges PS-specific syntax classes.
"""

import re
import sys

ID_PAIRS = [
    ("#mainNav", "#mainNavPs1"),
    ("#tocSidebar", "#tocSidebarPs1"),
    ("#aliasSearch", "#aliasSearchPs1"),
    ("#backToTop", "#backToTopPs1"),
]

def extract_style(html):
    m = re.search(r"<style>(.*?)</style>", html, re.DOTALL)
    return m.group(1).strip() if m else ""

def transform_selector(sel):
    """
    Add Ps1 variants for each ID in the selector.
    Handles selectors like #mainNav.scrolled, #tocSidebar .nav-link, etc.
    Spacing is normalized to single spaces.
    """
    sel = sel.strip()
    # Split multi-part selectors by comma
    parts = [p.strip() for p in sel.split(",")]
    new_parts = list(parts)

    for old_id, new_id in ID_PAIRS:
        additions = []
        for part in new_parts:
            # Check if this part starts with or contains #oldId as a selector segment
            idx = part.find(old_id)
            if idx == -1:
                continue
            # Verify it's a standalone ID: not preceded/followed by alnum or dash
            before_ok = idx == 0 or not (part[idx - 1].isalnum() or part[idx - 1] in ('-', '_'))
            after_idx = idx + len(old_id)
            after_ok = after_idx >= len(part) or not (part[after_idx].isalnum() or part[after_idx] in ('-', '_'))
            if before_ok and after_ok:
                # Duplicate this part with the new ID
                additions.append(part.replace(old_id, new_id, 1))

        new_parts.extend(additions)

    return ", ".join(new_parts)

def parse_css_rules(css):
    """Parse CSS into list of (selector, body) tuples respecting nested {}."""
    rules = []
    depth = 0
    sel_start = 0
    body_start = 0

    i = 0
    while i < len(css):
        ch = css[i]
        if ch == "{":
            if depth == 0:
                sel = css[sel_start:i].strip()
                body_start = i + 1
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                body = css[body_start:i]
                rules.append((sel, body))
                sel_start = i + 1
        i += 1

    return rules

def add_ps1_variants(css):
    """Process CSS and add Ps1 variants to ID-based selectors."""
    rules = parse_css_rules(css)
    result = []
    for sel, body in rules:
        new_sel = transform_selector(sel)
        result.append(f"{new_sel} {{{body}}}")
    return "\n".join(result)

def extract_ps_syntax_classes(css):
    """Extract PS-specific syntax class rules (.ps-cmdlet, .ps-comment etc.)."""
    rules = parse_css_rules(css)
    lines = []
    for sel, body in rules:
        # Skip rules that are empty selector or have no PS class
        if not sel.strip():
            continue
        if ".ps-" in sel:
            lines.append(f"{sel} {{{body}}}")
    return "\n".join(lines)

def main():
    index_path = sys.argv[1] if len(sys.argv) > 1 else "index.html"

    with open("Bash/Linux/aliases-references.html", "r", encoding="utf-8") as f:
        bash_html = f.read()
    with open("PowerShell/ps1/aliases-references.html", "r", encoding="utf-8") as f:
        ps_html = f.read()

    bash_css = extract_style(bash_html)
    ps_css = extract_style(ps_html)

    bash_with_variants = add_ps1_variants(bash_css)
    ps_syntax = extract_ps_syntax_classes(ps_css)

    consolidated = f"    <style>\n{bash_with_variants}\n\n{ps_syntax}\n    </style>"

    with open(index_path, "r", encoding="utf-8") as f:
        index_content = f.read()

    new_content = re.sub(
        r"<style>.*?</style>",
        lambda _: consolidated,
        index_content,
        count=1,
        flags=re.DOTALL,
    )

    with open(index_path, "w", encoding="utf-8") as f:
        f.write(new_content)

    print(f"Done. {len(rules_in_css(bash_css))} Bash rules + {len(extract_ps_syntax_classes(ps_css).splitlines())} PS syntax lines")

def rules_in_css(css):
    return parse_css_rules(css)

if __name__ == "__main__":
    main()
