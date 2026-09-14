# Publishing documentation to Notion

The Notion MCP accepts page content as **Notion-flavored Markdown**, so most of
the doc you already drafted transfers directly. This file covers the parts that
differ from plain repo Markdown and the steps to publish cleanly.

## Before creating anything

1. **Read the Markdown spec.** The create-pages tool description says to first
   read the MCP resource `notion://docs/enhanced-markdown-spec` through the
   resource-reading interface (do NOT fetch it as a URL). Do this once per
   session before writing Notion content, so the syntax for tables, callouts,
   toggles, and code blocks is exact rather than guessed.
2. **Find the parent.** Pages need a home. Ask the user where the docs should
   live, or use `notion-search` to locate the likely parent (a team space, a
   "Projects" or "Engineering" page). Confirm the destination with the user
   before creating — creating pages is outward-facing and not trivially undone.
   Pass the parent as `{ type: "page_id", page_id: "<id>" }`. With no parent the
   pages land as private workspace-level pages, which is rarely what's wanted.

## Page structure: one page vs page + subpages

Decide with the user (the skill defaults to asking at publish time):

- **Single page** — best for small/medium projects. One page with H2 sections
  (Overview, Architecture, …). Easiest to read top to bottom.
- **Index page + subpages** — best for larger projects. Create the parent index
  page first, get its `page_id` from the result, then create one child page per
  section under that parent. The index links to the children. Do this in two
  `notion-create-pages` calls (parent, then children) because the children need
  the parent's real ID.

## Notion-Markdown specifics

- **Title**: put the page title in `properties.title`, NOT as an `#` heading at
  the top of `content`. Notion renders the property as the page H1.
- **Diagrams**: Mermaid goes in a fenced code block whose language is
  `mermaid`. Notion renders it as a real diagram. The exact same Mermaid source
  from `references/mermaid.md` works — just keep it in the code block.
- **Tables**: standard Markdown pipe tables render as Notion tables. Keep
  headers on the first row.
- **Code**: fenced blocks with a language tag get syntax highlighting.
- **Callouts/toggles**: useful for "Note:" asides and collapsible detail —
  check the enhanced-markdown-spec for the exact syntax before using them.
- **Links to source code**: Notion can't open repo-relative paths. When
  publishing to Notion, either link to the file on the repo's web host (GitHub
  URL) or reference the path as inline code (`app/main.py`) so it's at least
  readable.

## After publishing

Report the created page URL(s) back to the user. If you created an index +
subpages, give the index URL and note the subpages hang under it.
