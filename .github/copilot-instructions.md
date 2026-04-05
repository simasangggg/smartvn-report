# Copilot instructions

## Build and preview
- **Windows build:** `build.bat` (Pandoc: Markdown → Word)
  - **Default input:** `bao_cao_t2.md` (repo root)
  - **Output:** `bao-cao.docx` (gitignored)
  - If `bao_cao_t2.md` isn’t tracked in git, start by copying `buildMD.md` (or `pthttm.md`) and then fill in content.
- **Windows watch mode:** `watch.bat` reruns `build.bat` on `.md` changes (requires `nodemon` on PATH).
- **Makefile:** Contains `build`, `watch`, `clean`, `open` targets but currently points to missing `build.sh`/`watch.sh` scripts (placeholder for Unix/Linux).
- **Tests / lint:** None (this repo is a document generation pipeline).

### Prerequisites (implied by scripts)
- `pandoc` on PATH
- `pandoc-crossref.exe` on PATH (used via `--filter pandoc-crossref.exe`)
- `nodemon` on PATH for `watch.bat`

## High-level architecture
- **Purpose:** Pandoc-driven Vietnamese academic report generator for PTIT Ho Chi Minh campus.
- **Conversion pipeline:** Markdown (with YAML front matter) → Pandoc (+ `pandoc-crossref`) → Word (`.docx`).
- **Styling:** `template.docx` is the Pandoc reference document that controls Word styles/fonts/layout.
  - `build.bat` only applies `--reference-doc=template.docx` if the file exists.
- **Report templates:** `buildMD.md` and `pthttm.md` are Markdown templates containing the YAML front matter used to control TOC/LOF/LOT, margins, language, and crossref prefixes.
- **Content authoring aid:** `prompt.txt` is a detailed Vietnamese prompt for generating a full report Markdown; it includes strict “don’t invent numbers/specs” constraints.

## Pandoc configuration
Key flags used by `build.bat`:
- `--filter pandoc-crossref.exe` (cross-references for figures/tables/equations)
- `--toc --toc-depth=3` (TOC generation)
- `--reference-doc=template.docx` (Word styling)
- `--highlight-style=tango` (code block highlighting)
- `-M tables=true` (table rendering)

## Key conventions
- **Language/encoding:** Content and metadata are Vietnamese (`vi-VN`). `build.bat` switches the console to UTF-8 (`chcp 65001`)—keep Markdown files UTF-8.
- **YAML front matter is “config”:** Preserve existing keys/structure (paper size, geometry, TOC/LOF/LOT titles, figure/table prefixes, `autoSectionLabels`, etc.) because they drive the generated document.
- **Unnumbered headings:** Front-matter sections may use Pandoc’s unnumbered heading syntax: `# ... {-}` (see `buildMD.md`).
- **Cross-references:** When using `pandoc-crossref`, keep reference labels stable and cite them like `@fig:...`, `@tbl:...`.
- **Generated artifacts:** Don’t hand-edit `bao-cao.docx`; edit the Markdown and/or `template.docx` instead.
