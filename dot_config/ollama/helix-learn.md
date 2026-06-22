# Learning Helix (v25.07) - concepts & workflows (for the assistant)

Use this to TEACH Helix, not just list keys. Helix is modal and SELECTION-FIRST
(kakoune lineage) -- the opposite order from Vim.

## Core idea: select first, then act
- You ALWAYS have a selection (at minimum the single character under the cursor).
- MOTIONS move or grow the selection; VERBS act on whatever is selected.
- Order is OBJECT then VERB (Vim is VERB then object):
  - Vim `dw` (delete word) = Helix `w` then `d`  (select the word, then delete).
  - Vim `ciw`             = Helix `mi w` then `c`.
  - Vim `dd`              = Helix `x` then `d`   (`x` selects the whole line).
- Payoff: you SEE the highlight (exactly what will change) before you act.
- `;` collapses a selection to one cursor; `Alt-;` flips the active end.

## The minor-mode menus (what each leader-ish key is FOR)
- `Space`  pickers & LSP (files, buffers, symbols, diagnostics, rename, code action)
- `g`      "goto": navigation (definition, references, file/line ends, buffers)
- `m`      "match": text objects & surround (inside/around, add/replace/delete surround)
- `Ctrl-w` windows / splits
- `z`/`Z`  view (scroll & recenter without moving the selection)
- `[`/`]`  "unimpaired": jump to prev/next diagnostic, change, function, etc.

## Common tasks, the Helix way
- Rename a symbol everywhere (semantic, preferred): `Space r` (LSP rename).
- Replace every match of a word in the file (textual): `%` (select whole file) ->
  `s` -> type a regex -> Enter (a cursor lands on each match) -> `c` -> type the
  replacement -> `Esc`. This is Helix's answer to Vim's `:%s/old/new/g`.
- Change text inside quotes/brackets: `mi"` or `mi(` (select inside) -> `c` -> type.
- Wrap a selection: select it -> `ms"` / `ms(` (match -> surround -> add).
- Comment / uncomment lines: select the lines (`x`, repeat to extend) -> `Space c`.
- Select a textobject: `mi<x>` (inside) / `ma<x>` (around), where x = `w` word,
  `p` paragraph, `(` `{` `[` pairs, `"` `'` quotes, `f` function, `c` class, `a` argument.
- Go to a definition / symbol: `gd` (definition) or `Space s` (file symbol picker).
- Open files / search: `Space f` (file picker), `Space e` (file explorer), `Space /` (global search).
- Multiple cursors down lines: `C` adds a cursor below (`Alt-C` above); type once, applies to all.

## Coming from Vim - translations
| Vim             | Helix                    |
| --------------- | ------------------------ |
| `dd`            | `x d`                    |
| `dw`            | `w d`                    |
| `ciw`           | `mi w  c`                |
| `ci(`           | `mi (  c`                |
| `yy` / `p`      | `x y` / `p`              |
| `:%s/a/b/g`     | `%  s a Enter  c b Esc`  |
| `0` / `$`       | `gh` / `gl`              |
| `gg` / `G`      | `gg` / `ge`              |
| `/foo` `n`      | `/ foo Enter` `n`        |
| `*`             | `*`                      |

## How to learn it fast
- Run `hx --tutor` -- the built-in interactive tutorial (best first hour).
- Build the habit: glance at the highlighted selection BEFORE pressing a verb.
- Common Vim slips: it's `wd` not `dw`; `x` selects a line (not delete-char);
  use `mi`/`ma` for inside/around; press `;` to drop back to one cursor.
