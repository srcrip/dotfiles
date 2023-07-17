vim.cmd [[
set clipboard=unnamedplus
"let g:clipboard = {
      "\   'name': 'xsel_override',
      "\   'copy': {
      "\      '+': 'xsel --input --clipboard',
      "\      '*': 'xsel --input --primary',
      "\    },
      "\   'paste': {
      "\      '+': 'xsel --output --clipboard',
      "\      '*': 'xsel --output --primary',
      "\   },
      "\   'cache_enabled': 1,
      "\ }
let g:yoinkSyncNumberedRegisters = 1
let g:yoinkIncludeDeleteOperations = 1
let g:yoinkAutoFormatPaste = 1
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)
nmap <c-p> <plug>(YoinkPostPasteSwapBack)
nmap <c-n> <plug>(YoinkPostPasteSwapForward)
nmap y <plug>(YoinkYankPreserveCursorPosition)
xmap y <plug>(YoinkYankPreserveCursorPosition)
nmap Y y$
]]
