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




vim.cmd [[
  au TermOpen * startinsert | setlocal listchars= nonumber
  au BufEnter,BufWinEnter,WinEnter term://* if !has_key(b:, '_termdone') | startinsert | endif
  au TermClose * ++nested stopinsert | let b:_termdone = 1 | au TermEnter <buffer> stopinsert
]]

vim.keymap.set('t', '<esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<c-q>', '<esc>')
vim.keymap.set('t', '<c-h>', '<C-\\><C-n>:BufferLineCyclePrev<CR>', { silent = true })
vim.keymap.set('t', '<c-l>', '<C-\\><C-n>:BufferLineCycleNext<CR>', { silent = true })
