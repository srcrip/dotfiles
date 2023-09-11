-- vim.api.nvim_create_autocmd({ "TermOpen" }, {
--   pattern = { "*" },
--   command = "setlocal listchars= nonumber norelativenumber | startinsert",
-- })
--
-- vim.api.nvim_create_autocmd({ "BufLeave" }, {
--   pattern = { "term://*" },
--   command = "stopinsert",
-- })
--
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
--   pattern = { "term://*" },
--   command = "if !has_key(b:, '_termdone') | startinsert | endif",
-- })
--
-- vim.api.nvim_create_autocmd({ "TermClose" }, {
--   pattern = { "*" },
--   command = "++nested stopinsert | let b:_termdone = 1 | au TermEnter <buffer> stopinsert",
-- })
--
--

-- make terminals more convenient
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

