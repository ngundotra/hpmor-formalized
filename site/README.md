# Findings Microsite

This directory contains a static GitHub Pages-friendly microsite for presenting
the hard-won findings from formalizing HPMOR.

## Source of truth

The canonical record remains [`../ROADMAP.md`](../ROADMAP.md).

The file [`data/findings.json`](./data/findings.json) is a presentation-layer
mirror of the information currently recorded there. Update `ROADMAP.md` first,
then sync the JSON if the site should reflect the change.

## Layout

- `index.html` — page shell
- `styles.css` — visual design
- `app.js` — client-side rendering
- `data/findings.json` — findings database used by the site

## Hosting

This site is designed to be deployed from the `site/` subdirectory via a GitHub
Pages workflow, without forcing the repository into a `docs/` layout.

The deployed artifact is intentionally small and static so GitHub Pages can serve
it without any extra build tooling.
