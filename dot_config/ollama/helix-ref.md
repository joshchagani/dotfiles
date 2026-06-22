# Helix 25.07.1 - curated keymap (common bindings)

Helix is modal & SELECTION-FIRST (select, THEN act). No leader key; menus:
Space (pickers/LSP), g (goto), m (match/surround), Ctrl-w (windows), z (view).

## Movement (normal mode)
- h j k l        left/down/up/right
- w / b / e      next word start / prev word start / word end  (W/B/E = WORD)
- f<c> / t<c>    find / till char forward; F/T backward; ; , to repeat
- gg / ge        file start / file end
- gh / gl / gs   line start / line end / first non-blank
- Ctrl-d / Ctrl-u   half-page down / up
- gd gr gy gi    goto definition / references / type-def / implementation (LSP)
- ga             last accessed buffer; gn / gp  next / prev buffer

## Selections (first-class)
- x              extend selection to whole line (repeat for more)
- %              select the entire file
- v              enter select/extend mode; Esc returns to normal
- ; / Alt-;      collapse to one cursor / flip cursor & anchor
- s              select all regex matches WITHIN the selection (-> multi-cursor)
- S              split selection on regex
- C / Alt-C      add a cursor on next / previous line
- , / Alt-,      keep only primary cursor / remove primary cursor

## Changes (act on the selection)
- d / c / y      delete / change / yank
- p / P          paste after / before; R replace selection with yank
- i / a          insert before / after selection; o / O open line below / above
- r<c>           replace each selected char; ~ switch case
- > / <          indent / unindent; = format (LSP)
- u / U          undo / redo; . repeat last insert

## Search
- / then Enter   search forward; n / N next / prev; * search word under cursor

## Match mode (m)
- m m            jump to matching bracket
- m i <x> / m a <x>   select inside / around textobject (w, p, (, ", etc.)
- m s <x> / m r <a><b> / m d <x>   add / replace / delete surround

## Space menu (pickers / LSP)
- Space f / F    file picker (workspace root / cwd)
- Space e        file EXPLORER tree (workspace root)   [details in supplement]
- Space b        buffer picker; Space j jumplist; Space ' last picker
- Space /        global search; Space k hover docs (LSP)
- Space s / S    document / workspace symbol picker
- Space d / D    document / workspace diagnostics
- Space r / a    rename symbol / code action (LSP); Space ? command palette

## Window mode (Ctrl-w, or Space w)
- Ctrl-w v / s   vertical / horizontal split
- Ctrl-w h/j/k/l focus split; Ctrl-w q close; Ctrl-w o only
