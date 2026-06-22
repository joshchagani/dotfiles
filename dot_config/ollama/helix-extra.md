# Helix supplement (v25.07.1) — fills gaps the version's keymap.md misses

## File explorer (in the 25.07.1 binary, but MISSING from its keymap.md)
- `Space e` — open the file explorer (tree) at the workspace root  (`file_explorer`)
- `file_explorer_in_current_buffer_directory` and `file_explorer_in_current_directory`
  also exist; the exact extra key varies by version, so prefer `Space e`.
- Note: `Space f` is the fuzzy file PICKER; `Space e` is the tree EXPLORER. Different things.

## Helix is NOT Vim — answer the Helix way (selection-first, kakoune-style)
- You SELECT first, then act: the verb comes AFTER the object.
  - Vim `dw` (delete word) = Helix `w` then `d`.
  - Vim `ciw` = Helix `miw` then `c`.
- There is NO leader key. Use the minor-mode menus instead:
  `Space` (pickers/LSP), `g` (goto), `m` (match / surround / textobjects),
  `Ctrl-w` (windows), `z` (view), `[` / `]` (unimpaired).
- NEVER answer a Helix question with a tmux-style "<prefix>"; that is a tmux concept.
- Most motions move the SELECTION; `;` collapses it to a single cursor, `Alt-;` flips ends.

## Multiple cursors (the model often gets this wrong)
- `C` — add a cursor on the NEXT line; `Alt-C` — add one on the PREVIOUS line.
- In a selection, `s` + regex + Enter — place a cursor at every match.
- `S` — split the current selection into one selection per regex match.
- `,` — keep only the primary cursor; `Alt-,` — remove the primary cursor.
- `(` / `)` — rotate which selection is primary. Edits apply to ALL cursors at once.
- Typical flow: select region → `s` pattern Enter → edit all at once → `,` to collapse.
