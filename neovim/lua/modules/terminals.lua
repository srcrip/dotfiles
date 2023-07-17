vim.cmd [[
  au TermOpen * setlocal listchars= nonumber norelativenumber
  au TermOpen * startinsert
  au BufLeave term://* stopinsert
  au BufEnter,BufWinEnter,WinEnter term://* if !has_key(b:, '_termdone') | startinsert | endif
  au TermClose * ++nested stopinsert | let b:_termdone = 1 | au TermEnter <buffer> stopinsert
  au TermClose term://*tig* :Bclose

  tnoremap <Esc> <C-\><C-n>
  tnoremap <c-q>> <Esc>
  tnoremap <silent> <c-h> <C-\><C-n>:BufferLineMovePrev<CR>
  tnoremap <silent> <c-l> <C-\><C-n>:BufferLineMoveNext<CR>
]]
