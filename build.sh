#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_JSON="$SCRIPT_DIR/data/profile.json"

# --- Validation ---
if [ ! -f "$PROFILE_JSON" ]; then
  echo "Error: $PROFILE_JSON not found" >&2
  exit 1
fi

# --- Use Python for everything (no jq dependency) ---
python3 << 'PYTHON_SCRIPT'
import json
import sys
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
profile_path = os.path.join(script_dir, 'data', 'profile.json')
html_path = os.path.join(script_dir, 'index.html')
readme_path = os.path.join(script_dir, 'README.md')

try:
    with open(profile_path, 'r') as f:
        data = json.load(f)
except FileNotFoundError:
    print(f'Error: {profile_path} not found', file=sys.stderr)
    sys.exit(1)
except json.JSONDecodeError as e:
    print(f'Error: Invalid JSON in profile.json: {e}', file=sys.stderr)
    sys.exit(1)

# Validate required fields
required_fields = ['name', 'title', 'bio']
for field in required_fields:
    if field not in data or not data[field]:
        print(f'Error: Required field "{field}" is missing or empty in profile.json', file=sys.stderr)
        sys.exit(1)

name = data['name']
title = data['title']
bio = data['bio']
tech_stack = data.get('tech_stack', [])
current_focus = data.get('current_focus', '')
featured_projects = data.get('featured_projects', [])
contact = data.get('contact', {})
site_url = contact.get('website', 'https://rairahulr1.com')
github = contact.get('github', '')
email = contact.get('email', '')
linkedin = contact.get('linkedin', '')

# --- Generate HTML ---
tech_html = '\n'.join(f'                <li>{t}</li>' for t in tech_stack)

projects_html = ''
if featured_projects:
    projects_items = '\n'.join(
        f'                <a href="{p["url"]}" class="project-card"><h3>{p["name"]}</h3><p>{p["description"]}</p></a>'
        for p in featured_projects
    )
    projects_html = f'''
        <section id="projects">
            <h2>Featured Projects</h2>
            <div class="projects-grid">
{projects_items}
            </div>
        </section>'''

focus_html = ''
if current_focus:
    focus_html = f'''
        <section id="focus">
            <h2>Current Focus</h2>
            <p>{current_focus}</p>
        </section>'''

contact_items = []
if github:
    contact_items.append(f'                <li><a href="https://github.com/{github}">GitHub</a></li>')
if email:
    contact_items.append(f'                <li><a href="mailto:{email}">Email</a></li>')
if linkedin:
    contact_items.append(f'                <li><a href="https://linkedin.com/in/{linkedin}">LinkedIn</a></li>')
contact_html = '\n'.join(contact_items)

html = f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{name} - {title}</title>
    <meta name="description" content="{bio}">

    <!-- Open Graph -->
    <meta property="og:title" content="{name} - {title}">
    <meta property="og:description" content="{bio}">
    <meta property="og:url" content="{site_url}">
    <meta property="og:type" content="website">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <h1>{name}</h1>
        <p class="title">{title}</p>
    </header>
    <main>
        <section id="about">
            <h2>About</h2>
            <p>{bio}</p>
        </section>

        <section id="tech-stack">
            <h2>Tech Stack</h2>
            <ul>
{tech_html}
            </ul>
        </section>{projects_html}{focus_html}

        <section id="contact">
            <h2>Contact</h2>
            <ul>
{contact_html}
            </ul>
        </section>
    </main>
    <footer>
        <p>&copy; 2026 {name}</p>
    </footer>
    <script src="js/main.js"></script>
</body>
</html>'''

with open(html_path, 'w') as f:
    f.write(html)
print(f'Generated: {html_path}')

# --- Generate README.md ---
tech_md = '\n'.join(f'- {t}' for t in tech_stack)

projects_md = ''
if featured_projects:
    projects_items = '\n'.join(
        f'- [{p["name"]}]({p["url"]}) - {p["description"]}'
        for p in featured_projects
    )
    projects_md = f'\n## Featured Projects\n\n{projects_items}'

focus_md = f'\n## Current Focus\n\n{current_focus}' if current_focus else ''

contact_parts = []
if github:
    contact_parts.append(f'- [GitHub](https://github.com/{github})')
if email:
    contact_parts.append(f'- [Email](mailto:{email})')
if linkedin:
    contact_parts.append(f'- [LinkedIn](https://linkedin.com/in/{linkedin})')
contact_md = '\n'.join(contact_parts)

readme = f'''# {name}

**{title}**

{bio}

## Tech Stack

{tech_md}
{projects_md}
{focus_md}

## Contact

{contact_md}

Generated from `data/profile.json`'''

with open(readme_path, 'w') as f:
    f.write(readme)
print(f'Generated: {readme_path}')
PYTHON_SCRIPT
