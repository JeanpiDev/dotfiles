---
name: project-documenter
description: >-
  Documents a software project as visual, code-grounded Markdown — with Mermaid
  diagrams and tables — and publishes it correctly to Notion, the repo, or both.
  Use whenever the user wants to document a project/codebase/service in Notion
  ("write up this project in Notion", "document this repo on a Notion page"), or
  wants project docs with an architecture diagram, data-flow/sequence diagram,
  or tables of endpoints/env vars. The model already writes good repo docs on
  its own; this skill exists to add the two things it tends to get wrong:
  keeping the whole doc in one consistent language, and publishing to Notion the
  right way (title as page property, Mermaid in code blocks). Do NOT use for
  inline explanations, code comments, or single-function docstrings.
---

# Project Documenter

You already know how to read a codebase and write a solid architecture doc with
Mermaid diagrams and tables — so this skill doesn't re-teach that. It exists to
enforce the two things that otherwise go wrong, and to publish to Notion
correctly.

## The two rules that matter

1. **One consistent language — the project's.** Before writing, find the
   project's dominant language from its README, `docs/`, `CLAUDE.md`, and the
   user's request, then write the *entire* output in that language: prose,
   **section headings, table headers, and diagram labels included**. A body in
   Spanish under headings like "Overview"/"Architecture" reads as careless and
   machine-made. For a Spanish project, headings are `## Visión general`,
   `## Arquitectura`, `## Configuración`, etc. If the language is genuinely
   ambiguous, match the language the user wrote in.

2. **Ground everything in the real code.** Read the files. Never invent
   endpoints, env vars, or modules you didn't verify. Cite source paths so
   readers can jump to them. Wrong docs are worse than none.

## What to produce

Document what the user asked for; default to a new engineer as the audience.
A typical full write-up covers: overview & purpose, architecture (with a Mermaid
diagram), the main data flow (a Mermaid flowchart or sequence diagram), the
API/interfaces (a table), configuration (an env-var table), and setup/running.
Adapt to the project — a CLI needs "Commands", a library needs "Public API".
Lead with diagrams and tables; use prose for the *why*.

**Diagrams:** use Mermaid — it renders on GitHub and in Notion. Pick the fitting
type (`flowchart` for architecture/pipelines, `sequenceDiagram` for
request/response, `erDiagram` for data models, `stateDiagram-v2` for
lifecycles). Keep each diagram to ~5–15 nodes; split if it grows. To avoid the
red "syntax error" box: declare every node, and quote labels containing spaces
or punctuation — `N["Label (with parens)"]`.

## Publishing

**Repo:** write Markdown that matches the project's existing convention — a
`docs/` folder with an index for a larger project, or a single `ARCHITECTURE.md`
/ improved `README.md` for a small one. Use relative links between docs and to
source files.

**Notion:** read `references/notion.md` before publishing — Notion has specific
rules (title goes in the page property, not as a `#` heading in the body;
Mermaid goes in a ` ```mermaid ` code block; tables are standard Markdown).
Confirm the target parent page with the user before creating anything, then
report the URL(s) you created.

## Reference

- `references/notion.md` — how to publish to Notion via the MCP: finding the
  parent, the page-property title, single-page vs index+subpages, and the
  Notion-Markdown gotchas. Read it before any Notion publish.
