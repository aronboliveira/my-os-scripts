#!/usr/bin/env python3
"""
Fix index.html: rename duplicate IDs in PowerShell section (lines 25528-33465),
update all JS references, remove duplicate CDN scripts.
"""

import re
import sys

def fix_index_html(content: str) -> str:
    lines = content.split("\n")
    # PowerShell section starts at line 25528 (0-indexed: 25527)
    # The script block in PowerShell section is at ~33084-33459

    # Map of IDs that appear in BOTH Bash and PowerShell sections
    # Each entry: (old_id_without_prefix, old_id_full) for JavaScript references
    id_mappings = {
        # Structural IDs
        "aliasApp": "aliasAppPs1",
        "mainNav": "mainNavPs1",
        "navbarContent": "navbarContentPs1",
        "mainContent": "mainContentPs1",
        "tocSidebar": "tocSidebarPs1",
        "navHoverZone": "navHoverZonePs1",
        "sidebarToggleBtn": "sidebarToggleBtnPs1",
        "sidebarCloseBtn": "sidebarCloseBtnPs1",
        "themeBtn": "themeBtnPs1",
        "aliasSearch": "aliasSearchPs1",
        "searchIcon": "searchIconPs1",
        "backToTop": "backToTopPs1",

        # Section IDs
        "systemSetup": "systemSetupPs1",
        "systemSetupHeading": "systemSetupHeadingPs1",
        "systemSetupAccordion": "systemSetupAccordionPs1",
        "gitAliases": "gitAliasesPs1",
        "gitAliasesHeading": "gitAliasesHeadingPs1",
        "prettyAliases": "prettyAliasesPs1",
        "prettyAliasesHeading": "prettyAliasesHeadingPs1",
        "utilities": "utilitiesPs1",
        "utilitiesHeading": "utilitiesHeadingPs1",
        "htmlCssTools": "htmlCssToolsPs1",
        "htmlCssToolsHeading": "htmlCssToolsHeadingPs1",
        "navigationAliases": "navigationAliasesPs1",
        "navigationAliasesHeading": "navigationAliasesHeadingPs1",
        "laravelPhp": "laravelPhpPs1",
        "laravelPhpHeading": "laravelPhpHeadingPs1",
    }

    # These are used within template literals and data attributes
    # The JS uses `getElementById(\`typed_${id}\`)` — the `id` variable comes from data-demo-target
    # So if we rename data-demo-target values, the JS auto-follows
    # We need to rename: id="ex_*", id="typed_ex_*", id="cursor_ex_*", id="output_ex_*"
    # plus: data-example-id="*", data-demo-target="*"

    ps_start = 25527  # 0-indexed
    ps_script_start = 33083  # 0-indexed
    ps_script_end = 33459   # 0-indexed (exclusive)

    new_lines = []
    # Track position
    pos = 0
    ps_marker_found = False

    for i, line in enumerate(lines):
        # Detect PowerShell section start
        if not ps_marker_found and ('<h2 class="section-title">PowerShell</h2>' in line or
                                     '<h2 class="section-title">PowerShell' in line):
            ps_marker_found = True

        in_ps_section = ps_marker_found or (i >= ps_start)
        in_ps_script = (ps_script_start <= i < ps_script_end) and ps_marker_found

        if in_ps_section:
            modified = line

            # Remove duplicate CDN scripts
            if ('vue.global.prod.js' in line or 'bootstrap.bundle.min.js' in line) and in_ps_script:
                # Check if it's the script tag (not a comment)
                if re.search(r'<script\s', line):
                    new_lines.append("")  # Remove the line
                    continue
                elif '</script>' in line and not any(c.isalpha() for c in line if c != '<' and c != '/' and c != 's' and c != 'c' and c != 'r' and c != 'i' and c != 'p' and c != 't' and c != '>'):
                    new_lines.append("")  # Remove the line
                    continue
                # Otherwise process normally

            # For HTML lines (not in the JS block), rename id attributes
            if not in_ps_script:
                # Rename id="X" attributes
                for old_id, new_id in id_mappings.items():
                    modified = modified.replace(f'id="{old_id}"', f'id="{new_id}"')

                # Rename href="#X" references
                for old_id, new_id in id_mappings.items():
                    if old_id in {"aliasApp", "mainNav", "navbarContent", "mainContent",
                                   "tocSidebar", "navHoverZone", "sidebarToggleBtn",
                                   "sidebarCloseBtn", "themeBtn", "aliasSearch",
                                   "searchIcon", "backToTop"}:
                        continue
                    modified = modified.replace(f'href="#{old_id}"', f'href="#{new_id}"')

                # Rename data-bs-target
                for old_id, new_id in id_mappings.items():
                    modified = modified.replace(f'data-bs-target="#{old_id}"',
                                                f'data-bs-target="#{new_id}"')

                # Rename data-bs-parent
                for old_id, new_id in id_mappings.items():
                    modified = modified.replace(f'data-bs-parent="#{old_id}"',
                                                f'data-bs-parent="#{new_id}"')

                # Rename aria-controls
                for old_id, new_id in id_mappings.items():
                    modified = modified.replace(f'aria-controls="{old_id}"',
                                                f'aria-controls="{new_id}"')

                # Rename aria-labelledby
                for old_id, new_id in id_mappings.items():
                    modified = modified.replace(f'aria-labelledby="{old_id}"',
                                                f'aria-labelledby="{new_id}"')

                # Rename data-example-id
                modified = re.sub(
                    r'(data-example-id="[^"]*)"',
                    lambda m: m.group(1) + 'Ps1"',
                    modified,
                )

                # Rename data-demo-target
                modified = re.sub(
                    r'(data-demo-target="[^"]*)"',
                    lambda m: m.group(1) + 'Ps1"',
                    modified,
                )

                # Rename typed_ex_*, cursor_ex_*, output_ex_*, ex_* IDs
                # These appear as id="typed_ex_*" or id="cursor_ex_*" etc.
                for prefix in ["typed_ex_", "cursor_ex_", "output_ex_", "ex_"]:
                    modified = re.sub(
                        f'(id="{re.escape(prefix)}[^"]*)"',
                        lambda m: m.group(1) + 'Ps1"',
                        modified,
                    )

            # For JS script block lines
            if in_ps_script:
                # Update S selector constants
                for old_id, new_id in id_mappings.items():
                    if old_id in {"mainContent"}:
                        continue  # mainContent isn't referenced in S
                    # Replace "#oldId" with "#newId"
                    modified = modified.replace(f'"#{old_id}"', f'"#{new_id}"')

                # Update getElementById("aliasApp")
                for old_id, new_id in id_mappings.items():
                    if old_id == "aliasApp":
                        modified = modified.replace(
                            'getElementById("aliasApp")',
                            'getElementById("aliasAppPs1")',
                        )
                        modified = modified.replace(
                            'mount("#aliasApp")',
                            'mount("#aliasAppPs1")',
                        )
                        break

            line = modified

        new_lines.append(line)

    result = "\n".join(new_lines)
    return result

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python fix_index.py <index.html>")
        sys.exit(1)

    path = sys.argv[1]
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    fixed = fix_index_html(content)

    with open(path, "w", encoding="utf-8") as f:
        f.write(fixed)

    print(f"Fixed {path}")
